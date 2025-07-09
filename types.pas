unit types;

const
  SLASH = System.IO.Path.DirectorySeparatorChar;
  MAX_RETRIES = 5;    // Количество попыток подключения к серверу
  RETRY_DELAY = 2000; // Задержка в мс
  GETPATH = 'GETPATH';
  E_GET_PATH = 'E@1';
  E_GET_DIRS = 'E@2';
  E_GET_FILES = 'E@3';
  E_ARROW_UP = 'E@4';
  E_ENTER_FOLDER = 'E@5';
  E_RECEIVE_FILE = 'E@6';
  E_RECEIVE_CONTINUE_C = 'E@6C';
  E_RECEIVE_CONTINUE_S = 'E@6S';
  E_FILE_SUCCESSFULLY_TRANSFERRED = 'E@8';


type
  ServiceState = (Run, Stop, Resume);



end.