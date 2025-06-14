/// Модуль эмулирующий стандартную командную оболочку Windows > cmd.exe 
unit cmd;

interface

uses System.Diagnostics, System.Text;

var
  p: Process;
  /// Сюда записываются выводы всех комманд
  output: string;
  __initialized__: boolean = false;
  /// Список нестандартных команд для cmd (например, cd)
  CustomCommands: array of string = ['cd'];
  CustomCommandTitle, path: string;


procedure init();
procedure run(
  command: string; 
  ignore_path: boolean := false; 
  ignore_custom_command: boolean := false);
procedure CD(command: string := 'cd');
procedure CLS;
procedure DIR;
procedure HELP;
procedure MKDIR(dirName: string);
procedure SetPath(d: string);
procedure RunCustomCommand(command: string);

function IsCustomCommand(command: string): boolean;
function Strip(str: string; chars: string := ' '): string;

implementation

/// Инициализация процесса командной оболочки
procedure init;
begin
  p := new Process();
  p.StartInfo.FileName := 'cmd.exe';
  p.StartInfo.RedirectStandardOutput := true; 
  p.StartInfo.StandardOutputEncoding := Encoding.GetEncoding(866);
  p.StartInfo.RedirectStandardError := true;
  p.StartInfo.StandardErrorEncoding := Encoding.GetEncoding(866);
  p.StartInfo.UseShellExecute := false; 
  p.StartInfo.CreateNoWindow := true;
  __initialized__ := true;
end;


/// Выполняет команду в консоли
procedure run(
  command: string; 
  ignore_path: boolean;
  ignore_custom_command: boolean);
begin
  if not __initialized__ then 
    init();
  
  if (not ignore_custom_command) and (IsCustomCommand(command)) then begin
    RunCustomCommand(command);
    exit;
  end;
  
  if (ignore_path) or (path = '') then
    command := $'/c {command}' else
    command := $'/c cd /d {path} && {command}';
  p.StartInfo.Arguments := command;
  p.Start();
  output := '';
  output := p.StandardOutput.ReadToEnd();
  if output = '' then
    output := p.StandardError.ReadToEnd();
  p.WaitForExit();
end;

function IsCustomCommand(command: string): boolean;
begin
  var res: boolean = false;
  foreach var c in CustomCommands do
  begin
    if c in command then begin
      res := true;
      CustomCommandTitle := c;
      break;
    end;
  end;
  Result := res;
end;

/// Запуск нестандартных команд в оболочке cmd.exe
procedure RunCustomCommand(command: string);
begin
  case CustomCommandTitle of
    'cd':
      begin
        CD(command); 
        if path <> output then
           path := output;
        output := 'cd>' + output;
      end;
  end;
  
end;

//procedure __cd__(param: string);
//begin
//  var tmp := path + '\' + param;
//  if System.IO.Directory.Exists(tmp) then
//    path += '\' + param else
//  if param = '..' then
//    path := Copy(path, 1, path.LastIndexOf('\') - 1);
//end;

procedure CD(command: string);
begin
  if command = 'cd' then 
    run(command, ignore_custom_command := true) else
    run($'{command} && cd', ignore_custom_command := true);
  output := Strip(output, #10);
end;

/// Очищает консоль
procedure CLS := run('cls');

/// Выводит информацию о каталоге 
procedure DIR := run('dir', ignore_path := true);

/// Выводит все возможные команды
procedure HELP := run('help');

/// Создает папку
procedure MKDIR(dirName: string) := run($'mkdir {dirName}');


/// Установить рабочую дирректорию
procedure SetPath(d: string) := path := d;

/// 
function Strip(str, chars: string): string;
begin
  var from := 0;
  var to_ := 0;
  for var i := 1 to str.Length do
    if not (str[i] in chars) then
      if from = 0 then from := i else
        to_ := i;
  if (from = 0) and (to_ = 0) then exit('');
  if to_ < from then
    to_ := from;
  Result := Copy(str, from, to_ - from + 1);
end;

end.