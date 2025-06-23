unit explorer;

interface

uses
  System,  
  System.IO,
  System.Drawing,
  System.Threading,
  System.Windows.Forms;
  

var
  items: List<SplitContainer>;
  item_template: SplitContainer;
  icon_list: ImageList;
  path: string;
  window: TabPage;
  
  DefaultSize: Size = new Size(100, 50);

implementation

procedure init(window: TabPage; icon_list: ImageList; path: string);
begin
  item_template.Orientation := Orientation.Horizontal;
  item_template.Size := Size.Add(100, 100);
  item_template.Location := new Point(6, 6);
  
  var label1, label2: System.Windows.Forms.Label;
  
  // Icon 
  item_template.Panel1.Controls.Add(label1);
   
  label1.Dock := DockStyle.Fill;
  label1.ImageKey := 'ini.png';
  label1.ImageList := icon_list;
  label1.Location := new Point(0, 0);
//  label1.Name := 'label2';
  label1.Size := new Size(100, 50);
  label1.TabIndex := 0;
  label1.Click += label2_Click;
   
  // Filename
  item_template.Panel2.Controls.Add(label2);
  item_template.Size := new Size(100, 100);
  item_template.TabIndex := 1;
  
  label2.Dock := DockStyle.Fill;
  label2.Location := new Point(0, 0);
//  label2.Name := 'label1';
  label2.Size := new Size(100, 46);
  label2.TabIndex := 0;
  label2.Text := 'label1';
  label2.TextAlign := ContentAlignment.TopCenter;
  
end;


procedure Update();
begin
  // Dirs
  foreach var filename in Directory.GetDirectories(path) do
  begin
    items.Add(NewItem(filename, true));
  end;
  
  // Files
  foreach var filename in Directory.GetFiles(path) do
  begin
    items.Add(NewItem(filename, false));
  end;
end;


procedure NewItem(name: string; is_dir: boolean);
begin
  
end;


procedure GetItems();
begin
  
end;

end.