void TrailingStop(){   // Подвигаем трейлинги:  
   if (TS<0) return;
   float TrlBuy=0, TrlSell=0, STOP=0;
   
   switch (Iprice){  // трейлинг согласно расчету цен входов: 
      case  0:  // StpHi / StpLo
         TrlBuy  = N5(StpLo-StpDelta*ATR); // стоп ниже LO на: 0.4  0.9 
         TrlSell = N5(StpHi+StpDelta*ATR);
      break;   
      case  1:  // по рынку, все расчеты через ATR          
         STOP=N5(ATR*S*0.5);
         TrlBuy =float(Low [1])-STOP;   
         TrlSell=float(High[1])+STOP;   
      break;
      case  2: // по ФИБО уровням       
         TrlBuy =Fibo( D-S); //Print("Up>0 setBUY.Val=",setBUY.Val," BUY.Val=",BUY.Val+BUYSTOP+BUYLIMIT);
         TrlSell=Fibo(-D+S); //Print("Dn>0 setSEL.Val=",setSEL.Val," SELL=",SEL.Val+SELLSTOP+SELLLIMIT);//Print("setSEL.Val=",setSEL.Val," setSEL.Stp=",setSEL.Stp, " OrdLim=",OrdLim," setSEL.Val-Open[0]=",setSEL.Val-Open[0]," Open[0]-setSEL.Val=",Open[0]-setSEL.Val);   
      break;
      case 3: // HI / LO
         STOP=N5((MathAbs(D)+1)*ATR*0.4); // 0.4 0.8 1.2 1.6 2.0 2.4
         if (D>0){
            TrlBuy =HI-STOP; 
            TrlSell=LO+STOP;
         }else{   
            TrlBuy =LO-STOP;    
            TrlSell=HI+STOP; 
            }
      break;   
      }                  
   if (TM>0 && Tm>0){   
      float temp;
      switch (TM){ // модификации трейлингов
         case 1:  // чем дальше от входа, тем меньше трал Tm = 0..4
            if (TrlBuy>BUY.Val)  TrlBuy=TrlBuy+float(NormalizeDouble((TrlBuy-BUY.Val)*Tm*Tm*0.1,Digits));    // 0.1  0.4  0.9  1.6  от прибыли
            if (TrlSell<SEL.Val) TrlSell=TrlSell-float(NormalizeDouble((SEL.Val-TrlSell)*Tm*Tm*0.1,Digits)); 
            break;
         case 2:  // перемещение с заданным шагом
            temp=float(ATR*Tm*0.1); // Шаг трейлинга = ATR * 0.3  0.6  0.9  1.2
            if (TrlBuy-BUY.Stp<temp)    TrlBuy=BUY.Stp;
            if (SEL.Stp-TrlSell<temp)  TrlSell=SEL.Stp;   
            break;
         case 3:  // постепенное перемещение стопа к новому значению
            if (TrlBuy>BUY.Stp)  TrlBuy=BUY.Stp+float(NormalizeDouble((TrlBuy-BUY.Stp)*Tm*Tm*0.1,Digits));  // 0.1  0.4  0.9  1.6 
            if (TrlSell<SEL.Stp) TrlSell=SEL.Stp-float(NormalizeDouble((SEL.Stp-TrlSell)*Tm*Tm*0.1,Digits));
            break;
      }  }           
   if (BUY.Val>0  && TrlBuy>BUY.Stp   && ((TrlBuy>BUY.Val && TrlBuy<Bid-StopLevel) || TS==0))   BUY.Stp=TrlBuy;
   if (SEL.Val>0 && TrlSell<SEL.Stp && ((TrlSell<SEL.Val && TrlSell>Ask+StopLevel) || TS==0))   SEL.Stp=TrlSell; //{Print("SELL=",SEL.Val," TrlSell=",TrlSell);} 
   ERROR_CHECK("Trailing");
   }
   
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ 
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ   

void TrailingProfit(){ // модификации профита (профитТаргет тока приближается к цене открытия)  
   if (PM==0) return;
   float NewProfitBuy=0, NewProfitSell=0, temp, Mid1=0, Mid2=0;
   switch (PM){
      case 1: // обычный профит таргет + если цена провалится от максимальнодостигнутого на xATR, то выставляем профит на максимальнодостигнутый уровень
         temp=ATR*Pm; // 1  2  3  4
         if (BUY.Val>0  && MaxFromBuy-Low[1]>temp)    NewProfitBuy=MaxFromBuy; 
         if (SEL.Val>0 && High[1]-MinFromSell>temp)   NewProfitSell=MinFromSell; 
      break; 
      case 2: // приближение ПрофитТаргета при каждом откате цены против сделки но не ниже максимальнодостигнутой в сделке цены
         Mid1=float(NormalizeDouble((High[1]+Low[1]+Close[1])/3,Digits));
         Mid2=float(NormalizeDouble((High[2]+Low[2]+Close[2])/3,Digits));
         temp=float(NormalizeDouble((Mid2-Mid1)*(Pm+1)*(Pm+1)*0.1,Digits)); // 0.4  0.9  1.6  2.5
         if (BUY.Val>0 && temp>0){// если был обратный откат
            if (BUY.Prf==0) BUY.Prf=MaxFromBuy;
            if (BUY.Prf-temp>MaxFromBuy) NewProfitBuy=BUY.Prf-temp; // двигаем профит не ниже максимальнодостигнутой в сделке цены                              
            }  
         if (SEL.Val>0 &&  temp<0){
            if (SEL.Prf==0) SEL.Prf=MinFromSell; 
            if (SEL.Prf-temp<MinFromSell) NewProfitSell=SEL.Prf-temp; // не двигаем профит выше минимальнодостигнутой в сделке цены
            }
      break; 
      case 3: // как в п.2: приближение ПрофитТаргета при каждом откате цены против сделки, но профит двигается ниже открытия
         temp=float(NormalizeDouble((Mid2-Mid1)*(Pm+1)*(Pm+1)*0.1,Digits)); // 0.4  0.9  1.6  2.5
         if (BUY.Val>0 && temp>0){// если был обратный откат
            if (BUY.Prf==0) BUY.Prf=MaxFromBuy; 
            NewProfitBuy=BUY.Prf-temp; // двигаем профит не ниже цены открытия               
            }
         if (SEL.Val>0 && temp<0){
            if (SEL.Prf==0) SEL.Prf=MinFromSell;  
            NewProfitSell=SEL.Prf-temp; 
            }  
      break;
      }
   if (NewProfitBuy>0   && (NewProfitBuy<BUY.Prf   || BUY.Prf==0))  BUY.Prf=NewProfitBuy;
   if (NewProfitSell>0  && (NewProfitSell>SEL.Prf || SEL.Prf==0)) SEL.Prf=NewProfitSell;
   ERROR_CHECK("TrailingProfit");
   }  
   
    
   
              