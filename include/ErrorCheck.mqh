bool ErrorCheck(){ // �������� ���������� �������� � ��������:
   bool repeat=true;
   int err=GetLastError(); //err=141;
   string ErrOrder;
   if (err>0){ 
      ErrOrder=str; // ��������� ���� �� ������, ����� ����� �������� � ���� Error...
      str="!Error-"+DoubleToStr(err,0)+": "; // ��������� �����������
      }
   switch (err){   
      case 0:    return(false);    // �������� �������� ������ �������
      case 1:    repeat=false;   str=str+"OrderModify try to change value by same value"; break; // OrderModify �������� �������� ��� ������������� �������� ������ �� ����������. ���������� �������� ���� ��� ��������� �������� � ��������� �������.
      case 2:    repeat=false;   str=str+"Common error"; break; // ����� ������. ���������� ��� ������� �������� �������� �� ��������� �������������. �������� ������������� ������������ ������� � ���������� ��������.
      case 3:    repeat=false;   str=str+"Invalid trade parameters"; break; // � �������� ������� �������� ������������ ���������, ��������, ������������ ������, ������������ �������� ��������, ������������� ���������� ���������� ����, �������������� ����� ������ � �.�. ���������� �������� ������ ���������.
      case 4:    Sleep(60000);   str=str+"Trade server is busy, wait 1 min";  break; // �������� ������ �����. ����� ��������� ������� ����� ���������� ������� ���������� ������� (�� ���������� �����).
      case 5:    repeat=false;   str=str+"Old version of the client terminal"; break; // ������ ������ ����������� ���������. ���������� ���������� ��������� ������ ����������� ���������.
      case 6:    Connect();      str=str+"No connection with trade server, wait 2 min while Connect";  break; // ��� ����� � �������� ��������. ���������� ���������, ��� ����� �� �������� (��������, ��� ������ ������� IsConnected) � ����� ��������� ���������� ������� (�� 5 ������) ��������� �������.
      case 7:    repeat=false;   str=str+"Not enough rights"; break; // ������������ ����
      case 8:    Sleep(5000);    str=str+"Too frequent requests, wait 5 sec"; break; // ������� ������ �������. ���������� ��������� ������� ��������, �������� ������ ���������.
      case 9:    repeat=false;   str=str+"Malfunctional trade operation"; break; // ������������ �������� ���������� ���������������� �������
      case 64:   repeat=false;   str=str+"Account disabled"; break; //���� ������������/ ���������� ���������� ��� ������� �������� ��������.
      case 65:   repeat=false;   str=str+"Invalid account"; break;  //������������ ����� �����. ���������� ���������� ��� ������� �������� ��������
      case 128:  Sleep(30000);   str=str+"Not Error: Trade timeout, wait 30s"; break; // ����� ���� �������� ���������� ������. ������, ��� ����������� ��������� ������� (�� �����, ��� ����� 1 ������), ���������� ���������, ��� �������� �������� ������������� �� ������ (����� ������� �� ���� �������, ���� ������������ ����� �� ��� ������ ��� �����, ���� ������������ ������� �� ���� �������)
      case 129:  Sleep(5000);    str=str+"Invalid price"; break;  // ������������ ���� bid ��� ask, ��������, ����������������� ����. ���������� ����� �������� �� 5 ������ �������� ������ ��� ������ ������� RefreshRates � ��������� �������. ���� ������ �� ��������, ���������� ���������� ��� ������� �������� �������� � �������� ������ ���������. 
      case 130:  repeat=false;   str=str+"Invalid stops"; break; // ������� ������� ����� ��� ����������� ������������ ��� ����������������� ���� � ������ (��� � ���� �������� ����������� ������). ������� ����� ��������� ������ � ��� ������, ���� ������ ��������� ��-�� ����������� ����. ���������� ����� �������� �� 5 ������ �������� ������ ��� ������ ������� RefreshRates � ��������� �������. ���� ������ �� ��������, ���������� ���������� ��� ������� �������� �������� � �������� ������ ���������.   
      case 131:  repeat=false;   str=str+"Invalid trade volume"; break; // ������������ �����, ������ � ���������� ������. ���������� ���������� ��� ������� �������� �������� � �������� ������ ���������.
      case 132:  repeat=false;   str=str+"Market is closed"; Report(str); return(false); // ����� ������. ����� ��������� ������� ����� ���������� ������� ���������� ������� (�� ���������� �����).
      case 133:  repeat=false;   str=str+"Trade is disabled"; break; // �������� ���������. ���������� ���������� ��� ������� �������� ��������.
      case 134:  repeat=false;   str=str+"Not enough money";  return(false); // ������������ ����� ��� ���������� ��������. ��������� ������ � ���� �� ����������� ������. ������� ����� ��������� ����� �������� �� 5 ������, �������� �����, �� ���� ���� ��������� � ������������� ������� ��� ���������� ��������.
      case 135:                  str=str+"Price changed"; break; // ���� ����������. ����� ��� �������� �������� ������ ��� ������ ������� RefreshRates � ��������� �������.
      case 136:  Sleep(5000);    str=str+"Off quotes, wait 5 sec"; break; // ��� ���. ������ �� �����-�� ������� (��������, � ������ ������ ��� ���, ���������������� ����, ������� �����) �� ��� ��� ��� �������. ���������� ����� �������� �� 5 ������ �������� ������ ��� ������ ������� RefreshRates � ��������� �������.
      case 137:  Sleep(5000);    str=str+"Broker is busy, wait 5 sec"; break; // ������ �����
      case 138:                  str=str+"Requote"; break; // ����������� ���� ��������, ���� ���������� bid � ask. ����� ��� �������� �������� ������ ��� ������ ������� RefreshRates � ��������� �������. ���� ������ �� ��������, ���������� ���������� ��� ������� �������� �������� � �������� ������ ���������.   
      case 139:  repeat=false;   str=str+"Order is locked"; break; // ����� ������������ � ��� ��������������. ���������� ���������� ��� ������� �������� �������� � �������� ������ ���������.
      case 140:  repeat=false;   str=str+"Long positions only allowed"; break; // ��������� ������ �������. ��������� �������� SELL ������.
      case 141:  Sleep(5000);    str=str+"Too many requests, wait 5 sec";  break; // ������� ����� ��������. ���������� ��������� ������� ��������, �������� ������ ���������.
      case 142:  repeat=false;   str=str+"Not Error: Check operation result, wait 1 min"; break; // ����� ��������� � �������. ��� �� ������, � ���� �� ����� �������������� ����� ���������� ���������� � �������� ��������. ���� ��� ����� ���� ������� � ������ ������, ����� �� ����� ���������� �������� �������� ��������� ����� � ����������� �������������� �����. ���������� ������������ ��� �� ��� � ������ 128.
      case 143:  repeat=false;   str=str+"Not Error: Check operation result, wait 1 min"; break; // ����� ������ ������� � ����������. ���� �� ����� �������������� ����� ���������� ���������� � �������� ��������. ����� ���������� �� ��� �� �������, ��� � ��� 142. ���������� ������������ ��� �� ��� � ������ 128.
      case 144:  repeat=false;   str=str+"Not Error: Order disabled by client"; break; // ����� ����������� ����� �������� ��� ������ ������������� ������. ���� �� ����� �������������� ����� ���������� ���������� � �������� ��������.
      case 145:  Sleep(15000);   str=str+"Modification denied because order too near to market, wait 15 sec";  break; // ����������� ���������, ��� ��� ����� ������� ������ � ����� � ������������ ��-�� ���������� ������� ����������. ����� �� �����, ��� ����� 15 ������, �������� ������ ��� ������ ������� RefreshRates � ��������� �������.
      case 146:  ContextBusy();  str=str+"Trade context is busy, wait 10 min while ContextBusy";  break; // ���������� �������� ������. ��������� ������� ������ ����� ����, ��� ������� IsTradeContextBusy ������ FALSE.
      case 147:  repeat=false;   str=str+"Expirations are denied by broker"; break; // ������������� ���� ��������� ������ ��������� ��������. �������� ����� ��������� ������ � ��� ������, ���� �������� �������� expiration.
      case 148:  repeat=false;   str=str+"The amount of open and pending orders has reached the limit set by the broker"; break; // ���������� �������� � ���������� ������� �������� �������, �������������� ��������. ����� �������� ������� � ���������� ������ �������� ������ ����� �������� ��� �������� ������������ ������� ��� �������.
      case 4000: repeat=false;   str=str+"NO MQL ERROR"; break;
      case 4051: repeat=false;   str=str+"������������ �������� ��������� �������"; break;
      case 4059: repeat=false;   str=str+"������� �� ��������� � �������� ������"; break;
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
   ErrorLog(ErrOrder); // ��������� ������ � ���� � ��������� ���� ������, ��� ������� ��� ��������
   RefreshRates(); // � ������� GlobalOrdersSet() ������ �������� � ������ ������� �� ������ ����, ������� ���� ����� ������ ���� ������������� ������     
   ASK      =MarketInfo(SYMBOL,MODE_ASK); 
   BID      =MarketInfo(SYMBOL,MODE_BID);   
   StopLevel=MarketInfo(SYMBOL,MODE_STOPLEVEL)*MarketInfo(SYMBOL,MODE_POINT);  
   Spred    =MarketInfo(SYMBOL,MODE_SPREAD)   *MarketInfo(SYMBOL,MODE_POINT);
   return(repeat);
   }  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////   

void Connect(){ // �������� ����� ������ 5 �����, ����� ������ ��� �� ���////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   int WaitingStart=TimeLocal(); 
   while (!IsConnected()){
      Sleep(1000); 
      TerminalHold(60); // ���������� ��������, ����� �������� �� ������������� ��� ��������� ���� � �����. ����� ��� ����� ���.
      if (TimeLocal()-WaitingStart>120) {Report("Connect Waiting time > 2 minute!");  return;} // ����� 2 ���, �� ���������
   }  }////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   
void ContextBusy(){ // ��������� ����� ��� ���������� �������� ��������
   int time=TimeLocal();   
   while (IsTradeContextBusy()){ // ��������� ������� ������ ����� ����, ��� ������� IsTradeContextBusy ������ FALSE.
      Sleep(5000);                              
      if (TimeLocal()-time>300) {Report("ContextBusy Waiting time > 5 Minute!");  return;} // ����� 5 �����, �� ���������
   }  }////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  
   
void ErrorLog(string ErrOrder){
   string sB, sBS, sBP, sS, sSS, sSP, ServerTime, ErrorFileName;
   int ErrorFile, Expir, ChkRsk, Ticket;
   double Stop;
   ErrorFileName="ERROR_"+DoubleToStr(Magic,0)+"_"+ExpertName+".csv"; 
   ErrorFile=FileOpen(ErrorFileName, FILE_READ|FILE_WRITE, ';');  if(ErrorFile<0) {Report("ERROR! ErrorCheck(): �� ���� ������� ���� "+ErrorFileName); return;}
   Ticket=DoubleToStr(OrderTicket(),0); // � �.TesterFileCreate() ���������� Magic ���������������, ������� �� ���� ��������� 
   Expir =DoubleToStr(ExpirHours,0)+" ("+TimeToStr(ExpirHours,TIME_DATE|TIME_MINUTES)+")";
   if (SetBUY>0){ // ������ �������� ���� � ����
      Stop=SetBUY-SetSTOP_BUY;
      sB ="set"+DoubleToStr(SetBUY,DIGITS); 
      sBS="set"+DoubleToStr(SetSTOP_BUY,DIGITS); 
      sBP="set"+DoubleToStr(SetPROFIT_BUY,DIGITS);} 
   else { // ���� � ���� ��� �������
      sB =DoubleToStr(BUY+BUYSTOP+BUYLIMIT,DIGITS); 
      sBS=DoubleToStr(STOP_BUY,DIGITS); 
      sBP=DoubleToStr(PROFIT_BUY,DIGITS);}
   if (SetSELL>0){// ������ �������� ���� � ����
      Stop=SetSTOP_SELL-SetSELL;
      sS ="set"+DoubleToStr(SetSELL,DIGITS); 
      sSS="set"+DoubleToStr(SetSTOP_SELL,DIGITS); 
      sSP="set"+DoubleToStr(SetPROFIT_SELL,DIGITS);} 
   else { // ���� � ���� ��� �������
      sS =DoubleToStr(SELL+SELLSTOP+SELLLIMIT,DIGITS); 
      sSS=DoubleToStr(STOP_SELL,DIGITS); 
      sSP=DoubleToStr(PROFIT_SELL,DIGITS);}
   ChkRsk=DoubleToStr(RiskChecker(Lot,Stop,SYMBOL),2);
   ServerTime="-"+TimeToStr(AlpariTime(0),TIME_DATE|TIME_MINUTES);
   if (FileReadString(ErrorFile)=="")// ����������� ��������� �������� 
      FileWrite (ErrorFile,"ServerTime", "Ask/Bid" ,"StpLev" ,"Spred","Ticket","BUY","StpBUY","PrfBUY","SELL","StpSELL","PrfSELL","Expir","Lot",     "Sym/SYM"     ,"CheckRisk","Err");
   FileSeek(ErrorFile,0,SEEK_END);     // ������������ � �����
   FileWrite    (ErrorFile, ServerTime ,ASK+"/"+BID,StopLevel, Spred , Ticket , sB  ,  sBS   ,  sBP   ,  sS  ,   sSS   ,  sSP    , Expir , Lot ,Symbol()+"/"+SYMBOL,  ChkRsk   , str+". Order: "+ErrOrder);
   FileClose(ErrorFile);
   }////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////   
   
   // if (err==134) return; // 134-����� ���������������� ������ ��� �����������, 130-�� NDD ������, ��� �����=0
   /*if (err==3){// ���������� ������ �������, ����� ������ ����������� (� 14:28 �� �30) ��� (� 13:59 �� �1).   
      temp=1.0/Period()*Minute(); // ��� ����� �������� ������� ����� �������� ������ � �������� �� 
      temp-=MathRound(temp);      // (������ ��������� 0), 
      if (temp!=0) return; // � ���������� ������, ���� ���� ��� �������
      }*/