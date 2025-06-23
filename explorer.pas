unit explorer;

interface

uses
  System,  
  System.IO,
  System.Drawing,
  System.Threading,
  System.Windows.Forms;
  

var
  __initialized__: boolean = false;
  /// Содержит элементы рабочей директории
  items: List<SplitContainer>;
  //item_template: SplitContainer;
  icon_list: ImageList;
  /// Путь к рабочей директории
  path: string;
  window: TabPage;
  filetypes: set of string = [
    'dll', 'doc', 'exe', 'html', 'ini', 'iso', 'jpg',
    'mp3', 'obj', 'pdf', 'txt', 'wav', 'xls', 'xml', 
    'zip', 'pas', 'docx', 'htm', 'xlsx', 'pabcproj',
    'asp', 'avi', 'bat', 'cmd', 'com', 'csv', 'gif',
    'jar', 'js', 'jsx', 'mp4', 'nfo', 'otf', 'pkg', 
    'png', 'wmv', 'ppt', 'pptx', 'rtf'
  ];
  
  
procedure init(window: TabPage; icon_list: ImageList; path: string);
procedure GetItems();
procedure Update(is_not_new_dir: boolean := false);

function NewItem(filename: string; is_dir: boolean): SplitContainer;
function GetIconName(filename: string): string;

implementation

procedure init(window: TabPage; icon_list: ImageList; path: string);
begin
  explorer.window := window;
  explorer.icon_list := icon_list;
  explorer.path := 'D:\PascalABC.NET\3 курс\Курсовая\RemoteControl';
  
  items := new List<SplitContainer>(10);
  
  __initialized__ := true;
end;


procedure Update(is_not_new_dir: boolean);
begin
  if not is_not_new_dir then begin
    if items.Count <> 0 then
      items.Clear();
    // Dirs
    foreach var dirname in Directory.GetDirectories(path) do
    begin
      items.Add(NewItem(dirname.Substring(dirname.LastIndexOf('\')+1), true));
    end;
    
    // Files
    foreach var filename in Directory.GetFiles(path) do
    begin
      items.Add(NewItem(filename.Substring(filename.LastIndexOf('\')+1), false));
    end;
  end;
  
  var (x, y) := (10, 10);
  window.Controls.Clear();
  foreach var obj in items do begin
    if x + obj.Width >= window.Width then begin
      x := 10;
      y += obj.Height+5
    end;
    obj.Location := new Point(x, y);    
    window.Controls.Add(obj as Control);
    x += obj.Width;
  end;
  
end;


function NewItem(filename: string; is_dir: boolean): SplitContainer;
begin
  var item_template: SplitContainer = new SplitContainer();
  item_template.Orientation := Orientation.Horizontal;
  item_template.Size := new Size(100, 100);
  item_template.IsSplitterFixed := true;
  item_template.BackColor := Color.Transparent;
  
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
  
  Result := item_template;
end;


function GetIconName(filename: string): string;
begin
  var filetype := filename.Substring(filename.LastIndexOf('.')+1);
  if filetype in filetypes then 
    Result := filetype + '.png' else
    Result := 'file.png';
end;


procedure GetItems();
begin
  
end;

end.