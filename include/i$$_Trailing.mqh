void TrailingStop(){   // Подвигаем трейлинги:
   if (T>9 || T==0) return;    
   float TrlBuy=0,TrlSell=0;
   float temp=float(NormalizeDouble(atr*MathPow((T+3),1.8)*0.1,Digits)); // 1.2ATR  1.8ATR  2.5ATR  3.3ATR  4.2ATR  5.2ATR  6.3ATR  7.5ATR  8.7ATR 
   switch (Tk){    
      case 1: // Обычный
         TrlBuy=float(Close[1])-temp;  
         TrlSell=float(Close[1])+temp;  
      break;   
      case 2:  // CandelStop (Люстра от Чака Лебо)
         TrlBuy =MaxFromBuy-temp;  //Print("MaxFromBuy=",MaxFromBuy," MinFromSell=",MinFromSell); 
         TrlSell=MinFromSell+temp;   
      break;
      case 3: // ФИБЫ  
         TrlBuy =Fibo(4-T);   
         TrlSell=Fibo(T-4);
      break;
      default: // Экстремальнокороткий
         TrlBuy=float(Low[1]);  
         TrlSell=float(High[1]);
      break;    
      }  
   if (TM>0 && Tm>0){   
      switch (TM){ // модификации трейлингов
         case 1:  // чем дальше от входа, тем меньше трал Tm = 0..4
            if (TrlBuy>BUY.Val)   TrlBuy=TrlBuy+float(NormalizeDouble((TrlBuy-BUY.Val)*Tm*Tm*0.1,Digits));    // 0.1  0.4  0.9  1.6  от прибыли
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
   if (BUY.Val>0  && TrlBuy>BUY.Stp   && ((TrlBuy>BUY.Val && TrlBuy<Bid-StopLevel)    || TS==0))   BUY.Stp=TrlBuy;
   if (SEL.Val>0 && TrlSell<SEL.Stp && ((TrlSell<SEL.Val && TrlSell>Ask+StopLevel) || TS==0))   SEL.Stp=TrlSell; //{Print("SELL=",SEL.Val," TrlSell=",TrlSell);} 
   ERROR_CHECK("Trailing");
   }
   
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ 
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ   

void TrailingProfit(){ // модификации профита (профитТаргет тока приближается к цене открытия)  
   if (PM==0) return;
   float NewProfitBuy=0, NewProfitSell=0, temp;
   switch (PM){
      case 1: // обычный профит таргет + если цена провалится от максимальнодостигнутого на xATR, то выставляем профит на максимальнодостигнутый уровень
         temp=ATR*Pm; // 1  2  3  4
         if (BUY.Val>0  && MaxFromBuy-Low[1]>temp)    NewProfitBuy=MaxFromBuy; 
         if (SEL.Val>0 && High[1]-MinFromSell>temp)   NewProfitSell=MinFromSell; 
      break; 
      case 2: // приближение ПрофитТаргета при каждом откате цены против сделки но не ниже максимальнодостигнутой в сделке цены
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
   
    
   
              