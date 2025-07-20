unit ListOfConnectedDevices;

interface

uses System, System.Drawing, System.Windows.Forms, client, server, types;

type
  ListWindow = class(Form)
    function NewItem(desc: string; selected: boolean): SplitContainer;
    procedure label2_Click(sender: Object; e: EventArgs);
    procedure ListWindow_Load(sender: Object; e: EventArgs);
    procedure Update();
    function GetImage(IconKey: string): Image;
    procedure StateButton_MouseDown(sender: Object; e: MouseEventArgs);
  {$region FormDesigner}
  internal
    {$resource ListOfConnectedDevices.ListWindow.resources}
    ConnectedDevice: SplitContainer;
    DeviceIcon: &Label;
    components: System.ComponentModel.IContainer;
    StateButton: CheckBox;
    Info: &Label;
    {$include ListOfConnectedDevices.ListWindow.inc}
  {$endregion FormDesigner}
  public
    connected_devices: array of TClient;
    items: List<SplitContainer>;
    _server: TcpServer;
    selectedDeviceCheckBtn: CheckBox; 
    UpdateSelectedDevice: System.Action<TClient>;
    
    constructor(__server__: TcpServer; __update_method__: System.Action<TClient>);
    begin
      InitializeComponent;
      
      self._server := __server__;
      self.UpdateSelectedDevice := __update_method__;
      self.connected_devices := _server.Walk();
      self.items := new List<SplitContainer>(10);
      
      self.Update();
      self.Show();
    end;
  end;

implementation


procedure ListWindow.Update();
begin
  foreach var device in connected_devices do 
    items.Add(NewItem(device.WinInfo.OS + #10 + 'IP:' + device.ip + #10 + device.WinInfo.UserName + '@' + device.WinInfo.ComputerName, 
                      _server.selectedClient = device));
  
  
  self.Controls.Clear();
  
  var (x, y) := (5, 30);
  foreach var obj in items do
  begin
    if x + obj.Width >= self.Width then begin
      x := 5;
      y += obj.Height + 5
    end;
    obj.Location := new Point(x, y);    
    self.Controls.Add(obj as Control);
    x += obj.Width;
  end; 
  
end;


function ListWindow.NewItem(desc: string; selected: boolean): SplitContainer;
begin
  
  //  __StateButton
  var __StateButton: CheckBox = new CheckBox();
  __StateButton.CheckAlign := System.Drawing.ContentAlignment.MiddleCenter;
  __StateButton.Checked := selected;
  __StateButton.Cursor := System.Windows.Forms.Cursors.Hand;
  __StateButton.Dock := System.Windows.Forms.DockStyle.Top;
  __StateButton.Location := new System.Drawing.Point(0, 0);
  __StateButton.MaximumSize := new System.Drawing.Size(13, 13);
  __StateButton.MinimumSize := new System.Drawing.Size(13, 13);
  __StateButton.Size := new System.Drawing.Size(13, 13);
  __StateButton.TabIndex := 4;
  __StateButton.TabStop := true;
  __StateButton.TextAlign := System.Drawing.ContentAlignment.TopCenter;
  __StateButton.UseVisualStyleBackColor := true;
  __StateButton.MouseDown += self.StateButton_MouseDown;
  
  if selected then selectedDeviceCheckBtn := __StateButton;
  
  //  __Image
  var __Image: System.Windows.Forms.Label = new System.Windows.Forms.Label();
  __Image.BackColor := System.Drawing.SystemColors.Control;
  __Image.Dock := System.Windows.Forms.DockStyle.Fill;
  __Image.Image := self.GetImage(Copy(desc, 9, 2).Replace(' ', ''));
  __Image.Location := new System.Drawing.Point(0, 0);
  __Image.Size := new System.Drawing.Size(110, 110);
  __Image.TabIndex := 1;
  __Image.Click += label2_Click;
  
  //  __Info
  var __Info: System.Windows.Forms.Label = new System.Windows.Forms.Label();
  __Info.AutoEllipsis := true;
  __Info.AutoSize := true;
  __Info.BackColor := System.Drawing.SystemColors.Control;
  __Info.Dock := System.Windows.Forms.DockStyle.Fill;
  __Info.Font := new System.Drawing.Font('Times New Roman', 10, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, (System.Byte(204)));
  __Info.Location := new System.Drawing.Point(0, 0);
  __Info.MaximumSize := new System.Drawing.Size(110, 0);
  __Info.Size := new System.Drawing.Size(23, 17);
  __Info.Text := desc;
  __Info.TabIndex := 0;
  __Info.TextAlign := System.Drawing.ContentAlignment.MiddleCenter;
  __Info.UseCompatibleTextRendering := true;
  
  //  __ConnectedDevice (SplitContainer)
  var __ConnectedDevice: SplitContainer = new SplitContainer();
  __ConnectedDevice.BackColor := System.Drawing.SystemColors.Control;
  __ConnectedDevice.FixedPanel := System.Windows.Forms.FixedPanel.Panel1;
  __ConnectedDevice.IsSplitterFixed := true;
  __ConnectedDevice.Location := new System.Drawing.Point(12, 12);
  __ConnectedDevice.MaximumSize := new System.Drawing.Size(110, 180);
  __ConnectedDevice.Orientation := System.Windows.Forms.Orientation.Horizontal;
  
  //  __ConnectedDevice (Panel1)
  __ConnectedDevice.Panel1.Controls.Add(__StateButton);
  __ConnectedDevice.Panel1.Controls.Add(__Image);
  
  //  __ConnectedDevice (Panel2)
  __ConnectedDevice.Panel2.Controls.Add(__Info);
  __ConnectedDevice.Panel2MinSize := 50;
  __ConnectedDevice.Size := new System.Drawing.Size(110, 180);
  __ConnectedDevice.SplitterDistance := 110;
  __ConnectedDevice.TabIndex := 2;
  
  Result := __ConnectedDevice;
end;


function ListWindow.GetImage(IconKey: string): Image;
begin
  IconKey := types.WinIcons.ContainsKey(IconKey) ? IconKey : 'computer.png';
  Result := types.WinIcons[IconKey];
end;


procedure ListWindow.label2_Click(sender: Object; e: EventArgs);
begin
  
end;


procedure ListWindow.ListWindow_Load(sender: Object; e: EventArgs);
begin
  
end;

procedure ListWindow.StateButton_MouseDown(sender: Object; e: MouseEventArgs);
begin
  var newCheckBtn := (sender as Control) as CheckBox;
  
  if selectedDeviceCheckBtn = newCheckBtn then begin
    selectedDeviceCheckBtn.Checked := false;
    exit;
  end;
  
  selectedDeviceCheckBtn.Checked := false;
  selectedDeviceCheckBtn := newCheckBtn;
  
  self.UpdateSelectedDevice.Invoke(
    connected_devices[
      items.FindIndex(
        item -> item = (selectedDeviceCheckBtn.Parent.Parent as SplitContainer)
  )]);
end;

end.
