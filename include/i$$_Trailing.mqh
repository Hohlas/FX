void TRAILING_STOP(){   // Подвигаем трейлинги:  
   if (TS<0) return;
   float TrlBuy=0, TrlSell=0, STOP=0;
   
   switch (Iprice){  // трейлинг согласно расчету цен входов: 
      case  0: // StpHi / StpLo
         if (D<0) STOP=N5(0.9*ATR); else STOP=N5(0.4*ATR); // 
         TrlBuy  = N5(StpLo-STOP); // стоп ниже LO на: 0.4  0.9 
         TrlSell = N5(StpHi+STOP);
      break;   
      case  1: // по рынку, все расчеты через ATR          
         STOP  =N5(ATR*(S+1)*0.5);  //  1.0ATR  1.5ATR  2.0ATR  2.5ATR  3.0ATR  3.5ATR  4ATR  4.5ATR
         TrlBuy =float(Low [1])-STOP;   
         TrlSell=float(High[1])+STOP;   
      break;
      case  2: // по ФИБО уровням       
         TrlBuy =Fibo( D-S); //Print("Up>0 setBUY.Val=",setBUY.Val," BUY.Val=",BUY.Val+BUYSTOP+BUYLIMIT);
         TrlSell=Fibo(-D+S); //Print("Dn>0 setSEL.Val=",setSEL.Val," SELL=",SEL.Val+SELLSTOP+SELLLIMIT);//Print("setSEL.Val=",setSEL.Val," setSEL.Stp=",setSEL.Stp, " OrdLim=",OrdLim," setSEL.Val-Open[0]=",setSEL.Val-Open[0]," Open[0]-setSEL.Val=",Open[0]-setSEL.Val);   
      break;
      case 3:  // HI / LO
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
   LINE("TrlBuy",  bar,TrlBuy,  bar+1,TrlBuy,  clrDarkGray,0);
   LINE("TrlSell", bar,TrlSell, bar+1,TrlSell, clrDarkGray,0);                    
   if (BUY.Val>0  && TrlBuy>BUY.Stp   && ((TrlBuy>BUY.Val && TrlBuy<Bid-StopLevel) || TS==0)){
      LINE("TrlBuy", bar,TrlBuy, bar+1,TrlBuy, clrBlack,1);
      BUY.Stp=TrlBuy;}
   if (SEL.Val>0 && TrlSell<SEL.Stp && ((TrlSell<SEL.Val && TrlSell>Ask+StopLevel) || TS==0)){
      LINE("TrlSell", bar,TrlSell, bar+1,TrlSell, clrBlack,1);
      SEL.Stp=TrlSell;} //{Print("SELL=",SEL.Val," TrlSell=",TrlSell);} 
   ERROR_CHECK("TRAILING_STOP");
   }
   
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ 
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ   

void TRAILING_PROFIT(){ // модификации профита (профитТаргет тока приближается к цене открытия)  
   if (!PM1 && !PM2) return;
   float NewProfitBuy=0, NewProfitSel=0;
   if (PM1){// приближение профита при каждом откате
      float BuyBack=N5((High[2]-High[1])*(PM2+1)*(PM2+1)*0.1); // 0.4  0.9  1.6  2.5
      float SelBack=N5((Low [1]-Low [2])*(PM2+1)*(PM2+1)*0.1); // 0.4  0.9  1.6  2.5
      if (BUY.Val>0 && BuyBack>0 && SHIFT(BuyTime)>1){// если был обратный откат
         if (BUY.Prf==0) BUY.Prf=MaxFromBuy;
         if (BUY.Prf-BuyBack>BUY.Val) NewProfitBuy=BUY.Prf-BuyBack;  else  NewProfitBuy=BUY.Val;// двигаем профит не ниже максимальнодостигнутой в сделке цены                              
         //V("NewProfitBuy "+S0(SHIFT(BuyTime)), NewProfitBuy, bar, clrMagenta);
         }  
      if (SEL.Val>0 &&  SelBack>0 && SHIFT(SellTime)>1){
         if (SEL.Prf==0) SEL.Prf=MinFromSell; 
         if (SEL.Prf+SelBack<SEL.Val) NewProfitSel=SEL.Prf+SelBack; else  NewProfitSel=SEL.Val;// не двигаем профит выше минимальнодостигнутой в сделке цены
         //A("NewProfitSel "+S0(SHIFT(SellTime)), NewProfitSel, bar, clrMagenta);
      }  }
   if (PM2){// если цена провалится от максимальнодостигнутого на xATR, выставляется тейк на максимальнодостигнутый уровень
      float temp=ATR*(PM1+1); // 2  3  4  
      if (BUY.Val>0 && MaxFromBuy-Low [1] >temp && (BUY.Prf>MaxFromBuy  || BUY.Prf==0))   {NewProfitBuy=MaxFromBuy;}   //     V("MaxFromBuy", MaxFromBuy, bar, clrRed);
      if (SEL.Val>0 && High[1]-MinFromSell>temp && (SEL.Prf<MinFromSell || SEL.Prf==0))   {NewProfitSel=MinFromSell;}  //     A("MinFromSell", MinFromSell, bar, clrRed);
      }  
   if (NewProfitBuy>0   && (NewProfitBuy <BUY.Prf || BUY.Prf==0)) BUY.Prf=NewProfitBuy;
   if (NewProfitSel>0  && (NewProfitSel>SEL.Prf || SEL.Prf==0)) SEL.Prf=NewProfitSel;
   ERROR_CHECK("TRAILING_PROFIT");
   }  
   
    
   
              