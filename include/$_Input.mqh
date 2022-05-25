void Input(){ // ‘ » Ћ № “ – џ    ¬ ’ ќ ƒ ј    ///////////////////////////////////////////////////////
   switch (Itr){ // ќбработка сигналов тренда  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      case 1:  Up=UpTr;  Dn=DnTr;   break;   // без переворота
      case 0:  Up=1; Dn=1;          break;   // игнорирование тренда
      case -1: Up=DnTr; Dn=UpTr;    break;   // реверсируем сигналы тренда
      }
   Up=(Up && !BUY);  
   Dn=(Dn && !SELL);
   if (!Up && !Dn) return;  
   bool tmpUp=Up, tmpDn=Dn; // ¬ременное сохранение переменных Up и Dn
   int k;
   Signal(2,IN,Ik,1); // Signal (int SigMode, int SigType, int Sk, int bar) // ќбработка сигналов входа  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   if (Irev==-1)   {k=Up; Up=Dn; Dn=k;} // реверснем сигналы
   Up=(Up && tmpUp); 
   Dn=(Dn && tmpDn);  
   if (!Up && !Dn) return; // Print(" Up=",Up," Dn=",Dn);   
   
   switch (Iprice){  // расчет цены входов: 
      case  1:  // по рынку, все расчеты через ATR
         double STOP,PROFIT,DELTA, Sprd=MarketInfo(Symbol(),MODE_SPREAD)*Point;           
         STOP  =NormalizeDouble(ATR*(S*S*0.1+1),Digits);  // 1.1ATR  1.4ATR  1.9ATR  2.6ATR  3.5ATR  4.6ATR  5.9ATR  7.4ATR  9.1ATR
         PROFIT=NormalizeDouble(ATR*(P*P*0.1+1),Digits);  // 1.1ATR  1.4ATR  1.9ATR  2.6ATR  3.5ATR  4.6ATR  5.9ATR  7.4ATR  9.1ATR 
         if (D!=0) DELTA=NormalizeDouble(ATR* D*D*0.1   ,Digits)+StopLevel;  // 0.1ATR  0.4ATR  0.9ATR  1.6ATR  2.5ATR  3.6ATR  
         if (D<0) DELTA*=-1; 
         if (Up>0) {SetBUY =Open[0]+Sprd+DELTA; SetSTOP_BUY =SetBUY-STOP;    if (P>0 && P<10) SetPROFIT_BUY =SetBUY+PROFIT;}  // ask и bid формируем из Open[0],
         if (Dn>0) {SetSELL=Open[0]-DELTA;       SetSTOP_SELL=SetSELL+STOP;   if (P>0 && P<10) SetPROFIT_SELL=SetSELL-PROFIT;} // чтоб отложники не зависели от шустрых движух   
      break;
      case  2: // по ‘»Ѕќ уровн€м 
         if (Up>0) {SetBUY =Fibo( D);  SetSTOP_BUY =Fibo( D-S);    if (P>0 && P<10) SetPROFIT_BUY =Fibo( D+P);}   
         if (Dn>0) {SetSELL=Fibo(-D);  SetSTOP_SELL=Fibo(-D+S);    if (P>0 && P<10) SetPROFIT_SELL=Fibo(-D-P);}    
      break;
      }
   temp=NormalizeDouble(ATR*7*MathPow(60/Period(),0.5),Digits); // максимальный стоп ограничим в 7 часовых ATR. 60/Period()-нормализаци€ ATR к часовкам, чтобы на всех “‘ максимальный стоп был примерно одинаковым     
   if (Up>0){
      if (SetBUY-SetSTOP_BUY>temp) SetSTOP_BUY=SetBUY-temp;
      }
   if (Dn>0){
      if (SetSTOP_SELL-SetSELL>temp) SetSTOP_SELL=SetSELL+temp;
      }         
 
// проверка и удаление старых ордеров ////////////////////////////////////////////////////////////////////////////////////////////////////
   if (Up>0){  // —игнал на покупку
      if (Del==1){   // при по€влении нового сигнала удал€ем старый ордер;       Print("Buy=",Buy," BUYSTOP=",BUYSTOP," Buy-BUYSTOP=",Buy-BUYSTOP," StopLevel=",StopLevel);
         if (BUYSTOP>0  && MathAbs(SetBUY-BUYSTOP)>StopLevel && BUYSTOP!=RevBUY)  BUYSTOP=0;     // если старый ордер далеко от нового
         if (BUYLIMIT>0 && MathAbs(SetBUY-BUYLIMIT)>StopLevel)                    BUYLIMIT=0;     // то удал€ем его, если нет, оставим
         }
      if (Del==2){   // при по€влении нового сигнала удал€ем противоположный или если ордер осталс€ один;
         if (SELL>0) SetBUY=0; // если уже есть селл, лонг не ставим, чтоб не пришлось тут же его удал€ть
         if (Dn==0 && SELLSTOP>0 && SELLSTOP!=RevSELL)   SELLSTOP=0;   // если есть противоположный отложник и сигналы не одновременные, т.е. чтоб не пришлось тут же его восстанавливать 
         if (Dn==0 && SELLLIMIT>0)                       SELLLIMIT=0; 
      }  }
   if (Dn>0){  // —игнал на продажу
      if (Del==1){//Print("SELLSTOP=",SELLSTOP," SELLLIMIT=",SELLLIMIT);
         if (SELLSTOP>0  && MathAbs(SetSELL-SELLSTOP)>StopLevel && SELLSTOP!=RevSELL)   SELLSTOP=0; 
         if (SELLLIMIT>0 && MathAbs(SetSELL-SELLLIMIT)>StopLevel)                       SELLLIMIT=0;  
         }
      if (Del==2){
         if (BUY>0) SetSELL=0;
         if (Up==0 && BUYSTOP>0  && BUYSTOP!=RevBUY)  BUYSTOP=0;  
         if (Up==0 && BUYLIMIT>0)                     BUYLIMIT=0;   
      }  }
   if (BUY!=0  || BUYSTOP!=0  || BUYLIMIT!=0)   SetBUY=0;  // если остались старые ордера, новые не выставл€ем 
   if (SELL!=0 || SELLSTOP!=0 || SELLLIMIT!=0)  SetSELL=0; 
   
   }

//∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆
//∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆




double Fibo(int FiboLevel) // —читаем ‘»Ѕ”:  –азбиваем диапазон HL   0   11.8   23.6   38.2  50  61.8   76.4  88.2   100 
   {
   double Fib;
   switch(FiboLevel){
      case 16: Fib= (H-L)*2.500; break;
      case 15: Fib= (H-L)*2.382; break;
      case 14: Fib= (H-L)*2.236; break;
      case 13: Fib= (H-L)*2.118; break;
      case 12: Fib= (H-L)*2.000; break;
      case 11: Fib= (H-L)*1.882; break;
      case 10: Fib= (H-L)*1.764; break;
      case  9: Fib= (H-L)*1.618; break;
      case  8: Fib= (H-L)*1.500; break;
      case  7: Fib= (H-L)*1.382; break;
      case  6: Fib= (H-L)*1.236; break;
      case  5: Fib= (H-L)*1.118; break;
      case  4: Fib= (H-L)*1.000; break; // Hi
      case  3: Fib= (H-L)*0.882; break;
      case  2: Fib= (H-L)*0.764; break; 
      case  1: Fib= (H-L)*0.618; break; // «олотое сечение
      case  0: Fib= (H-L)*0.500; break; 
      case -1: Fib= (H-L)*0.382; break; // «олотое сечение 
      case -2: Fib= (H-L)*0.236; break;
      case -3: Fib= (H-L)*0.118; break; 
      case -4: Fib= (H-L)*0;     break; // Lo   
      case -5: Fib=-(H-L)*0.118; break; 
      case -6: Fib=-(H-L)*0.236; break;
      case -7: Fib=-(H-L)*0.382; break; 
      case -8: Fib=-(H-L)*0.500; break; 
      case -9: Fib=-(H-L)*0.618; break; 
      case-10: Fib=-(H-L)*0.764; break;
      case-11: Fib=-(H-L)*0.882; break;
      case-12: Fib=-(H-L)*1.000; break;
      case-13: Fib=-(H-L)*1.118; break;
      case-14: Fib=-(H-L)*1.236; break;
      case-15: Fib=-(H-L)*1.382; break;
      case-16: Fib=-(H-L)*1.500; break;
      }
   return( NormalizeDouble(L+Fib,Digits) );
   }


   
   
         
         
         
         
         
         
         
         
      

