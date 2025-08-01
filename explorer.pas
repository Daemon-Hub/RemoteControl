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
  items: List<&Label>;
  
  /// Содержит элементы которые были выделены нажатием
  selected_items: List<&Label>;
  
  /// Цвет в который окрашивается объект при наведении на него мышки или клике
  selected_color: Color = Color.FromKnownColor(KnownColor.ActiveCaption);
  
  /// Стандартный цвет объекта
  unselected_color: Color = Color.Transparent;
  
  /// Список содержащий иконки для поддерживающихся типов файлов
  icon_list: ImageList;
  
  /// Основная область проводника
  window: Panel;
  
  /// Строка с инструментами
  tool_bar: ToolStrip;
  
  /// Поддерживаемые типы файлов
  filetypes: set of string = [
  'accdb','asp','avi','bak','bat','bin','blend','c++','c','class','cmd','com',
  'cpp','cs','css','csv','cxx','dat','db','dir','dll','doc','dockerfile','docx',
  'exe','file','gd','gif','go','gradle','h++','h','hpp','htm','html','hxx','ico',
  'ini','io','ipynb','iso','jar','java','jpg','js','json','jsx','kt','lnk','lua',
  'mp3','mp4','nfo','obj','otf','pabcproj','pak','pas','pdb','pdf','php','pkg',
  'png','ppt','pptx','prettierrc','ps1','py','rs','rtf','scss','sln','ts','txt',
  'vim','vite','vsix','vue','wav','wmv','xls','xlsx','xml','zip'];
  
  /// На элемент нажали два раза подряд
  Control_DoubleClick: EventHandler;
  
  /// Контекстное меню появляющееся при левом клике на объект (папка\файл)
  context_menu: ContextMenuStrip;
  
  /// Информация про скопированный\вырезанный объект 
  cut_or_copy_item_info: PasteInformation;
  
  /// Содержит информацию о странице "Главная"
  home_info: ExplorerInformation;
  
  /// Необходимо добавлять в начало названия файла
  label_text_start := #13#10#13#10#13#10;
  
  /// Переменная которая указывает на поле редактирующее название файла
  rename_field: TextBox;
  
  /// Переменная которая указывает на поле редактирующее название пути
  rename_path: ToolStripTextBox;


/// Инициальизирует необходимые объекты для работы модуля
procedure init(window: Panel; icon_list: ImageList; tool_bar: ToolStrip; double_click_event_handle: EventHandler; context_menu: ContextMenuStrip);

/// Обновляет содержимое главной старницы проводника
procedure UpdateHomePage(info: ExplorerInformation; is_new: boolean := true);

/// Обновляет содержимое проводника               
procedure Update(dirs: string := ''; files: string := '');

/// Обновляет окно проводника
procedure UpdateWindow();

/// Обновляет расположение каждого объекта
procedure UpdateItemsLocation();

/// Создаёт новый объект директория/файл
function NewItem(filename: string; is_dir: boolean := false; special: string := nil): &Label;

/// По расширению файла определяет нужную иконку и возвращает ключ для списка иконок
function GetIconName(filename: string): string;

/// Возвращает названия выделенных папок и файлов в виде json строки 
function GetSelectedItemsNames(): string;

/// Удаляет все выделенные объекты
procedure DeleteAllSelectedItems();

/// Удаляет все выделенные объекты кроме одного (container)
procedure DeleteAllSelectedItemsExceptSelected(container: &Label);


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

procedure init(window: Panel; icon_list: ImageList; tool_bar: ToolStrip; double_click_event_handle: EventHandler; context_menu: ContextMenuStrip);
begin
  explorer.window := window;
  explorer.icon_list := icon_list;
  explorer.tool_bar := tool_bar;
  explorer.Control_DoubleClick += double_click_event_handle;
  explorer.context_menu := context_menu;
  
  items := new List<&Label>(10);
  selected_items := new List<&Label>(10);
  cut_or_copy_item_info := new PasteInformation();
  
  __initialized__ := true;
end;


procedure UpdateHomePage(info: ExplorerInformation; is_new: boolean);
begin
  
  if is_new then
    home_info := info else
    info := home_info;
  
  if items.Count > 0 then
    items.Clear();
      
  items.Add(NewItem('Рабочий стол', true, 'Desktop'));
  items.Add(NewItem('Загрузки', true, 'Downloads'));
  items.Add(NewItem('Документы', true, 'Documents'));
  items.Add(NewItem('Изображения', true, 'Pictures'));
  items.Add(NewItem('Музыка', true, 'Music'));
  items.Add(NewItem(info.User.Substring(info.User.LastIndexOf(SLASH)+1), true, 'User'));
  
  foreach var drive in info.Drives do begin
    var png: string = 'drive';
    if drive.DriveType = DriveType.Network then 
      png := 'network-drive' else 
    if drive.DriveType = DriveType.Removable then
      png := 'usb-flash-drive';
    items.Add(NewItem(drive.Name, true, png));
  end;
  
  UpdateWindow();
end;


procedure Update(dirs, files: string);
begin
  if items.Count <> 0 then
    items.Clear(); 
  
//  Println($'dirs: {dirs}');
//  Println($'files: {files}');
  
  // Dirs
  foreach var dirname in JsonConvert.DeserializeObject&<array of string>(dirs) do
    items.Add(NewItem(dirname.Substring(dirname.LastIndexOf('\') + 1), true));
  
  // Files
  foreach var filename in JsonConvert.DeserializeObject&<array of string>(files) do
    items.Add(NewItem(filename.Substring(filename.LastIndexOf('\') + 1)));
  
  UpdateWindow();
end;


procedure UpdateWindow();
begin
  window.Controls.Clear();
  
  var (x, y) := (5, 5);
  var space := 5;
  
  foreach obj: &Label in items.ToArray() do
  begin
    if x + obj.Width >= window.Width-16 then begin
      x := 5;
      y += obj.Height + 5 + space;
    end;
    obj.Location := new Point(x, y);    
    window.Controls.Add(obj as Control);
    x += obj.Width + space;
  end;
end;


procedure UpdateItemsLocation();
begin
  var (x, y) := (5, 5);
  var space := 5;
  
  foreach obj: &Label in window.Controls do
  begin
    if x + obj.Width >= window.Width-16 then begin
      x := 5;
      y += obj.Height + 5 + space;
    end;
    obj.Location := new Point(x, y);    
    x += obj.Width + space;
  end;
end;


function GetIconName(filename: string): string;
begin
  var filetype := filename.Substring(filename.LastIndexOf('.') + 1);
  if filetype in filetypes then 
    Result := filetype + '.png' else
    Result := 'file.png';
end;


function NewItem(filename: string; is_dir: boolean; special: string): &Label;
begin
  var ItemLabel := new &Label();
      ItemLabel.AutoEllipsis := true;
      ItemLabel.AutoSize := false;
      ItemLabel.BackColor := System.Drawing.Color.Transparent;
      ItemLabel.FlatStyle := System.Windows.Forms.FlatStyle.Flat;
      ItemLabel.ImageAlign := System.Drawing.ContentAlignment.TopCenter;
      if is_dir then begin
        ItemLabel.DoubleClick += Control_DoubleClick;
        ItemLabel.ImageKey := (special <> nil ? special : 'dir') +'.png';
      end else 
        ItemLabel.ImageKey := GetIconName(filename);
      ItemLabel.ImageList := icon_list;
      ItemLabel.Margin := new System.Windows.Forms.Padding(3, 3, 3, 0);
      ItemLabel.MaximumSize := new System.Drawing.Size(80, 0);
      ItemLabel.MinimumSize := new System.Drawing.Size(80, 100);
      ItemLabel.Size := new System.Drawing.Size(80, 100);
      ItemLabel.Padding := new System.Windows.Forms.Padding(0, 0, 0, 3);
      ItemLabel.Text := (filename.Length > 6 ? label_text_start: label_text_start[1:5]) + filename;
      ItemLabel.TextAlign := System.Drawing.ContentAlignment.MiddleCenter;
      ItemLabel.UseCompatibleTextRendering := true;
      ItemLabel.MouseDown += Control_MouseDown;
      ItemLabel.MouseMove += Control_MouseMove;
      ItemLabel.MouseLeave += Control_MouseLeave;
  if special = nil then 
    ItemLabel.ContextMenuStrip := explorer.context_menu;
  Result := ItemLabel;
end;


function GetSelectedItemsNames(): string;
begin
  var res := new List<string>();
  foreach var item in selected_items do 
    res.Add(item.Text.Trim);
  Result := JsonConvert.SerializeObject(res);
end;


procedure DeleteAllSelectedItems();
begin
  for var id := selected_items.Count - 1 downto 0 do
  begin
    selected_items[id].BackColor := unselected_color;
    selected_items[id].AutoSize := false;
    selected_items[id].Size := selected_items[id].MinimumSize;
    selected_items.RemoveAt(id);
  end;
end;


procedure DeleteAllSelectedItemsExceptSelected(container: &Label);
begin
  if selected_items.Count >= 1 then 
    DeleteAllSelectedItems();
  selected_items.Add(container);
  selected_items[0].AutoSize := true;
end;


{$region EventHandlers}

procedure Control_MouseDown(sender: Object; e: MouseEventArgs);
begin
  var container := sender as &Label;
      container.BackColor := selected_color;
  
  if e.Button = MouseButtons.Right then begin
    if selected_items.Count = 0 then
      selected_items.Add(container) else
    if not (container in selected_items) then 
      DeleteAllSelectedItemsExceptSelected(container);
  end else begin
    if ((Control.ModifierKeys and Keys.Control) = Keys.Control) or (selected_items.Count = 0) then begin
      if not (container in selected_items) then 
        selected_items.Add(container)
      else begin
        container.BackColor := unselected_color;
        selected_items.Remove(container);
      end
    end else 
      DeleteAllSelectedItemsExceptSelected(container);
  end;
  
  try rename_field.Dispose(); except end;
end;


procedure Control_MouseMove(sender: Object; e: MouseEventArgs);
begin
  (sender as &Label).BackColor := selected_color; 
end;


procedure Control_MouseLeave(sender: Object; e: EventArgs);
begin
  var container := sender as &Label;
  if not selected_items.Contains(container) then
    container.BackColor := unselected_color;
end;

{$endregion EventHandlers}

end.