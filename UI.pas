unit UI;

interface

uses 
  System, 
  System.Drawing, 
  System.Threading,
  System.Windows.Forms,  
  explorer, server, client, types;

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
    procedure ConsoleBox_KeyDown(sender: Object; e: KeyEventArgs);
    procedure ConsoleBox_MouseDown(sender: Object; e: MouseEventArgs);
    procedure cls(_t: string := '');
    procedure ExplorerTab_Resize(sender: Object; e: EventArgs);
    procedure ExplorerToolBarButtonUp_Click(sender: Object; e: EventArgs);
    procedure ExplorerDirectory_DoubleClick(sender: Object; e: EventArgs);
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
    clientConnectingProgress: ProgressBar;
    {$include UI.MainWindow.inc}
  {$endregion FormDesigner}
  public
    constructor;
    begin
      InitializeComponent;
      _server_service := new Thread(ServerConnectionService);
      _server_service.Name := 'service';
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
  
  if _server_is_working then begin
    
    _server_service.Suspend();
    _server_is_working := false;
    _server.Stop();
    
    ServerStartedInfo.Visible := false;
    
    ServerCreateButton.Text := 'Запустить сервер';
    
    ClientControlTab.Enabled := false;
    
  end else begin
    
    AppState := ApplicationState.SERVER;
    
    _server_is_working := true;
    _server_count_of_clients := 0;
    
    if _server = nil then begin
      _server := new TcpServer();
      _server.Start();
    end else 
      _server.Resume();
    
    ServerStartedInfo.Visible := true;
    ServerStartedInfo.Text := 'Сервер успешно запущен' + #10;
    ServerStartedInfo.Text += 'IPv4:' + _server.ipv4.ToString() + #10;
    ServerStartedInfo.Text += 'IPv6:' + _server.ipv6.ToString() + #10;
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
    var serverIP: string = '172.29.80.1';//ClientIPMask.Text.Replace(' ', '');
    
    _client := new TClient(serverIP);
    _client.Connect();
    
    if clientConnectingProgress.Value <> 0 then
      clientConnectingProgress.Increment(-clientConnectingProgress.Value);
    
    clientConnectState.ResetText();
    
    Thread.Create(
      () -> begin
        self.Invoke( procedure () -> begin
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
          end;
        end);
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
          if (_server_count_of_clients = 0) and (_server.CountOfClients > 0) then 
          begin
            Thread.Sleep(100);
            ClientControlTab.Enabled := true;
            
            var path: string = _server.MessageHandler(GETPATH);
            
            // Console
            consoleBox.AppendText(path+'>');
            consoleBox.SelectionStart := consoleBox.Text.Length;
            
            // Explorer
            self.LabelPath.Text := path;
            explorer.init(self.ExplorerTab, self.FilesIconList, self.ExplorerToolBar, self.ExplorerDirectory_DoubleClick);
            explorer.Update(_server.MessageHandler(E_GET_DIRS),
                            _server.MessageHandler(E_GET_FILES));
            
          end 
          else if (_server_count_of_clients > 0) and (_server.CountOfClients = 0) then 
          begin
            cls();
            ClientControlTab.Enabled := false;
          end;
          
          _server_count_of_clients := _server.CountOfClients;
          CountOfClientsLabel.Text := $'{Copy(CountOfClientsLabel.Text, 1, 23)} {_server_count_of_clients}';
        end
      );
      
    end;
  end; // while
end;

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
  sender: Object; 
  e: EventArgs
) := explorer.Update(is_not_new_dir := true);


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
  
  self.LabelPath.Text += '\' + folder_name;
  
  _server.MessageHandler(E_ENTER_FOLDER+folder_name);
  
  explorer.Update(_server.MessageHandler(E_GET_DIRS),
                  _server.MessageHandler(E_GET_FILES));
end;

end.