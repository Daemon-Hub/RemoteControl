procedure InitializeComponent;
    begin
        var resources: System.ComponentModel.ComponentResourceManager := new System.ComponentModel.ComponentResourceManager(typeof(ListWindow));
        self.ConnectedDevice := new System.Windows.Forms.SplitContainer();
        self.StateButton := new System.Windows.Forms.RadioButton();
        self.DeviceIcon := new System.Windows.Forms.Label();
        self.Info := new System.Windows.Forms.Label();
        (System.ComponentModel.ISupportInitialize(self.ConnectedDevice)).BeginInit();
        self.ConnectedDevice.Panel1.SuspendLayout();
        self.ConnectedDevice.Panel2.SuspendLayout();
        self.ConnectedDevice.SuspendLayout();
        self.SuspendLayout();
        // 
        // ConnectedDevice
        // 
        self.ConnectedDevice.BackColor := System.Drawing.SystemColors.Control;
        self.ConnectedDevice.FixedPanel := System.Windows.Forms.FixedPanel.Panel1;
        self.ConnectedDevice.IsSplitterFixed := true;
        self.ConnectedDevice.Location := new System.Drawing.Point(12, 12);
        self.ConnectedDevice.MaximumSize := new System.Drawing.Size(110, 180);
        self.ConnectedDevice.Name := 'ConnectedDevice';
        self.ConnectedDevice.Orientation := System.Windows.Forms.Orientation.Horizontal;
        // 
        // ConnectedDevice.Panel1
        // 
        self.ConnectedDevice.Panel1.Controls.Add(self.StateButton);
        self.ConnectedDevice.Panel1.Controls.Add(self.DeviceIcon);
        // 
        // ConnectedDevice.Panel2
        // 
        self.ConnectedDevice.Panel2.Controls.Add(self.Info);
        self.ConnectedDevice.Panel2MinSize := 50;
        self.ConnectedDevice.Size := new System.Drawing.Size(107, 179);
        self.ConnectedDevice.SplitterDistance := 111;
        self.ConnectedDevice.TabIndex := 2;
        // 
        // StateButton
        // 
        self.StateButton.CheckAlign := System.Drawing.ContentAlignment.MiddleCenter;
        self.StateButton.Checked := true;
        self.StateButton.Cursor := System.Windows.Forms.Cursors.Hand;
        self.StateButton.Dock := System.Windows.Forms.DockStyle.Top;
        self.StateButton.Location := new System.Drawing.Point(0, 0);
        self.StateButton.MaximumSize := new System.Drawing.Size(14, 14);
        self.StateButton.MinimumSize := new System.Drawing.Size(14, 14);
        self.StateButton.Name := 'StateButton';
        self.StateButton.Size := new System.Drawing.Size(14, 14);
        self.StateButton.TabIndex := 4;
        self.StateButton.TabStop := true;
        self.StateButton.TextAlign := System.Drawing.ContentAlignment.TopCenter;
        self.StateButton.UseVisualStyleBackColor := true;
        // 
        // DeviceIcon
        // 
        self.DeviceIcon.BackColor := System.Drawing.SystemColors.Control;
        self.DeviceIcon.Dock := System.Windows.Forms.DockStyle.Fill;
        self.DeviceIcon.ImageKey := '10.png';
        self.DeviceIcon.Location := new System.Drawing.Point(0, 0);
        self.DeviceIcon.Name := 'DeviceIcon';
        self.DeviceIcon.Size := new System.Drawing.Size(107, 111);
        self.DeviceIcon.TabIndex := 1;
        self.DeviceIcon.Click += label2_Click;
        // 
        // Info
        // 
        self.Info.AutoEllipsis := true;
        self.Info.AutoSize := true;
        self.Info.BackColor := System.Drawing.SystemColors.Control;
        self.Info.Dock := System.Windows.Forms.DockStyle.Fill;
        self.Info.Font := new System.Drawing.Font('Times New Roman', 10, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, (System.Byte(204)));
        self.Info.Location := new System.Drawing.Point(0, 0);
        self.Info.MaximumSize := new System.Drawing.Size(100, 0);
        self.Info.Name := 'Info';
        self.Info.Size := new System.Drawing.Size(26, 20);
        self.Info.TabIndex := 0;
        self.Info.Text := '123';
        self.Info.TextAlign := System.Drawing.ContentAlignment.MiddleCenter;
        self.Info.UseCompatibleTextRendering := true;
        // 
        // ListWindow
        // 
        self.ClientSize := new System.Drawing.Size(654, 384);
        self.Controls.Add(self.ConnectedDevice);
        self.Icon := (System.Drawing.Icon(resources.GetObject('$this.Icon')));
        self.Name := 'ListWindow';
        self.Text := 'Подключёные устройства ';
        self.Load += ListWindow_Load;
        self.ConnectedDevice.Panel1.ResumeLayout(false);
        self.ConnectedDevice.Panel2.ResumeLayout(false);
        self.ConnectedDevice.Panel2.PerformLayout();
        (System.ComponentModel.ISupportInitialize(self.ConnectedDevice)).EndInit();
        self.ConnectedDevice.ResumeLayout(false);
        self.ResumeLayout(false);
    end;
