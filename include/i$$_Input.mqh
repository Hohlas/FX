void Input(){ // Ф И Л Ь Т Р Ы    В Х О Д А    ///////////////////////////////////////////////////////
   if (BUY.Val && SEL.Val) return;
   Signal(1,TR,TRk); // Signal (int SigMode, int SigType, int Sk, int bar) = Расчет направления тренда
   if (TR<0)   {bool k=Up; Up=Dn; Dn=k;} // реверснем сигналы
   if (OTr){// пропадание сигнала тренда (удаляем отложники, закрываем позы (в Output())
      if (!Up) {BUYSTP=0;  BUYLIM=0;}
      if (!Dn) {SELSTP=0;  SELLIM=0;}
      }  
   
   SIG_LINES(Up, "TrUp", Dn, "TrDn", clrGreen);
   bool TrUp=(Up && !BUY.Val);  
   bool TrDn=(Dn && !SEL.Val);
   if (!TrUp && !TrDn) return;  
   
   Signal(2,IN,Ik); // Signal (int SigMode, int SigType, int Sk, int bar) // Обработка сигналов входа  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   if (IN<0)   {bool k=Up; Up=Dn; Dn=k;} // реверснем сигналы
   SIG_LINES(Up, "SigUp", Dn, "SigDn", clrRed);
   Up=(Up && TrUp); 
   Dn=(Dn && TrDn);  
   if (!Up && !Dn) return; // Print(" Up=",Up," Dn=",Dn);   
   float STOP=0, PROFIT=0, DELTA=0, 
         OrdLim=N5(ATR*7),
         StpLim=N5(ATR*8); // максимальный стоп ограничим в 7.5 часовых ATR. 60/Period()-нормализация ATR к часовкам, чтобы на всех ТФ максимальный стоп был примерно одинаковым
   switch (Iprice){  // расчет цены входов: 
      case  0:  // StpHi / StpLo
         if (D<0) DELTA=N5(0.9*ATR); else DELTA=N5(0.4*ATR); // 
         if (Up){    //LINE("StpLo", bar,StpLo, bar+1,StpLo, clrBlack,0);
            setBUY.Stp = N5(StpLo-DELTA); // стоп ниже LO на 0.4  0.9:   if (D<0) StpDelta=0.9; else StpDelta=0.4;
            setBUY.Val = N5(setBUY.Stp+N5(ATR*(MathAbs(D)+2)*0.5));  // Buy выше Stp на:  1  1.5  2  2.5  3  3.5
            setBUY.Prf = N5(setBUY.Val+(setBUY.Val-setBUY.Stp)*P);
            }
         if (Dn){    //LINE("StpHi", bar,StpHi, bar+1,StpHi, clrBlack,0);
            setSEL.Stp = N5(StpHi+DELTA);
            setSEL.Val = N5(setSEL.Stp-N5(ATR*(MathAbs(D)+2)*0.5));
            setSEL.Prf = N5(setSEL.Val-(setSEL.Stp-setSEL.Val)*P);
            }
      break;         
      case  1:  // по рынку, все расчеты через ATR          
         STOP  =N5(ATR*(S+1)*0.5);  //  1.0ATR  1.5ATR  2.0ATR  2.5ATR  3.0ATR  3.5ATR  4ATR  4.5ATR
         PROFIT=N5(ATR*MathPow((P+2),1.8)*0.1);  // 0.7ATR  1.2ATR  1.8ATR  2.5ATR  3.3ATR  4.2ATR  5.2ATR  6.3ATR  7.5ATR 
         DELTA =N5(ATR*D*0.5);  // 0.5ATR  1.0ATR  1.5ATR  2.0ATR  2.5ATR 
         if (Up>0) {setBUY.Val=float(Open[0]+Spred+DELTA);   setBUY.Stp=setBUY.Val-STOP;   setBUY.Prf=setBUY.Val+PROFIT;}  // ask и bid формируем из Open[0],
         if (Dn>0) {setSEL.Val=float(Open[0]-DELTA);         setSEL.Stp=setSEL.Val+STOP;   setSEL.Prf=setSEL.Val-PROFIT;} // чтоб отложники не зависели от шустрых движух   
      break;
      case  2: // по ФИБО уровням       
         if (Up){
            setBUY.Val =Fibo( D);  
            setBUY.Stp =Fibo( D-S);   
            setBUY.Prf =Fibo( D+P);    
            }     
         if (Dn){
            setSEL.Val=Fibo(-D);  
            setSEL.Stp=Fibo(-D+S);       
            setSEL.Prf=Fibo(-D-P);     
            } 
         //LINE("FIBO Buy", bar,setBUY.Val, bar+1,setBUY.Val, clrWhite,0);  LINE("FIBO BuyStp", bar,setBUY.Stp, bar+1,setBUY.Stp, clrRed,3);  LINE("FIBO BuyPrf", bar,setBUY.Prf, bar+1,setBUY.Prf, clrYellow,0); 
         //LINE("FIBO Sel", bar,setSEL.Val, bar+1,setSEL.Val, clrWhite,0);  LINE("FIBO SelStp", bar,setSEL.Stp, bar+1,setSEL.Stp, clrRed,3);  LINE("FIBO SelPrf", bar,setSEL.Prf, bar+1,setSEL.Prf, clrYellow,0);         
      break;
      case 3:
         DELTA=N5((MathAbs(D)+1)*ATR*0.4); // 0.4 0.8 1.2 1.6 2.0 2.4
         STOP =N5(ATR*S*0.5);              // 0.5ATR  1.0ATR  1.5ATR  2.0ATR  2.5ATR  3.0ATR  3.5ATR  4ATR  4.5ATR
         PROFIT=N5(ATR*(P-4)); //  
         if (Up){
            if (D>0){ // пробой HI
               setBUY.Stp = N5(HI-DELTA);  // 0.8 1.2 1.6 2.0 2.4   
               setBUY.Val = N5(setBUY.Stp+STOP);// 
               setBUY.Prf = N5(setBUY.Val+(setBUY.Val-setBUY.Stp)*(P+1)*0.5); // процент от стопа  1  1.5 ... 5
            }else{   // откат к LO
               setBUY.Stp = N5(LO-DELTA);  // 0.4 0.8 1.2 1.6 2.0 2.4
               setBUY.Val = N5(setBUY.Stp+STOP);
               //setBUY.Prf = MathMax(HI+PROFIT, N5(setBUY.Val+(setBUY.Val-setBUY.Stp)*0.5)); // на верхней границе, но не меньше стопа 
               setBUY.Prf = N5(HI+PROFIT);    if (setBUY.Prf<setBUY.Val+(setBUY.Val-setBUY.Stp)) setBUY.Val=0;
            }  }
         if (Dn){
            if (D>0){
               setSEL.Stp = N5(LO+DELTA);
               setSEL.Val = N5(setSEL.Stp-STOP);
               setSEL.Prf = N5(setSEL.Val-(setSEL.Stp-setSEL.Val)*(P+1)*0.5);
            }else{     
               setSEL.Stp = N5(HI+DELTA);
               setSEL.Val = N5(setSEL.Stp-STOP);  
               //setSEL.Prf = MathMin(LO-PROFIT, N5(setSEL.Val-(setSEL.Stp-setSEL.Val)*0.5));
               setSEL.Prf = N5(LO-PROFIT);    if (setSEL.Prf>setSEL.Val-(setSEL.Stp-setSEL.Val)) setSEL.Val=0;
            }  }
      break;   
      } 
   if (P==0){ // тейк в бесконечность
      setBUY.Prf =0;   
      setSEL.Prf =0;
      }                
   if (setBUY.Val>0){  // 
      if (Del==1){   // при появлении нового сигнала удаляем старый ордер;       Print("setBUY=",setBUY," BUYSTOP=",BUYSTOP," setBUY-BUYSTOP=",setBUY-BUYSTOP," StopLevel=",StopLevel);
         if (BUYSTP>0 && MathAbs(setBUY.Val-BUYSTP)>StopLevel && BUYSTP!=RevBUY)    BUYSTP=0;     // если старый ордер далеко от нового
         if (BUYLIM>0 && MathAbs(setBUY.Val-BUYLIM)>StopLevel)                      BUYLIM=0;     // то удаляем его, если нет, оставим
         }
      if (Del==2){   // при появлении нового сигнала удаляем противоположный или если ордер остался один;
         if (SEL.Val>0 && Ask<SEL.Val)                      SEL.Val=0; // если есть прибыльный селл, закрываем его
         if (setSEL.Val==0 && SELSTP>0 && SELSTP!=RevSELL)  SELSTP=0;  // если есть противоположный отложник и сигналы не одновременные, т.е. чтоб не пришлось тут же его восстанавливать 
         if (setSEL.Val==0 && SELLIM>0)                     SELLIM=0; 
      }  }
   if (setSEL.Val>0){  // 
      if (Del==1){//Print("SELLSTOP=",SELLSTOP," SELLLIMIT=",SELLLIMIT);
         if (SELSTP>0 && MathAbs(setSEL.Val-SELSTP)>StopLevel && SELSTP!=RevSELL)   SELSTP=0; 
         if (SELLIM>0 && MathAbs(setSEL.Val-SELLIM)>StopLevel)                      SELLIM=0;  
         }
      if (Del==2){
         if (BUY.Val>0 && Bid>BUY.Val)                      BUY.Val=0;
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


   
   
         
         
         
         
         
         
         
         
      

