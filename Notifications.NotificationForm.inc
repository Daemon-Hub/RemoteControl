procedure InitializeComponent;
    begin
        self.components := new System.ComponentModel.Container();
        self.NotificationLifeTimer := new System.Windows.Forms.Timer(self.components);
        self.MessageText := new System.Windows.Forms.Label();
        self.SuspendLayout();
        // 
        // NotificationLifeTimer
        // 
        self.NotificationLifeTimer.Interval := 3000;
        self.NotificationLifeTimer.Tick += NotificationLifeTimer_Tick;
        // 
        // MessageText
        // 
        self.MessageText.AutoSize := true;
        self.MessageText.BackColor := System.Drawing.Color.Transparent;
        self.MessageText.Dock := System.Windows.Forms.DockStyle.Fill;
        self.MessageText.Location := new System.Drawing.Point(0, 0);
        self.MessageText.MaximumSize := new System.Drawing.Size(250, 60);
        self.MessageText.Name := 'MessageText';
        self.MessageText.Size := new System.Drawing.Size(0, 13);
        self.MessageText.TabIndex := 0;
        self.MessageText.TextAlign := System.Drawing.ContentAlignment.MiddleCenter;
        // 
        // NotificationForm
        // 
        self.BackColor := System.Drawing.Color.FromArgb((System.Int32((System.Byte(192)))), (System.Int32((System.Byte(255)))), (System.Int32((System.Byte(192)))));
        self.ClientSize := new System.Drawing.Size(250, 60);
        self.Controls.Add(self.MessageText);
        self.FormBorderStyle := System.Windows.Forms.FormBorderStyle.None;
        self.Name := 'NotificationForm';
        self.StartPosition := System.Windows.Forms.FormStartPosition.Manual;
        self.Text := 'Уведомление';
        self.TopMost := true;
        self.Load += NotificationForm_Load;
        self.ResumeLayout(false);
        self.PerformLayout();
    end;
