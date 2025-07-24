procedure InitializeComponent;
    begin
        var resources: System.ComponentModel.ComponentResourceManager := new System.ComponentModel.ComponentResourceManager(typeof(ProgressOverlay));
        self.progress := new System.Windows.Forms.ProgressBar();
        self.label1 := new System.Windows.Forms.Label();
        self.SuspendLayout();
        // 
        // progress
        // 
        self.progress.Cursor := System.Windows.Forms.Cursors.WaitCursor;
        self.progress.Dock := System.Windows.Forms.DockStyle.Bottom;
        self.progress.Location := new System.Drawing.Point(0, 55);
        self.progress.Name := 'progress';
        self.progress.Size := new System.Drawing.Size(200, 25);
        self.progress.Style := System.Windows.Forms.ProgressBarStyle.Continuous;
        self.progress.TabIndex := 0;
        self.progress.UseWaitCursor := true;
        // 
        // label1
        // 
        self.label1.BackColor := System.Drawing.Color.Transparent;
        self.label1.Dock := System.Windows.Forms.DockStyle.Fill;
        self.label1.Font := new System.Drawing.Font('Segoe UI', 12, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, (System.Byte(204)));
        self.label1.Location := new System.Drawing.Point(0, 0);
        self.label1.Name := 'label1';
        self.label1.Size := new System.Drawing.Size(200, 55);
        self.label1.TabIndex := 1;
        self.label1.Text := 'Подождите... Идет загрузка.';
        self.label1.TextAlign := System.Drawing.ContentAlignment.MiddleCenter;
        self.label1.UseWaitCursor := true;
        // 
        // ProgressOverlay
        // 
        self.ClientSize := new System.Drawing.Size(200, 80);
        self.Controls.Add(self.label1);
        self.Controls.Add(self.progress);
        self.FormBorderStyle := System.Windows.Forms.FormBorderStyle.None;
        self.Icon := (System.Drawing.Icon(resources.GetObject('$this.Icon')));
        self.MaximumSize := new System.Drawing.Size(200, 100);
        self.Name := 'ProgressOverlay';
        self.StartPosition := System.Windows.Forms.FormStartPosition.Manual;
        self.Text := 'Загрузка';
        self.TopMost := true;
        self.UseWaitCursor := true;
        self.Paint += ProgressOverlay_Paint;
        self.ResumeLayout(false);
    end;
