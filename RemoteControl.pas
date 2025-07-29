{$apptype windows}
{$mainresource 'debug.res'}


uses UI;

uses 
  System.Runtime.InteropServices, 
  System.IO, 
  System;


[DllImport('kernel32.dll')]
function FindResource(hModule: IntPtr; lpName, lpType: IntPtr): IntPtr; external;

[DllImport('kernel32.dll')]
function LoadResource(hModule: IntPtr; hResInfo: IntPtr): IntPtr; external;

[DllImport('kernel32.dll')]
function LockResource(hResData: IntPtr): IntPtr; external;

[DllImport('kernel32.dll')]
function SizeofResource(hModule: IntPtr; hResInfo: IntPtr): integer; external;

[DllImport('kernel32.dll')]
function GetModuleHandle(lpModuleName: IntPtr): IntPtr; external;


procedure ExtractResource(resName: string; resType: integer; outPath: string);
begin
  var hModule := GetModuleHandle(IntPtr.Zero);
  var namePtr := Marshal.StringToHGlobalAnsi(resName);
  var typePtr := new IntPtr(resType);

  try
    var hRes := FindResource(hModule, namePtr, typePtr);
    if hRes = IntPtr.Zero then begin
      Writeln('❌ Ресурс не найден.');
      exit;
    end;

    var hData := LoadResource(hModule, hRes);
    var pData := LockResource(hData);
    var size := SizeofResource(hModule, hRes);

    var buf := new byte[size];
    Marshal.Copy(pData, buf, 0, size);

    &File.WriteAllBytes(outPath, buf);
    Writeln('✅ Ресурс успешно извлечён в файл: ' + outPath);
  finally
    Marshal.FreeHGlobal(namePtr);
  end;
end;

begin
  var manualPath: string = Path.Combine(Path.GetTempPath(), 'HowToUse.chm');
  
  if not(&File.Exists(manualPath)) then
    ExtractResource('HELPFILE', 10, Path.Combine(Path.GetTempPath(), 'HowToUse.chm'));
  
  System.Windows.Forms.Application.EnableVisualStyles();
  System.Windows.Forms.Application.SetCompatibleTextRenderingDefault(false);
  System.Windows.Forms.Application.Run(new MainWindow);

end.
