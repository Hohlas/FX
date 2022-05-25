void TrailingStop(){   // ѕодвигаем трейлинги:
   if (T>9 || T==0) return;    
   double TrlBuy=0,TrlSell=0;
   temp=NormalizeDouble(atr*MathPow((T+3),1.8)*0.1,Digits); // 1.2ATR  1.8ATR  2.5ATR  3.3ATR  4.2ATR  5.2ATR  6.3ATR  7.5ATR  8.7ATR 
   switch (Tk){    
      case 1: // ќбычный
         TrlBuy=Close[1]-temp;  
         TrlSell=Close[1]+temp;  
      break;   
      case 2:  // CandelStop (Ћюстра от „ака Ћебо)
         TrlBuy =MaxFromBuy-temp;  //Print("MaxFromBuy=",MaxFromBuy," MinFromSell=",MinFromSell); 
         TrlSell=MinFromSell+temp;   
      break;
      case 3: // ‘»Ѕџ  
         TrlBuy =Fibo(4-T);   
         TrlSell=Fibo(T-4);
      break;
      default: // Ёкстремальнокороткий
         TrlBuy=Low[1];  
         TrlSell=High[1];
      break;    
      }  
   if (TM>0 && Tm>0){   
      switch (TM){ // модификации трейлингов
         case 1:  // чем дальше от входа, тем меньше трал Tm = 0..4
            if (TrlBuy>BUY)   TrlBuy=TrlBuy+NormalizeDouble((TrlBuy-BUY)*Tm*Tm*0.1,Digits);    // 0.1  0.4  0.9  1.6  от прибыли
            if (TrlSell<SELL) TrlSell=TrlSell-NormalizeDouble((SELL-TrlSell)*Tm*Tm*0.1,Digits); 
            break;
         case 2:  // перемещение с заданным шагом
            temp=ATR*Tm*0.1; // Ўаг трейлинга = ATR * 0.3  0.6  0.9  1.2
            if (TrlBuy-STOP_BUY<temp)    TrlBuy=STOP_BUY;
            if (STOP_SELL-TrlSell<temp)  TrlSell=STOP_SELL;   
            break;
         case 3:  // постепенное перемещение стопа к новому значению
            if (TrlBuy>STOP_BUY)   TrlBuy=STOP_BUY+NormalizeDouble((TrlBuy-STOP_BUY)*Tm*Tm*0.1,Digits);  // 0.1  0.4  0.9  1.6 
            if (TrlSell<STOP_SELL) TrlSell=STOP_SELL-NormalizeDouble((STOP_SELL-TrlSell)*Tm*Tm*0.1,Digits);
            break;
      }  }  
   temp=StopLevel+Spred;          
   if (BUY>0  && TrlBuy>STOP_BUY   && ((TrlBuy>BUY && TrlBuy<Bid-temp)    || TS==0))   STOP_BUY=TrlBuy;
   if (SELL>0 && TrlSell<STOP_SELL && ((TrlSell<SELL && TrlSell>Ask+temp) || TS==0))   STOP_SELL=TrlSell; //{Print("SELL=",SELL," TrlSell=",TrlSell);} 
   }
   
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆ 
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆   

void TrailingProfit(){ // модификации профита (профит“аргет тока приближаетс€ к цене открыти€)  
   if (PM==0) return;
   double NewProfitBuy, NewProfitSell;
   switch (PM){
      case 1: // обычный профит таргет + если цена провалитс€ от максимальнодостигнутого на xATR, то выставл€ем профит на максимальнодостигнутый уровень
         temp=ATR*Pm; // 1  2  3  4
         if (BUY>0  && MaxFromBuy-Low[1]>temp)     NewProfitBuy=MaxFromBuy; 
         if (SELL>0 && High[1]-MinFromSell>temp)   NewProfitSell=MinFromSell; 
      break; 
      case 2: // приближение ѕрофит“аргета при каждом откате цены против сделки но не ниже максимальнодостигнутой в сделке цены
         temp=NormalizeDouble((Mid2-Mid1)*(Pm+1)*(Pm+1)*0.1,Digits); // 0.4  0.9  1.6  2.5
         if (BUY>0 && temp>0){// если был обратный откат
            if (PROFIT_BUY==0) PROFIT_BUY=MaxFromBuy;
            if (PROFIT_BUY-temp>MaxFromBuy) NewProfitBuy=PROFIT_BUY-temp; // двигаем профит не ниже максимальнодостигнутой в сделке цены                              
            }  
         if (SELL>0 &&  temp<0){
            if (PROFIT_SELL==0) PROFIT_SELL=MinFromSell; 
            if (PROFIT_SELL-temp<MinFromSell) NewProfitSell=PROFIT_SELL-temp; // не двигаем профит выше минимальнодостигнутой в сделке цены
            }
      break; 
      case 3: // как в п.2: приближение ѕрофит“аргета при каждом откате цены против сделки, но профит двигаетс€ ниже открыти€
         temp=NormalizeDouble((Mid2-Mid1)*(Pm+1)*(Pm+1)*0.1,Digits); // 0.4  0.9  1.6  2.5
         if (BUY>0 && temp>0){// если был обратный откат
            if (PROFIT_BUY==0) PROFIT_BUY=MaxFromBuy; 
            NewProfitBuy=PROFIT_BUY-temp; // двигаем профит не ниже цены открыти€               
            }
         if (SELL>0 && temp<0){
            if (PROFIT_SELL==0) PROFIT_SELL=MinFromSell;  
            NewProfitSell=PROFIT_SELL-temp; 
            }  
      break;
      }
   if (NewProfitBuy>0   && (NewProfitBuy<PROFIT_BUY   || PROFIT_BUY==0))  PROFIT_BUY=NewProfitBuy;
   if (NewProfitSell>0  && (NewProfitSell>PROFIT_SELL || PROFIT_SELL==0)) PROFIT_SELL=NewProfitSell;
   }  
   
    
   
              