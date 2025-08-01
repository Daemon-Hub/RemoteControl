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
  ProgressOverlayWindow,
  ListOfConnectedDevices,
  Newtonsoft.Json;

type
  ApplicationState = (NULL, SERVER, CLIENT);


type
  MainWindow = class(Form)
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
    procedure ExplorerPanel_Resize(sender: Object; e: EventArgs);
    procedure ExplorerPanel_MouseDown(sender: Object; e: MouseEventArgs);
    procedure ExplorerToolBarButtonUp_Click(sender: Object; e: EventArgs);
    procedure ExplorerDirectory_DoubleClick(sender: Object; e: EventArgs);
    procedure __update_MouseDown(sender: Object; e: MouseEventArgs);
    procedure __select_all_Click(sender: Object; e: EventArgs);
    procedure __receive_file_Click(sender: Object; e: EventArgs);
    procedure OpenListOfConnectedDevices_Click(sender: Object; e: EventArgs);
    procedure UpdateSelectedDevice(NewDevice: TClient);
    procedure __cut_MouseDown(sender: Object; e: MouseEventArgs);
    procedure __copy_MouseDown(sender: Object; e: MouseEventArgs);
    procedure __paste_MouseDown(sender: Object; e: MouseEventArgs);
    procedure __delete_MouseDown(sender: Object; e: MouseEventArgs);
    procedure ExplorerHomeBtn_MouseDown(sender: Object; e: MouseEventArgs);
    procedure __rename_MouseDown(sender: Object; e: MouseEventArgs);
    procedure __rename_send_KeyDown(sender: Object; e: KeyEventArgs);
    procedure ManualOpenBtn_MouseDown(sender: Object; e: MouseEventArgs);
    procedure ExplorerPathLabel_DoubleClick(sender: Object; e: EventArgs);
    procedure ExplorerToolBar_Resize(sender: Object; e: EventArgs);
    procedure EditPathText_KeyDown(sender: Object; e: KeyEventArgs);
    procedure EditPathText_LostFocus(sender: Object; e: EventArgs);
    procedure ItemLabel_Leave(sender: Object; e: EventArgs);
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
    ItemLabel: &Label;
    ExplorerToolBar: ToolStrip;
    ExplorerToolBarButtonUp: ToolStripButton;
    ExplorerTabContextMenu: System.Windows.Forms.ContextMenuStrip;
    __paste: ToolStripMenuItem;
    __update: ToolStripMenuItem;
    __select_all: ToolStripMenuItem;
    ExplorerItemContextMenu: System.Windows.Forms.ContextMenuStrip;
    __copy: ToolStripMenuItem;
    __cut: ToolStripMenuItem;
    __rename: ToolStripMenuItem;
    __receive_file: ToolStripMenuItem;
    OpenListOfConnectedDevices: Button;
    ExplorerItemsUpdateButton: ToolStripButton;
    __delete: ToolStripMenuItem;
    SelectAllItems: ToolStripButton;
    PasteSelectedBtn: ToolStripButton;
    ExplorerHomeBtn: ToolStripButton;
    ExplorerPathLabel: ToolStripLabel;
    SettingsTab: TabPage;
    ManualOpenBtn: Button;
    CopyrightText: &Label;
    ExplorerPanel: Panel;
    clientConnectingProgress: ProgressBar;
    {$include UI.MainWindow.inc}
  {$endregion FormDesigner}
  public
    _server: TcpServer;
    _server_is_working: boolean;
    _server_count_of_clients: integer;
    _server_service: Thread;
    clientsNumberChangedEvent: AutoResetEvent;
    
    _client: TClient;
    
    AppState: ApplicationState;
    
    ConnectedDevicesListWindow: ListWindow;
  
    constructor;
    begin
      InitializeComponent;
      self.DoubleBuffered := true;
      self.ExplorerPanel.DoubleBuffered := true;
      self._server_service := new Thread(ServerConnectionService);
      self._server_service.Name := 'service';
      self.clientsNumberChangedEvent := new AutoResetEvent(false);
      types.InitWinIcons();
    end;
  end;

implementation


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
    
    AppState := ApplicationState.NULL;
    
    _server_service.Suspend();
    _server_is_working := false;
    _server.Stop();
    _server.Finalize();
    _server := nil;
    
    ServerStartedInfo.Visible := false;
    
    ServerCreateButton.Text := ' '*5+ 'Запустить сервер';
    ServerCreateButton.ImageKey := 'off.png';
    ServerCreateButton.Size := new System.Drawing.Size(185, 38);
    
    ClientControlTab.Enabled := false;
    
    self.UpdateCountOfClientsLabel();
    
  end else begin
    
    AppState := ApplicationState.SERVER;
    
    _server_is_working := true;
    
    if _server = nil then begin
      _server := new TcpServer(self.clientsNumberChangedEvent);
      _server.Start();
    end;
    
    ServerStartedInfo.Visible := true;
    ServerStartedInfo.Text := 'Доступные адаптеры:' + #10*2 + _server.ipv4.ToString();
    
    ServerCreateButton.Text := ' '*5+ 'Остановить';
    ServerCreateButton.ImageKey := 'on.png';
    ServerCreateButton.Size := new System.Drawing.Size(140, 38);
    
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
    var serverIP: string = ClientIPMask.Text.Replace(' ', '');
    
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
          AppState := ApplicationState.NULL;
        end else begin
          clientConnectButton.Text := ' '*5+ 'Отключиться';
          clientConnectButton.ImageKey := 'connected.png';
          AppState := ApplicationState.CLIENT;
          Thread.Create(procedure () -> ClientConnectionStateMonitoring).Start();
        end;
      end);
    end).Start();
  end
  else begin
    ClientIPMask.Enabled := true;
    
    clientConnectButton.Text := ' '*6+ 'Подключиться';
    clientConnectButton.ImageKey := 'disconnected.png';
    
    clientConnectState.Text := 'Не подключено';
    
    clientConnectingProgress.Value := 0;
    
    _client.Disconnect(); 
    _client := nil;
    
    AppState := ApplicationState.NULL;
  end;
  
end;


procedure MainWindow.ClientConnectionStateMonitoring();
begin
  
  while not(_client = nil) and _client.AppIsRunning do
    Thread.Sleep(1000);
  
  ClientIPMask.Enabled := true;
  
  clientConnectButton.Text := ' '*6+ 'Подключиться';
  clientConnectButton.ImageKey := 'disconnected.png';
  
  clientConnectState.Text := 'Не подключено';
  
  clientConnectingProgress.Value := 0;
  
  _client := nil;
  AppState := ApplicationState.NULL;
  
  ErrorHandler('Сервер закрыл соединение!');
end;


procedure MainWindow.ClientIPMask_KeyPress(sender: Object; e: KeyPressEventArgs);
begin
  if e.KeyChar = #13 then 
    self.ClientConnectButton_Click(sender, e);
end;


procedure MainWindow.ServerConnectionService();
begin
  while _server_is_working do
  begin
    
    self.clientsNumberChangedEvent.WaitOne(); 
    if not _server_is_working then break;
      
    self.Invoke(
      procedure () -> begin
      if (_server_count_of_clients < _server.CountOfClients) then
        ErrorHandler($'{_server.tail.WinInfo.ComputerName} подключился{#13}IP:{_server.tail.ip}');
      if (_server_count_of_clients = 0) and (_server.CountOfClients > 0) then begin
        Thread.Sleep(100);
        
        self.ClientControlTab.Enabled := true;
        self.OpenListOfConnectedDevices.Enabled := true;  
        
        explorer.init(self.ExplorerPanel, 
                      self.FilesIconList, 
                      self.ExplorerToolBar, 
                      self.ExplorerDirectory_DoubleClick,
                      self.ExplorerItemContextMenu);
        
        self.UpdateSelectedDevice(_server.head); 
      end 
      else if (_server_count_of_clients > 0) and (_server.CountOfClients = 0) then begin
        cls();
        self.ClientControlTab.Enabled := false;
        self.OpenListOfConnectedDevices.Enabled := false; 
        _server.selectedClient := nil;
      end;
      
    end);
      
    _server_count_of_clients := _server.CountOfClients;
    self.UpdateCountOfClientsLabel();

  end; // while
  
end;


procedure MainWindow.UpdateSelectedDevice(NewDevice: TClient);
begin
  _server.selectedClient := NewDevice;
  
  // Console
  self.ConsoleBox.Text := '';
  self.ConsoleBox.AppendText(_server.MessageHandler(GETPATH) + '>');
  self.ConsoleBox.SelectionStart := self.consoleBox.Text.Length;
  
  // Explorer
  self.ExplorerPathLabel.Text := 'Главная';
  explorer.UpdateHomePage(NewDevice.WinInfo.ExInfo);

end;


procedure MainWindow.UpdateCountOfClientsLabel();
begin
  self.Invoke(procedure () -> CountOfClientsLabel.Text := 
   CountOfClientsLabel.Text.Substring(0, 
   CountOfClientsLabel.Text.IndexOf(':') + 1) +
   _server_count_of_clients.ToString
  );
end;


procedure MainWindow.cls(_t: string) := ConsoleBox.Text := _t;


procedure MainWindow.ConsoleBox_KeyDown(sender: Object; e: KeyEventArgs);
begin
  {$region Options}
  
  // Отключаем стрелки верх и вниз
  if e.KeyCode in [Keys.UP, Keys.Down] then begin
    e.Handled := true;
    exit;
  end;
  
  // Позиция с которой начинается ввод команды
  var inputStart: integer = ConsoleBox.Text.LastIndexOf('>') + 1;
  
  // На клавишу Home перемещаемся в начало строки
  if e.KeyCode = Keys.Home then begin
    e.Handled := true;
    ConsoleBox.SelectionStart := inputStart;
    exit;
  end;
  
  // На клавишу End перемещаемся в конец строки
  if e.KeyCode = Keys.End then begin
    e.Handled := true;
    ConsoleBox.SelectionStart := ConsoleBox.Text.Length;
    exit;
  end;
  
  // Нельзя переступать знак '>' клавишей лево 
  if (e.KeyCode = Keys.Left) and (ConsoleBox.SelectionStart = inputStart) then begin
    e.Handled := true;
    ConsoleBox.SelectionStart := inputStart;
    exit;
  end;
  
  // Backspace можно использовать только когда курсор стоит после знака >
  if (e.KeyCode = Keys.Back) and (ConsoleBox.SelectionStart <= inputStart) then begin
    e.Handled := true;
    e.SuppressKeyPress := true;
    exit;
  end;
  
  // Запрещаем редактирование предыдущего текста
  if ConsoleBox.SelectionStart < inputStart then 
    ConsoleBox.SelectionStart := ConsoleBox.Text.Length;
  
  // Отслеживаем переполнение консоли
  if ConsoleBox.Text.Length >= 60000 then
  begin
    var startCut := ConsoleBox.Text.IndexOf(#13#10, ConsoleBox.Text.Length div 2);
    if startCut <> -1 then
      ConsoleBox.Text := ConsoleBox.Text.Substring(startCut + 2); // +2 = длина CRLF
    inputStart := ConsoleBox.Text.LastIndexOf('>') + 1;
  end;

  
  {$endregion Options}
  // -------------------------- Enter Pressed -------------------------- //
  // Println(ConsoleBox.Text.Length);
  if e.KeyCode <> Keys.Enter then exit;
  
  e.SuppressKeyPress := true; 
  
  var command := ConsoleBox.Text.Substring(inputStart);
  
  if command in ['cls', 'clear'] then begin
    cls(_server.MessageHandler(GETPATH) + '>');
    exit;
  end;
  
  var msg: string = '';
  if not (command in AllDelimiters) then 
    msg := _server.MessageHandler(command);
  
  if 'cd' in command then
    ConsoleBox.AppendText(#13#10 + _server.MessageHandler(GETPATH) + '>') else
    ConsoleBox.AppendText(#13#10 + msg + #13#10 + _server.MessageHandler(GETPATH) + '>');
  
  // Автопрокрутка вниз
  ConsoleBox.SelectionStart := ConsoleBox.Text.Length;
  ConsoleBox.ScrollToCaret();
  
end;


procedure MainWindow.ConsoleBox_MouseDown(sender: Object; e: MouseEventArgs);
begin
  if e.Button = System.Windows.Forms.MouseButtons.Right then begin
    if ConsoleBox.SelectionLength > 0 then
      Clipboard.SetText(ConsoleBox.SelectedText)
                    else
    if Clipboard.ContainsText() then
      ConsoleBox.Text += Clipboard.GetText();
    consoleBox.SelectionStart := consoleBox.Text.Length;
    consoleBox.ScrollToCaret();
  end;
end;


procedure MainWindow.ExplorerPanel_Resize(sender: Object; e: EventArgs);
begin
  if self._server_count_of_clients <= 0 then exit;
  if self.ExplorerPathLabel.Text = 'Главная' then
    explorer.UpdateHomePage(explorer.home_info, false) else  
    explorer.UpdateItemsLocation();
end;


procedure MainWindow.ExplorerPanel_MouseDown(sender: Object; e: MouseEventArgs);
begin
  explorer.DeleteAllSelectedItems();
end;


procedure MainWindow.ExplorerToolBarButtonUp_Click(sender: Object; e: EventArgs);
begin
  if self.ExplorerPathLabel.Text = 'Главная' then exit;
//  Println(self.ExplorerPathLabel.Text);
  explorer.DeleteAllSelectedItems();
  
  if self.ExplorerPathLabel.Text in explorer.home_info.DrivesNames() then begin
    self.ExplorerPathLabel.Text := 'Главная';
    explorer.UpdateHomePage(_server.UpdateExInfo());
  end else begin
    self.ExplorerPathLabel.Text := _server.MessageHandler(E_ARROW_UP);
    explorer.Update(_server.MessageHandler(E_GET_DIRS),
                    _server.MessageHandler(E_GET_FILES));    
  end;
end;


procedure MainWindow.ExplorerDirectory_DoubleClick(sender: Object; e: EventArgs);
begin
  var container := sender as &Label;
  var folder_name, response: string;
  
  explorer.DeleteAllSelectedItems();
  
  folder_name := container.Text.Trim;
  if self.ExplorerPathLabel.Text = 'Главная' then begin
    if not(':\' in folder_name) then
      folder_name := explorer.home_info.GetItem(folder_name);
    response := _server.MessageHandler(E_ENTER_SHORTCUT + folder_name);
  end else
    response := _server.MessageHandler(E_ENTER_FOLDER + folder_name);
  
  if response.StartsWith('R@') then 
    ErrorHandler(response) 
  else begin
    if self.ExplorerPathLabel.Text = 'Главная' then
       self.ExplorerPathLabel.Text := folder_name 
    else begin
      if self.ExplorerPathLabel.Text in explorer.home_info.DrivesNames() then
         self.ExplorerPathLabel.Text += folder_name
      else
         self.ExplorerPathLabel.Text += SLASH + folder_name;
    end;
    explorer.Update(_server.MessageHandler(E_GET_DIRS),
                    _server.MessageHandler(E_GET_FILES));
  end;                  
end;


procedure MainWindow.__update_MouseDown(sender: Object; e: MouseEventArgs);
begin
  if self.ExplorerPathLabel.Text = 'Главная' then
    explorer.UpdateHomePage(_server.UpdateExInfo())
  else
    explorer.Update(_server.MessageHandler(E_GET_DIRS), 
                    _server.MessageHandler(E_GET_FILES));
end;                


procedure MainWindow.__select_all_Click(sender: Object; e: EventArgs);
begin
  for var id := 0 to ExplorerPanel.Controls.Count - 1 do
    if ExplorerPanel.Controls[id] is &Label then begin
      ExplorerPanel.Controls[id].BackColor := explorer.selected_color;
      selected_items.Add(ExplorerPanel.Controls[id] as &Label);
    end;  
end;


procedure MainWindow.__receive_file_Click(sender: Object; e: EventArgs);
begin
  var folderDialog := new FolderBrowserDialog();
  folderDialog.Description := 'Выберите папку для сохранения файлов';

  if not(folderDialog.ShowDialog() = System.Windows.Forms.DialogResult.OK) then begin
    MessageBox.Show('Сохранение отменено пользователем!', 'Передача файла', MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
    exit;
  end;
  var savePath: string = folderDialog.SelectedPath;
  
  self.Enabled := false;

  var progWin := new ProgressOverlay();
      progWin.Location := new Point(
        self.Left + (self.Width - progWin.Width) div 2,
        self.Top + (self.Height - progWin.Height) div 2);
      progWin.Show();
      
  var totalFiles := selected_items.Count;
  var currentFile := 0;
  
  foreach var item in explorer.selected_items do begin
    var fileName := item.Text.Trim;
    if item.ImageKey = 'dir.png' then begin
      var response := JsonConvert.DeserializeObject&<array of string>(
        _server.MessageHandler(
          E_GET_ALL_FILES_IN_FOLDER+$'{self.ExplorerPathLabel.Text}{SLASH}{fileName}'
        )
      );
      totalFiles += response.Length - 1;
      foreach file_path: string in response do begin
        var finalPath := savePath + file_path.Replace(self.ExplorerPathLabel.Text, '');
        self._server.ReceiveFile(file_path, finalPath);
        Inc(currentFile);
        progWin.SetProgress(currentFile, totalFiles);
      end;
    end else begin
      self._server.ReceiveFile(
        $'{self.ExplorerPathLabel.Text}{SLASH}{fileName}', 
        $'{savePath}{SLASH}{fileName}'
      );
      Inc(currentFile);
      progWin.SetProgress(currentFile, totalFiles);
    end;
  end;
  
  self.Enabled := true;
  
  progWin.Close();
  progWin.Dispose(true);
  
  MessageBox.Show('Выбранные файлы успешно сохранены по пути: ' + #13#10 + savePath, 'Передача завершена!', MessageBoxButtons.OK, MessageBoxIcon.Asterisk);
end;


procedure MainWindow.__cut_MouseDown(sender: Object; e: MouseEventArgs);
begin
  explorer.cut_or_copy_item_info.Code := E_CUT_ITEM;
  explorer.cut_or_copy_item_info.SourcePath := self.ExplorerPathLabel.Text;
  explorer.cut_or_copy_item_info.Items := explorer.GetSelectedItemsNames();
end;


procedure MainWindow.__copy_MouseDown(sender: Object; e: MouseEventArgs);
begin
  explorer.cut_or_copy_item_info.Code := E_COPY_ITEM;
  explorer.cut_or_copy_item_info.SourcePath := self.ExplorerPathLabel.Text;
  explorer.cut_or_copy_item_info.Items := explorer.GetSelectedItemsNames();
end;


procedure MainWindow.__paste_MouseDown(sender: Object; e: MouseEventArgs);
begin
  if (explorer.cut_or_copy_item_info.Code = nil) or
     (explorer.cut_or_copy_item_info.TakeFrom = nil) or 
     (self.ExplorerPathLabel.Text = 'Главная') then exit;
  
  explorer.cut_or_copy_item_info.DestinationPath := self.ExplorerPathLabel.Text;
  var request: string = JsonConvert.SerializeObject(explorer.cut_or_copy_item_info);
  
  ErrorHandler(_server.MessageHandler(E_PASTE_ITEM + request));
  explorer.Update(_server.MessageHandler(E_GET_DIRS),
                  _server.MessageHandler(E_GET_FILES));
end;


procedure MainWindow.__delete_MouseDown(sender: Object; e: MouseEventArgs);
begin
  var items := explorer.GetSelectedItemsNames();
  
  if MessageBox.Show(
      'Вы подтверждайте удаление всех выделенных объектов?',
      'Удаление выделеного', 
      MessageBoxButtons.YesNo, 
      MessageBoxIcon.Question) = System.Windows.Forms.DialogResult.No 
  then exit;

  ErrorHandler(
    _server.MessageHandler(
      E_DELETE_ITEM +
      self.ExplorerPathLabel.Text + 
      items
    )
  );
  explorer.Update(_server.MessageHandler(E_GET_DIRS),
                  _server.MessageHandler(E_GET_FILES));
end;


procedure MainWindow.OpenListOfConnectedDevices_Click(sender: Object; e: EventArgs);
begin
  if ConnectedDevicesListWindow = nil then
    self.ConnectedDevicesListWindow := new ListWindow(_server, self.UpdateSelectedDevice)
  else begin
    if self.ConnectedDevicesListWindow.Visible then
      self.ConnectedDevicesListWindow.Activate() 
    else begin
      self.ConnectedDevicesListWindow.Update();
      self.ConnectedDevicesListWindow.Show();
    end;
  end;
end;


procedure MainWindow.ExplorerHomeBtn_MouseDown(sender: Object; e: MouseEventArgs);
begin
  self.ExplorerPathLabel.Text := 'Главная';
  explorer.UpdateHomePage(explorer.home_info, false);
end;


procedure MainWindow.__rename_MouseDown(sender: Object; e: MouseEventArgs);
begin
  if selected_items.Count > 1 then
    DeleteAllSelectedItemsExceptSelected(selected_items[0]);
  
  var lbT := selected_items[0];
  
  rename_field := new TextBox();
  rename_field.MaximumSize := new System.Drawing.Size(lbT.Size.Width, lbT.Size.Height div 2 - 1);
  rename_field.Size := new System.Drawing.Size(lbT.Size.Width, lbT.Size.Height div 2 - 1);
  rename_field.Dock := DockStyle.None;
  rename_field.Parent := lbT.Parent;
  rename_field.Location := new Point(lbT.Location.X, lbT.Location.Y+50);
  rename_field.Text := lbT.Text.Trim;
  rename_field.TextAlign := HorizontalAlignment.Center;
  rename_field.Multiline := true;
  rename_field.KeyDown += __rename_send_KeyDown;
  rename_field.Focus();
  rename_field.BringToFront();
  rename_field.SelectAll();
  
end;


procedure MainWindow.__rename_send_KeyDown(sender: Object; e: KeyEventArgs);
begin
  if e.KeyCode = Keys.Enter then begin
    e.Handled := true;
    var newText := sender as TextBox;
    var lbT := selected_items[0]; _server.MessageHandler(E_RENAME + lbT.Text.Trim + '#' + newText.Text);
        lbT.Text := label_text_start+newText.Text;
    ExplorerPanel.Controls.Remove(newText);
    rename_field.Dispose();
  end;
end;


procedure MainWindow.ManualOpenBtn_MouseDown(sender: Object; e: MouseEventArgs);
begin
  Execute(System.IO.Path.Combine(System.IO.Path.GetTempPath(), 'HowToUse.chm'));
end;


procedure MainWindow.ExplorerPathLabel_DoubleClick(sender: Object; e: EventArgs);
begin
  var lbT := sender as ToolStripLabel;
      lbT.Enabled := false;
      lbT.Visible := false;
  
  rename_path := new ToolStripTextBox;
  rename_path.Size := lbT.Size;
  rename_path.Overflow := lbT.Overflow;
  rename_path.Text := lbT.Text;
  rename_path.TextAlign := lbT.TextAlign;
  rename_path.Multiline := false;
  rename_path.KeyDown += EditPathText_KeyDown;
  rename_path.LostFocus += EditPathText_LostFocus;
  rename_path.Focus();
  rename_path.SelectAll();
  
  self.ExplorerToolBar.Items.Add(rename_path);
end;


procedure MainWindow.EditPathText_KeyDown(sender: Object; e: KeyEventArgs);
begin
  if e.KeyCode = Keys.Enter then begin
    e.Handled := true;
    var newText := sender as ToolStripTextBox;
    if (newText.Text <> '') and (newText.Text <> 'Главная') then begin
      if _server.MessageHandler(E_RENAME_PATH + newText.Text) = E_ERROR_RENAME_PATH then 
        MessageBox.Show('Ошибка в пути! Такой директории не существует!', 'Изменение пути', MessageBoxButtons.OK, MessageBoxIcon.Error)
      else 
        self.ExplorerPathLabel.Text := newText.Text.Trim(' ', #10, SLASH);
    end else 
      self.ExplorerPathLabel.Text := 'Главная';
    self.ExplorerPathLabel.Enabled := true;
    self.ExplorerPathLabel.Visible := true;
    self.__update_MouseDown(self.__update, new MouseEventArgs(System.Windows.Forms.MouseButtons.Left,0,0,0,0));
    self.ExplorerToolBar.Items.Remove(rename_path);
    rename_path.Dispose();
  end;
end;


procedure MainWindow.EditPathText_LostFocus(sender: Object; e: EventArgs);
begin
  self.ExplorerPathLabel.Enabled := true;
  self.ExplorerPathLabel.Visible := true;
  self.ExplorerToolBar.Items.Remove(rename_path);
  rename_path.Dispose();
end;


procedure MainWindow.ExplorerToolBar_Resize(sender: Object; e: EventArgs);
begin
  self.ExplorerPathLabel.Width := (sender as ToolStrip).Width - 150;
end;

procedure MainWindow.ItemLabel_Leave(sender: Object; e: EventArgs);
begin
  
end;



end.