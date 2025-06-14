unit types;

const
  MAX_RETRIES = 5;    // Количество попыток подключения к серверу
  RETRY_DELAY = 2000; // Задержка в мс
  GETPATH = 'GETPATH';

type 
  ServiceState = (Run, Stop, Resume);


end.