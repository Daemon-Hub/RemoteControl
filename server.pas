unit server;

uses 
  System.Threading.Tasks,
  System.Net.Sockets, 
  System.Threading,
  System.Text,
  System.Net, 
  Newtonsoft.Json,
  types, client,
  Notifications;


type
  TcpServer = class
    
    public AppIsRunning: boolean;
    public listener: TcpListener;
    public ipv4, ipv6: IPAddress;
    public stream: NetworkStream;
    public head, tail: TClient;
    public CountOfClients: integer;
    public path: string;
    public messageSending: boolean;
    public _accept_service, _pp_service: Thread;
    public port: integer;
    
    /// Представляет конструктор по умолчанию для объекта
    public constructor();
    begin
      self.AppIsRunning := true;
      self.ipv4 := Dns.GetHostByName(Dns.GetHostName()).AddressList.Last();
      self.ipv6 := Dns.GetHostAddresses(Dns.GetHostName())[0];
      self.port := 10000 + (DateTime.Now.DayOfYear mod 5000);
      self.listener := new TcpListener(self.ipv4, self.port);
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
        self.RemoveClient(fnd)
      else 
        Writeln($'Клиент {ip} не найден');
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
    private async procedure AcceptService();
    begin
      while self.AppIsRunning do
      begin
        if self.listener.Pending then begin
          var newClient: TcpClient = self.listener.AcceptTcpClient();
          if newClient <> nil then begin
            var ip := (newClient.Client.RemoteEndPoint as IPEndPoint).Address;
            AddClient(new TClient(ip.ToString(), self.port, newClient));
          end;
        end;
      end; // while
    end;
    
    /// Сервис: Следит за состоянием подключения клиентов, реализован на технологии PING-PONG
    private async procedure PPService();
    begin
      while self.AppIsRunning do
      begin
        
        if (CountOfClients = 0) or messageSending then continue;
        {$omp parallel for}
        foreach var obj in self.Walk() do
        begin
          var data: array of byte;
          try
            stream := obj.client.GetStream();
            
            data := Encoding.UTF8.GetBytes('PING');
            stream.Write(data, 0, 4);
            
            var responseStatus := stream.Read(data, 0, 4);
            if (messageSending = false) and (responseStatus = 0) then
              self.RemoveClient(obj);
          except
            self.RemoveClient(obj);
          end;
        end;
        Thread.Sleep(10000);
      end; // while
      
    end;
    
    /// Отправка сообщений
    public function MessageHandler(msg: string): string;
    begin
      self.messageSending := true;
      
      var stream := self.head.client.GetStream();
      
      var message: string = msg;
      var buffer: array of byte;
      
      SetLength(buffer, message.Length);
      buffer := Encoding.UTF8.GetBytes(message);
      
      stream.Write(buffer, 0, buffer.Length);
      
      
      SetLength(buffer, self.head.client.ReceiveBufferSize);
      var len := stream.Read(buffer, 0, buffer.Length); 
      
      message := Encoding.UTF8.GetString(buffer, 0, len);
      
      Result := message;
      self.messageSending := false;
    end;
    
    /// Принимает файл fileName и сохраняет его по пути savePath
    public function ReceiveFile(fileName, savePath: string): boolean;
    begin
      Result := false;
      self.messageSending := true;
    
      var stream := self.head.client.GetStream();
      
      // Отправка команды и имени файла
      var message := E_RECEIVE_FILE + fileName;
      var buffer := Encoding.UTF8.GetBytes(message);
      stream.Write(buffer, 0, buffer.Length);
      
      // Получение размера файла (8 байт)
      var sizeBuffer := new byte[8];
      stream.Read(sizeBuffer, 0, 8);
      var fileSize := System.BitConverter.ToInt64(sizeBuffer, 0);
      
      var receivedBytes := 0;
      var readBytes := 0;
      var chunk := new byte[4096];
      
      var FStream := System.IO.File.Create(savePath);
      while receivedBytes < fileSize do begin
        var toRead := Min(chunk.Length, fileSize - receivedBytes);
        readBytes := stream.Read(chunk, 0, toRead);
        
        if readBytes = 0 then break; // соединение прервано
        
        FStream.Write(chunk, 0, readBytes);
        receivedBytes += readBytes;
      end;
      FStream.Close();
      
      stream.Read(chunk, 0, 3);
      var ReceiveEndCode := Encoding.UTF8.GetString(chunk, 0, 3);
      
      // Можно ещё принять "успешно завершено" маркер (по желанию)
      if (receivedBytes = fileSize) and (ReceiveEndCode = E_FILE_SUCCESSFULLY_TRANSFERRED) then
        Result := true else 
        System.IO.File.Delete(savePath);
        
      self.messageSending := false;
    end;
  
  
  end;// class

end.