unit explorer;

interface

uses
  System,  
  System.IO,
  System.Drawing,
  System.Threading,
  System.Windows.Forms,
  Newtonsoft.Json;
  

var
  __initialized__: boolean = false;
  /// Содержит элементы рабочей директории
  items: List<SplitContainer>;
  /// Содержит элементы которые были выделены нажатием
  selected_items: List<SplitContainer>;
  selected_color: Color = Color.FromKnownColor(KnownColor.ActiveCaption);
  unselected_color: Color = Color.Transparent;
  icon_list: ImageList;
  window: TabPage;
  tool_bar: ToolStrip;
  filetypes: set of string = [
    'dll', 'doc', 'exe', 'html', 'ini', 'iso', 'jpg',
    'mp3', 'obj', 'pdf', 'txt', 'wav', 'xls', 'xml', 
    'zip', 'pas', 'docx', 'htm', 'xlsx', 'pabcproj',
    'asp', 'avi', 'bat', 'cmd', 'com', 'csv', 'gif',
    'jar', 'js', 'jsx', 'mp4', 'nfo', 'otf', 'pkg', 
    'png', 'wmv', 'ppt', 'pptx', 'rtf', 'ico'
  ];
  
  
procedure init(window: TabPage; 
               icon_list: ImageList; 
               tool_bar: ToolStrip);
procedure Update(dirs: string := ''; 
                files: string := ''; 
                is_not_new_dir: boolean := false);

function NewItem(filename: string; is_dir: boolean): SplitContainer;
function GetIconName(filename: string): string;

{$region EventHandlers}
procedure Label_MouseDown(sender: Object; e: MouseEventArgs);
procedure Label_MouseMove(sender: Object; e: MouseEventArgs);
procedure Label_MouseLeave(sender: Object; e: EventArgs);
{$endregion EventHandlers}

implementation

procedure init(window: TabPage; 
               icon_list: ImageList; 
               tool_bar: ToolStrip);
begin
  explorer.window := window;
  explorer.icon_list := icon_list;
  explorer.tool_bar := tool_bar;

  items := new List<SplitContainer>(10);
  selected_items := new List<SplitContainer>(10);
  
  __initialized__ := true;
end;


procedure Update(dirs, files: string; is_not_new_dir: boolean);
begin
  if not is_not_new_dir then begin
    if items.Count <> 0 then
      items.Clear(); 

    // Dirs
    foreach var dirname in JsonConvert.DeserializeObject&<array of string>(dirs) do
      items.Add(NewItem(dirname.Substring(dirname.LastIndexOf('\')+1), true));
    
    // Files
    foreach var filename in JsonConvert.DeserializeObject&<array of string>(files) do
      items.Add(NewItem(filename.Substring(filename.LastIndexOf('\')+1), false));

  end;

  window.Controls.Clear();
  window.Controls.Add(tool_bar);
  
  var (x, y) := (5, 30);
  foreach var obj in items do begin
    if x + obj.Width >= window.Width then begin
      x := 5;
      y += obj.Height+5
    end;
    obj.Location := new Point(x, y);    
    window.Controls.Add(obj as Control);
    x += obj.Width;
  end;
  
end;


function GetIconName(filename: string): string;
begin
  var filetype := filename.Substring(filename.LastIndexOf('.')+1);
  if filetype in filetypes then 
    Result := filetype + '.png' else
    Result := 'file.png';
end;


function NewItem(filename: string; is_dir: boolean): SplitContainer;
begin
  var item_template: SplitContainer = new SplitContainer();
  item_template.Orientation := Orientation.Horizontal;
  item_template.Size := new Size(100, 100);
  item_template.IsSplitterFixed := true;
  item_template.BackColor := unselected_color;
  
  var label1, label2: System.Windows.Forms.Label;
  
  (label1, label2) := (new System.Windows.Forms.Label(), new System.Windows.Forms.Label());
  
  // ---------------- Icon ---------------- //
  item_template.Panel1.Controls.Add(label1);
   
  label1.Dock := DockStyle.Fill;
  label1.ImageKey := is_dir ? 'dir.png':GetIconName(filename);
  label1.ImageList := icon_list;
  label1.Location := new Point(0, 0);
  label1.Size := new Size(100, 50);
  label1.TabIndex := 0;
  
  label1.MouseDown += Label_MouseDown;
  label1.MouseMove += Label_MouseMove;
  label1.MouseLeave += Label_MouseLeave;
   
  // ---------------- Filename ---------------- //
  item_template.Panel2.Controls.Add(label2);
  item_template.Size := new Size(100, 100);
  item_template.TabIndex := 1;
  
  label2.Dock := DockStyle.Fill;
  label2.Location := new Point(0, 0);
  label2.Size := new Size(100, 50);
  label2.TabIndex := 0;
  label2.Text := filename;
  label2.TextAlign := ContentAlignment.TopCenter;
  label2.AutoEllipsis := true;
  
  label2.MouseDown += Label_MouseDown;
  label2.MouseMove += Label_MouseMove;
  label2.MouseLeave += Label_MouseLeave;
  
  Result := item_template;
end;


function GetSplitContainer(obj: Object): SplitContainer;
begin
  var ctrl: Control = obj as Control;
  Result := ctrl.Parent.Parent as SplitContainer;
end;

{$region EventHandlers}

procedure Label_MouseDown(sender: Object; e: MouseEventArgs);
begin
  var container: SplitContainer = GetSplitContainer(sender);
  container.BackColor := selected_color;
   
  var length: integer = selected_items.Count;
  if ((Control.ModifierKeys and Keys.Control) = Keys.Control) or 
     (length = 0) then
    selected_items.Add(container) else 
  begin
    if length >= 2 then begin
      for var id := length-1 downto 1 do begin
        selected_items[id].BackColor := unselected_color;
        selected_items.RemoveAt(id);
      end;
    end;
    selected_items[0].BackColor := unselected_color;
    selected_items[0] := container;
  end;
end;


procedure Label_MouseMove(sender: Object; e: MouseEventArgs);
begin
  var container: SplitContainer = GetSplitContainer(sender);
  container.BackColor := selected_color;
end;


procedure Label_MouseLeave(sender: Object; e: EventArgs);
begin
  var container: SplitContainer = GetSplitContainer(sender);
  if not selected_items.Contains(container) then
    container.BackColor := unselected_color;
end;

{$endregion EventHandlers}

end.