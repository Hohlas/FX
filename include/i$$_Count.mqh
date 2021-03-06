struct PICS {float PssP;}; // структура  PICS для совместимости с $o$imple в файле ORDERS.mqh 
int OnInit(){// функции сохранения и восстановления параметров на случай отключения терминала в течении часа // ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
   if (!IsTesting() && !IsOptimization()) {Real=true;} // на реале формирование файла проверки обязательно  
   InitDeposit=float(AccountBalance());
   DayMinEquity=InitDeposit;
   SYMBOL=Symbol();
   Per=short(Period());
   MaxRisk=MAX_RISK;
   string AccComp="test"; 
   if (AccountCompany()!="") AccComp=AccountCompany();
   Company=StringSubstr(AccComp,0,StringFind(AccComp," ",0)); // Первое слово до пробела
   if (MarketInfo(Symbol(),MODE_LOTSTEP)<0.1) LotDigits=2; else LotDigits=1;
   CHART_SETTINGS();
   if (Real){
      int ms=0;
      for (int i=0; i<StringLen(Symbol()); i++)    ms+=StringGetChar(Symbol(),i); 
      for (int i=0; i<StringLen(ExpertName); i++)  ms+=StringGetChar(ExpertName,i);
      ms+=Period(); // индивидуальная пауза для каждого эксперта, чтобы не стартовали разом
      while (ms>1000) ms-=1000;  ms*=2;
      Sleep(ms);
      if (!GlobalVariableCheck("GlobalOrdersSet")) GlobalVariableSet("GlobalOrdersSet",0);
      while (!GlobalVariableSetOnCondition("GlobalOrdersSet",ms,0))  Sleep(ms);
      LABEL("                  "+ExpertName+" Back="+S0(BackTest)+" Risk="+S1(Risk)+" MaxRisk="+S0(MaxRisk)+" MM="+S0(MM)+" Bars="+S0(Bars)+" Time[1]="+TimeToStr(Time[1],TIME_DATE));
      Print("Init() ",ExpertName," ",Symbol()+S0(Period())," Bars=",Bars, " Time[Bars]=",TimeToStr(Time[Bars-1],TIME_DATE | TIME_MINUTES)," Time[1]=",TimeToStr(Time[1],TIME_DATE | TIME_MINUTES)," Sleep=",ms,"ms");
      if (Bars<1000) MessageBox("Before(): History too short < 1000 bars!"); // история слишком короткая, индикаторы могут посчитаться неверно
      if (Risk==0) Aggress=1; // Если в настройках выставить риск>0, то риск, считанный из #.csv будет увеличен в данное количество раз. 
      else{
         Aggress=Risk; 
         MaxRisk=MAX_RISK*Aggress; 
         Alert(" WARNING, Risk x ",Aggress,"  MaxRisk=",MaxRisk, " !!!");
         } 
      INPUT_FILE_READ(); // занесение в массив CSV считанных из файла #.csv входных параметров всех экспертов
      for (Exp=1; Exp<=ExpTotal; Exp++){// осуществление перебора всех строк с входными параметрами за один тик (только для реала) 
         if (!EXPERT_SET()) continue; // выбор параметров эксперта из строки Exp массива CSV, сформированного из файла #.csv
         LOAD_VARIABLES(Exp);
         for (bar=Bars-3; bar>1; bar--) Count(); // расчет индикаторов на доступной истории
         SAVE_VARIABLES(Exp);// сохранение инициализированных значений Print("v[",e,"].BarDM=",v[e].BarDM," DayBar=",v[e].DayBar," daybar=",v[e].daybar);  
         }
      bar=1;   
      if (!GlobalVariableCheck("LastBalance"))     GlobalVariableSet("LastBalance",AccountBalance()); 
      GlobalVariableSet("RepFile",0); // флаг доступа к файлу с репортами
      GlobalVariableSet("CanTrade",0); // заводим глобал для огранизации доступа к терминалу
      GlobalVariableSet("CHECK_OUT_Time",TimeCurrent()); // глобал для обеспечения периодичности проверки ордеров
      GlobalVariableSet("LastOrdTime",LAST_ORD_TIME()); // время последнего выставленного ордера
      Print("Init() ",ExpertName," ",Symbol()+S0(Period()), " Last Start BarTime=",TimeToStr(BarTime,TIME_DATE | TIME_MINUTES),", ExpetrsTotal =",ExpTotal,", StartPause =",ms,"ms");
      if (UninitializeReason()==1) REPORT("Last Exit=Program Remove");
      GlobalVariableSet("GlobalOrdersSet",0);
      }
   else{
      if (BackTest==0){// режим оптимизации
         ExpTotal=1; // отключение режима перебора экспертов
         MAGIC_GENERATOR();
         CONSTANT_COUNTER(); // Индивидуальные константы: MinProfit, PerAdapter, AtrPer, HLper, время входа/выхода...
      }else{// работа экспетра со считанными из файла #.csv параметрами
         INPUT_FILE_READ(); // занесение в массив CSV считанных из файла #.csv входных параметров всех экспертов
         }
      if (StringLen(SkipPer)==5){   
         SkipFrom=2000+short(StrToDouble(StringSubstr(SkipPer,0,2)));
         SkipTo  =2000+short(StrToDouble(StringSubstr(SkipPer,3,2))); Print("Skip From-To =  ",SkipFrom,"-",SkipTo);
         }    
      INPUT_PARAMETERS_PRINT();  // ПЕЧАТЬ В ЛЕВОЙ ЧАСТИ ГРАФИКА ВХОДНЫХ ПАРАМЕТРОВ ЭКСПЕРТА   
      }
   
   //for (bar=Bars-1; bar>1; bar--){// прогоняем индикаторы на доступной истории, чтобы к началу работы все значения были готовы 
   //   ATR=float(PerAdapter*iATR(NULL,0,SlowAtrPer,bar)); //Print("ATR=",ATR);
   //   iHILO(); // ОСНОВНОЙ ЦИКЛ ПОИСКА УРОВНЕЙ 
   //   }   
   ERROR_CHECK("OnInit");
   Print("Init() ",ExpertName," ",SYMBOL+S0(Per), " Bars=",Bars," BarsTime=",TimeToStr(Time[Bars-1],TIME_DATE | TIME_MINUTES)," Time[1]=",TimeToStr(Time[1],TIME_DATE | TIME_MINUTES));   
   return (INIT_SUCCEEDED);   
   }  
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
//double HHI, LLO, HHI1, LLO1;
bool Count(){// Общие расчеты для всего эксперта 
   history="";
   MARKET_UPDATE(Symbol());
   atr=float(PerAdapter*iATR(NULL,0,FastAtrPer,bar)); //Print("atr=",atr);
   ATR=float(PerAdapter*iATR(NULL,0,SlowAtrPer,bar)); // Print("ATR(",SlowAtrPer,")=",ATR);
   Lim=(atr+ATR)*AtrLim/200;   // допуск уровней в % ATR
   // Расчет минимальной прибыли, без которой не хочется закрываться
   if (Oprf<0) Present=float(-20*ATR); // при отрицательных значениях oP поХ c каким кушем выходить
   else        Present=float(MinProfit*ATR); // пороговая прибыль, без которой не закрываемся  0.1  0.4  0.9  1.6  2.5  3.6 
   iHILO();// Расчет экстремумов HL  
   LINE("HI", bar+1,HI1, bar,HI, clrBlack,0);
   LINE("LO", bar+1,LO1, bar,LO, clrBlack,0);
   //LINE("FIBO Buy", bar,Fibo( D), bar+1,Fibo( D), clrWhite,0);  LINE("FIBO BuyStp", bar,Fibo(D-S), bar+1,Fibo(D-S), clrRed,0);  LINE("FIBO BuyPrf", bar,Fibo(D+P), bar+1,Fibo(D+P), clrYellow,0); 
   //LINE("FIBO Sel", bar,Fibo(-D), bar+1,Fibo(-D), clrWhite,0);  LINE("FIBO SelStp", bar,Fibo(S-D), bar+1,Fibo(S-D), clrRed,0);  LINE("FIBO SelPrf", bar,Fibo(-D-P), bar+1,Fibo(-D-P), clrYellow,0); 
   if (HI==0 || LO==0 || ATR==0) {return(false);}
   
// НАЙДЕМ МАКСИМАЛЬНЫЕ/МИНИМАЛЬНЫЕ ЦЕНЫ С МОМЕНТА ОТКРЫТИЯ ПОЗ ////////////////////////////////////////////////////////////////////////
   if (BUY.Val>0){
      int shift=SHIFT(BuyTime);
      MinFromBuy=(float)Low [iLowest (NULL,0,MODE_LOW ,shift,0)]; 
      MaxFromBuy=(float)High[iHighest(NULL,0,MODE_HIGH,shift,0)];} //  Print("BUY.Val=",BUY.Val," BuyTime=",BuyTime," Shift=",Shift," MinFromBuy=",MinFromBuy," MaxFromBuy=",MaxFromBuy);    
   if (SEL.Val>0){
      int shift=SHIFT(SellTime);
      MinFromSell=(float)Low [iLowest (NULL,0,MODE_LOW ,shift,0)];
      MaxFromSell=(float)High[iHighest(NULL,0,MODE_HIGH,shift,0)];
      }
   if (tk==0 && ExpirBars>0)  Expiration=Time[0]+datetime(ExpirBars*Period()*60-180); // уменьшаем период на три минутки, чтоб совпадало с реалом    
   else Expiration=0; 
   setBUY.Val=0;  setBUY.Stp=0; setBUY.Prf=0; setSEL.Val=0; setSEL.Stp=0; setSEL.Prf=0; //
   ERROR_CHECK("COUNT");
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
bool FineTime(){ // время, в которое разрешено торговать 
   if (tk==0) return (true); // при tk=0 ограничение по времени не работает
   else{
      short temp=short((TimeHour(Time[0])*60+Minute())/Period()); // приводим текущее время в количесво баров с начала дня
      if ((Tin<Tout &&  Tin<=temp && temp<Tout) ||              //  00:00-нельзя / Tin-МОЖНО-Tout / нельзя-23:59
          (Tout<Tin && (Tin<=temp || (0<=temp && temp<Tout))))  //  00:00-можно / Tout-НЕЛЬЗЯ-Tin / можно-23:59  
         return (true); else return (false);   
   }  }////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////   
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
void TESTER_FILE_CREATE(string Inf, string TesterFileName){ // создание файла отчета со всеми характеристиками  //////////////////////////////////////////////////////////////////////////////////////////////////
   ResetLastError(); TesterFile=FileOpen(TesterFileName, FILE_READ|FILE_WRITE | FILE_SHARE_READ | FILE_SHARE_WRITE, ';'); 
   if (TesterFile<0) {REPORT("ERROR! TesterFileCreate()  Не могу создать файл "+TesterFileName); return;}
   string SymPer=SYMBOL+S0(Per);
   //MAGIC_GENERATOR();
   if (FileReadString(TesterFile)==""){
      FileWrite(TesterFile,"INFO","SymPer",Str1,Str2,Str3,Str4,Str5,Str6,Str7,Str8,Str9,Str10,Str11,Str12,Str13,"Magic"); 
      DATA_PROCESSING(TesterFile, WRITE_HEAD);
      FileSeek (TesterFile,-2,SEEK_END); FileWrite(TesterFile,""," ","start");
      for (short i=1; i<=day; i++){ 
         FileSeek (TesterFile,-2,SEEK_END);  
         FileWrite(TesterFile,"",TimeToStr(DayTime[i],TIME_DATE)); // ежегодные отсечки высотой в последний баланс
      }  }
   int magic=Magic;
   if (Real) magic=CSV[Exp].Magic;   
   FileSeek (TesterFile, 0,SEEK_END); // перемещаемся в конец   
   FileWrite(TesterFile,    Inf  , SymPer ,Prm1,Prm2,Prm3,Prm4,Prm5,Prm6,Prm7,Prm8,Prm9,Prm10,Prm11,Prm12,Prm13, magic); 
   DATA_PROCESSING(TesterFile, WRITE_PARAM);
   FileSeek (TesterFile,-2,SEEK_END); FileWrite(TesterFile,""," "," ");
   ERROR_CHECK("TESTER_FILE_CREATE"); 
   }
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
void MAGIC_GENERATOR(){
   MagicLong=0;
   DATA_PROCESSING(0, MAGIC_GEN);   // генерит огромное чило MagicLong типа ulong складыая побитно все входные параметры
   ExpID=CODE(MagicLong);  // Уникальное 70-ти разрядное строковое имя из символов, сгенерированных на основе числа MagicLong 
   Magic=int(MagicLong);   // обрезаем до размеров, используемых в функциях OrderSend(), OrderModify()...
   if (Magic<0) Magic*=-1; // Отрицательный не нужен
   }  
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ     
void INPUT_PARAMETERS_PRINT(){ // ПЕЧАТЬ В ЛЕВОЙ ЧАСТИ ГРАФИКА ВХОДНЫХ ПАРАМЕТРОВ ЭКСПЕРТА и создание файла настроек magic.set 
   if (IsOptimization()) return;
   for (int i=ObjectsTotal()-1; i>=0; i--) ObjectDelete(ObjectName(i)); // удаляются все объекты 
   string FileName=ExpertName+"_"+S0(Magic)+".set";   // TerminalInfoString(TERMINAL_DATA_PATH)+"\\tester\\files\\"+ExpertName+DoubleToString(Magic,0)+".txt";
   int file=FileOpen(FileName,FILE_WRITE|FILE_TXT);
   if (file<0){   Print("INPUT_PARAMETERS_PRINT: Can't write setter file ", FileName);  return;}
   LABEL("                  "+ExpertName+" Back="+S0(BackTest)+" Risk="+S1(Risk)+" MaxRisk="+S0(MaxRisk));
   LABEL("                  Magic="+S0(Magic)); LABEL(" "); 
   DATA_PROCESSING(file, LABEL_WRITE);
   FileClose(file); 
   ERROR_CHECK("INPUT_PARAMETERS_PRINT"); 
   }  
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ    
void DATA_PROCESSING(int source, char ProcessingType){// универсальная ф-ция для записи/чтения парамеров, их печати на графике и генерации MagicLong   
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
      RevBUY=     CSV[Exp].RevBUY; 
      RevSELL=    CSV[Exp].RevSELL; 
      ExpMemory=  CSV[Exp].ExpMemory;
      }
   ERROR_CHECK("DATA_PROCESSING");    
   }    
    
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ     
void DATA(string name, char& param, int& source, char ProcessingType){// выбор типа обработки входных данных в DATA_PROCESSING
   char i=2; 
   switch (ProcessingType){// тип обработки входных данных
      case LABEL_WRITE: LABEL(name+"="+S0(param));  FileWrite(source,name+"=",S0(param)); ERROR_CHECK("DATA/LABEL_WRITE"); break;
      case READ_FILE:   param=char(StrToDouble(FileReadString(source)));                  ERROR_CHECK("DATA/READ_FILE");   break; 
      case READ_ARR:    param=CSV[Exp].PRM[source];    source++;                          ERROR_CHECK("DATA/READ_ARR");    break;//  присвоение переменным эксперта параметров строки Exp массива CSV, считанного из файла #.csv   Print(name,"=",param);
      case WRITE_HEAD:  FileSeek (source,-2,SEEK_END); FileWrite(source,"",name);         ERROR_CHECK("DATA/WRITE_HEAD");  break;   
      case WRITE_PARAM: FileSeek (source,-2,SEEK_END); FileWrite(source,"",param);        ERROR_CHECK("DATA/WRITE_PARAM"); break;    
      case MAGIC_GEN:   // формирование длинного числа из всех параметров эксперта
         while (i<param) {i*=2; if (i>4) break;} // кол-во зарзрядов (бит), необходимое для добавления нового параметра, но не более 3, чтобы не сильно растягивать число
         MagicLong*=i; // сдвиг MagicLong на i кол-во зарзрядов  
         MagicLong+=param; // Добавление очередного параметра
         ERROR_CHECK("DATA/MAGIC_GEN");
         break;
   }  }
   
     
      
        
   
         