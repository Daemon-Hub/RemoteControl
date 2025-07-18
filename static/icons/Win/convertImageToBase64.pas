uses System, System.IO, System.Drawing;

begin
  var img := Image.FromFile('7.png');
  var ms := new MemoryStream;
  img.Save(ms, System.Drawing.Imaging.ImageFormat.Png);
  var bytes := ms.ToArray;
  var base64 := Convert.ToBase64String(bytes);
  Println(base64);
end.