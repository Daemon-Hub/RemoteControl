procedure InitializeComponent;
    begin
        self.components := new System.ComponentModel.Container();
        var resources: System.ComponentModel.ComponentResourceManager := new System.ComponentModel.ComponentResourceManager(typeof(MainWindow));
        self.DefaultTab := new System.Windows.Forms.TabControl();
        self.ClientTab := new System.Windows.Forms.TabPage();
        self.clientConnectingProgress := new System.Windows.Forms.ProgressBar();
        self.clientConnectState := new System.Windows.Forms.Label();
        self.ClientIPMask := new System.Windows.Forms.MaskedTextBox();
        self.clientConnectButton := new System.Windows.Forms.Button();
        self.ServerTab := new System.Windows.Forms.TabPage();
        self.splitContainer1 := new System.Windows.Forms.SplitContainer();
        self.CountOfClientsLabel := new System.Windows.Forms.Label();
        self.ServerStartedInfo := new System.Windows.Forms.Label();
        self.ServerCreateButton := new System.Windows.Forms.Button();
        self.ClientControlTab := new System.Windows.Forms.TabControl();
        self.ConsoleTab := new System.Windows.Forms.TabPage();
        self.ConsoleBox := new System.Windows.Forms.TextBox();
        self.contextMenuStrip1 := new System.Windows.Forms.ContextMenuStrip(self.components);
        self.ExplorerTab := new System.Windows.Forms.TabPage();
        self.ExplorerTabContextMenu := new System.Windows.Forms.ContextMenuStrip(self.components);
        self.__select_all := new System.Windows.Forms.ToolStripMenuItem();
        self.__update := new System.Windows.Forms.ToolStripMenuItem();
        self.__paste := new System.Windows.Forms.ToolStripMenuItem();
        self.ExplorerToolBar := new System.Windows.Forms.ToolStrip();
        self.ExplorerToolBarButtonUp := new System.Windows.Forms.ToolStripButton();
        self.toolStripSeparator1 := new System.Windows.Forms.ToolStripSeparator();
        self.LabelPath := new System.Windows.Forms.ToolStripLabel();
        self.splitContainer2 := new System.Windows.Forms.SplitContainer();
        self.label2 := new System.Windows.Forms.Label();
        self.FilesIconList := new System.Windows.Forms.ImageList(self.components);
        self.label1 := new System.Windows.Forms.Label();
        self.UIIconList := new System.Windows.Forms.ImageList(self.components);
        self.ExplorerItemContextMenu := new System.Windows.Forms.ContextMenuStrip(self.components);
        self.__copy := new System.Windows.Forms.ToolStripMenuItem();
        self.__cut := new System.Windows.Forms.ToolStripMenuItem();
        self.__rename := new System.Windows.Forms.ToolStripMenuItem();
        self.__receive_file := new System.Windows.Forms.ToolStripMenuItem();
        self.DefaultTab.SuspendLayout();
        self.ClientTab.SuspendLayout();
        self.ServerTab.SuspendLayout();
        (System.ComponentModel.ISupportInitialize(self.splitContainer1)).BeginInit();
        self.splitContainer1.Panel1.SuspendLayout();
        self.splitContainer1.Panel2.SuspendLayout();
        self.splitContainer1.SuspendLayout();
        self.ClientControlTab.SuspendLayout();
        self.ConsoleTab.SuspendLayout();
        self.ExplorerTab.SuspendLayout();
        self.ExplorerTabContextMenu.SuspendLayout();
        self.ExplorerToolBar.SuspendLayout();
        (System.ComponentModel.ISupportInitialize(self.splitContainer2)).BeginInit();
        self.splitContainer2.Panel1.SuspendLayout();
        self.splitContainer2.Panel2.SuspendLayout();
        self.splitContainer2.SuspendLayout();
        self.ExplorerItemContextMenu.SuspendLayout();
        self.SuspendLayout();
        // 
        // DefaultTab
        // 
        self.DefaultTab.Controls.Add(self.ClientTab);
        self.DefaultTab.Controls.Add(self.ServerTab);
        self.DefaultTab.Cursor := System.Windows.Forms.Cursors.Default;
        self.DefaultTab.Dock := System.Windows.Forms.DockStyle.Fill;
        self.DefaultTab.Font := new System.Drawing.Font('Microsoft Sans Serif', 12, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, (System.Byte(204)));
        self.DefaultTab.Location := new System.Drawing.Point(0, 0);
        self.DefaultTab.Name := 'DefaultTab';
        self.DefaultTab.SelectedIndex := 0;
        self.DefaultTab.Size := new System.Drawing.Size(862, 477);
        self.DefaultTab.TabIndex := 0;
        // 
        // ClientTab
        // 
        self.ClientTab.BackColor := System.Drawing.SystemColors.ScrollBar;
        self.ClientTab.BorderStyle := System.Windows.Forms.BorderStyle.Fixed3D;
        self.ClientTab.Controls.Add(self.clientConnectingProgress);
        self.ClientTab.Controls.Add(self.clientConnectState);
        self.ClientTab.Controls.Add(self.ClientIPMask);
        self.ClientTab.Controls.Add(self.clientConnectButton);
        self.ClientTab.Cursor := System.Windows.Forms.Cursors.Default;
        self.ClientTab.Font := new System.Drawing.Font('Microsoft Sans Serif', 11.25, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, (System.Byte(204)));
        self.ClientTab.Location := new System.Drawing.Point(4, 29);
        self.ClientTab.Name := 'ClientTab';
        self.ClientTab.Padding := new System.Windows.Forms.Padding(3);
        self.ClientTab.Size := new System.Drawing.Size(854, 444);
        self.ClientTab.TabIndex := 0;
        self.ClientTab.Text := 'Клиент';
        // 
        // clientConnectingProgress
        // 
        self.clientConnectingProgress.Location := new System.Drawing.Point(391, 11);
        self.clientConnectingProgress.Maximum := 5;
        self.clientConnectingProgress.Name := 'clientConnectingProgress';
        self.clientConnectingProgress.Size := new System.Drawing.Size(100, 23);
        self.clientConnectingProgress.Step := 1;
        self.clientConnectingProgress.TabIndex := 3;
        // 
        // clientConnectState
        // 
        self.clientConnectState.AutoSize := true;
        self.clientConnectState.Font := new System.Drawing.Font('Microsoft Sans Serif', 12, (System.Drawing.FontStyle((System.Drawing.FontStyle.Bold or System.Drawing.FontStyle.Italic))), System.Drawing.GraphicsUnit.Point, (System.Byte(204)));
        self.clientConnectState.ForeColor := System.Drawing.SystemColors.ControlText;
        self.clientConnectState.Location := new System.Drawing.Point(512, 13);
        self.clientConnectState.Name := 'clientConnectState';
        self.clientConnectState.Size := new System.Drawing.Size(129, 24);
        self.clientConnectState.TabIndex := 2;
        self.clientConnectState.Text := 'Не подключено';
        self.clientConnectState.UseCompatibleTextRendering := true;
        // 
        // ClientIPMask
        // 
        self.ClientIPMask.InsertKeyMode := System.Windows.Forms.InsertKeyMode.Insert;
        self.ClientIPMask.Location := new System.Drawing.Point(256, 10);
        self.ClientIPMask.Mask := '000.000.000.000';
        self.ClientIPMask.Name := 'ClientIPMask';
        self.ClientIPMask.Size := new System.Drawing.Size(116, 24);
        self.ClientIPMask.TabIndex := 1;
        self.ClientIPMask.KeyPress += ClientIPMask_KeyPress;
        // 
        // clientConnectButton
        // 
        self.clientConnectButton.AutoSize := true;
        self.clientConnectButton.Font := new System.Drawing.Font('Microsoft Sans Serif', 12, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, (System.Byte(204)));
        self.clientConnectButton.Location := new System.Drawing.Point(6, 6);
        self.clientConnectButton.Name := 'clientConnectButton';
        self.clientConnectButton.Size := new System.Drawing.Size(232, 35);
        self.clientConnectButton.TabIndex := 0;
        self.clientConnectButton.Text := 'Подключиться к серверу';
        self.clientConnectButton.UseCompatibleTextRendering := true;
        self.clientConnectButton.UseVisualStyleBackColor := true;
        self.clientConnectButton.Click += ClientConnectButton_Click;
        // 
        // ServerTab
        // 
        self.ServerTab.BackColor := System.Drawing.SystemColors.ScrollBar;
        self.ServerTab.BorderStyle := System.Windows.Forms.BorderStyle.Fixed3D;
        self.ServerTab.Controls.Add(self.splitContainer1);
        self.ServerTab.Cursor := System.Windows.Forms.Cursors.Default;
        self.ServerTab.Font := new System.Drawing.Font('Microsoft Sans Serif', 11.25, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, (System.Byte(204)));
        self.ServerTab.ImeMode := System.Windows.Forms.ImeMode.NoControl;
        self.ServerTab.Location := new System.Drawing.Point(4, 29);
        self.ServerTab.Name := 'ServerTab';
        self.ServerTab.Padding := new System.Windows.Forms.Padding(3);
        self.ServerTab.Size := new System.Drawing.Size(854, 444);
        self.ServerTab.TabIndex := 1;
        self.ServerTab.Text := 'Сервер';
        // 
        // splitContainer1
        // 
        self.splitContainer1.Dock := System.Windows.Forms.DockStyle.Fill;
        self.splitContainer1.Location := new System.Drawing.Point(3, 3);
        self.splitContainer1.Name := 'splitContainer1';
        self.splitContainer1.Orientation := System.Windows.Forms.Orientation.Horizontal;
        // 
        // splitContainer1.Panel1
        // 
        self.splitContainer1.Panel1.Controls.Add(self.CountOfClientsLabel);
        self.splitContainer1.Panel1.Controls.Add(self.ServerStartedInfo);
        self.splitContainer1.Panel1.Controls.Add(self.ServerCreateButton);
        // 
        // splitContainer1.Panel2
        // 
        self.splitContainer1.Panel2.Controls.Add(self.ClientControlTab);
        self.splitContainer1.Size := new System.Drawing.Size(844, 434);
        self.splitContainer1.SplitterDistance := 217;
        self.splitContainer1.TabIndex := 4;
        // 
        // CountOfClientsLabel
        // 
        self.CountOfClientsLabel.AutoSize := true;
        self.CountOfClientsLabel.Font := new System.Drawing.Font('Microsoft Sans Serif', 12, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, (System.Byte(204)));
        self.CountOfClientsLabel.Location := new System.Drawing.Point(556, 3);
        self.CountOfClientsLabel.Name := 'CountOfClientsLabel';
        self.CountOfClientsLabel.Size := new System.Drawing.Size(229, 24);
        self.CountOfClientsLabel.TabIndex := 2;
        self.CountOfClientsLabel.Text := 'Подключённых устройств: 0';
        self.CountOfClientsLabel.UseCompatibleTextRendering := true;
        // 
        // ServerStartedInfo
        // 
        self.ServerStartedInfo.AutoEllipsis := true;
        self.ServerStartedInfo.AutoSize := true;
        self.ServerStartedInfo.Font := new System.Drawing.Font('Microsoft Sans Serif', 12, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, (System.Byte(204)));
        self.ServerStartedInfo.Location := new System.Drawing.Point(182, 3);
        self.ServerStartedInfo.Name := 'ServerStartedInfo';
        self.ServerStartedInfo.Size := new System.Drawing.Size(221, 24);
        self.ServerStartedInfo.TabIndex := 1;
        self.ServerStartedInfo.Text := 'Сервер успешно запущен'#13#10;
        self.ServerStartedInfo.UseCompatibleTextRendering := true;
        self.ServerStartedInfo.Visible := false;
        // 
        // ServerCreateButton
        // 
        self.ServerCreateButton.AutoSize := true;
        self.ServerCreateButton.Font := new System.Drawing.Font('Microsoft Sans Serif', 12, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, (System.Byte(204)));
        self.ServerCreateButton.Location := new System.Drawing.Point(4, 3);
        self.ServerCreateButton.Name := 'ServerCreateButton';
        self.ServerCreateButton.Size := new System.Drawing.Size(172, 39);
        self.ServerCreateButton.TabIndex := 0;
        self.ServerCreateButton.Text := 'Запустить сервер';
        self.ServerCreateButton.UseCompatibleTextRendering := true;
        self.ServerCreateButton.UseVisualStyleBackColor := true;
        self.ServerCreateButton.Click += ServerCreate_Click;
        // 
        // ClientControlTab
        // 
        self.ClientControlTab.Appearance := System.Windows.Forms.TabAppearance.FlatButtons;
        self.ClientControlTab.Controls.Add(self.ConsoleTab);
        self.ClientControlTab.Controls.Add(self.ExplorerTab);
        self.ClientControlTab.Dock := System.Windows.Forms.DockStyle.Fill;
        self.ClientControlTab.Enabled := false;
        self.ClientControlTab.ImageList := self.UIIconList;
        self.ClientControlTab.Location := new System.Drawing.Point(0, 0);
        self.ClientControlTab.Name := 'ClientControlTab';
        self.ClientControlTab.SelectedIndex := 0;
        self.ClientControlTab.Size := new System.Drawing.Size(844, 213);
        self.ClientControlTab.TabIndex := 5;
        // 
        // ConsoleTab
        // 
        self.ConsoleTab.BackgroundImage := (System.Drawing.Image(resources.GetObject('ConsoleTab.BackgroundImage')));
        self.ConsoleTab.BackgroundImageLayout := System.Windows.Forms.ImageLayout.Center;
        self.ConsoleTab.BorderStyle := System.Windows.Forms.BorderStyle.Fixed3D;
        self.ConsoleTab.Controls.Add(self.ConsoleBox);
        self.ConsoleTab.ImageKey := 'terminal.png';
        self.ConsoleTab.Location := new System.Drawing.Point(4, 35);
        self.ConsoleTab.Name := 'ConsoleTab';
        self.ConsoleTab.Padding := new System.Windows.Forms.Padding(3);
        self.ConsoleTab.Size := new System.Drawing.Size(836, 174);
        self.ConsoleTab.TabIndex := 0;
        self.ConsoleTab.Text := 'Консоль';
        self.ConsoleTab.UseVisualStyleBackColor := true;
        // 
        // ConsoleBox
        // 
        self.ConsoleBox.AcceptsReturn := true;
        self.ConsoleBox.AcceptsTab := true;
        self.ConsoleBox.AutoCompleteMode := System.Windows.Forms.AutoCompleteMode.Append;
        self.ConsoleBox.AutoCompleteSource := System.Windows.Forms.AutoCompleteSource.RecentlyUsedList;
        self.ConsoleBox.BackColor := System.Drawing.SystemColors.Desktop;
        self.ConsoleBox.CausesValidation := false;
        self.ConsoleBox.ContextMenuStrip := self.contextMenuStrip1;
        self.ConsoleBox.Dock := System.Windows.Forms.DockStyle.Fill;
        self.ConsoleBox.Font := new System.Drawing.Font('Microsoft Sans Serif', 14.25, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, (System.Byte(204)));
        self.ConsoleBox.ForeColor := System.Drawing.SystemColors.Menu;
        self.ConsoleBox.ImeMode := System.Windows.Forms.ImeMode.NoControl;
        self.ConsoleBox.Location := new System.Drawing.Point(3, 3);
        self.ConsoleBox.MaxLength := 100767;
        self.ConsoleBox.Multiline := true;
        self.ConsoleBox.Name := 'ConsoleBox';
        self.ConsoleBox.ScrollBars := System.Windows.Forms.ScrollBars.Vertical;
        self.ConsoleBox.Size := new System.Drawing.Size(826, 164);
        self.ConsoleBox.TabIndex := 0;
        self.ConsoleBox.WordWrap := false;
        self.ConsoleBox.KeyDown += ConsoleBox_KeyDown;
        self.ConsoleBox.MouseDown += ConsoleBox_MouseDown;
        // 
        // contextMenuStrip1
        // 
        self.contextMenuStrip1.Name := 'contextMenuStrip1';
        self.contextMenuStrip1.Size := new System.Drawing.Size(61, 4);
        // 
        // ExplorerTab
        // 
        self.ExplorerTab.AutoScroll := true;
        self.ExplorerTab.BackgroundImageLayout := System.Windows.Forms.ImageLayout.Center;
        self.ExplorerTab.BorderStyle := System.Windows.Forms.BorderStyle.Fixed3D;
        self.ExplorerTab.ContextMenuStrip := self.ExplorerTabContextMenu;
        self.ExplorerTab.Controls.Add(self.ExplorerToolBar);
        self.ExplorerTab.Controls.Add(self.splitContainer2);
        self.ExplorerTab.ImageKey := 'explorer.png';
        self.ExplorerTab.Location := new System.Drawing.Point(4, 35);
        self.ExplorerTab.Name := 'ExplorerTab';
        self.ExplorerTab.Padding := new System.Windows.Forms.Padding(3);
        self.ExplorerTab.Size := new System.Drawing.Size(836, 174);
        self.ExplorerTab.TabIndex := 1;
        self.ExplorerTab.Text := 'Проводник';
        self.ExplorerTab.UseVisualStyleBackColor := true;
        self.ExplorerTab.Resize += ExplorerTab_Resize;
        // 
        // ExplorerTabContextMenu
        // 
        self.ExplorerTabContextMenu.Items.AddRange(new System.Windows.Forms.ToolStripItem[3](self.__select_all, self.__update, self.__paste));
        self.ExplorerTabContextMenu.Name := 'contextMenuStrip2';
        self.ExplorerTabContextMenu.Size := new System.Drawing.Size(194, 70);
        // 
        // __select_all
        // 
        self.__select_all.Image := (System.Drawing.Image(resources.GetObject('__select_all.Image')));
        self.__select_all.Name := '__select_all';
        self.__select_all.ShortcutKeys := (System.Windows.Forms.Keys((System.Windows.Forms.Keys.Control or System.Windows.Forms.Keys.A)));
        self.__select_all.Size := new System.Drawing.Size(193, 22);
        self.__select_all.Text := 'Выбрать все';
        self.__select_all.Click += __select_all_Click;
        // 
        // __update
        // 
        self.__update.Image := (System.Drawing.Image(resources.GetObject('__update.Image')));
        self.__update.Name := '__update';
        self.__update.ShortcutKeys := System.Windows.Forms.Keys.F5;
        self.__update.Size := new System.Drawing.Size(193, 22);
        self.__update.Text := 'Обновить';
        self.__update.ToolTipText := 'Обновить содержимое окна';
        self.__update.MouseDown += __update_MouseDown;
        // 
        // __paste
        // 
        self.__paste.Image := (System.Drawing.Image(resources.GetObject('__paste.Image')));
        self.__paste.Name := '__paste';
        self.__paste.ShortcutKeys := (System.Windows.Forms.Keys((System.Windows.Forms.Keys.Control or System.Windows.Forms.Keys.V)));
        self.__paste.Size := new System.Drawing.Size(193, 22);
        self.__paste.Text := 'Вставить';
        // 
        // ExplorerToolBar
        // 
        self.ExplorerToolBar.BackColor := System.Drawing.SystemColors.InactiveCaption;
        self.ExplorerToolBar.Items.AddRange(new System.Windows.Forms.ToolStripItem[3](self.ExplorerToolBarButtonUp, self.toolStripSeparator1, self.LabelPath));
        self.ExplorerToolBar.Location := new System.Drawing.Point(3, 3);
        self.ExplorerToolBar.MaximumSize := new System.Drawing.Size(0, 25);
        self.ExplorerToolBar.Name := 'ExplorerToolBar';
        self.ExplorerToolBar.Size := new System.Drawing.Size(826, 25);
        self.ExplorerToolBar.TabIndex := 0;
        // 
        // ExplorerToolBarButtonUp
        // 
        self.ExplorerToolBarButtonUp.Alignment := System.Windows.Forms.ToolStripItemAlignment.Right;
        self.ExplorerToolBarButtonUp.DisplayStyle := System.Windows.Forms.ToolStripItemDisplayStyle.Image;
        self.ExplorerToolBarButtonUp.Image := (System.Drawing.Image(resources.GetObject('ExplorerToolBarButtonUp.Image')));
        self.ExplorerToolBarButtonUp.ImageTransparentColor := System.Drawing.Color.Transparent;
        self.ExplorerToolBarButtonUp.Name := 'ExplorerToolBarButtonUp';
        self.ExplorerToolBarButtonUp.Size := new System.Drawing.Size(23, 22);
        self.ExplorerToolBarButtonUp.ToolTipText := 'Перейти в верхнюю директорию';
        self.ExplorerToolBarButtonUp.Click += ExplorerToolBarButtonUp_Click;
        // 
        // toolStripSeparator1
        // 
        self.toolStripSeparator1.Alignment := System.Windows.Forms.ToolStripItemAlignment.Right;
        self.toolStripSeparator1.Name := 'toolStripSeparator1';
        self.toolStripSeparator1.Size := new System.Drawing.Size(6, 25);
        // 
        // LabelPath
        // 
        self.LabelPath.AutoToolTip := true;
        self.LabelPath.DisplayStyle := System.Windows.Forms.ToolStripItemDisplayStyle.Text;
        self.LabelPath.Name := 'LabelPath';
        self.LabelPath.Size := new System.Drawing.Size(0, 22);
        self.LabelPath.TextAlign := System.Drawing.ContentAlignment.MiddleRight;
        self.LabelPath.ToolTipText := 'Путь, по которой вы сейчас находитесь';
        // 
        // splitContainer2
        // 
        self.splitContainer2.BackColor := System.Drawing.SystemColors.Control;
        self.splitContainer2.Location := new System.Drawing.Point(282, 42);
        self.splitContainer2.Name := 'splitContainer2';
        self.splitContainer2.Orientation := System.Windows.Forms.Orientation.Horizontal;
        // 
        // splitContainer2.Panel1
        // 
        self.splitContainer2.Panel1.Controls.Add(self.label2);
        // 
        // splitContainer2.Panel2
        // 
        self.splitContainer2.Panel2.Controls.Add(self.label1);
        self.splitContainer2.Panel2MinSize := 50;
        self.splitContainer2.Size := new System.Drawing.Size(100, 100);
        self.splitContainer2.SplitterDistance := 46;
        self.splitContainer2.TabIndex := 1;
        // 
        // label2
        // 
        self.label2.BackColor := System.Drawing.SystemColors.Control;
        self.label2.Dock := System.Windows.Forms.DockStyle.Fill;
        self.label2.ImageKey := 'ini.png';
        self.label2.ImageList := self.FilesIconList;
        self.label2.Location := new System.Drawing.Point(0, 0);
        self.label2.Name := 'label2';
        self.label2.Size := new System.Drawing.Size(100, 46);
        self.label2.TabIndex := 1;
        // 
        // FilesIconList
        // 
        self.FilesIconList.ImageStream := (System.Windows.Forms.ImageListStreamer(resources.GetObject('FilesIconList.ImageStream')));
        self.FilesIconList.TransparentColor := System.Drawing.Color.Transparent;
        self.FilesIconList.Images.SetKeyName(0, 'asp.png');
        self.FilesIconList.Images.SetKeyName(1, 'avi.png');
        self.FilesIconList.Images.SetKeyName(2, 'bat.png');
        self.FilesIconList.Images.SetKeyName(3, 'cmd.png');
        self.FilesIconList.Images.SetKeyName(4, 'com.png');
        self.FilesIconList.Images.SetKeyName(5, 'csv.png');
        self.FilesIconList.Images.SetKeyName(6, 'dir.png');
        self.FilesIconList.Images.SetKeyName(7, 'dll.png');
        self.FilesIconList.Images.SetKeyName(8, 'doc.png');
        self.FilesIconList.Images.SetKeyName(9, 'docx.png');
        self.FilesIconList.Images.SetKeyName(10, 'exe.png');
        self.FilesIconList.Images.SetKeyName(11, 'explorer.png');
        self.FilesIconList.Images.SetKeyName(12, 'file.png');
        self.FilesIconList.Images.SetKeyName(13, 'gif.png');
        self.FilesIconList.Images.SetKeyName(14, 'htm.png');
        self.FilesIconList.Images.SetKeyName(15, 'html.png');
        self.FilesIconList.Images.SetKeyName(16, 'ico.png');
        self.FilesIconList.Images.SetKeyName(17, 'ini.png');
        self.FilesIconList.Images.SetKeyName(18, 'iso.png');
        self.FilesIconList.Images.SetKeyName(19, 'jar.png');
        self.FilesIconList.Images.SetKeyName(20, 'jpg.png');
        self.FilesIconList.Images.SetKeyName(21, 'js.png');
        self.FilesIconList.Images.SetKeyName(22, 'jsx.png');
        self.FilesIconList.Images.SetKeyName(23, 'mp3.png');
        self.FilesIconList.Images.SetKeyName(24, 'mp4.png');
        self.FilesIconList.Images.SetKeyName(25, 'nfo.png');
        self.FilesIconList.Images.SetKeyName(26, 'obj.png');
        self.FilesIconList.Images.SetKeyName(27, 'otf.png');
        self.FilesIconList.Images.SetKeyName(28, 'pabcproj.png');
        self.FilesIconList.Images.SetKeyName(29, 'pas.png');
        self.FilesIconList.Images.SetKeyName(30, 'pdf.png');
        self.FilesIconList.Images.SetKeyName(31, 'pkg.png');
        self.FilesIconList.Images.SetKeyName(32, 'png.png');
        self.FilesIconList.Images.SetKeyName(33, 'ppt.png');
        self.FilesIconList.Images.SetKeyName(34, 'pptx.png');
        self.FilesIconList.Images.SetKeyName(35, 'rtf.png');
        self.FilesIconList.Images.SetKeyName(36, 'terminal.png');
        self.FilesIconList.Images.SetKeyName(37, 'txt.png');
        self.FilesIconList.Images.SetKeyName(38, 'wav.png');
        self.FilesIconList.Images.SetKeyName(39, 'wmv.png');
        self.FilesIconList.Images.SetKeyName(40, 'xls.png');
        self.FilesIconList.Images.SetKeyName(41, 'xlsx.png');
        self.FilesIconList.Images.SetKeyName(42, 'xml.png');
        self.FilesIconList.Images.SetKeyName(43, 'zip.png');
        // 
        // label1
        // 
        self.label1.Anchor := (System.Windows.Forms.AnchorStyles(((System.Windows.Forms.AnchorStyles.Bottom or System.Windows.Forms.AnchorStyles.Left) 
                    or System.Windows.Forms.AnchorStyles.Right)));
        self.label1.AutoEllipsis := true;
        self.label1.BackColor := System.Drawing.SystemColors.Control;
        self.label1.Location := new System.Drawing.Point(-147, 0);
        self.label1.MaximumSize := new System.Drawing.Size(100, 0);
        self.label1.Name := 'label1';
        self.label1.Size := new System.Drawing.Size(100, 56);
        self.label1.TabIndex := 0;
        self.label1.Text := 'autorun_1234567890_1234567890.ini';
        self.label1.TextAlign := System.Drawing.ContentAlignment.TopCenter;
        self.label1.UseCompatibleTextRendering := true;
        // 
        // UIIconList
        // 
        self.UIIconList.ImageStream := (System.Windows.Forms.ImageListStreamer(resources.GetObject('UIIconList.ImageStream')));
        self.UIIconList.TransparentColor := System.Drawing.Color.Transparent;
        self.UIIconList.Images.SetKeyName(0, 'explorer.png');
        self.UIIconList.Images.SetKeyName(1, 'terminal.png');
        self.UIIconList.Images.SetKeyName(2, 'arrow.png');
        // 
        // ExplorerItemContextMenu
        // 
        self.ExplorerItemContextMenu.Items.AddRange(new System.Windows.Forms.ToolStripItem[4](self.__copy, self.__cut, self.__rename, self.__receive_file));
        self.ExplorerItemContextMenu.Name := 'contextMenuStrip2';
        self.ExplorerItemContextMenu.Size := new System.Drawing.Size(191, 114);
        // 
        // __copy
        // 
        self.__copy.Image := (System.Drawing.Image(resources.GetObject('__copy.Image')));
        self.__copy.Name := '__copy';
        self.__copy.ShortcutKeys := (System.Windows.Forms.Keys((System.Windows.Forms.Keys.Control or System.Windows.Forms.Keys.C)));
        self.__copy.Size := new System.Drawing.Size(190, 22);
        self.__copy.Text := 'Копировать';
        // 
        // __cut
        // 
        self.__cut.Image := (System.Drawing.Image(resources.GetObject('__cut.Image')));
        self.__cut.Name := '__cut';
        self.__cut.ShortcutKeys := (System.Windows.Forms.Keys((System.Windows.Forms.Keys.Control or System.Windows.Forms.Keys.X)));
        self.__cut.Size := new System.Drawing.Size(190, 22);
        self.__cut.Text := 'Вырезать';
        // 
        // __rename
        // 
        self.__rename.Image := (System.Drawing.Image(resources.GetObject('__rename.Image')));
        self.__rename.Name := '__rename';
        self.__rename.ShortcutKeys := System.Windows.Forms.Keys.F2;
        self.__rename.Size := new System.Drawing.Size(190, 22);
        self.__rename.Text := 'Переименовать';
        // 
        // __receive_file
        // 
        self.__receive_file.Image := (System.Drawing.Image(resources.GetObject('__receive_file.Image')));
        self.__receive_file.MergeIndex := 0;
        self.__receive_file.Name := '__receive_file';
        self.__receive_file.Size := new System.Drawing.Size(190, 22);
        self.__receive_file.Text := 'Получить файл';
        self.__receive_file.Click += __receive_file_Click;
        // 
        // MainWindow
        // 
        self.ClientSize := new System.Drawing.Size(862, 477);
        self.Controls.Add(self.DefaultTab);
        self.Font := new System.Drawing.Font('Microsoft Sans Serif', 15.75, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, (System.Byte(204)));
        self.Icon := (System.Drawing.Icon(resources.GetObject('$this.Icon')));
        self.Name := 'MainWindow';
        self.Text := 'Remote Control';
        self.FormClosing += MainWindow_FormClosing;
        self.Load += Form1_Load;
        self.DefaultTab.ResumeLayout(false);
        self.ClientTab.ResumeLayout(false);
        self.ClientTab.PerformLayout();
        self.ServerTab.ResumeLayout(false);
        self.splitContainer1.Panel1.ResumeLayout(false);
        self.splitContainer1.Panel1.PerformLayout();
        self.splitContainer1.Panel2.ResumeLayout(false);
        (System.ComponentModel.ISupportInitialize(self.splitContainer1)).EndInit();
        self.splitContainer1.ResumeLayout(false);
        self.ClientControlTab.ResumeLayout(false);
        self.ConsoleTab.ResumeLayout(false);
        self.ConsoleTab.PerformLayout();
        self.ExplorerTab.ResumeLayout(false);
        self.ExplorerTab.PerformLayout();
        self.ExplorerTabContextMenu.ResumeLayout(false);
        self.ExplorerToolBar.ResumeLayout(false);
        self.ExplorerToolBar.PerformLayout();
        self.splitContainer2.Panel1.ResumeLayout(false);
        self.splitContainer2.Panel2.ResumeLayout(false);
        (System.ComponentModel.ISupportInitialize(self.splitContainer2)).EndInit();
        self.splitContainer2.ResumeLayout(false);
        self.ExplorerItemContextMenu.ResumeLayout(false);
        self.ResumeLayout(false);
    end;
