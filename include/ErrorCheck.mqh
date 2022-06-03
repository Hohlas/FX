bool ErrorCheck(){ // Проверка проведения операций с ордерами:
   bool repeat=true;
   int err=GetLastError(); //err=141;
   string ErrOrder;
   if (err>0){ 
      ErrOrder=str; // сохраняем инфу об ордере, чтобы потом вставить в файл Error...
      str="!Error-"+DoubleToStr(err,0)+": "; // формируем диагностику
      }
   switch (err){   
      case 0:    return(false);    // Торговая операция прошла успешно
      case 1:    repeat=false;   str=str+"OrderModify try to change value by same value"; break; // OrderModify пытается изменить уже установленные значения такими же значениями. Необходимо изменить одно или несколько значений и повторить попытку.
      case 2:    repeat=false;   str=str+"Common error"; break; // Общая ошибка. Прекратить все попытки торговых операций до выяснения обстоятельств. Возможно перезагрузить операционную систему и клиентский терминал.
      case 3:    repeat=false;   str=str+"Invalid trade parameters"; break; // В торговую функцию переданы неправильные параметры, например, неправильный символ, неопознанная торговая операция, отрицательное допустимое отклонение цены, несуществующий номер тикета и т.п. Необходимо изменить логику программы.
      case 4:    Sleep(60000);   str=str+"Trade server is busy, wait 1 min";  break; // Торговый сервер занят. Можно повторить попытку через достаточно большой промежуток времени (от нескольких минут).
      case 5:    repeat=false;   str=str+"Old version of the client terminal"; break; // Старая версия клиентского терминала. Необходимо установить последнюю версию клиентского терминала.
      case 6:    Connect();      str=str+"No connection with trade server, wait 2 min while Connect";  break; // Нет связи с торговым сервером. Необходимо убедиться, что связь не нарушена (например, при помощи функции IsConnected) и через небольшой промежуток времени (от 5 секунд) повторить попытку.
      case 7:    repeat=false;   str=str+"Not enough rights"; break; // Недостаточно прав
      case 8:    Sleep(5000);    str=str+"Too frequent requests, wait 5 sec"; break; // Слишком частые запросы. Необходимо уменьшить частоту запросов, изменить логику программы.
      case 9:    repeat=false;   str=str+"Malfunctional trade operation"; break; // Недопустимая операция нарушающая функционирование сервера
      case 64:   repeat=false;   str=str+"Account disabled"; break; //Счет заблокирован/ Необходимо прекратить все попытки торговых операций.
      case 65:   repeat=false;   str=str+"Invalid account"; break;  //Неправильный номер счета. Необходимо прекратить все попытки торговых операций
      case 128:  Sleep(30000);   str=str+"Not Error: Trade timeout, wait 30s"; break; // Истек срок ожидания совершения сделки. Прежде, чем производить повторную попытку (не менее, чем через 1 минуту), необходимо убедиться, что торговая операция действительно не прошла (новая позиция не была открыта, либо существующий ордер не был изменён или удалён, либо существующая позиция не была закрыта)
      case 129:  Sleep(5000);    str=str+"Invalid price"; break;  // Неправильная цена bid или ask, возможно, ненормализованная цена. Необходимо после задержки от 5 секунд обновить данные при помощи функции RefreshRates и повторить попытку. Если ошибка не исчезает, необходимо прекратить все попытки торговых операций и изменить логику программы. 
      case 130:  repeat=false;   str=str+"Invalid stops"; break; // Слишком близкие стопы или неправильно рассчитанные или ненормализованные цены в стопах (или в цене открытия отложенного ордера). Попытку можно повторять только в том случае, если ошибка произошла из-за устаревания цены. Необходимо после задержки от 5 секунд обновить данные при помощи функции RefreshRates и повторить попытку. Если ошибка не исчезает, необходимо прекратить все попытки торговых операций и изменить логику программы.   
      case 131:  repeat=false;   str=str+"Invalid trade volume"; break; // Неправильный объем, ошибка в грануляции объема. Необходимо прекратить все попытки торговых операций и изменить логику программы.
      case 132:  repeat=false;   str=str+"Market is closed"; Report(str); return(false); // Рынок закрыт. Можно повторить попытку через достаточно большой промежуток времени (от нескольких минут).
      case 133:  repeat=false;   str=str+"Trade is disabled"; break; // Торговля запрещена. Необходимо прекратить все попытки торговых операций.
      case 134:  repeat=false;   str=str+"Not enough money";  return(false); // Недостаточно денег для совершения операции. Повторять сделку с теми же параметрами нельзя. Попытку можно повторить после задержки от 5 секунд, уменьшив объем, но надо быть уверенным в достаточности средств для совершения операции.
      case 135:                  str=str+"Price changed"; break; // Цена изменилась. Можно без задержки обновить данные при помощи функции RefreshRates и повторить попытку.
      case 136:  Sleep(5000);    str=str+"Off quotes, wait 5 sec"; break; // Нет цен. Брокер по какой-то причине (например, в начале сессии цен нет, неподтвержденные цены, быстрый рынок) не дал цен или отказал. Необходимо после задержки от 5 секунд обновить данные при помощи функции RefreshRates и повторить попытку.
      case 137:  Sleep(5000);    str=str+"Broker is busy, wait 5 sec"; break; // Брокер занят
      case 138:                  str=str+"Requote"; break; // Запрошенная цена устарела, либо перепутаны bid и ask. Можно без задержки обновить данные при помощи функции RefreshRates и повторить попытку. Если ошибка не исчезает, необходимо прекратить все попытки торговых операций и изменить логику программы.   
      case 139:  repeat=false;   str=str+"Order is locked"; break; // Ордер заблокирован и уже обрабатывается. Необходимо прекратить все попытки торговых операций и изменить логику программы.
      case 140:  repeat=false;   str=str+"Long positions only allowed"; break; // Разрешена только покупка. Повторять операцию SELL нельзя.
      case 141:  Sleep(5000);    str=str+"Too many requests, wait 5 sec";  break; // Слишком много запросов. Необходимо уменьшить частоту запросов, изменить логику программы.
      case 142:  repeat=false;   str=str+"Not Error: Check operation result, wait 1 min"; break; // Ордер поставлен в очередь. Это не ошибка, а один из кодов взаимодействия между клиентским терминалом и торговым сервером. Этот код может быть получен в редком случае, когда во время выполнения торговой операции произошёл обрыв и последующее восстановление связи. Необходимо обрабатывать так же как и ошибку 128.
      case 143:  repeat=false;   str=str+"Not Error: Check operation result, wait 1 min"; break; // Ордер принят дилером к исполнению. Один из кодов взаимодействия между клиентским терминалом и торговым сервером. Может возникнуть по той же причине, что и код 142. Необходимо обрабатывать так же как и ошибку 128.
      case 144:  repeat=false;   str=str+"Not Error: Order disabled by client"; break; // Ордер аннулирован самим клиентом при ручном подтверждении сделки. Один из кодов взаимодействия между клиентским терминалом и торговым сервером.
      case 145:  Sleep(15000);   str=str+"Modification denied because order too near to market, wait 15 sec";  break; // Модификация запрещена, так как ордер слишком близок к рынку и заблокирован из-за возможного скорого исполнения. Можно не ранее, чем через 15 секунд, обновить данные при помощи функции RefreshRates и повторить попытку.
      case 146:  ContextBusy();  str=str+"Trade context is busy, wait 10 min while ContextBusy";  break; // Подсистема торговли занята. Повторить попытку только после того, как функция IsTradeContextBusy вернет FALSE.
      case 147:  repeat=false;   str=str+"Expirations are denied by broker"; break; // Использование даты истечения ордера запрещено брокером. Операцию можно повторить только в том случае, если обнулить параметр expiration.
      case 148:  repeat=false;   str=str+"The amount of open and pending orders has reached the limit set by the broker"; break; // Количество открытых и отложенных ордеров достигло предела, установленного брокером. Новые открытые позиции и отложенные ордера возможны только после закрытия или удаления существующих позиций или ордеров.
      case 4000: repeat=false;   str=str+"NO MQL ERROR"; break;
      case 4051: repeat=false;   str=str+"Недопустимое значение параметра функции"; break;
      case 4059: repeat=false;   str=str+"Функция не разрешена в тестовом режиме"; break;
      case 4105: repeat=false;   str=str+"Program bug: No order selected"; break;
      case 4106: repeat=false;   str=str+"Program bug: Unknown symbol"; break;
      case 4107: repeat=false;   str=str+"Program bug: Invalid price"; break;
      case 4108: repeat=false;   str=str+"Program bug: Invalid ticket"; break;
      case 4109: repeat=false;   str=str+"Program bug: Trade is not allowed"; break;
      case 4110: repeat=false;   str=str+"Program bug: Longs are not allowed"; break;
      case 4111: repeat=false;   str=str+"Program bug: Shorts are not allowed"; break;
      case 5020: repeat=false;   str=str+"FILE_NOT_EXIST"; break;
      default:   repeat=false;   str=str+"Unknown Error"; break;
      }
   Report(str); // 
   ErrorLog(ErrOrder); // фиксируем ошибки в файл с указанием типа ордера, при котором она возникла
   RefreshRates(); // в функции GlobalOrdersSet() ордера ставятся с одного графика на разные пары, поэтому надо знать данные пары выставляемого ордера     
   ASK      =MarketInfo(SYMBOL,MODE_ASK); 
   BID      =MarketInfo(SYMBOL,MODE_BID);   
   StopLevel=MarketInfo(SYMBOL,MODE_STOPLEVEL)*MarketInfo(SYMBOL,MODE_POINT);  
   Spred    =MarketInfo(SYMBOL,MODE_SPREAD)   *MarketInfo(SYMBOL,MODE_POINT);
   return(repeat);
   }  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////   

void Connect(){ // Проверка связи длится 5 минут, потом решаем что ее нет////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   int WaitingStart=TimeLocal(); 
   while (!IsConnected()){
      Sleep(1000); 
      TerminalHold(60); // удерживаем терминал, чтобы эксперты не перехватывали его бесцельно друг у друга. Связи все равно нет.
      if (TimeLocal()-WaitingStart>120) {Report("Connect Waiting time > 2 minute!");  return;} // ждали 2 мин, не дождались
   }  }////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   
void ContextBusy(){ // проверяет поток для выполнения торговых операций
   int time=TimeLocal();   
   while (IsTradeContextBusy()){ // Повторить попытку только после того, как функция IsTradeContextBusy вернет FALSE.
      Sleep(5000);                              
      if (TimeLocal()-time>300) {Report("ContextBusy Waiting time > 5 Minute!");  return;} // ждали 5 минут, не дождались
   }  }////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  
   
void ErrorLog(string ErrOrder){
   string sB, sBS, sBP, sS, sSS, sSP, ServerTime, ErrorFileName;
   int ErrorFile, Expir, ChkRsk, Ticket;
   double Stop;
   ErrorFileName="ERROR_"+DoubleToStr(Magic,0)+"_"+ExpertName+".csv"; 
   ErrorFile=FileOpen(ErrorFileName, FILE_READ|FILE_WRITE, ';');  if(ErrorFile<0) {Report("ERROR! ErrorCheck(): Не могу открыть файл "+ErrorFileName); return;}
   Ticket=DoubleToStr(OrderTicket(),0); // в ф.TesterFileCreate() переменная Magic пересчитывается, поэтому ее надо запомнить 
   Expir =DoubleToStr(ExpirHours,0)+" ("+TimeToStr(ExpirHours,TIME_DATE|TIME_MINUTES)+")";
   if (SetBUY>0){ // момент открытия позы в лонг
      Stop=SetBUY-SetSTOP_BUY;
      sB ="set"+DoubleToStr(SetBUY,DIGITS); 
      sBS="set"+DoubleToStr(SetSTOP_BUY,DIGITS); 
      sBP="set"+DoubleToStr(SetPROFIT_BUY,DIGITS);} 
   else { // поза в лонг уже открыта
      sB =DoubleToStr(BUY+BUYSTOP+BUYLIMIT,DIGITS); 
      sBS=DoubleToStr(STOP_BUY,DIGITS); 
      sBP=DoubleToStr(PROFIT_BUY,DIGITS);}
   if (SetSELL>0){// момент открытия позы в шорт
      Stop=SetSTOP_SELL-SetSELL;
      sS ="set"+DoubleToStr(SetSELL,DIGITS); 
      sSS="set"+DoubleToStr(SetSTOP_SELL,DIGITS); 
      sSP="set"+DoubleToStr(SetPROFIT_SELL,DIGITS);} 
   else { // поза в шорт уже открыта
      sS =DoubleToStr(SELL+SELLSTOP+SELLLIMIT,DIGITS); 
      sSS=DoubleToStr(STOP_SELL,DIGITS); 
      sSP=DoubleToStr(PROFIT_SELL,DIGITS);}
   ChkRsk=DoubleToStr(RiskChecker(Lot,Stop,SYMBOL),2);
   ServerTime="-"+TimeToStr(AlpariTime(0),TIME_DATE|TIME_MINUTES);
   if (FileReadString(ErrorFile)=="")// прописываем заголовки столбцов 
      FileWrite (ErrorFile,"ServerTime", "Ask/Bid" ,"StpLev" ,"Spred","Ticket","BUY","StpBUY","PrfBUY","SELL","StpSELL","PrfSELL","Expir","Lot",     "Sym/SYM"     ,"CheckRisk","Err");
   FileSeek(ErrorFile,0,SEEK_END);     // перемещаемся в конец
   FileWrite    (ErrorFile, ServerTime ,ASK+"/"+BID,StopLevel, Spred , Ticket , sB  ,  sBS   ,  sBP   ,  sS  ,   sSS   ,  sSP    , Expir , Lot ,Symbol()+"/"+SYMBOL,  ChkRsk   , str+". Order: "+ErrOrder);
   FileClose(ErrorFile);
   }////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////   
   
   // if (err==134) return; // 134-самая распространенная ошибка при оптимизации, 130-на NDD счетах, где стопы=0
   /*if (err==3){// Исключение ошибки тестера, когда сделки совершаются (в 14:28 на М30) или (в 13:59 на Н1).   
      temp=1.0/Period()*Minute(); // Для этого выделяем разницу между временем сделки и временем ТФ 
      temp-=MathRound(temp);      // (должна равняться 0), 
      if (temp!=0) return; // и игнорируем ошибку, если есть эта разница
      }*/