unit types;

const
  MAX_RETRIES = 5;    // Количество попыток подключения к серверу
  RETRY_DELAY = 2000; // Задержка в мс
  GETPATH = 'GETPATH';
  E_GET_PATH = 'E@1';
  E_GET_DIRS = 'E@2';
  E_GET_FILES = 'E@3';
  E_ARROW_UP = 'E@4';
  E_ENTER_FOLDER = 'E@5';
  

type 
  ServiceState = (Run, Stop, Resume);
  


end.