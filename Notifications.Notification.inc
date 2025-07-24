procedure InitializeComponent;
    begin
        self.components := new System.ComponentModel.Container();
        var resources: System.ComponentModel.ComponentResourceManager := new System.ComponentModel.ComponentResourceManager(typeof(Notification));
        self.MessageText := new System.Windows.Forms.Label();
        self.FormClosingAnimation := new System.Windows.Forms.Timer(self.components);
        self.FormShowAnimation := new System.Windows.Forms.Timer(self.components);
        self.NotificationLifeTimer := new System.Windows.Forms.Timer(self.components);
        self.SuspendLayout();
        // 
        // MessageText
        // 
        self.MessageText.BackColor := System.Drawing.Color.Transparent;
        self.MessageText.Dock := System.Windows.Forms.DockStyle.Fill;
        self.MessageText.Font := new System.Drawing.Font('Microsoft Sans Serif', 9.75, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, (System.Byte(204)));
        self.MessageText.Location := new System.Drawing.Point(0, 0);
        self.MessageText.MaximumSize := new System.Drawing.Size(300, 100);
        self.MessageText.MinimumSize := new System.Drawing.Size(300, 100);
        self.MessageText.Name := 'MessageText';
        self.MessageText.Size := new System.Drawing.Size(300, 100);
        self.MessageText.TabIndex := 0;
        self.MessageText.Text := #13#10;
        self.MessageText.TextAlign := System.Drawing.ContentAlignment.MiddleCenter;
        // 
        // FormClosingAnimation
        // 
        self.FormClosingAnimation.Interval := 50;
        self.FormClosingAnimation.Tick += Notification_ClosingAnimation_Tick;
        // 
        // FormShowAnimation
        // 
        self.FormShowAnimation.Interval := 50;
        self.FormShowAnimation.Tick += Notification_ShownAnimation_Tick;
        // 
        // NotificationLifeTimer
        // 
        self.NotificationLifeTimer.Interval := 3000;
        self.NotificationLifeTimer.Tick += NotificationLifeTimer_Tick;
        // 
        // Notification
        // 
        self.ClientSize := new System.Drawing.Size(300, 100);
        self.Controls.Add(self.MessageText);
        self.FormBorderStyle := System.Windows.Forms.FormBorderStyle.None;
        self.Icon := (System.Drawing.Icon(resources.GetObject('$this.Icon')));
        self.Name := 'Notification';
        self.Opacity := 0;
        self.StartPosition := System.Windows.Forms.FormStartPosition.Manual;
        self.TopMost := true;
        self.FormClosing += Notification_FormClosing;
        self.Paint += Notification_Paint;
        self.ResumeLayout(false);
    end;
