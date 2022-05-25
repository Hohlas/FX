void TrailingStop(){   // ѕодвигаем трейлинги:
   if (T>9 || T==0) return;    
   double TrlBuy=0,TrlSell=0;
   
   temp=NormalizeDouble(atr*(T*T*0.1+1),Digits); // 1.1ATR  1.4ATR  1.9ATR  2.6ATR  3.5ATR  4.6ATR  5.9ATR  7.4ATR  9.1ATR         
   switch (Tk){    
      case 1: // ќбычный
         TrlBuy=High[1]-temp;  
         TrlSell=Low[1]+temp;  
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
   
   switch (TM){ // модификации трейлингов
      case 1:  // чем дальше от входа, тем меньше трал Tm = 0..4
         if (TrlBuy>BUY)   TrlBuy=TrlBuy+NormalizeDouble((TrlBuy-BUY)*Tm*Tm*0.1,Digits);    // 0.1  0.4  0.9  1.6  от прибыли
         if (TrlSell<SELL) TrlSell=TrlSell-NormalizeDouble((SELL-TrlSell)*Tm*Tm*0.1,Digits); 
         break;
      
      case 2:  // перемещение с заданным шагом
         temp=ATR*Tm*Tm*0.1; // Ўаг трейлинга = ATR * 0.1  0.4  0.9  1.6
         if (TrlBuy-STOP_BUY<temp)    TrlBuy=STOP_BUY;
         if (STOP_SELL-TrlSell<temp)  TrlSell=STOP_SELL;   
         break;
      case 3:  // постепенное перемещение стопа к новому значению
         if (TrlBuy>STOP_BUY)   TrlBuy=STOP_BUY+NormalizeDouble((TrlBuy-STOP_BUY)*Tm*Tm*0.1,Digits);  // 0.1  0.4  0.9  1.6 
         if (TrlSell<STOP_SELL) TrlSell=STOP_SELL-NormalizeDouble((STOP_SELL-TrlSell)*Tm*Tm*0.1,Digits);
         break;
      // этот метод нигде не используетс€   
      case 222:  // чем дальше от входа, тем больше трал Tm = 0..4
         if (TrlBuy>BUY)   TrlBuy=TrlBuy-NormalizeDouble((TrlBuy-BUY)*Tm*Tm*0.1,Digits);    // 0.1  0.4  0.9  1.6  от прибыли
         if (TrlSell<SELL) TrlSell=TrlSell+NormalizeDouble((SELL-TrlSell)*Tm*Tm*0.1,Digits); 
         break;      
      }      
   
   // двинем стопы если настала пора   
   if (BUY>0  && TrlBuy>STOP_BUY   && (TrlBuy>BUY   || TS==0))   STOP_BUY=TrlBuy;
   if (SELL>0 && TrlSell<STOP_SELL && (TrlSell<SELL || TS==0))   STOP_SELL=TrlSell;
   }
   
   
   
   
     
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆   

void TrailingProfit(){ // модификации профита (профит“аргет тока приближаетс€ к цене открыти€)  
   if (PM==0) return;
   double NewProfitBuy, NewProfitSell;
   switch (PM){
      case 1: // обычный профит таргет + если цена провалитс€ от максимальнодостигнутого на xATR, то выставл€ем профит на максимальнодостигнутый уровень
         if (BUY>0  && MaxFromBuy-Low[1]>(MaxFromBuy-STOP_BUY)*Pm*0.2)     NewProfitBuy=MaxFromBuy; 
         if (SELL>0 && High[1]-MinFromSell>(STOP_SELL-MinFromSell)*Pm*0.2) NewProfitSell=MinFromSell; 
      break; 
      case 2: // приближение ѕрофит“аргета при каждом откате цены против сделки но не ниже максимальнодостигнутой в сделке цены
         if (BUY>0){
            temp=NormalizeDouble((Mid2-Mid1)*(Pm+1)*(Pm+1)*0.1,Digits); // 0.4  0.9  1.6  2.5
            if (temp>0) { // если был обратный откат
               if (PROFIT_BUY>0){
                  if (PROFIT_BUY-temp>MaxFromBuy) NewProfitBuy=PROFIT_BUY-temp; // двигаем профит не ниже максимальнодостигнутой в сделке цены  
                  }
               else NewProfitBuy=MaxFromBuy;                            
            }  }
         if (SELL>0){
            temp=NormalizeDouble((Mid1-Mid2)*(Pm+1)*(Pm+1)*0.1,Digits);
            if (temp>0) {
               if (PROFIT_SELL>0){ 
                  if (PROFIT_SELL+temp<MinFromSell) NewProfitSell=PROFIT_SELL+temp; // не двигаем профит выше минимальнодостигнутой в сделке цены
                  }
               else NewProfitSell=MinFromSell;   
            }  }
      break; 
      case 3: // как в п.2: приближение ѕрофит“аргета при каждом откате цены против сделки, но профит двигаетс€ ниже MaxFromBuy
         if (BUY>0){
            temp=NormalizeDouble((Mid2-Mid1)*(Pm+1)*(Pm+1)*0.1,Digits); // 0.4  0.9  1.6  2.5
            if (temp>0) { // если был обратный откат
               if (PROFIT_BUY>0){
                  if (PROFIT_BUY-temp>BUY) NewProfitBuy=PROFIT_BUY-temp; // двигаем профит не ниже цены открыти€ 
                  }
               else NewProfitBuy=MaxFromBuy;                            
            }  }
         if (SELL>0){
            temp=NormalizeDouble((Mid1-Mid2)*(Pm+1)*(Pm+1)*0.1,Digits);
            if (temp>0) {
               if (PROFIT_SELL>0){ 
                  if (PROFIT_SELL+temp<SELL) NewProfitSell=PROFIT_SELL+temp; 
                  }
               else NewProfitSell=MinFromSell;   
            }  }
      break;
      }
   if (NewProfitBuy>0   && (NewProfitBuy<PROFIT_BUY   || PROFIT_BUY==0))  PROFIT_BUY=NewProfitBuy;
   if (NewProfitSell>0  && (NewProfitSell>PROFIT_SELL || PROFIT_SELL==0)) PROFIT_SELL=NewProfitSell;
   }  
   
    
   
              