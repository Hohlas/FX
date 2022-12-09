
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
//double HHI, LLO, HHI1, LLO1;
bool COUNT(){// Общие расчеты для всего эксперта 
   ChartHistory="";
   MARKET_UPDATE(Symbol());
   iHILO();// Расчет экстремумов HL, ATR  
   // Расчет минимальной прибыли, без которой не хочется закрываться
   if (Oprf<0) Present=float(-20*ATR); // при отрицательных значениях oP поХ c каким кушем выходить
   else        Present=float(MinProfit*ATR); // пороговая прибыль, без которой не закрываемся  0.1  0.4  0.9  1.6  2.5  3.6 
   
   LINE("HI", bar+1,HI1, bar,HI, clrBlack,0);
   LINE("LO", bar+1,LO1, bar,LO, clrBlack,0);
   //LINE("FIBO Buy", bar,Fibo( D), bar+1,Fibo( D), clrWhite,0);  LINE("FIBO BuyStp", bar,Fibo(D-S), bar+1,Fibo(D-S), clrRed,0);  LINE("FIBO BuyPrf", bar,Fibo(D+P), bar+1,Fibo(D+P), clrYellow,0); 
   //LINE("FIBO Sel", bar,Fibo(-D), bar+1,Fibo(-D), clrWhite,0);  LINE("FIBO SelStp", bar,Fibo(S-D), bar+1,Fibo(S-D), clrRed,0);  LINE("FIBO SelPrf", bar,Fibo(-D-P), bar+1,Fibo(-D-P), clrYellow,0); 
   if (HI==0 || LO==0 || ATR==0) {return(false);}
   
// НАЙДЕМ МАКСИМАЛЬНЫЕ/МИНИМАЛЬНЫЕ ЦЕНЫ С МОМЕНТА ОТКРЫТИЯ ПОЗ ////////////////////////////////////////////////////////////////////////
   if (BUY.Val>0){
      int shift=SHIFT(BUY.T);
      MinFromBuy=(float)Low [iLowest (NULL,0,MODE_LOW ,shift,0)]; 
      MaxFromBuy=(float)High[iHighest(NULL,0,MODE_HIGH,shift,0)];} //  Print("BUY.Val=",BUY.Val," BuyTime=",BuyTime," Shift=",Shift," MinFromBuy=",MinFromBuy," MaxFromBuy=",MaxFromBuy);    
   if (SEL.Val>0){
      int shift=SHIFT(SEL.T);
      MinFromSell=(float)Low [iLowest (NULL,0,MODE_LOW ,shift,0)];
      MaxFromSell=(float)High[iHighest(NULL,0,MODE_HIGH,shift,0)];
      }
   if (tk==0 && ExpirBars>0)  setBUY.Exp=Time[0]+datetime(ExpirBars*Period()*60-180); // уменьшаем период на три минутки, чтоб совпадало с реалом    
   else setBUY.Exp=0; 
   setSEL.Exp=setBUY.Exp;
   setBUY.Val=0;  setBUY.Stp=0; setBUY.Prf=0; setSEL.Val=0; setSEL.Stp=0; setSEL.Prf=0; //
   ERROR_CHECK(__FUNCTION__);
   return (true);
   }
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
void CONSTANT_COUNTER(){// Индивидуальные константы: MinProfit, PerAdapter, AtrPer, время входа/выхода...      
   PerAdapter=float(60.00/Period()); //Print("PerAdapter=",PerAdapter);
   MinProfit=(Oprf+1)*(Oprf+1)*float(0.1);
   FastAtrPer=a*a; 
   SlowAtrPer=A*A;
   HL_init(); // формирование входных параметров HLper, HLwid для ф. iHILO()
   if (tk==0){ // без временного фильтра, активны только GTC и Tper(удержание отрытой позы)
      Tin=0;
      switch(T0){// расчет времени жизни отложников
         case 1: ExpirBars= 1;  break; 
         case 2: ExpirBars= 2;  break; 
         case 3: ExpirBars= 3;  break;     
         case 4: ExpirBars= 5;  break;
         case 5: ExpirBars= 8;  break;
         case 6: ExpirBars=13;  break;
         case 7: ExpirBars=21;  break;
         default:ExpirBars=0;   break; // при Т0=0, 8
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
      ExpirBars=short(ExpirBars*PerAdapter);
      Tper=short(Tper*PerAdapter); // Print("T0=",T0," T1=",T1," Tper=",Tper);
      }
   else{ // при tk>0 торговля ведется в определенный период
      ExpirBars=0; Tper=0;   
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
      Tin =short(Tin*PerAdapter);   
      Tout=short(Tout*PerAdapter); 
      if (Tout>=BarsInDay) Tout-=BarsInDay;   // если время начала торговли будет 18:00, а Период 20 часов, то разрешено торговать с 18:00 до 14:00      
      //Print("OLD Tin=",Tin," Tout=",Tout," PerAdapter=",PerAdapter,".  Или с ",MathFloor((Tin*Period())/60),":",Tin*Period()-MathFloor((Tin*Period())/60)*60," по ",MathFloor((Tout*Period())/60),":",Tout*Period()-MathFloor((Tout*Period())/60)*60);
   }  }
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
bool FINE_TIME(){ // время, в которое разрешено торговать 
   if (tk==0) return (true); // при tk=0 ограничение по времени не работает
   else{
      short temp=short((TimeHour(Time[0])*60+Minute())/Period()); // приводим текущее время в количесво баров с начала дня
      if ((Tin<Tout &&  Tin<=temp && temp<Tout) ||              //  00:00-нельзя / Tin-МОЖНО-Tout / нельзя-23:59
          (Tout<Tin && (Tin<=temp || (0<=temp && temp<Tout))))  //  00:00-можно / Tout-НЕЛЬЗЯ-Tin / можно-23:59  
         return (true); else return (false);   
   }  }////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////   
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ    
void DATA_PROCESSING(int source, char ProcessingType){// универсальная ф-ция для записи/чтения парамеров, их печати на графике и генерации MagicLong   
   int err=GetLastError();  if (err>0) REPORT("DATA_PROCESSING: "+ErrorDescription(err)+"! ERROR-"+S0(err)); // в этой функции нельзя вызывать ERROR_CHECK(), т.к. она сама вызывается в ERROR_CHECK / ERROR_LOG / TESTER_FILE_CREATE и при возникновении повторной ошибки происходит переполнение стека
   if (ProcessingType==LABEL_WRITE)   LABEL(" - I N P U T  - ");///////////
   DATA("HL",  HL,   source,ProcessingType);
   DATA("HLk", HLk,  source,ProcessingType);
   DATA("TR",  TR,   source,ProcessingType);
   DATA("TRk", TRk,  source,ProcessingType);
   DATA("IN",  IN,   source,ProcessingType);
   DATA("Ik",  Ik,   source,ProcessingType);
   if (ProcessingType==LABEL_WRITE)   LABEL(" -  S T O P S  - ");//////////////// 
   DATA("Del", Del,  source,ProcessingType);
   DATA("Rev", Rev,  source,ProcessingType);
   DATA("D",   D,    source,ProcessingType);
   DATA("Iprice",Iprice,source,ProcessingType);
   DATA("S",   S,    source,ProcessingType);
   DATA("P",   P,    source,ProcessingType);
   DATA("PM1", PM1,  source,ProcessingType);
   DATA("PM2", PM2,  source,ProcessingType);
   DATA("TS",  TS,   source,ProcessingType);
   if (ProcessingType==LABEL_WRITE)   LABEL(" -  O U T P U T  -");////////////////
   DATA("Out1",Out1, source,ProcessingType);
   DATA("Out2",Out2, source,ProcessingType);
   DATA("Out3",Out3, source,ProcessingType);
   DATA("Out4",Out4, source,ProcessingType);
   DATA("Out5",Out5, source,ProcessingType);
   DATA("Out6",Out6, source,ProcessingType);
   DATA("Out7",Out7, source,ProcessingType);
   DATA("Out8",Out8, source,ProcessingType);
   DATA("OTr", OTr,  source,ProcessingType);
   DATA("Oprc",Oprc, source,ProcessingType);
   DATA("Oprf",Oprf, source,ProcessingType);
   if (ProcessingType==LABEL_WRITE)   LABEL(" -  A T R  -");////////////////
   DATA("A",   A,    source,ProcessingType);
   DATA("a",   a,    source,ProcessingType);
   DATA("AtrLim",AtrLim,source,ProcessingType);
   if (ProcessingType==LABEL_WRITE)   LABEL(" -  T I M E  -");////////////////
   DATA("tk",  tk,source,ProcessingType);
   DATA("T0",  T0,   source,ProcessingType);
   DATA("T1",  T1,   source,ProcessingType);
   DATA("tp",  tp,   source,ProcessingType);
   if (ProcessingType==READ_ARR){
      TestEndTime=CSV[Exp].TestEndTime;
      OptPeriod=  CSV[Exp].OptPeriod;
      HistDD=     CSV[Exp].HistDD;
      LastTestDD= CSV[Exp].LastTestDD;
  //  Risk=       CSV[Exp].Risk;
      Magic=      CSV[Exp].Magic;
      ID=         CSV[Exp].ID;
      memBUY.Val= CSV[Exp].Buy; 
      memSEL.Val= CSV[Exp].Sel; 
      } 
   err=GetLastError();  if (err>0) REPORT("DATA_PROCESSING/"+PRC_TYPE(ProcessingType)+": "+ErrorDescription(err)+"! ERROR-"+S0(err)); // в этой функции нельзя вызывать ERROR_CHECK(), т.к. она сама вызывается в ERROR_CHECK / ERROR_LOG / TESTER_FILE_CREATE и при возникновении повторной ошибки происходит переполнение стека
   }    
   
     
      
        
   
         