uchar OutGlob, OutLoc, OutImp; // бинарные константы сформированные из входной переменной Out
void OUTPUT(){
   if (Out==0) return;
   SetPROFIT_BUY=0;  SetPROFIT_SELL=0; // значени€ тейков дл€ обновлени€ ордеров 
   switch (oPrice){// закрываемс€ при пропадании сигналов от входных фильтров MovUP и MovDN  
      case 1:  SetPROFIT_BUY=Bid;  // немедленное закрытие 
               SetPROFIT_SELL=Ask;  break; // позы
      case 2:  CHOOSE_PROFIT(0);    break; //  перемещение тейка на ближайший уровень   (1-открытие, 0-модификаци€ позы) среди уровней: UP1, UP2, ATR*pAtr, UP3, Poc.UpLev, TargetUp
      case 3:  SetPROFIT_BUY=MaxFromBuy;   // перемещение тейка на максимальную цену с момента открыти€ позы
               SetPROFIT_SELL=MinFromSell; break;   
      }
   SetPROFIT_BUY +=DELTA(oD);  //  корректировка выхода
   SetPROFIT_SELL-=DELTA(oD);  //  ATR = ATR*dAtr*0.1,  D=-5..5,    dAtr=6..12     
   if (BUY &&
     ((OutGlob && GlobalTrend<0) || // глобальный тренд развернулс€
      (OutLoc  && Trend<0) ||       // локальный тренд развернулс€
      (OutImp  && Imp.Sig<0))){     // обратный импульс
      if (SetPROFIT_BUY <PROFIT_BUY)  PROFIT_BUY=SetPROFIT_BUY; // пододвигаем тейк ближе 
      if (SetPROFIT_BUY-Bid<StopLevel) BUY=0;  // закрываемс€
      }  
   if (SELL && 
     ((OutGlob && GlobalTrend>0) || // глобальный тренд развернулс€
      (OutLoc  && Trend>0) ||       // локальный тренд развернулс€
      (OutImp  && Imp.Sig>0))){     // обратный импульс
      if (SetPROFIT_SELL>PROFIT_SELL) PROFIT_SELL=SetPROFIT_SELL;
      if (Ask-SetPROFIT_SELL<StopLevel)  SELL=0;
   }  }  
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆          
void TRAILING(){//    - T R A I L I N G   S T O P -
   if (Trl==0) return;
   SetBUY=Low[bar];  SetSELL=High[bar]; // в ф.-ции CHOOSE_STOP() есть проверка на положительность этих значений, ставим просто
   SetSTOP_BUY=0;    SetSTOP_SELL=0; // значени€ стопов дл€ обновлени€ ордеров
   CHOOSE_STOP(0); //  перемещение стопа на ближайший уровень   (1-открытие, 0-модификаци€ позы) среди уровней: DN1, DN2, ATR*sAtr, DN3Pic, Poc.DnLev, TargetDn
   if (BUY && 
      (SetSTOP_BUY>BUY || Trl<0)  && // при Trl>0 “рейлинг от входа
      SetSTOP_BUY>STOP_BUY){   X("TRAILING_BUY="+DoubleToStr(SetSTOP_BUY,Digits)+" BUY="+DoubleToStr(BUY,Digits) , SetSTOP_BUY , clrWhite);
      STOP_BUY=SetSTOP_BUY;} // пододвигаем тейк ближе    
   if (SELL && SetSTOP_SELL>0 &&
      (SetSTOP_SELL<SELL || Trl<0) && 
      SetSTOP_SELL<STOP_SELL){ X("TRAILING_SELL", SetSTOP_SELL, clrWhite);
      STOP_SELL=SetSTOP_SELL;}
   }

   