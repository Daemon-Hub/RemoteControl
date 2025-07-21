/// Модуль эмулирующий стандартную командную оболочку Windows > cmd.exe 
unit cmd;

interface

uses System.Diagnostics, System.Text, types;

var
  __initialized__: boolean = false;
  
  p: Process;
  /// Сюда записываются выводы всех комманд
  output: string;
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
procedure RMDIR(pathToDirectory: string);
procedure MOVE(source, dist: string);
procedure SetPath(d: string);
procedure RunCustomCommand(command: string);

function IsCustomCommand(command: string): boolean;

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

/// Удаляет папку и все её содержимое
procedure RMDIR(pathToDirectory: string);
begin
  run($'rmdir /s /q {pathToDirectory}', true, true);
end;

/// Перемещает каталог полностью с его содержимым
procedure MOVE(source, dist: string);
begin
  run($'robocopy "{source}" "{dist}" /E /MOVE /NFL /NDL /NJH /NJS /NP /R:0 /W:0', true, true);  
end;

/// Установить рабочую дирректорию
procedure SetPath(d: string) := path := d;



end.