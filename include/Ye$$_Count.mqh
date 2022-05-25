void Count(){// Общие расчеты для всего эксперта ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   RefreshRates();
   SYMBOL=Symbol();
   Per=Period();
   DIGITS   =Digits; // т.к. в ф. GlobalOrdersSet() ордера ставятся с одного графика на разные пары, 
   StopLevel=MarketInfo(Symbol(),MODE_STOPLEVEL)*Point; 
   Spred    =MarketInfo(Symbol(),MODE_SPREAD)*Point;
   Mid1=NormalizeDouble((High[1]+Low[1]+Close[1])/3,Digits);
   Mid2=NormalizeDouble((High[2]+Low[2]+Close[2])/3,Digits);
   int i=a*a*PerAdapter; 
   int j=A*A*PerAdapter;
   atr=PerAdapter*iCustom(NULL,0,"0ATR",i,j,0,1); //Print("atr=",atr);
   ATR=PerAdapter*iCustom(NULL,0,"0ATR",i,j,1,1); //Print("ATR=",ATR);
   // Расчет минимальной прибыли, без которой не хочется закрываться
   if (Op<0)  Present=-20*ATR; // при отрицательных значениях oP поХ c каким кушем выходить
   else       Present=(Op+1)*(Op+1)*0.1*ATR; // пороговая прибыль, без которой не закрываемся  0.1  0.4  0.9  1.6  2.5  3.6 
   // Расчет экстремумов HL   
   iHL=PeriodCount(HLk); 
   H=iCustom(NULL,0,"0HL",HL,iHL,PerCnt,0,1);  // переменная iHL может пригодиться в Signal поэтому она глобал 
   L=iCustom(NULL,0,"0HL",HL,iHL,PerCnt,1,1);  // PerCnt-способ расчета периода (только для HL=1)

// НАЙДЕМ МАКСИМАЛЬНЫЕ/МИНИМАЛЬНЫЕ ЦЕНЫ С МОМЕНТА ОТКРЫТИЯ ПОЗ ////////////////////////////////////////////////////////////////////////
   if (BUY>0){
      i=1; MinFromBuy=Low[1]; MaxFromBuy=High[1]; //Print("BuyOrderOpenTime()=",OrderOpenTime());
      while (Time[i]>=BuyTime){
         if (High[i]>MaxFromBuy) MaxFromBuy=High[i];
         if (Low[i]<MinFromBuy)  MinFromBuy=Low[i];
         i++;  
      }  } // Print(" BuyTime=",BuyTime," Time=",Time[i],",  MaxFromBuy=",MaxFromBuy," MinFromBuy=",MinFromBuy, " Low[1]=",Low[1]);
   if (SELL>0){
      i=1; MinFromSell=Low[1]; MaxFromSell=High[1]; //Print("SellOrderOpenTime()=",OrderOpenTime());
      while (Time[i]>=SellTime){
         if (High[i]>MaxFromSell) MaxFromSell=High[i];
         if (Low[i]<MinFromSell)  MinFromSell=Low[i];
         i++;  //Print(" SellTime=",Time[i]," High[i]=",High[i]," Low[i]=",Low[i]); 
     }  }
   if (tk==0 && ExpirHours>0)  Expiration=Time[0]+ExpirHours*Period()*60-180; // уменьшаем период на три минутки, чтоб совпадало с реалом    
   else Expiration=0; 
   SetBUY=0; SetSELL=0; SetSTOP_BUY=0; SetPROFIT_BUY=0; SetSTOP_SELL=0; SetPROFIT_SELL=0; //
   }////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
int PeriodCount(int Q){// расчет периодов HL используется дважды, поэтому отдельная функция //////////////////////////////////////////////////////////////////
   int CountPeriod;
   switch (HL){
      case 1: CountPeriod=MathPow((Q+1)*PerAdapter,1.7);    break; // 3  6  11  15  21  27  34  42  50
      case 2: // HL_DayBegin начиная с i-го часа от начала дня и по сей момент
         CountPeriod=(Q-1)*3+PerCnt;
         if (CountPeriod>23) CountPeriod-=24;  //  (0,3,6,9,12,15,18,21,24) + (0..2)
      break; 
      case 3: CountPeriod=(Q+1)*PerAdapter;  break; // HL_N отсчитываем N максимумов, превосходящих текущий хай
      case 4: CountPeriod=(Q+2)*PerAdapter;  break; // HL_Delta-2 формирование нового хая при удалении на заданную величину от последнего лоу
      case 5: CountPeriod=(Q+2)*PerAdapter;  break; // HL_Delta - hi на расстоянии iHL*ATR(100)/2 пунктов от lo
      case 6: CountPeriod=Q*PerAdapter;      break; // HL_Fractal 
      }    
   return (CountPeriod);
   }////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void TimeCounter(){// Находим время входа и выхода  //////////////////////////////////////////////////////////////////
   StockDefine();  // выставление таймера, определение сессий для стоков     
   PerAdapter=MathPow(60.00/Period(),0.5); //Print("PerAdapter=",PerAdapter);
   if (tk==0){ // без временного фильтра, активны только GTC и Tper(удержание отрытой позы)
      Tin=0;
      switch(T0){// расчет времени жизни отложников
         case 1: ExpirHours= 1;  break; 
         case 2: ExpirHours= 2;  break; 
         case 3: ExpirHours= 3;  break;     
         case 4: ExpirHours= 5;  break;
         case 5: ExpirHours= 8;  break;
         case 6: ExpirHours=13;  break;
         case 7: ExpirHours=21;  break;
         default:ExpirHours=0;   break; // при Т0=0, 8
         }
      switch(T1){// Время удержания открытой позы и период сделки 
         case 1: Tper= 1;  break;  
         case 2: Tper= 2;  break;  
         case 3: Tper= 3;  break;  
         case 4: Tper= 5;  break;     
         case 5: Tper= 8;  break;  
         case 6: Tper=13;  break;  
         case 7: Tper=21;  break;  
         default:Tper=0; // бесконечно 
         }
      ExpirHours*=PerAdapter;
      Tper*=PerAdapter;
      }
   else{ // при tk>0 торговля ведется в определенный период
      ExpirHours=0; Tper=0;   
      Tin=(8*(tk-1) + T0-1); // с какого бара начинать торговлю
      switch(T1){// Время удержания открытой позы и период сделки 
         case 1: Tout=Tin+ 1; break; 
         case 2: Tout=Tin+ 2; break; 
         case 3: Tout=Tin+ 3; break; 
         case 4: Tout=Tin+ 5; break;      
         case 5: Tout=Tin+ 8; break;
         case 6: Tout=Tin+12; break;
         case 7: Tout=Tin+16; break;
         default:Tout=Tin+20; break;// при Т1=0, 8
         }
      Tin*=PerAdapter;   
      Tout*=PerAdapter; 
      temp=60/Period()*24; // кол-во баров в сутках   
      if (Tout>=temp) Tout-=temp;   // если время начала торговли будет 18:00, а Период 20 часов, то разрешено торговать с 18:00 до 14:00      
      //Print("OLD Tin=",Tin," Tout=",Tout," PerAdapter=",PerAdapter,".  Или с ",MathFloor((Tin*Period())/60),":",Tin*Period()-MathFloor((Tin*Period())/60)*60," по ",MathFloor((Tout*Period())/60),":",Tout*Period()-MathFloor((Tout*Period())/60)*60);
   }  }////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
bool FineTime(){ // время, в которое разрешено торговать //////////////////////////////////////////////////////////////////////////////////////////////////
   if (Stock){ // поскольку (ХЗ почему) сессия на Альпари всегда начинается то в 16:30, то в 17:30, фиксируем начало каждой сессии:
      if (TimeHour(Time[1])>TimeHour(Time[0])){// час прошлого бара больше часа текущего, значит началась новая торговая сессия
         SessionStart=Time[0];    // Начало торговой сессии и ее 
         SessionEnd=SessionStart+23400;   // конец. На стоках сессия (9:30..16:00 NY) длится 6ч 30мин, т.е. 23400сек  
         //Print("SessionStart=",TimeToString(SessionStart,TIME_SECONDS)," SessionEnd=",TimeToString(SessionEnd,TIME_SECONDS));
         }
      if (tp<-1 && SessionEnd-Time[0]<=(Period()+3)*60) {/*Print("Последний бар, пора закрываться");*/ return (false);} // до конца сессии остался ровно бар, закрываем все позы
      if (tk==0) return (true); //  Print("Can trade from ",TimeToString(StockTin,TIME_DATE|TIME_SECONDS)," to ",TimeToString(StockTout,TIME_DATE|TIME_SECONDS), "       T0=",T0," T1=",T1," TimeHour(Time[1]=",TimeHour(Time[1])," TimeHour(Time[0]=",TimeHour(Time[0]));
      int StockTin, StockTout;
      if (T0>=0){// разрешенное время внутри торговой сессии
         StockTin=SessionStart+T0*60*30; StockTout=SessionEnd-T1*60*30;
         if (StockTin<=Time[0] && Time[0]<StockTout) return (true); else return (false); // Print("FineTime=false, StockTin=",TimeToString(StockTin,TIME_DATE|TIME_SECONDS)," Time[0]=",TimeToString(Time[0],TIME_DATE|TIME_SECONDS)," StockTout=",TimeToString(StockTout,TIME_DATE|TIME_SECONDS)); 
         }
      else{ // разрешенное время прерывается границей торговых сессий
         StockTin=SessionEnd+T0*60*30;   StockTout=SessionStart+T1*60*30; //Print(" StockTin=",TimeToString(StockTin,TIME_DATE|TIME_SECONDS)," Time[0]=",TimeToString(Time[0],TIME_DATE|TIME_SECONDS)," StockTout=",TimeToString(StockTout,TIME_DATE|TIME_SECONDS)); 
         if (StockTin<=Time[0] || Time[0]<StockTout) return (true); else return (false);
      }  }  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   if (tk==0) return (true); // при tk=0 ограничение по времени не работает
   else{
      temp=(TimeHour(AlpariTime(0))*60+Minute())/Period(); // приводим текущее время в количесво баров с начала дня
      if ((Tin<Tout &&  Tin<=temp && temp<Tout) ||              //  00:00-нельзя / Tin-МОЖНО-Tout / нельзя-23:59
          (Tout<Tin && (Tin<=temp || (0<=temp && temp<Tout))))  //  00:00-можно / Tout-НЕЛЬЗЯ-Tin / можно-23:59  
         return (true); else return (false);   
   }  }////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////   

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void TesterFileCreate(){ // создание файла отчета со всеми характеристиками  //////////////////////////////////////////////////////////////////////////////////////////////////
   TesterFile=-1; while(TesterFile<0) TesterFile=FileOpen(TesterFileName, FILE_READ|FILE_WRITE, ';'); if(TesterFile<0) {Report("ERROR! TesterFileCreate()  Не могу создать файл "+TesterFileName); return;}
   if (!Real) MagicGenerator();
   if (FileReadString(TesterFile)=="") FileWrite(TesterFile,"INFO","SymPer",Str1,Str2,Str3,Str4,Str5,Str6,Str7,Str8,Str9,Str10,Str11,Str12,Str13,"-Magic-","HL=","HLk=","TR=","TRk=","PerCnt=","Itr=","IN=","Ik=","Irev=","Del=","Rev=","D=","Iprice=","S=","P=","PM=","Pm=","T=","TS=","Tk=","TM=","Tm=","Op=","OUT=","Ok=","Orev=","Oprice=","A=","a=","tk=","T0=","T1=","tp=","NULL");
   FileSeek(TesterFile,0,SEEK_END);     // перемещаемся в конец
   FileWrite                                    (TesterFile,str ,SYMBOL+Per,Prm1,Prm2,Prm3,Prm4,Prm5,Prm6,Prm7,Prm8,Prm9,Prm10,Prm11,Prm12,Prm13,  Magic  , HL  , HLk  , TR  , TRk  , PerCnt  , Itr ,  IN  , Ik ,  Irev  , Del  , Rev ,  D  , Iprice  , S  , P  , PM  , Pm  , T  , TS  , Tk  , TM  , Tm  , Op  , OUT  , Ok  , Orev  , Oprice  , A  , a  , tk  , T0  , T1  , tp , 0); 
   }////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////   
void DataRead(int ExNum){ // считываем входные параметры эксперта из массива (строка ExNum) //////////////////////////////////////////////////////////////////////////////////////////////////
   HL    =aExpParams[ExNum][0];  //Alert("HL=",HL);
   HLk   =aExpParams[ExNum][1]; //Alert("HLk=",HLk);
   TR    =aExpParams[ExNum][2];  //Alert("TR=",TR);
   TRk   =aExpParams[ExNum][3];
   PerCnt=aExpParams[ExNum][4];
         
   Itr   =aExpParams[ExNum][5];
   IN    =aExpParams[ExNum][6];
   Ik    =aExpParams[ExNum][7];
   Irev  =aExpParams[ExNum][8];
   
   Del   =aExpParams[ExNum][9];
   Rev   =aExpParams[ExNum][10];
   D     =aExpParams[ExNum][11];
   Iprice=aExpParams[ExNum][12];
   S     =aExpParams[ExNum][13];
   P     =aExpParams[ExNum][14];
   PM    =aExpParams[ExNum][15];
   Pm    =aExpParams[ExNum][16];
   
   T     =aExpParams[ExNum][17];
   TS    =aExpParams[ExNum][18];
   Tk    =aExpParams[ExNum][19];
   TM    =aExpParams[ExNum][20];
   Tm    =aExpParams[ExNum][21];
   
   Op    =aExpParams[ExNum][22];
   OUT   =aExpParams[ExNum][23];
   Ok    =aExpParams[ExNum][24];
   Orev  =aExpParams[ExNum][25];
   Oprice=aExpParams[ExNum][26];
      
   A     =aExpParams[ExNum][27];
   a     =aExpParams[ExNum][28];
   
   tk    =aExpParams[ExNum][29];
   T0    =aExpParams[ExNum][30];
   T1    =aExpParams[ExNum][31];
   tp    =aExpParams[ExNum][32];
   
   TestEndTime =aTestEndTime[ExNum];
   SYMBOL      =aSym[ExNum];
   HistDD      =aHistDD[ExNum];
   LastTestDD  =aLastTestDD[ExNum];
   Risk        =aRisk[ExNum];
   Magic       =aMagic[ExNum];
   RevBUY      =aRevBUY[ExNum]; 
   RevSELL     =aRevSELL[ExNum]; 
   ExpMemory   =aExpMemory[ExNum];
   }////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////   
   
void MagicGenerator(){/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   Magic = HL*1000000+TR*100000+IN*10000+OUT*1000+ (TRk+HLk+Ik+Ok)*5 + (S+P+Op+T)*6 + (Itr+Irev+Orev+Rev)*10 + (TS+Tk+TM+Tm+PM+Pm)*9+(A+a+T0+T1)*tk;
   }
         