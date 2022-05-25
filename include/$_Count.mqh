void Count(){   // Общие расчеты для всего эксперта
   RefreshRates();
   SYMBOL=Symbol();
   Per=Period();
   DIGITS   =Digits; // т.к. в ф. GlobalOrdersSet() ордера ставятся с одного графика на разные пары, 
   StopLevel=MarketInfo(Symbol(),MODE_STOPLEVEL)*Point; 
   Spred    =MarketInfo(Symbol(),MODE_SPREAD)*Point;
   Mid1=NormalizeDouble((High[1]+Low[1]+Close[1])/3,Digits);
   Mid2=NormalizeDouble((High[2]+Low[2]+Close[2])/3,Digits);
   atr=iATR(NULL,0,a*a,1);
   ATR=iATR(NULL,0,A*A,1);
         
   
            
   // Расчет минимальной прибыли, без которой не хочется закрываться
   if (Op<0)  Present=-20*ATR; // при отрицательных значениях oP поХ c каким кушем выходить
   else       Present=(Op+1)*(Op+1)*0.1*ATR; // пороговая прибыль, без которой не закрываемся
   if (Op==0) Present=0; // отбить охтябы спред // Print("Present=",Present);
     
   // Расчет экстремумов HL
   switch (HL){
      case 1: iHL=HLk*HLk;    break; // HL_Per -стандартный HL   
      case 2: // HL_DayBegin начиная с i-го часа от начала дня и по сей момент
         iHL=16+HLk*2;
         if (iHL>=24) iHL-=24;  // 18, 20, 22, 0, 2, 4, 6, 8, 10
      break; 
      case 3: iHL=HLk+1;      break; // HL_N отсчитываем N максимумов, превосходящих текущий хай
      case 4: iHL=HLk+1;      break; // HL_Delta-2 формирование нового хая при удалении на заданную величину от последнего лоу
      case 5: iHL=HLk+1;      break; // HL_Delta - hi на расстоянии iHL*ATR(100)/2 пунктов от lo
      case 6: iHL=HLk+1;      break; // HL_Fractal 
      // используются только 6 индюков, 8-ой для расчета сигнала 6
      //case 8: iHL=HLk; k=5; break; // VolumeCluster, параметр k надо менять еще и в Signal/2
      }    
   H=iCustom(NULL,0,"0HL",HL,iHL,PerCnt,0,1);   // переменная iHL может пригодиться в Signal поэтому она глобал 
   L=iCustom(NULL,0,"0HL",HL,iHL,PerCnt,1,1);  // PerCnt-способ расчета периода (только для HL=1)
   //Print(" H=",H," L=",L);  
    // Расчет направления тренда
   Signal(1,TR,TRk,1); // Signal (int SigMode, int SigType, int Sk, int bar)
   UpTr=Up; DnTr=Dn;
   // время, в которое не грешно торговать
   temp=(TimeHour(AlpariTime(0))*60+Minute())/Period(); // приводим текущее время в количесво баров с начала дня
   if ((Tin<Tout &&  Tin<=temp && temp<Tout) ||              //  00:00-нельзя / Tin-МОЖНО-Tout / нельзя-23:59
       (Tout<Tin && (Tin<=temp || (0<=temp && temp<Tout))))  //  00:00-можно / Tout-НЕЛЬЗЯ-Tin / можно-23:59  
      FineTime=true; else FineTime=false;
    
   // НАЙДЕМ МАКСИМАЛЬНЫЕ/МИНИМАЛЬНЫЕ ЦЕНЫ С МОМЕНТА ОТКРЫТИЯ ПОЗ ////////////////////////////////////////////////////////////////////////
   int t;
   if (BUY>0){
      t=1; MinFromBuy=Low[1]; MaxFromBuy=High[1]; //Print("BuyOrderOpenTime()=",OrderOpenTime());
      while (Time[t]>=BuyTime){
         if (High[t]>MaxFromBuy) MaxFromBuy=High[t];
         if (Low[t]<MinFromBuy)  MinFromBuy=Low[t];
         t++;  
      }  } // Print(" BuyTime=",BuyTime," Time=",Time[t],",  MaxFromBuy=",MaxFromBuy," MinFromBuy=",MinFromBuy, " Low[1]=",Low[1]);
   if (SELL>0){
      t=1; MinFromSell=Low[1]; MaxFromSell=High[1]; //Print("SellOrderOpenTime()=",OrderOpenTime());
      while (Time[t]>=SellTime){
         if (High[t]>MaxFromSell) MaxFromSell=High[t];
         if (Low[t]<MinFromSell)  MinFromSell=Low[t];
         t++;  //Print(" SellTime=",Time[t]," High[t]=",High[t]," Low[t]=",Low[t]); 
     }  }
   if (tk==0 && ExpirHours>0)   Expiration=Time[0]+ExpirHours*Period()*60-180; // уменьшаем период на три минутки, чтоб совпадало с реалом    
   else Expiration=0;  
   SetBUY=0; SetSELL=0; SetSTOP_BUY=0; SetPROFIT_BUY=0; SetSTOP_SELL=0; SetPROFIT_SELL=0; //
   }

void TimeCounter(){// Находим время входа и выхода    
   if (tk==0){ // без временного фильтра, активны только Expiration и Tper(удержание отрытой позы)
      Tin=0;
      switch(T0){// расчет времени удержания отложников (актуально при tk=0) 
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
         case 2: Tper= 3;  break; 
         case 3: Tper= 5;  break; 
         case 4: Tper= 8;  break;      
         case 5: Tper=16;  break;
         case 6: Tper=24;  break;
         case 7: Tper=36;  break;
         default:Tper=0;   break;// при Т1=0, 8   
      }  }
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
         case 7: Tout=Tin+17; break;
         default:Tout=Tin+23; break;// при Т1=0, 8
         }
      temp=60/Period()*24; // кол-во баров в сутках   
      if (Tout>=temp) Tout-=temp;   // если время начала торговли будет 18:00, а Период 20 часов, то разрешено торговать с 18:00 до 14:00 
   }  }
   
void TesterFileCreate(){ // создание файла отчета со всеми характеристиками
   TesterFile=-1; while(TesterFile<0) TesterFile=FileOpen(TesterFileName, FILE_READ|FILE_WRITE, ';'); // if(TesterFile<0) {Report("ERROR! TesterFileCreate() Не могу создать файл "+ TesterFileName,1); return;}
   if (!Real) MagicGenerator();
   if (FileReadString(TesterFile)=="") FileWrite(TesterFile,"INFO","SymPer",Str1,Str2,Str3,Str4,Str5,Str6,Str7,Str8,Str9,Str10,Str11,Str12,Str13,"-Magic-","HL=","HLk=","TR=","TRk=","PerCnt=","Itr=","IN=","Ik=","Irev=","Del=","Rev=","D=","Iprice=","S=","P=","PM=","Pm=","T=","TS=","Tk=","TM=","Tm=","Otr=","Op=","OUT=","Ok=","Orev=","Oprice=","A=","a=","tk=","T0=","T1=","X=");
   FileSeek(TesterFile,0,SEEK_END);     // перемещаемся в конец
   FileWrite                                    (TesterFile,str ,SYMBOL+Per,Prm1,Prm2,Prm3,Prm4,Prm5,Prm6,Prm7,Prm8,Prm9,Prm10,Prm11,Prm12,Prm13,  Magic  , HL  , HLk  , TR  , TRk  , PerCnt  , Itr ,  IN  , Ik ,  Irev  , Del  , Rev ,  D  , Iprice  , S  , P  , PM  , Pm  , T  , TS  , Tk  , TM  , Tm  , Otr  , Op  , OUT  , Ok  , Orev  , Oprice  , A  , a  , tk  , T0  , T1,   X); 
   }
   
void DataRead(int ExNum){ // считываем входные параметры эксперта из массива (строка ExNum)
   HL=      aExpParams[ExNum][0];
   HLk=     aExpParams[ExNum][1];
   TR=      aExpParams[ExNum][2];
   TRk=     aExpParams[ExNum][3];
   PerCnt=  aExpParams[ExNum][4];
         
   Itr=     aExpParams[ExNum][5];
   IN=      aExpParams[ExNum][6];
   Ik=      aExpParams[ExNum][7];
   Irev=    aExpParams[ExNum][8];
   
   Del=     aExpParams[ExNum][9];
   Rev=     aExpParams[ExNum][10];
   D=       aExpParams[ExNum][11];
   Iprice=  aExpParams[ExNum][12];
   S=       aExpParams[ExNum][13];
   P=       aExpParams[ExNum][14];
   PM=      aExpParams[ExNum][15];
   Pm=      aExpParams[ExNum][16];
   
   T=       aExpParams[ExNum][17];
   TS=      aExpParams[ExNum][18];
   Tk=      aExpParams[ExNum][19];
   TM=      aExpParams[ExNum][20];
   Tm=      aExpParams[ExNum][21];
   
   Otr=     aExpParams[ExNum][22];
   Op=      aExpParams[ExNum][23];
   OUT=     aExpParams[ExNum][24];
   Ok=      aExpParams[ExNum][25];
   Orev=    aExpParams[ExNum][26];
   Oprice=  aExpParams[ExNum][27];
      
   A=       aExpParams[ExNum][28];
   a=       aExpParams[ExNum][29];
   
   tk=      aExpParams[ExNum][30];
   T0=      aExpParams[ExNum][31];
   T1=      aExpParams[ExNum][32];
   X=       aExpParams[ExNum][33];
   
   TestEndTime=aTestEndTime[ExNum];
   SYMBOL=     aSym[ExNum];
   HistDD=     aHistDD[ExNum];
   LastTestDD= aLastTestDD[ExNum];
   Risk  =     aRisk[ExNum];
   Magic =     aMagic[ExNum];
   RevBUY=     aRevBUY[ExNum]; 
   RevSELL=    aRevSELL[ExNum]; 
   ExpMemory=  aExpMemory[ExNum];
   }///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   
void MagicGenerator(){/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   Magic = HL*1000000+TR*100000+IN*10000+OUT*1000+ (TRk+HLk+Ik+Ok)*5 + (S+P+Op+T)*6 + (Itr+Irev+Otr+Orev+Rev)*10 + (TS+Tk+TM+Tm+PM+Pm)*9+(A+a+T0+T1)*tk;
   }////////////////////////////////////////////////////////////////////////////////////////////////////          