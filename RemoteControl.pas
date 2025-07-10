{$apptype windows}
{$mainresource 'release.res'}


uses UI;


begin
  
  System.Windows.Forms.Application.EnableVisualStyles();
  System.Windows.Forms.Application.SetCompatibleTextRenderingDefault(false);
  System.Windows.Forms.Application.Run(new MainWindow);
  
end.
