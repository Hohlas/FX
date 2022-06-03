void Input(){ // Ф И Л Ь Т Р Ы    В Х О Д А    ///////////////////////////////////////////////////////
   if (BUY.Val && SEL.Val) return;
   Signal(1,TR,TRk); // Signal (int SigMode, int SigType, int Sk, int bar) = Расчет направления тренда
   if (TR<0)   {int k=Up; Up=Dn; Dn=k;} // реверснем сигналы
   //SIG_LINES(Up, "TrUp", Dn, "TrDn", clrGreen);
   bool TrUp=(Up && !BUY.Val);  
   bool TrDn=(Dn && !SEL.Val);
   if (!TrUp && !TrDn) return;  
   
   Signal(2,IN,Ik); // Signal (int SigMode, int SigType, int Sk, int bar) // Обработка сигналов входа  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   if (IN<0)   {int k=Up; Up=Dn; Dn=k;} // реверснем сигналы
   //SIG_LINES(Up, "SigUp", Dn, "SigDn", clrRed);
   Up=(Up && TrUp); 
   Dn=(Dn && TrDn);  
   if (!Up && !Dn) return; // Print(" Up=",Up," Dn=",Dn);   
   float STOP=0, PROFIT=0, DELTA=0, 
         OrdLim=float(NormalizeDouble(ATR*7,Digits)),
         StpLim=float(NormalizeDouble(ATR*8,Digits)); // максимальный стоп ограничим в 7.5 часовых ATR. 60/Period()-нормализация ATR к часовкам, чтобы на всех ТФ максимальный стоп был примерно одинаковым
   switch (Iprice){  // расчет цены входов: 
      case  1:  // по рынку, все расчеты через ATR          
         STOP  =float(NormalizeDouble(ATR*S*0.5,Digits));  // 0.5ATR  1.0ATR  1.5ATR  2.0ATR  2.5ATR  3.0ATR  3.5ATR  4ATR  4.5ATR
         PROFIT=float(NormalizeDouble(ATR*MathPow((P+2),1.8)*0.1,Digits));  // 0.7ATR  1.2ATR  1.8ATR  2.5ATR  3.3ATR  4.2ATR  5.2ATR  6.3ATR  7.5ATR 
         DELTA =float(NormalizeDouble(ATR*D*0.5,Digits));  // 0.5ATR  1.0ATR  1.5ATR  2.0ATR  2.5ATR 
         if (Up>0) {setBUY.Val=float(Open[0]+Spred+DELTA);   setBUY.Stp=setBUY.Val-STOP;   if (P>0 && P<10) setBUY.Prf=setBUY.Val +PROFIT;}  // ask и bid формируем из Open[0],
         if (Dn>0) {setSEL.Val=float(Open[0]-DELTA);         setSEL.Stp=setSEL.Val+STOP;   if (P>0 && P<10) setSEL.Prf=setSEL.Val-PROFIT;} // чтоб отложники не зависели от шустрых движух   
      break;
      case  2: // по ФИБО уровням       
         if (Up>0){
            setBUY.Val =Fibo( D);  
            setBUY.Stp =Fibo( D-S); //Print("Up>0 setBUY.Val=",setBUY.Val," BUY.Val=",BUY.Val+BUYSTOP+BUYLIMIT);
            //if (MathAbs(setBUY.Val-Open[0])>OrdLim) setBUY.Val=0; // чтобы ордер не уходил далеко
            if (setBUY.Val-setBUY.Stp>StpLim) setBUY.Stp=setBUY.Val-StpLim; // проверка стопа на дальность
            if (P>0 && P<10){
               setBUY.Prf =Fibo( D+P);
               if (setBUY.Prf-setBUY.Val>StpLim) setBUY.Prf=setBUY.Val+StpLim;  // проверка профита на дальность
            }  }   
         if (Dn>0){
            setSEL.Val=Fibo(-D);  
            setSEL.Stp=Fibo(-D+S); //Print("Dn>0 setSEL.Val=",setSEL.Val," SELL=",SEL.Val+SELLSTOP+SELLLIMIT);//Print("setSEL.Val=",setSEL.Val," setSEL.Stp=",setSEL.Stp, " OrdLim=",OrdLim," setSEL.Val-Open[0]=",setSEL.Val-Open[0]," Open[0]-setSEL.Val=",Open[0]-setSEL.Val);
            //if (MathAbs(setSEL.Val-Open[0])>OrdLim) setSEL.Val=0; // чтобы ордер не уходил далеко
            if (setSEL.Stp-setSEL.Val>StpLim) setSEL.Stp=setSEL.Val+StpLim; // проверка стопа на дальность  
            if (P>0 && P<10){
               setSEL.Prf=Fibo(-D-P);
               if (setSEL.Val-setSEL.Prf>StpLim) setSEL.Prf=setSEL.Val-StpLim;  // проверка профита на дальность
            }  }    
      break;
      case 3:
         DELTA =float(NormalizeDouble(MathAbs(D)*ATR*0.5,Digits));  // 0.5ATR  1.0ATR  1.5ATR  2.0ATR  2.5ATR 
         STOP  =float(NormalizeDouble(ATR*S*0.5,Digits));  // 0.5ATR  1.0ATR  1.5ATR  2.0ATR  2.5ATR  3.0ATR  3.5ATR  4ATR  4.5ATR
         PROFIT=float(NormalizeDouble(ATR*MathPow((P+2),1.8)*0.1,Digits));  // 0.7ATR  1.2ATR  1.8ATR  2.5ATR  3.3ATR  4.2ATR  5.2ATR  6.3ATR  7.5ATR 
         if (Up>0){
            if (D<0) setBUY.Val=LO-DELTA+float(ATR*1.5);// LO: +1.0ATR  +0.5ATR  +0ATR  -0.5ATR  -1.0ATR
            else     setBUY.Val=HI+DELTA-ATR;    // HI: -1.0ATR  -0.5ATR  +0ATR  +0.5ATR  +1.0ATR  +1.5ATR
            setBUY.Stp =setBUY.Val-STOP;  if (P>0 && P<10) setBUY.Prf =setBUY.Val +PROFIT;
            }
         if (Dn>0){
            if (D<0) setSEL.Val=HI+DELTA-float(ATR*1.5);    // HI: -1.0ATR  -0.5ATR  +0ATR  +0.5ATR  +1.0ATR
            else     setSEL.Val=LO-DELTA+ATR;        // LO: +1.0ATR  +0.5ATR  +0ATR  -0.5ATR  -1.0ATR  -1.5ATR
            setBUY.Stp =setSEL.Val+STOP;  if (P>0 && P<10) setSEL.Prf =setSEL.Val -PROFIT;    
            }
      break;   
      }             
   if (setBUY.Val>0){  // 
      //if (setBUY.Val-setBUY.Stp<StopLevel || setBUY.Prf-setBUY.Val<StopLevel){      
      //   REPORT("Stop too close to OpenPrice, signal is blocked!!");
      //   setBUY.Val=0;
      //   }
      if (Del==1){   // при появлении нового сигнала удаляем старый ордер;       Print("setBUY=",setBUY," BUYSTOP=",BUYSTOP," setBUY-BUYSTOP=",setBUY-BUYSTOP," StopLevel=",StopLevel);
         if (BUYSTP>0 && MathAbs(setBUY.Val-BUYSTP)>StopLevel && BUYSTP!=RevBUY)  BUYSTP=0;     // если старый ордер далеко от нового
         if (BUYLIM>0 && MathAbs(setBUY.Val-BUYLIM)>StopLevel)                    BUYLIM=0;     // то удаляем его, если нет, оставим
         }
      if (Del==2){   // при появлении нового сигнала удаляем противоположный или если ордер остался один;
         if (SEL.Val>0 && Ask<SEL.Val-Present) SEL.Val=0; // если есть селл, и он достаточно прибылен, закрываем его
         if (setSEL.Val==0 && SELSTP>0 && SELSTP!=RevSELL)   SELSTP=0;   // если есть противоположный отложник и сигналы не одновременные, т.е. чтоб не пришлось тут же его восстанавливать 
         if (setSEL.Val==0 && SELLIM>0)                      SELLIM=0; 
      }  }
   if (setSEL.Val>0){  // 
      //if (setSEL.Stp-setSEL.Val<StopLevel || setSEL.Val-setSEL.Prf<StopLevel){    
      //   REPORT("Stop too close to OpenPrice, signal is blocked!!");
      //   setSEL.Val=0;
      //   }
      if (Del==1){//Print("SELLSTOP=",SELLSTOP," SELLLIMIT=",SELLLIMIT);
         if (SELSTP>0 && MathAbs(setSEL.Val-SELSTP)>StopLevel && SELSTP!=RevSELL)   SELSTP=0; 
         if (SELLIM>0 && MathAbs(setSEL.Val-SELLIM)>StopLevel)                      SELLIM=0;  
         }
      if (Del==2){
         if (BUY.Val>0 && Bid>BUY.Val+Present) BUY.Val=0;
         if (setBUY.Val==0 && BUYSTP>0  && BUYSTP!=RevBUY)  BUYSTP=0;  
         if (setBUY.Val==0 && BUYLIM>0)                     BUYLIM=0;   
      }  }
   if (BUY.Val!=0 || BUYSTP!=0 || BUYLIM!=0) setBUY.Val=0;  // если остались старые ордера, новые не выставляем 
   if (SEL.Val!=0 || SELSTP!=0 || SELLIM!=0) setSEL.Val=0; 
   ERROR_CHECK("Input");
   }
//ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
//ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ





//ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
//ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
float Fibo(int FiboLevel){ // Считаем ФИБУ:  Разбиваем диапазон HL   0   11.8   23.6   38.2  50  61.8   76.4  88.2   100 
   double Fib=0;
   switch(FiboLevel){
      case 16: Fib= (HI-LO)*2.500; break;
      case 15: Fib= (HI-LO)*2.382; break;
      case 14: Fib= (HI-LO)*2.236; break;
      case 13: Fib= (HI-LO)*2.118; break;
      case 12: Fib= (HI-LO)*2.000; break;
      case 11: Fib= (HI-LO)*1.882; break;
      case 10: Fib= (HI-LO)*1.764; break;
      case  9: Fib= (HI-LO)*1.618; break;
      case  8: Fib= (HI-LO)*1.500; break;
      case  7: Fib= (HI-LO)*1.382; break;
      case  6: Fib= (HI-LO)*1.236; break;
      case  5: Fib= (HI-LO)*1.118; break;
      case  4: Fib= (HI-LO)*1.000; break; // Hi
      case  3: Fib= (HI-LO)*0.882; break;
      case  2: Fib= (HI-LO)*0.764; break; 
      case  1: Fib= (HI-LO)*0.618; break; // Золотое сечение
      case  0: Fib= (HI-LO)*0.500; break; 
      case -1: Fib= (HI-LO)*0.382; break; // Золотое сечение 
      case -2: Fib= (HI-LO)*0.236; break;
      case -3: Fib= (HI-LO)*0.118; break; 
      case -4: Fib= (HI-LO)*0;     break; // Lo   
      case -5: Fib=-(HI-LO)*0.118; break; 
      case -6: Fib=-(HI-LO)*0.236; break;
      case -7: Fib=-(HI-LO)*0.382; break; 
      case -8: Fib=-(HI-LO)*0.500; break; 
      case -9: Fib=-(HI-LO)*0.618; break; 
      case-10: Fib=-(HI-LO)*0.764; break;
      case-11: Fib=-(HI-LO)*0.882; break;
      case-12: Fib=-(HI-LO)*1.000; break;
      case-13: Fib=-(HI-LO)*1.118; break;
      case-14: Fib=-(HI-LO)*1.236; break;
      case-15: Fib=-(HI-LO)*1.382; break;
      case-16: Fib=-(HI-LO)*1.500; break;
      } //Print("Fibo: HI=",S4(HI)," LO=",S4(LO));
   return( float(NormalizeDouble(LO+Fib,Digits)) );
   }


   
   
         
         
         
         
         
         
         
         
      

