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
        self.UIIconList := new System.Windows.Forms.ImageList(self.components);
        self.ServerTab := new System.Windows.Forms.TabPage();
        self.splitContainer1 := new System.Windows.Forms.SplitContainer();
        self.OpenListOfConnectedDevices := new System.Windows.Forms.Button();
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
        self.ExplorerPanel := new System.Windows.Forms.Panel();
        self.ItemLabel := new System.Windows.Forms.Label();
        self.FilesIconList := new System.Windows.Forms.ImageList(self.components);
        self.ExplorerToolBar := new System.Windows.Forms.ToolStrip();
        self.ExplorerHomeBtn := new System.Windows.Forms.ToolStripButton();
        self.ExplorerToolBarButtonUp := new System.Windows.Forms.ToolStripButton();
        self.ExplorerPathLabel := new System.Windows.Forms.ToolStripLabel();
        self.ExplorerItemsUpdateButton := new System.Windows.Forms.ToolStripButton();
        self.SelectAllItems := new System.Windows.Forms.ToolStripButton();
        self.toolStripButton2 := new System.Windows.Forms.ToolStripButton();
        self.SettingsTab := new System.Windows.Forms.TabPage();
        self.ManualOpenBtn := new System.Windows.Forms.Button();
        self.CopyrightText := new System.Windows.Forms.Label();
        self.ExplorerItemContextMenu := new System.Windows.Forms.ContextMenuStrip(self.components);
        self.__cut := new System.Windows.Forms.ToolStripMenuItem();
        self.__copy := new System.Windows.Forms.ToolStripMenuItem();
        self.__rename := new System.Windows.Forms.ToolStripMenuItem();
        self.__receive_file := new System.Windows.Forms.ToolStripMenuItem();
        self.__delete := new System.Windows.Forms.ToolStripMenuItem();
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
        self.ExplorerPanel.SuspendLayout();
        self.ExplorerToolBar.SuspendLayout();
        self.SettingsTab.SuspendLayout();
        self.ExplorerItemContextMenu.SuspendLayout();
        self.SuspendLayout();
        // 
        // DefaultTab
        // 
        self.DefaultTab.Controls.Add(self.ClientTab);
        self.DefaultTab.Controls.Add(self.ServerTab);
        self.DefaultTab.Controls.Add(self.SettingsTab);
        self.DefaultTab.Cursor := System.Windows.Forms.Cursors.Default;
        self.DefaultTab.Dock := System.Windows.Forms.DockStyle.Fill;
        self.DefaultTab.Font := new System.Drawing.Font('Microsoft Sans Serif', 12, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, (System.Byte(204)));
        self.DefaultTab.HotTrack := true;
        self.DefaultTab.ImageList := self.UIIconList;
        self.DefaultTab.Location := new System.Drawing.Point(0, 0);
        self.DefaultTab.Name := 'DefaultTab';
        self.DefaultTab.SelectedIndex := 0;
        self.DefaultTab.Size := new System.Drawing.Size(884, 561);
        self.DefaultTab.SizeMode := System.Windows.Forms.TabSizeMode.FillToRight;
        self.DefaultTab.TabIndex := 0;
        // 
        // ClientTab
        // 
        self.ClientTab.BackColor := System.Drawing.SystemColors.ScrollBar;
        self.ClientTab.Controls.Add(self.clientConnectingProgress);
        self.ClientTab.Controls.Add(self.clientConnectState);
        self.ClientTab.Controls.Add(self.ClientIPMask);
        self.ClientTab.Controls.Add(self.clientConnectButton);
        self.ClientTab.Cursor := System.Windows.Forms.Cursors.Default;
        self.ClientTab.Font := new System.Drawing.Font('Microsoft Sans Serif', 11.25, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, (System.Byte(204)));
        self.ClientTab.ImageKey := 'client.png';
        self.ClientTab.Location := new System.Drawing.Point(4, 32);
        self.ClientTab.Name := 'ClientTab';
        self.ClientTab.Padding := new System.Windows.Forms.Padding(3);
        self.ClientTab.Size := new System.Drawing.Size(854, 441);
        self.ClientTab.TabIndex := 0;
        self.ClientTab.Text := 'Клиент';
        // 
        // clientConnectingProgress
        // 
        self.clientConnectingProgress.Location := new System.Drawing.Point(318, 16);
        self.clientConnectingProgress.Maximum := 5;
        self.clientConnectingProgress.Name := 'clientConnectingProgress';
        self.clientConnectingProgress.Size := new System.Drawing.Size(100, 23);
        self.clientConnectingProgress.Step := 1;
        self.clientConnectingProgress.TabIndex := 3;
        // 
        // clientConnectState
        // 
        self.clientConnectState.AutoSize := true;
        self.clientConnectState.BackColor := System.Drawing.Color.Transparent;
        self.clientConnectState.Font := new System.Drawing.Font('Microsoft Sans Serif', 11.25, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, (System.Byte(204)));
        self.clientConnectState.ForeColor := System.Drawing.SystemColors.ControlText;
        self.clientConnectState.Location := new System.Drawing.Point(439, 19);
        self.clientConnectState.Name := 'clientConnectState';
        self.clientConnectState.Size := new System.Drawing.Size(121, 22);
        self.clientConnectState.TabIndex := 2;
        self.clientConnectState.Text := 'Не подключено';
        self.clientConnectState.UseCompatibleTextRendering := true;
        // 
        // ClientIPMask
        // 
        self.ClientIPMask.InsertKeyMode := System.Windows.Forms.InsertKeyMode.Insert;
        self.ClientIPMask.Location := new System.Drawing.Point(183, 16);
        self.ClientIPMask.Mask := '000.000.000.000';
        self.ClientIPMask.Name := 'ClientIPMask';
        self.ClientIPMask.Size := new System.Drawing.Size(116, 24);
        self.ClientIPMask.TabIndex := 1;
        self.ClientIPMask.KeyPress += ClientIPMask_KeyPress;
        // 
        // clientConnectButton
        // 
        self.clientConnectButton.AutoSize := true;
        self.clientConnectButton.BackColor := System.Drawing.SystemColors.AppWorkspace;
        self.clientConnectButton.FlatStyle := System.Windows.Forms.FlatStyle.Flat;
        self.clientConnectButton.Font := new System.Drawing.Font('Microsoft Sans Serif', 11.25, System.Drawing.FontStyle.Bold);
        self.clientConnectButton.ImageAlign := System.Drawing.ContentAlignment.MiddleLeft;
        self.clientConnectButton.ImageKey := 'disconnected.png';
        self.clientConnectButton.ImageList := self.UIIconList;
        self.clientConnectButton.Location := new System.Drawing.Point(10, 10);
        self.clientConnectButton.Name := 'clientConnectButton';
        self.clientConnectButton.Size := new System.Drawing.Size(161, 35);
        self.clientConnectButton.TabIndex := 0;
        self.clientConnectButton.Text := '      Подключиться';
        self.clientConnectButton.UseCompatibleTextRendering := true;
        self.clientConnectButton.UseVisualStyleBackColor := false;
        self.clientConnectButton.Click += ClientConnectButton_Click;
        // 
        // UIIconList
        // 
        self.UIIconList.ImageStream := (System.Windows.Forms.ImageListStreamer(resources.GetObject('UIIconList.ImageStream')));
        self.UIIconList.TransparentColor := System.Drawing.Color.Transparent;
        self.UIIconList.Images.SetKeyName(0, 'explorer.png');
        self.UIIconList.Images.SetKeyName(1, 'terminal.png');
        self.UIIconList.Images.SetKeyName(2, 'arrow.png');
        self.UIIconList.Images.SetKeyName(3, 'settings.png');
        self.UIIconList.Images.SetKeyName(4, 'client.png');
        self.UIIconList.Images.SetKeyName(5, 'server.png');
        self.UIIconList.Images.SetKeyName(6, 'server1.png');
        self.UIIconList.Images.SetKeyName(7, 'server2.png');
        self.UIIconList.Images.SetKeyName(8, 'server3.png');
        self.UIIconList.Images.SetKeyName(9, 'manual.png');
        self.UIIconList.Images.SetKeyName(10, 'list.png');
        self.UIIconList.Images.SetKeyName(11, 'list1.png');
        self.UIIconList.Images.SetKeyName(12, 'connected.png');
        self.UIIconList.Images.SetKeyName(13, 'disconnected.png');
        self.UIIconList.Images.SetKeyName(14, 'off.png');
        self.UIIconList.Images.SetKeyName(15, 'on.png');
        // 
        // ServerTab
        // 
        self.ServerTab.BackColor := System.Drawing.SystemColors.ScrollBar;
        self.ServerTab.Controls.Add(self.splitContainer1);
        self.ServerTab.Cursor := System.Windows.Forms.Cursors.Default;
        self.ServerTab.Font := new System.Drawing.Font('Microsoft Sans Serif', 11.25, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, (System.Byte(204)));
        self.ServerTab.ImageKey := 'server.png';
        self.ServerTab.ImeMode := System.Windows.Forms.ImeMode.NoControl;
        self.ServerTab.Location := new System.Drawing.Point(4, 32);
        self.ServerTab.Name := 'ServerTab';
        self.ServerTab.Padding := new System.Windows.Forms.Padding(3);
        self.ServerTab.Size := new System.Drawing.Size(876, 525);
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
        self.splitContainer1.Panel1.Controls.Add(self.OpenListOfConnectedDevices);
        self.splitContainer1.Panel1.Controls.Add(self.CountOfClientsLabel);
        self.splitContainer1.Panel1.Controls.Add(self.ServerStartedInfo);
        self.splitContainer1.Panel1.Controls.Add(self.ServerCreateButton);
        self.splitContainer1.Panel1.RightToLeft := System.Windows.Forms.RightToLeft.No;
        // 
        // splitContainer1.Panel2
        // 
        self.splitContainer1.Panel2.Controls.Add(self.ClientControlTab);
        self.splitContainer1.Panel2.RightToLeft := System.Windows.Forms.RightToLeft.No;
        self.splitContainer1.Size := new System.Drawing.Size(870, 519);
        self.splitContainer1.SplitterDistance := 258;
        self.splitContainer1.TabIndex := 4;
        // 
        // OpenListOfConnectedDevices
        // 
        self.OpenListOfConnectedDevices.Anchor := (System.Windows.Forms.AnchorStyles((System.Windows.Forms.AnchorStyles.Top or System.Windows.Forms.AnchorStyles.Right)));
        self.OpenListOfConnectedDevices.BackColor := System.Drawing.SystemColors.AppWorkspace;
        self.OpenListOfConnectedDevices.Enabled := false;
        self.OpenListOfConnectedDevices.FlatStyle := System.Windows.Forms.FlatStyle.Flat;
        self.OpenListOfConnectedDevices.Font := new System.Drawing.Font('Microsoft Sans Serif', 11.25, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, (System.Byte(204)));
        self.OpenListOfConnectedDevices.ForeColor := System.Drawing.SystemColors.ControlText;
        self.OpenListOfConnectedDevices.ImageAlign := System.Drawing.ContentAlignment.MiddleLeft;
        self.OpenListOfConnectedDevices.ImageKey := 'list1.png';
        self.OpenListOfConnectedDevices.ImageList := self.UIIconList;
        self.OpenListOfConnectedDevices.Location := new System.Drawing.Point(561, 6);
        self.OpenListOfConnectedDevices.Name := 'OpenListOfConnectedDevices';
        self.OpenListOfConnectedDevices.Size := new System.Drawing.Size(305, 38);
        self.OpenListOfConnectedDevices.TabIndex := 5;
        self.OpenListOfConnectedDevices.Text := 'Список подключённых устройств';
        self.OpenListOfConnectedDevices.TextAlign := System.Drawing.ContentAlignment.MiddleRight;
        self.OpenListOfConnectedDevices.UseVisualStyleBackColor := false;
        self.OpenListOfConnectedDevices.Click += OpenListOfConnectedDevices_Click;
        // 
        // CountOfClientsLabel
        // 
        self.CountOfClientsLabel.Anchor := (System.Windows.Forms.AnchorStyles((System.Windows.Forms.AnchorStyles.Top or System.Windows.Forms.AnchorStyles.Right)));
        self.CountOfClientsLabel.AutoSize := true;
        self.CountOfClientsLabel.Font := new System.Drawing.Font('Microsoft Sans Serif', 11.25, System.Drawing.FontStyle.Bold);
        self.CountOfClientsLabel.Location := new System.Drawing.Point(606, 53);
        self.CountOfClientsLabel.Name := 'CountOfClientsLabel';
        self.CountOfClientsLabel.Size := new System.Drawing.Size(215, 22);
        self.CountOfClientsLabel.TabIndex := 2;
        self.CountOfClientsLabel.Text := 'Подключённых устройств: 0';
        self.CountOfClientsLabel.UseCompatibleTextRendering := true;
        // 
        // ServerStartedInfo
        // 
        self.ServerStartedInfo.AutoEllipsis := true;
        self.ServerStartedInfo.AutoSize := true;
        self.ServerStartedInfo.Font := new System.Drawing.Font('Microsoft Sans Serif', 11.25, System.Drawing.FontStyle.Bold);
        self.ServerStartedInfo.Location := new System.Drawing.Point(169, 6);
        self.ServerStartedInfo.Name := 'ServerStartedInfo';
        self.ServerStartedInfo.Size := new System.Drawing.Size(207, 22);
        self.ServerStartedInfo.TabIndex := 1;
        self.ServerStartedInfo.Text := 'Сервер успешно запущен'#13#10;
        self.ServerStartedInfo.UseCompatibleTextRendering := true;
        self.ServerStartedInfo.Visible := false;
        // 
        // ServerCreateButton
        // 
        self.ServerCreateButton.AutoSize := true;
        self.ServerCreateButton.BackColor := System.Drawing.SystemColors.AppWorkspace;
        self.ServerCreateButton.FlatStyle := System.Windows.Forms.FlatStyle.Flat;
        self.ServerCreateButton.Font := new System.Drawing.Font('Microsoft Sans Serif', 11.25, System.Drawing.FontStyle.Bold);
        self.ServerCreateButton.ImageAlign := System.Drawing.ContentAlignment.MiddleLeft;
        self.ServerCreateButton.ImageKey := 'off.png';
        self.ServerCreateButton.ImageList := self.UIIconList;
        self.ServerCreateButton.Location := new System.Drawing.Point(6, 6);
        self.ServerCreateButton.Name := 'ServerCreateButton';
        self.ServerCreateButton.Size := new System.Drawing.Size(184, 38);
        self.ServerCreateButton.TabIndex := 0;
        self.ServerCreateButton.Text := '     Запустить сервер';
        self.ServerCreateButton.UseVisualStyleBackColor := false;
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
        self.ClientControlTab.Size := new System.Drawing.Size(870, 257);
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
        self.ConsoleTab.Size := new System.Drawing.Size(862, 218);
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
        self.ConsoleBox.Font := new System.Drawing.Font('Lucida Console', 12, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, (System.Byte(204)));
        self.ConsoleBox.ForeColor := System.Drawing.SystemColors.Menu;
        self.ConsoleBox.ImeMode := System.Windows.Forms.ImeMode.NoControl;
        self.ConsoleBox.Location := new System.Drawing.Point(3, 3);
        self.ConsoleBox.MaxLength := 100767;
        self.ConsoleBox.Multiline := true;
        self.ConsoleBox.Name := 'ConsoleBox';
        self.ConsoleBox.ScrollBars := System.Windows.Forms.ScrollBars.Vertical;
        self.ConsoleBox.Size := new System.Drawing.Size(852, 208);
        self.ConsoleBox.TabIndex := 0;
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
        self.ExplorerTab.BackColor := System.Drawing.SystemColors.ScrollBar;
        self.ExplorerTab.BackgroundImageLayout := System.Windows.Forms.ImageLayout.Center;
        self.ExplorerTab.BorderStyle := System.Windows.Forms.BorderStyle.Fixed3D;
        self.ExplorerTab.ContextMenuStrip := self.ExplorerTabContextMenu;
        self.ExplorerTab.Controls.Add(self.ExplorerPanel);
        self.ExplorerTab.Controls.Add(self.ExplorerToolBar);
        self.ExplorerTab.ImageKey := 'explorer.png';
        self.ExplorerTab.Location := new System.Drawing.Point(4, 35);
        self.ExplorerTab.Name := 'ExplorerTab';
        self.ExplorerTab.Padding := new System.Windows.Forms.Padding(3);
        self.ExplorerTab.Size := new System.Drawing.Size(862, 218);
        self.ExplorerTab.TabIndex := 1;
        self.ExplorerTab.Text := 'Проводник';
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
        self.__paste.MouseDown += __paste_MouseDown;
        // 
        // ExplorerPanel
        // 
        self.ExplorerPanel.AutoScroll := true;
        self.ExplorerPanel.Controls.Add(self.ItemLabel);
        self.ExplorerPanel.Dock := System.Windows.Forms.DockStyle.Fill;
        self.ExplorerPanel.Location := new System.Drawing.Point(3, 28);
        self.ExplorerPanel.Name := 'ExplorerPanel';
        self.ExplorerPanel.Size := new System.Drawing.Size(852, 183);
        self.ExplorerPanel.TabIndex := 2;
        self.ExplorerPanel.MouseDown += ExplorerPanel_MouseDown;
        self.ExplorerPanel.Resize += ExplorerPanel_Resize;
        // 
        // ItemLabel
        // 
        self.ItemLabel.AutoEllipsis := true;
        self.ItemLabel.AutoSize := true;
        self.ItemLabel.BackColor := System.Drawing.Color.Transparent;
        self.ItemLabel.FlatStyle := System.Windows.Forms.FlatStyle.Flat;
        self.ItemLabel.ImageAlign := System.Drawing.ContentAlignment.TopCenter;
        self.ItemLabel.ImageKey := 'ini.png';
        self.ItemLabel.ImageList := self.FilesIconList;
        self.ItemLabel.Location := new System.Drawing.Point(434, 22);
        self.ItemLabel.Margin := new System.Windows.Forms.Padding(3, 3, 3, 0);
        self.ItemLabel.MaximumSize := new System.Drawing.Size(70, 100);
        self.ItemLabel.Name := 'ItemLabel';
        self.ItemLabel.Padding := new System.Windows.Forms.Padding(0, 0, 0, 3);
        self.ItemLabel.Size := new System.Drawing.Size(66, 93);
        self.ItemLabel.TabIndex := 1;
        self.ItemLabel.Text := #13#10#13#10#13#10'файл.pngjd';
        self.ItemLabel.TextAlign := System.Drawing.ContentAlignment.MiddleCenter;
        self.ItemLabel.UseCompatibleTextRendering := true;
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
        self.FilesIconList.Images.SetKeyName(44, 'Desktop.png');
        self.FilesIconList.Images.SetKeyName(45, 'Documents.png');
        self.FilesIconList.Images.SetKeyName(46, 'Downloads.png');
        self.FilesIconList.Images.SetKeyName(47, 'Music.png');
        self.FilesIconList.Images.SetKeyName(48, 'Pictures.png');
        self.FilesIconList.Images.SetKeyName(49, 'User.png');
        self.FilesIconList.Images.SetKeyName(50, 'drive.png');
        self.FilesIconList.Images.SetKeyName(51, 'network-drive.png');
        self.FilesIconList.Images.SetKeyName(52, 'usb-flash-drive.png');
        // 
        // ExplorerToolBar
        // 
        self.ExplorerToolBar.BackColor := System.Drawing.SystemColors.AppWorkspace;
        self.ExplorerToolBar.Items.AddRange(new System.Windows.Forms.ToolStripItem[6](self.ExplorerHomeBtn, self.ExplorerToolBarButtonUp, self.ExplorerPathLabel, self.ExplorerItemsUpdateButton, self.SelectAllItems, self.toolStripButton2));
        self.ExplorerToolBar.Location := new System.Drawing.Point(3, 3);
        self.ExplorerToolBar.MaximumSize := new System.Drawing.Size(0, 25);
        self.ExplorerToolBar.Name := 'ExplorerToolBar';
        self.ExplorerToolBar.Padding := new System.Windows.Forms.Padding(0, 0, 5, 0);
        self.ExplorerToolBar.Size := new System.Drawing.Size(852, 25);
        self.ExplorerToolBar.TabIndex := 0;
        // 
        // ExplorerHomeBtn
        // 
        self.ExplorerHomeBtn.Alignment := System.Windows.Forms.ToolStripItemAlignment.Right;
        self.ExplorerHomeBtn.DisplayStyle := System.Windows.Forms.ToolStripItemDisplayStyle.Image;
        self.ExplorerHomeBtn.Image := (System.Drawing.Image(resources.GetObject('ExplorerHomeBtn.Image')));
        self.ExplorerHomeBtn.ImageTransparentColor := System.Drawing.Color.Magenta;
        self.ExplorerHomeBtn.Margin := new System.Windows.Forms.Padding(3, 1, 0, 2);
        self.ExplorerHomeBtn.Name := 'ExplorerHomeBtn';
        self.ExplorerHomeBtn.Overflow := System.Windows.Forms.ToolStripItemOverflow.Never;
        self.ExplorerHomeBtn.Size := new System.Drawing.Size(23, 22);
        self.ExplorerHomeBtn.ToolTipText := 'Домой';
        self.ExplorerHomeBtn.MouseDown += ExplorerHomeBtn_MouseDown;
        // 
        // ExplorerToolBarButtonUp
        // 
        self.ExplorerToolBarButtonUp.Alignment := System.Windows.Forms.ToolStripItemAlignment.Right;
        self.ExplorerToolBarButtonUp.DisplayStyle := System.Windows.Forms.ToolStripItemDisplayStyle.Image;
        self.ExplorerToolBarButtonUp.Image := (System.Drawing.Image(resources.GetObject('ExplorerToolBarButtonUp.Image')));
        self.ExplorerToolBarButtonUp.ImageTransparentColor := System.Drawing.Color.Transparent;
        self.ExplorerToolBarButtonUp.Margin := new System.Windows.Forms.Padding(3, 1, 0, 2);
        self.ExplorerToolBarButtonUp.Name := 'ExplorerToolBarButtonUp';
        self.ExplorerToolBarButtonUp.Size := new System.Drawing.Size(23, 22);
        self.ExplorerToolBarButtonUp.ToolTipText := 'Перейти в верхнюю директорию';
        self.ExplorerToolBarButtonUp.Click += ExplorerToolBarButtonUp_Click;
        // 
        // ExplorerPathLabel
        // 
        self.ExplorerPathLabel.AutoToolTip := true;
        self.ExplorerPathLabel.DisplayStyle := System.Windows.Forms.ToolStripItemDisplayStyle.Text;
        self.ExplorerPathLabel.Name := 'ExplorerPathLabel';
        self.ExplorerPathLabel.Overflow := System.Windows.Forms.ToolStripItemOverflow.Never;
        self.ExplorerPathLabel.Size := new System.Drawing.Size(0, 22);
        self.ExplorerPathLabel.ToolTipText := 'Путь, по которой вы сейчас находитесь';
        // 
        // ExplorerItemsUpdateButton
        // 
        self.ExplorerItemsUpdateButton.Alignment := System.Windows.Forms.ToolStripItemAlignment.Right;
        self.ExplorerItemsUpdateButton.DisplayStyle := System.Windows.Forms.ToolStripItemDisplayStyle.Image;
        self.ExplorerItemsUpdateButton.Image := (System.Drawing.Image(resources.GetObject('ExplorerItemsUpdateButton.Image')));
        self.ExplorerItemsUpdateButton.ImageTransparentColor := System.Drawing.Color.Magenta;
        self.ExplorerItemsUpdateButton.Margin := new System.Windows.Forms.Padding(3, 1, 0, 2);
        self.ExplorerItemsUpdateButton.Name := 'ExplorerItemsUpdateButton';
        self.ExplorerItemsUpdateButton.Size := new System.Drawing.Size(23, 22);
        self.ExplorerItemsUpdateButton.ToolTipText := 'Обновить';
        self.ExplorerItemsUpdateButton.MouseDown += __update_MouseDown;
        // 
        // SelectAllItems
        // 
        self.SelectAllItems.Alignment := System.Windows.Forms.ToolStripItemAlignment.Right;
        self.SelectAllItems.DisplayStyle := System.Windows.Forms.ToolStripItemDisplayStyle.Image;
        self.SelectAllItems.Image := (System.Drawing.Image(resources.GetObject('SelectAllItems.Image')));
        self.SelectAllItems.ImageTransparentColor := System.Drawing.Color.Magenta;
        self.SelectAllItems.Margin := new System.Windows.Forms.Padding(3, 1, 0, 2);
        self.SelectAllItems.Name := 'SelectAllItems';
        self.SelectAllItems.Size := new System.Drawing.Size(23, 22);
        self.SelectAllItems.ToolTipText := 'Выбрать всё';
        self.SelectAllItems.Click += __select_all_Click;
        // 
        // toolStripButton2
        // 
        self.toolStripButton2.Alignment := System.Windows.Forms.ToolStripItemAlignment.Right;
        self.toolStripButton2.DisplayStyle := System.Windows.Forms.ToolStripItemDisplayStyle.Image;
        self.toolStripButton2.Image := (System.Drawing.Image(resources.GetObject('toolStripButton2.Image')));
        self.toolStripButton2.ImageTransparentColor := System.Drawing.Color.Magenta;
        self.toolStripButton2.Margin := new System.Windows.Forms.Padding(3, 1, 0, 2);
        self.toolStripButton2.Name := 'toolStripButton2';
        self.toolStripButton2.Size := new System.Drawing.Size(23, 22);
        self.toolStripButton2.ToolTipText := 'Вставить';
        self.toolStripButton2.MouseDown += __paste_MouseDown;
        // 
        // SettingsTab
        // 
        self.SettingsTab.BackColor := System.Drawing.SystemColors.ScrollBar;
        self.SettingsTab.Controls.Add(self.ManualOpenBtn);
        self.SettingsTab.Controls.Add(self.CopyrightText);
        self.SettingsTab.ImageKey := 'settings.png';
        self.SettingsTab.Location := new System.Drawing.Point(4, 32);
        self.SettingsTab.Name := 'SettingsTab';
        self.SettingsTab.Padding := new System.Windows.Forms.Padding(3);
        self.SettingsTab.Size := new System.Drawing.Size(854, 441);
        self.SettingsTab.TabIndex := 2;
        self.SettingsTab.Text := 'Настройки';
        // 
        // ManualOpenBtn
        // 
        self.ManualOpenBtn.BackColor := System.Drawing.Color.Transparent;
        self.ManualOpenBtn.FlatStyle := System.Windows.Forms.FlatStyle.Flat;
        self.ManualOpenBtn.ImageAlign := System.Drawing.ContentAlignment.MiddleLeft;
        self.ManualOpenBtn.ImageKey := 'manual.png';
        self.ManualOpenBtn.ImageList := self.UIIconList;
        self.ManualOpenBtn.Location := new System.Drawing.Point(17, 18);
        self.ManualOpenBtn.Name := 'ManualOpenBtn';
        self.ManualOpenBtn.Size := new System.Drawing.Size(325, 38);
        self.ManualOpenBtn.TabIndex := 1;
        self.ManualOpenBtn.Text := 'Открыть руководство пользователя';
        self.ManualOpenBtn.TextAlign := System.Drawing.ContentAlignment.MiddleRight;
        self.ManualOpenBtn.UseVisualStyleBackColor := false;
        self.ManualOpenBtn.MouseDown += ManualOpenBtn_MouseDown;
        // 
        // CopyrightText
        // 
        self.CopyrightText.Dock := System.Windows.Forms.DockStyle.Bottom;
        self.CopyrightText.Location := new System.Drawing.Point(3, 414);
        self.CopyrightText.Name := 'CopyrightText';
        self.CopyrightText.Size := new System.Drawing.Size(848, 24);
        self.CopyrightText.TabIndex := 0;
        self.CopyrightText.Text := 'Copyright © 2025-2099 by Kertov Islam M. All Rights Reserved. ';
        // 
        // ExplorerItemContextMenu
        // 
        self.ExplorerItemContextMenu.Items.AddRange(new System.Windows.Forms.ToolStripItem[5](self.__cut, self.__copy, self.__rename, self.__receive_file, self.__delete));
        self.ExplorerItemContextMenu.Name := 'contextMenuStrip2';
        self.ExplorerItemContextMenu.Size := new System.Drawing.Size(191, 114);
        // 
        // __cut
        // 
        self.__cut.Image := (System.Drawing.Image(resources.GetObject('__cut.Image')));
        self.__cut.Name := '__cut';
        self.__cut.ShortcutKeys := (System.Windows.Forms.Keys((System.Windows.Forms.Keys.Control or System.Windows.Forms.Keys.X)));
        self.__cut.Size := new System.Drawing.Size(190, 22);
        self.__cut.Text := 'Вырезать';
        self.__cut.MouseDown += __cut_MouseDown;
        // 
        // __copy
        // 
        self.__copy.Image := (System.Drawing.Image(resources.GetObject('__copy.Image')));
        self.__copy.Name := '__copy';
        self.__copy.ShortcutKeys := (System.Windows.Forms.Keys((System.Windows.Forms.Keys.Control or System.Windows.Forms.Keys.C)));
        self.__copy.Size := new System.Drawing.Size(190, 22);
        self.__copy.Text := 'Копировать';
        self.__copy.MouseDown += __copy_MouseDown;
        // 
        // __rename
        // 
        self.__rename.Image := (System.Drawing.Image(resources.GetObject('__rename.Image')));
        self.__rename.Name := '__rename';
        self.__rename.ShortcutKeys := System.Windows.Forms.Keys.F2;
        self.__rename.Size := new System.Drawing.Size(190, 22);
        self.__rename.Text := 'Переименовать';
        self.__rename.MouseDown += __rename_MouseDown;
        // 
        // __receive_file
        // 
        self.__receive_file.Image := (System.Drawing.Image(resources.GetObject('__receive_file.Image')));
        self.__receive_file.MergeIndex := 0;
        self.__receive_file.Name := '__receive_file';
        self.__receive_file.ShortcutKeys := (System.Windows.Forms.Keys((System.Windows.Forms.Keys.Control or System.Windows.Forms.Keys.R)));
        self.__receive_file.Size := new System.Drawing.Size(190, 22);
        self.__receive_file.Text := 'Получить';
        self.__receive_file.Click += __receive_file_Click;
        // 
        // __delete
        // 
        self.__delete.Image := (System.Drawing.Image(resources.GetObject('__delete.Image')));
        self.__delete.Name := '__delete';
        self.__delete.ShortcutKeys := System.Windows.Forms.Keys.Delete;
        self.__delete.Size := new System.Drawing.Size(190, 22);
        self.__delete.Text := 'Удалить';
        self.__delete.MouseDown += __delete_MouseDown;
        // 
        // MainWindow
        // 
        self.ClientSize := new System.Drawing.Size(884, 561);
        self.Controls.Add(self.DefaultTab);
        self.Font := new System.Drawing.Font('Microsoft Sans Serif', 15.75, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, (System.Byte(204)));
        self.Icon := (System.Drawing.Icon(resources.GetObject('$this.Icon')));
        self.MinimumSize := new System.Drawing.Size(900, 600);
        self.Name := 'MainWindow';
        self.Text := 'Remote Control';
        self.FormClosing += MainWindow_FormClosing;
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
        self.ExplorerPanel.ResumeLayout(false);
        self.ExplorerPanel.PerformLayout();
        self.ExplorerToolBar.ResumeLayout(false);
        self.ExplorerToolBar.PerformLayout();
        self.SettingsTab.ResumeLayout(false);
        self.ExplorerItemContextMenu.ResumeLayout(false);
        self.ResumeLayout(false);
    end;
