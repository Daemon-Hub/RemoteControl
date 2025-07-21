unit explorer;

interface
{$region interface}

uses
  System,  
  System.IO,
  System.Drawing,
  System.Threading,
  System.Windows.Forms,
  Newtonsoft.Json, 
  types;
  

var
  /// Определяет инициальизирован ли модуль или нет
  __initialized__: boolean = false;
  
  /// Содержит элементы рабочей директории
  items: List<SplitContainer>;
  
  /// Содержит элементы которые были выделены нажатием
  selected_items: List<SplitContainer>;
  
  /// Цвет в который окрашивается объект при наведении на него мышки или клике
  selected_color: Color = Color.FromKnownColor(KnownColor.ActiveCaption);
  
  /// Стандартный цвет объекта
  unselected_color: Color = Color.Transparent;
  
  /// Список содержащий иконки для поддерживающихся типов файлов
  icon_list: ImageList;
  
  /// Основная область проводника
  window: TabPage;
  
  /// Строка с инструментами
  tool_bar: ToolStrip;
  
  /// Поддерживаемые типы файлов
  filetypes: set of string = [
    'dll', 'doc', 'exe', 'html', 'ini', 'iso', 'jpg',
    'mp3', 'obj', 'pdf', 'txt', 'wav', 'xls', 'xml', 
    'zip', 'pas', 'docx', 'htm', 'xlsx', 'pabcproj',
    'asp', 'avi', 'bat', 'cmd', 'com', 'csv', 'gif',
    'jar', 'js', 'jsx', 'mp4', 'nfo', 'otf', 'pkg', 
    'png', 'wmv', 'ppt', 'pptx', 'rtf', 'ico'
  ];
  
  /// На элемент нажали два раза подряд
  Control_DoubleClick: EventHandler;
  
  /// Контекстное меню появляющееся при левом клике на объект (папка\файл)
  context_menu: ContextMenuStrip;
  
  /// Информация про скопированный\вырезанный объект 
  cut_or_copy_item_info: PasteInformation;
  
  
/// Инициальизирует необходимые объекты для работы модуля
procedure init(window: TabPage; icon_list: ImageList; tool_bar: ToolStrip; double_click_event_handle: EventHandler; context_menu: ContextMenuStrip);
               
/// Обновляет содержимое проводника               
procedure Update(dirs: string := ''; files: string := ''; is_not_new_dir: boolean := false);
                
/// Создаёт новый объект директория/файл
function NewItem(filename: string; is_dir: boolean): SplitContainer;

/// По расширению файла определяет нужную иконку и возвращает ключ для списка иконок
function GetIconName(filename: string): string;

/// Возвращает объект SplitContainer, который хранит obj
function GetSplitContainer(obj: Object): SplitContainer;

/// Возвращает названия выделенных папок и файлов в виде json строки 
function GetSelectedItemsNames(): string;

/// Удаляет все выделенные объекты
procedure DeleteAllSelectedItems();

/// Удаляет все выделенные объекты кроме одного (container)
procedure DeleteAllSelectedItemsExceptSelected(container: SplitContainer);

{$region EventHandlers}

/// На элемент нажали кнопкой мыши
procedure Control_MouseDown(sender: Object; e: MouseEventArgs);

/// Курсор вошёл в область видимый элементом
procedure Control_MouseMove(sender: Object; e: MouseEventArgs);

/// Курсор вышел из области видимый элементом
procedure Control_MouseLeave(sender: Object; e: EventArgs);

{$endregion EventHandlers}

{$endregion interface}

implementation

procedure init(window: TabPage; icon_list: ImageList; tool_bar: ToolStrip; double_click_event_handle: EventHandler; context_menu: ContextMenuStrip);
begin
  explorer.window := window;
  explorer.icon_list := icon_list;
  explorer.tool_bar := tool_bar;
  explorer.Control_DoubleClick += double_click_event_handle;
  explorer.context_menu := context_menu;

  items := new List<SplitContainer>(10);
  selected_items := new List<SplitContainer>(10);
  cut_or_copy_item_info := new PasteInformation();
  
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
  item_template.Size := new Size(100, 110);
  item_template.Panel1.Size := new Size(100, 60);
  item_template.Panel2.Size := new Size(100, 50);
  item_template.IsSplitterFixed := true;
  item_template.BackColor := unselected_color;
  item_template.TabIndex := 1;
  item_template.ContextMenuStrip := explorer.context_menu;
  
  item_template.MouseDown += Control_MouseDown;
  item_template.MouseMove += Control_MouseMove;
  item_template.MouseLeave += Control_MouseLeave;
  
  var label1, label2: System.Windows.Forms.Label;
  
  (label1, label2) := (new System.Windows.Forms.Label(), new System.Windows.Forms.Label());
  
  // ---------------- Icon ---------------- //
  item_template.Panel1.Controls.Add(label1);
   
  label1.Dock := DockStyle.Fill;
  label1.ImageKey := is_dir ? 'dir.png':GetIconName(filename);
  label1.ImageList := icon_list;
  label1.Location := new Point(0, 0);
  label1.Size := new Size(100, 60);
  label1.MaximumSize := new Size(100, 60);
  label1.TabIndex := 0;
  label1.ImageAlign := ContentAlignment.TopCenter;
  label1.ContextMenuStrip := explorer.context_menu;
  
  label1.MouseDown += Control_MouseDown;
  label1.MouseMove += Control_MouseMove;
  label1.MouseLeave += Control_MouseLeave;
   
  // ---------------- Filename ---------------- //
  item_template.Panel2.Controls.Add(label2);
  
  label2.Dock := DockStyle.Fill;
  label2.Location := new Point(0, 0);
  label2.Size := new Size(100, 50);
  label2.MaximumSize := new Size(100, 0);
  label2.TabIndex := 0;
  label2.Text := filename;
  label2.TextAlign := ContentAlignment.TopCenter;
  label2.AutoEllipsis := true;
  label2.ContextMenuStrip := explorer.context_menu;
  
  label2.MouseDown += Control_MouseDown;
  label2.MouseMove += Control_MouseMove;
  label2.MouseLeave += Control_MouseLeave;
  
  if is_dir then begin
    item_template.DoubleClick += Control_DoubleClick;
           label1.DoubleClick += Control_DoubleClick;
           label2.DoubleClick += Control_DoubleClick;
  end;
  
  Result := item_template;
end;


function GetSplitContainer(obj: Object): SplitContainer;
begin
  var ctrl: Control = obj as Control;
  while not(ctrl is SplitContainer) do 
    ctrl := ctrl.Parent;
  Result := ctrl as SplitContainer;
end;


function GetSelectedItemsNames(): string;
begin
  var res := new List<string>();
  foreach var item in selected_items do 
    res.Add(item.Panel2.Controls[0].Text);
  var Resu := JsonConvert.SerializeObject(res);
  Println(resu);
  Result := Resu;
end;


procedure DeleteAllSelectedItems();
begin
 for var id := selected_items.Count-1 downto 0 do begin
   selected_items[id].BackColor := unselected_color;
   selected_items.RemoveAt(id);
 end;
end;


procedure DeleteAllSelectedItemsExceptSelected(container: SplitContainer);
begin
 var length: integer = selected_items.Count;
 if length >= 2 then begin
   for var id := length-1 downto 1 do begin
     selected_items[id].BackColor := unselected_color;
     selected_items.RemoveAt(id);
   end;
 end;
  selected_items[0].BackColor := unselected_color;
  selected_items[0] := container;
end;

{$region EventHandlers}

procedure Control_MouseDown(sender: Object; e: MouseEventArgs);
begin
  var container: SplitContainer = GetSplitContainer(sender);
  container.BackColor := selected_color;
   
  if e.Button = MouseButtons.Right then begin
    if selected_items.Count = 0 then
      selected_items.Add(container) else
    if not(container in selected_items) then 
      DeleteAllSelectedItemsExceptSelected(container);
  end else begin
    if ((Control.ModifierKeys and Keys.Control) = Keys.Control) or (selected_items.Count = 0) then begin
      if not(container in selected_items) then 
        selected_items.Add(container)
      else begin
        container.BackColor := unselected_color;
        selected_items.Remove(container);
      end
    end else 
      DeleteAllSelectedItemsExceptSelected(container);
  end;
end;


procedure Control_MouseMove(sender: Object; e: MouseEventArgs);
begin
  var container: SplitContainer = GetSplitContainer(sender);
  container.BackColor := selected_color; 
end;


procedure Control_MouseLeave(sender: Object; e: EventArgs);
begin
  var container: SplitContainer = GetSplitContainer(sender);
  if not selected_items.Contains(container) then
    container.BackColor := unselected_color;
end;

{$endregion EventHandlers}

end.