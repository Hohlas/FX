


void SIG_TURTLE(){
   // УДАЛЕНИЕ ОТЛОЖНИКА ПРИ "ПЕРЕДЫШКЕ" ЦЕНЫ ПЕРЕД НИМ
   //if (Update==True){
      if (SELSTP>0 && High[bar]>setSEL.Mem) {setSEL.Sig=0; SELSTP=0;} // повторный пробой пробивающего пика (ложняк пробился), 
      if (BUYSTP>0  && Low [bar]<setBUY.Mem) {setBUY.Sig=0; BUYSTP=0;} // отменяем сигнал
      
      if (BrokenPic>0 && // номер последнего пробитого пика
         F[BrokenPic].Back>=ATR*Power && // с достаточным отскоком
         F[BrokenPic].TrBrk >-1 &&  // сформированным трендовым уровнем
         F[BrokenPic].Per>FltLen*5 && SHIFT(F[BrokenPic].T)>FltLen){   // период последнего пробитого пика достаточно велик и с момента его формирования до пробоя больше FltLen бар
         
         if (F[BrokenPic].Dir>0){// пробита вершина
            setSEL.Sig=WAIT; // ждем окончания формирования пробивающего пика
            setSEL.T=Time[bar];         // время пробивающего бара
            setSEL.Mem=F[BrokenPic].P;  // значение пробитой вершины
            if (D>-2) {BUY_PRICE(F[lo].P);}// низ зоны продажи
            else     setSEL.Val=F[BrokenPic].P+DELTA(D+2);  // стоп ордер на возврат к пробитой вершине 
            setSEL.Prf=setSEL.Val-ATR*5; 
            //V(" Per="+S0(F[BrokenPic].Per)+" Shift="+S0(SHIFT(F[BrokenPic].T)), H, bar, clrRed);
            LINE(" ", SHIFT(F[BrokenPic].T),F[BrokenPic].P, bar,H, clrGray,0); 
         }else{// пробитая впадина
            setBUY.Sig=WAIT;
            setBUY.T=Time[bar];
            if (D>-2) {SELL_PRICE(F[hi].P);}     // последняя вершинка, из которой был выстрел
            else     setBUY.Val=F[BrokenPic].P-DELTA(D+2); // пробитая впадина
            setBUY.Prf=setBUY.Val+ATR*5;
            //A(" Per="+S0(F[BrokenPic].Per)+" Shift="+S0(SHIFT(F[BrokenPic].T)), L, bar, clrBlue);
            LINE("  Tbuy="+DTIME(setBUY.T)+" New="+S4(setBUY.Val), SHIFT(F[BrokenPic].T),F[BrokenPic].P, bar,L, clrGray,0);
            }
         }
      if (setSEL.Sig==WAIT && F[hi].T>=setSEL.T){  // дождались формирования пробивающего пика
         setSEL.Sig=GOGO;    // сигнал на открытие позы
         setSEL.Mem=F[hi].P; // запомним теперь значение пробивающей вершины
         setSEL.Stp=F[hi].P;  // за первый пик
         V(" GOGO Mem="+S4(setSEL.Mem), F[hi].P, SHIFT(F[hi].T), clrRed);
         }
      if (setBUY.Sig==WAIT && F[lo].T>=setBUY.T){ 
         setBUY.Sig=GOGO;
         setBUY.Mem=F[lo].P; // запомним значение пробивающей впадины
         setBUY.Stp=F[lo].P;  // за первый пик
         A(" GOGO Mem="+S4(setBUY.Mem), F[lo].P, SHIFT(F[lo].T), clrBlue);
         }       
   //if (Real) ERROR_CHECK("SIG_TURTLE");
   }
