unit Notifications;

interface

uses System, System.Drawing, System.Windows.Forms, types;

type
  Notification = class(Form)
    procedure Notification_FormClosing(sender: Object; e: FormClosingEventArgs);
    procedure Notification_ShownAnimation_Tick(sender: Object; e: EventArgs);
    procedure Notification_ClosingAnimation_Tick(sender: Object; e: EventArgs);
    procedure Notification_Paint(sender: Object; args: PaintEventArgs);
    procedure NotificationLifeTimer_Tick(sender: Object; e: EventArgs);
  {$region FormDesigner}
  internal
    {$resource Notifications.Notification.resources}
    components: System.ComponentModel.IContainer;
    FormClosingAnimation: Timer;
    FormShowAnimation: Timer;
    NotificationLifeTimer: Timer;
    MessageText: &Label;
    {$include Notifications.Notification.inc}
  {$endregion FormDesigner}
  public
    constructor(msg: string);
    begin
      InitializeComponent;
      
      var screenBounds := Screen.PrimaryScreen.WorkingArea;
      self.Location := new Point(screenBounds.Width - self.Width - 10, screenBounds.Height - self.Height - 10);
      
      self.MessageText.Text := msg;
      
      // Закруглённые углы
      var rectangle := new Rectangle(0, 0, Self.Width, Self.Height);
      var radius := 10;
      var graphicsPath := new System.Drawing.Drawing2D.GraphicsPath();
          graphicsPath.AddArc(rectangle.X, rectangle.Y, radius * 2, radius * 2, 180, 90);
          graphicsPath.AddArc(rectangle.Width - radius * 2, rectangle.Y, radius * 2, radius * 2, 270, 90);
          graphicsPath.AddArc(rectangle.Width - radius * 2, rectangle.Height - radius * 2, radius * 2, radius * 2, 0, 90);
          graphicsPath.AddArc(rectangle.X, rectangle.Height - radius * 2, radius * 2, radius * 2, 90, 90);
          graphicsPath.CloseFigure();
      Self.Region := new System.Drawing.Region(graphicsPath);
      
      self.FormShowAnimation.Start();
      self.Show();
    end;
  end;

/// Показывает уведомление с известной ошибкой
procedure ErrorHundler(error: string);

implementation


procedure Notification.Notification_Paint(sender: System.Object; args: PaintEventArgs);
begin
  var g := Args.Graphics;
  var rect := Self.ClientRectangle;
  var gradientBrush := new System.Drawing.Drawing2D.LinearGradientBrush(
  rect,
  Color.FromArgb(171, 171, 171),
  Color.FromArgb(153, 180, 209),
  System.Drawing.Drawing2D.LinearGradientMode.BackwardDiagonal);
  g.FillRectangle(gradientBrush, rect);
end;


procedure Notification.Notification_FormClosing(sender: System.Object; e: FormClosingEventArgs);
begin
  if self.Opacity > 0 then
  begin
    e.Cancel := True;
    NotificationLifeTimer.Stop(); 
    self.FormClosingAnimation.Start();
  end;
end;


procedure Notification.NotificationLifeTimer_Tick(sender: System.Object; e: System.EventArgs);
begin
  self.NotificationLifeTimer.Stop(); 
  self.FormClosingAnimation.Start();
end;

procedure Notification.Notification_ShownAnimation_Tick(sender: Object; e: EventArgs);
begin
  if self.Opacity < 0.95 then
    self.Opacity += 0.05 
  else begin
    self.FormShowAnimation.Stop();
    self.NotificationLifeTimer.Start();
  end;
end;


procedure Notification.Notification_ClosingAnimation_Tick(sender: Object; e: EventArgs);
begin
  if self.Opacity > 0 then
    self.Opacity -= 0.05 
  else begin
    self.FormClosingAnimation.Stop();
    self.Close();
  end;
end;

// ---------------------------------------------------------------------------- //
procedure ErrorHundler(error: string);
begin
  new Notification(error);
end;


end.
