Unit ProgressOverlayWindow;

interface

uses System, System.Drawing, System.Windows.Forms;

type
  ProgressOverlay = class(Form)
    procedure SetProgress(p: integer);
    procedure SetProgress(current, total: integer);
    procedure ProgressOverlay_Paint(sender: Object; e: PaintEventArgs);
  {$region FormDesigner}
  internal
    {$resource ProgressOverlayWindow.ProgressOverlay.resources}
    label1: &Label;
    progress: ProgressBar;
    {$include ProgressOverlayWindow.ProgressOverlay.inc}
  {$endregion FormDesigner}
  public
    constructor;
    begin
      InitializeComponent;
      
      // Закруглённые углы
      var rectangle := new Rectangle(0, 0, Self.Width, Self.Height);
      var radius := 6;
      var graphicsPath := new System.Drawing.Drawing2D.GraphicsPath();
          graphicsPath.AddArc(rectangle.X, rectangle.Y, radius * 2, radius * 2, 180, 90);
          graphicsPath.AddArc(rectangle.Width - radius * 2, rectangle.Y, radius * 2, radius * 2, 270, 90);
          graphicsPath.AddArc(rectangle.Width - radius * 2, rectangle.Height - radius * 2, radius * 2, radius * 2, 0, 90);
          graphicsPath.AddArc(rectangle.X, rectangle.Height - radius * 2, radius * 2, radius * 2, 90, 90);
          graphicsPath.CloseFigure();
          
      self.Region := new System.Drawing.Region(graphicsPath);
    end;
  end;

implementation

procedure ProgressOverlay.SetProgress(p: integer);
begin
  self.progress.Value := p;
  self.label1.Text := $'Получено: {p}%';
  self.Update();
end;

procedure ProgressOverlay.SetProgress(current, total: integer);
begin
  self.progress.Maximum := total;
  self.progress.Value := current;
  self.label1.Text := $'Получено: {current}/{total} файлов';
  self.Update();
end;


procedure ProgressOverlay.ProgressOverlay_Paint(sender: Object; e: PaintEventArgs);
begin
  var rect := Self.ClientRectangle;
  var gradientBrush := new System.Drawing.Drawing2D.LinearGradientBrush(
    rect,
    Color.FromArgb(171, 171, 171),
    Color.FromArgb(153, 180, 209),
    System.Drawing.Drawing2D.LinearGradientMode.Vertical
  );
  e.Graphics.FillRectangle(gradientBrush, rect);
end;

end.
