unit UI;

interface

uses 
  System, 
  System.Drawing, 
  System.Threading,
  System.Threading.Tasks,
  System.Windows.Forms,  
  explorer, server, client, types,
  Notifications, 
  ListOfConnectedDevices;

type ApplicationState = (SERVER, CLIENT);

var
  _server: TcpServer;
  _server_is_working: boolean;
  _server_count_of_clients: integer;
  _server_service: Thread;
  
  _client: TClient;

  AppState: ApplicationState;

type
  MainWindow = class(Form)
    procedure Form1_Load(sender: Object; e: EventArgs);
    procedure ServerCreate_Click(sender: Object; e: EventArgs);
    procedure ClientConnectButton_Click(sender: Object; e: EventArgs);
    procedure ServerConnectionService();
    procedure MainWindow_FormClosing(sender: Object; e: FormClosingEventArgs);
    procedure ClientIPMask_KeyPress(sender: Object; e: KeyPressEventArgs);
    procedure ClientConnectionStateMonitoring();
    procedure ConsoleBox_KeyDown(sender: Object; e: KeyEventArgs);
    procedure ConsoleBox_MouseDown(sender: Object; e: MouseEventArgs);
    procedure UpdateCountOfClientsLabel();
    procedure cls(_t: string := '');
    procedure ExplorerTab_Resize(sender: Object; e: EventArgs);
    procedure ExplorerToolBarButtonUp_Click(sender: Object; e: EventArgs);
    procedure ExplorerDirectory_DoubleClick(sender: Object; e: EventArgs);
    procedure __update_MouseDown(sender: Object; e: MouseEventArgs);
    procedure __select_all_Click(sender: Object; e: EventArgs);
    procedure __receive_file_Click(sender: Object; e: EventArgs);
    procedure OpenListOfConnectedDevices_Click(sender: Object; e: EventArgs);
  {$region FormDesigner}
  internal
    {$resource UI.MainWindow.resources}
    DefaultTab: TabControl;
    ClientTab: TabPage;
    ServerTab: TabPage;
    ServerCreateButton: Button;
    ServerStartedInfo: &Label;
    clientConnectButton: Button;
    ClientIPMask: MaskedTextBox;
    clientConnectState: &Label;
    UIIconList: ImageList;
    components: System.ComponentModel.IContainer;
    splitContainer1: SplitContainer;
    ClientControlTab: TabControl;
    ConsoleTab: TabPage;
    ConsoleBox: TextBox;
    ExplorerTab: TabPage;
    CountOfClientsLabel: &Label;
    contextMenuStrip1: System.Windows.Forms.ContextMenuStrip;
    FilesIconList: ImageList;
    splitContainer2: SplitContainer;
    label2: &Label;
    label1: &Label;
    ExplorerToolBar: ToolStrip;
    ExplorerToolBarButtonUp: ToolStripButton;
    toolStripSeparator1: ToolStripSeparator;
    LabelPath: ToolStripLabel;
    ExplorerTabContextMenu: System.Windows.Forms.ContextMenuStrip;
    __paste: ToolStripMenuItem;
    __update: ToolStripMenuItem;
    __select_all: ToolStripMenuItem;
    ExplorerItemContextMenu: System.Windows.Forms.ContextMenuStrip;
    __copy: ToolStripMenuItem;
    __cut: ToolStripMenuItem;
    __rename: ToolStripMenuItem;
    __receive_file: ToolStripMenuItem;
    ServerIPAddr: TextBox;
    OpenListOfConnectedDevices: Button;
    clientConnectingProgress: ProgressBar;
    {$include UI.MainWindow.inc}
  {$endregion FormDesigner}
  public
    constructor;
    begin
      InitializeComponent;
      _server_service := new Thread(ServerConnectionService);
      _server_service.Name := 'service';
      types.InitWinIcons();
    end;
  end;

implementation


procedure MainWindow.Form1_Load(sender: Object; e: EventArgs); begin end;


procedure MainWindow.MainWindow_FormClosing(sender: Object; e: FormClosingEventArgs);
begin
  if (AppState = ApplicationState.SERVER) and (_server <> nil) then begin
    _server_is_working := false;
    _server.KillAllServices();
  end else 
  if (AppState = ApplicationState.CLIENT) and (_client <> nil) then begin
    _client.KillAllServices();
  end;
  Thread.Sleep(100);
end;


procedure MainWindow.ServerCreate_Click(sender: Object; e: EventArgs);
begin
  _server_count_of_clients := 0;
  
  if _server_is_working then begin
    
    _server_service.Suspend();
    _server_is_working := false;
    _server.Stop();
    _server.Finalize();
    _server := nil;
    
    ServerStartedInfo.Visible := false;
    
    ServerCreateButton.Text := 'Запустить сервер';
    
    ClientControlTab.Enabled := false;
    
    self.UpdateCountOfClientsLabel();
    
  end else begin
    
    AppState := ApplicationState.SERVER;
    
    _server_is_working := true;
    
    if _server = nil then begin
      _server := new TcpServer();
      _server.Start();
    end;
    
    ServerStartedInfo.Visible := true;
    ServerStartedInfo.Text := 'Сервер успешно запущен' + #10;
    ServerStartedInfo.Text += 'IPs:' + _server.ipv4.ToString() + #10;
    ServerStartedInfo.Text += 'Port:' + _server.port.ToString() + #10;
    
    ServerCreateButton.Text := 'Остановить';
    
    try
      _server_service.Start();
    except 
      _server_service.Resume();
      
    end;
    
  end;
  
end;


procedure MainWindow.ClientConnectButton_Click(sender: Object; e: EventArgs);
begin
  if (_server_is_working) then exit;
  
  if _client = nil then begin
    var serverIP: string = '172.19.0.1';//ClientIPMask.Text.Replace(' ', '');
    
    _client := new TClient(serverIP);
    _client.Connect();
    
    if clientConnectingProgress.Value <> 0 then
      clientConnectingProgress.Increment(-clientConnectingProgress.Value);
    
    clientConnectState.ResetText();
    
    Thread.Create(
      () -> begin
        self.Invoke( 
          procedure () -> begin
            ClientIPMask.Enabled := false;
            while (_client.client = nil) and (_client.retry < 5) do
              clientConnectingProgress.Increment(_client.retry - clientConnectingProgress.Value);
            
            clientConnectingProgress.Increment(5);
            clientConnectState.Text := _client.ConnectedMsg();
            if _client.client = nil then begin
              ClientIPMask.Enabled := true;
              _client := nil;
            end else begin
              clientConnectButton.Text := 'Отключиться';
              AppState := ApplicationState.CLIENT;
              Thread.Create(procedure () -> ClientConnectionStateMonitoring).Start();
            end;
          end
        );
      end
    ).Start();
  end
  else begin
    ClientIPMask.Enabled := true;
    
    clientConnectButton.Text := 'Подключиться';
    clientConnectState.Text := 'Не подключено';
    
    clientConnectingProgress.Value := 0;
    
    _client.Disconnect(); 
    _client := nil;
  end;
  
end;


procedure MainWindow.ClientConnectionStateMonitoring();
begin

  while _client.AppIsRunning do
    Thread.Sleep(1000);
  
  ClientIPMask.Enabled := true;
  
  clientConnectButton.Text := 'Подключиться';
  clientConnectState.Text := 'Не подключено';
  
  clientConnectingProgress.Value := 0;
  
  _client := nil;
  
  ErrorHundler('Сервер закрыл соединение!');
end;


procedure MainWindow.ClientIPMask_KeyPress(sender: Object; e: KeyPressEventArgs);
begin
  if e.KeyChar = #13 then 
    self.ClientConnectButton_Click(sender, e);
end;


procedure MainWindow.ServerConnectionService();
begin
  while _server_is_working do begin
    if _server.CountOfClients <> _server_count_of_clients then begin
            
      // Используем Invoke для безопасного доступа к UI-элементам
      self.Invoke(
        procedure () -> begin
          if (_server_count_of_clients = 0) and (_server.CountOfClients > 0) then begin
            Thread.Sleep(100);
            
            _server.SelectFirstClient();
            ErrorHundler($'{_server.selectedClient.WinInfo.ComputerName} подключился{#13}IP:{_server.selectedClient.ip}');
            
            ClientControlTab.Enabled := true;
            
            var path: string = _server.MessageHandler(GETPATH);
            
            // Console
            consoleBox.AppendText(path+'>');
            
            consoleBox.SelectionStart := consoleBox.Text.Length;
            
            // Explorer
            self.LabelPath.Text := path;
            explorer.init(self.ExplorerTab, 
                          self.FilesIconList, 
                          self.ExplorerToolBar, 
                          self.ExplorerDirectory_DoubleClick,
                          self.ExplorerItemContextMenu);
                          
            explorer.Update(_server.MessageHandler(E_GET_DIRS),
                            _server.MessageHandler(E_GET_FILES));
            
          end 
          else if (_server_count_of_clients > 0) and (_server.CountOfClients = 0) then begin
            cls();
            ClientControlTab.Enabled := false;
            _server.selectedClient := nil;
          end;
         
        end
      );
      _server_count_of_clients := _server.CountOfClients;
      self.UpdateCountOfClientsLabel();
      
    end;
  end; // while

end;


procedure MainWindow.UpdateCountOfClientsLabel := CountOfClientsLabel.Text := 
                                       CountOfClientsLabel.Text.Substring(0, 
                                       CountOfClientsLabel.Text.IndexOf(':')+1) +
                                       _server_count_of_clients.ToString;

/// Очищает консольное окно
procedure MainWindow.cls(_t: string) := ConsoleBox.Text := _t;
 
 
procedure MainWindow.ConsoleBox_KeyDown(sender: Object; e: KeyEventArgs);
begin
  {$region Options}
  
  if e.KeyCode in [Keys.UP, Keys.Down] then begin
    e.Handled := true;
    exit;
  end;
  
  var pos := ConsoleBox.Text.LastIndexOf('>');
  
  if e.KeyCode = Keys.Home then begin
    e.Handled := true;
    ConsoleBox.SelectionStart := pos+1;
    exit;
  end;
  
  if e.KeyCode = Keys.End then begin
    e.Handled := true;
    ConsoleBox.SelectionStart := ConsoleBox.Text.Length;
    exit;
  end;

  // Нельзя переступать стрелкой влево знак >
  if (e.KeyCode = Keys.Left) and (ConsoleBox.SelectionStart = pos+1) then begin
    e.Handled := true;
    ConsoleBox.SelectionStart := pos + 1;
    exit;
  end;
  
  // Backspace можно использовать только когда курсор стоит после знака >
  if (e.KeyCode = Keys.Back) and (not(ConsoleBox.SelectionStart > pos+1)) then begin
    e.Handled := true;
    e.SuppressKeyPress := true;
    exit;
  end;
  
  // Запрещаем редактирование предыдущего текста
  if ConsoleBox.SelectionStart < pos+1 then begin
    e.Handled := true;
    e.SuppressKeyPress := true;
    exit;
  end;
    
  {$endregion Options}
  // -------------------------- Enter Pressed -------------------------- //
  
  if e.KeyCode <> Keys.Enter then exit;
  
  e.SuppressKeyPress := true; // Отключаем звук Enter
    
  var command := consoleBox.Lines[consoleBox.Lines.Length-1][2:];
  
  if command in ['cls', 'clear'] then begin
    cls(_server.MessageHandler(GETPATH) + '>');
    exit;
  end;
  
  var msg: string = '';
  if not(command in AllDelimiters) then 
    msg := _server.MessageHandler(command);
  
  if 'cd' in command then
    consoleBox.AppendText(#13#10 + _server.MessageHandler(GETPATH) + '>') else
  consoleBox.AppendText(#13#10 + msg + #13#10 + _server.MessageHandler(GETPATH) + '>');
  
  // Автопрокрутка вниз
  consoleBox.SelectionStart := consoleBox.Text.Length;
  consoleBox.ScrollToCaret();
  
end;


procedure MainWindow.ConsoleBox_MouseDown(sender: Object; e: MouseEventArgs);
begin
  if e.Button = System.Windows.Forms.MouseButtons.Right then begin
    if ConsoleBox.SelectionLength > 0 then
      Clipboard.SetText(Copy(ConsoleBox.Text, ConsoleBox.SelectionStart, ConsoleBox.SelectionLength)) else
    if Clipboard.ContainsText() then
      ConsoleBox.Text += Clipboard.GetText();
  consoleBox.SelectionStart := consoleBox.Text.Length;
  consoleBox.ScrollToCaret();
  end;
end;


procedure MainWindow.ExplorerTab_Resize(
          sender: Object; e: EventArgs) := 
          explorer.Update(is_not_new_dir := true);


procedure MainWindow.ExplorerToolBarButtonUp_Click(sender: Object; e: EventArgs);
begin
  self.LabelPath.Text := _server.MessageHandler(E_ARROW_UP);
  explorer.Update(_server.MessageHandler(E_GET_DIRS),
                  _server.MessageHandler(E_GET_FILES));
end;


procedure MainWindow.ExplorerDirectory_DoubleClick(sender: Object; e: EventArgs);
begin
  var container := explorer.GetSplitContainer(sender);
  var folder_name: string = container.Panel2.Controls[0].Text;
  
  var response: string = _server.MessageHandler(E_ENTER_FOLDER+folder_name);
  
  if response.StartsWith('R@') then 
    ErrorHundler(response) 
  else begin
    self.LabelPath.Text += '\' + folder_name;
    explorer.Update(_server.MessageHandler(E_GET_DIRS),
                    _server.MessageHandler(E_GET_FILES));
  end;                  
end;


procedure MainWindow.__update_MouseDown(sender: Object; e: MouseEventArgs) :=
  explorer.Update(_server.MessageHandler(E_GET_DIRS),
                  _server.MessageHandler(E_GET_FILES));


procedure MainWindow.__select_all_Click(sender: Object; e: EventArgs);
begin
  for var id := 0 to ExplorerTab.Controls.Count-1 do
    if ExplorerTab.Controls[id] is SplitContainer then begin
      ExplorerTab.Controls[id].BackColor := explorer.selected_color;
      selected_items.Add(ExplorerTab.Controls[id] as SplitContainer);
    end;  
end;


procedure MainWindow.__receive_file_Click(sender: Object; e: EventArgs);
begin
  if (explorer.selected_items[0].Panel1.Controls[0] as System.Windows.Forms.Label).ImageKey = 'dir.png' then begin
    MessageBox.Show('Нельзя передать папку!', 'Передача файла', MessageBoxButtons.OK, MessageBoxIcon.Error);
    exit;
  end;
  var fileName := explorer.selected_items[0].Panel2.Controls[0].Text;
  var saveDialog := new SaveFileDialog();
      saveDialog.Filter := 'All files (*.*)|*.*|Text files (*.txt)|*.txt';
      saveDialog.Title := 'Сохранить файл как...';
      saveDialog.FileName := fileName;
      saveDialog.InitialDirectory := System.Environment.GetFolderPath(System.Environment.SpecialFolder.MyDocuments);
  
  if saveDialog.ShowDialog() = System.Windows.Forms.DialogResult.OK then
  begin
    var savePath := saveDialog.FileName;
    
    if _server.ReceiveFile(fileName, savePath) then
      MessageBox.Show('Файл успешно сохранен по пути: ' + savePath, 'Передача файла', MessageBoxButtons.OK, MessageBoxIcon.Asterisk) else 
      MessageBox.Show('Произошла ошибка при передаче файла!', 'Передача файла', MessageBoxButtons.OK, MessageBoxIcon.Error)
  end else
      MessageBox.Show('Сохранение отменено пользователем!', 'Передача файла', MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
end;


procedure MainWindow.OpenListOfConnectedDevices_Click(sender: Object; e: EventArgs);
begin
  new ListWindow(_server);
end;


end.