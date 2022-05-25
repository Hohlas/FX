struct Signals{  //  C “ – ”   “ ” – ј   — » √ Ќ ј Ћ ќ ¬   Ќ ј   ¬ ’ ќ ƒ 
   int MaUp;      int MaDn;
   double Buy;    double Sell;   // цены входа на уровне возникновени€ сигнала
   double BuyStp; double SellStp;// цены стопа на уровне возникновени€ сигнала
   double BuyPrf; double SellPrf;// цены тейка на уровне возникновени€ сигнала
   } s; 

double memUP, memDN; // значение цены, на которой возник сигнал, дл€ определени€ момента возникновени€ нового сигнала  
           
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆   
void SIG_MIRROR_LEVELS(){// ќ“Ѕќ… ќ“ «≈– јЋ№Ќџ’ ”–ќ¬Ќ≈…
   int f, Shift, BreakTime=0;
   double LevContact=MathAbs(iLevContact)*Pic.Lim; // "погрешность приближени€ к уровн€м",  Pic.Lim-допуск совпадени€ уровней
   if (dm>-1){ // подход к зеркальной вершине, расположенной снизу
      double MirDn=LEV[dm][P]*Point; // значение зеркального уровн€
      LINE("MirDn", bar+1,MirDn, bar,MirDn, cSIG1);
      if (memUP!=MirDn){// обновилс€ уровень возникновени€ сигнала 
         Shift=iBarShift(NULL,0,LEV[dm][T],false); // сдвиг пробитой вершины 
         BreakTime=0;
         for (f=Shift-1; f>=bar; f--){// от пробитой вершины до текущего бара 
            if (High[f]>=MirDn && Low[f]<=MirDn){// находим пробивающие бары 
               BreakTime=f; // номер первого бара, пробившего уровень 
               break;
            }  } //if (Prn) Print(ttt," BreakBars=",BreakBars," BreakTime=",TimeToString(Time[BreakTime],TIME_DATE | TIME_MINUTES));        
         LINE("+MirDn",0,MirDn+LevContact, 0,0, cSIG2); LINE("-MirDn",0,MirDn-LevContact, 0,0, cSIG2); 
         if (iBar==0) sUP=0; // в режие iBar=0 сигнал отмен€етс€ лишь при обновлении уровн€ сигнала и его отмене; при iBar>0 после iBar бар.
         if (//BreakTime>FltLen/3 && // после пробити€ прошло достаточно времени
            High[iHighest(NULL,0,MODE_HIGH,Shift,0)]-MirDn>iParam*ATR && // пробой был достаточно далеко
            Shift-BreakTime>FltLen){// кол-во бар от пробитой вершины до момента пробити€
            if (iLevContact==0 && Low[bar]>MirDn) MIR_UP(Shift); // нахождение над границей
            if (iLevContact >0 && Low[bar]>MirDn && Low[bar]<MirDn+LevContact) MIR_UP(Shift); // приближение к границе в пределах iLevContact*Pic.Lim, цена над зеркальным уровнем и очень близко к нему
            if (iLevContact <0 && Low[bar]<MirDn && Low[bar]>MirDn-LevContact) MIR_UP(Shift);// обратный пробой (Break==2~однократно) границы в пределах LevContact
      }  }  }
   if (um>-1){ // подход к зеркальному дну, расположенному сверху
      double MirUp=LEV[um][P]*Point; // значение зеркального уровн€
      LINE("MirDn", bar+1,MirUp, bar,MirUp, cSIG1);
      if (memDN!=MirUp){// обновилс€ уровень возникновени€ сигнала        
         Shift=iBarShift(NULL,0,LEV[um][T],false); // сдвиг пробитого дна 
         BreakTime=0;
         for (f=Shift-1; f>=bar; f--){// от пробитого дна к текущему бару   
            if (High[f]>=MirUp && Low[f]<=MirUp){// находим пробивающие бары 
               BreakTime=f; // номер первого бара, пробившего уровень 
               break;
            }  }
         LINE("+MirUp",0,MirUp+LevContact, 0,0, cSIG2); LINE("-MirUp",0,MirUp-LevContact, 0,0, cSIG2); 
         if (iBar==0) sDN=0; // в режие iBar=0 сигнал отмен€етс€ лишь при обновлении уровн€ сигнала и его отмене; при iBar>0 после iBar бар.
         if (//BreakTime>FltLen/3 && // после пробити€ прошло достаточно времени
            MirUp-Low [iLowest (NULL,0,MODE_LOW ,Shift,0)]>iParam*ATR && // пробой был достаточно далеко
            Shift-BreakTime>FltLen){// кол-во бар от пробитого дна до момента пробити€
            if (iLevContact==0 && High[bar]<MirUp) MIR_DN(Shift);// нахождение под границей 
            if (iLevContact >0 && High[bar]<MirUp && High[bar]>MirUp-LevContact) MIR_DN(Shift); // приближение к границе на величину, меньшую чем iLevContact*Pic.Lim
            if (iLevContact <0 && High[bar]>MirUp && High[bar]<MirUp+LevContact) MIR_DN(Shift); // пробой границы на величину меньшую чем iLevContact*Pic.Lim  
   }  }  }  }
void MIR_UP(int Shift){// отработка сигнала в лонг при подходе к вершине, наход€щейс€ снизу
   memUP=LEV[dm][P]*Point; // запоминаем значени€ уровн€, чтобы не повтор€ть сигнал
   sUP=MathMax(1,iBar);  //LINE("memUP="+DoubleToStr(memUP,Digits), 0,memUP-0.003, 0,0, clrGold);
   s.Buy =memUP; // лонг от пробитого пика  
   s.BuyStp =Low [iLowest (NULL,0,MODE_LOW ,Shift,0)]; // ѕри лонге стоп за минимальную цену от текущего бара до пика, от которого был отскок, а 
   s.BuyPrf =High[iHighest(NULL,0,MODE_HIGH,Shift,0)]; // тейк на максимальную цену от текущего бара до пика, от которого был отскок
   }
void MIR_DN(int Shift){// отработка сигнала в шорт при подходе ко впадине, наход€щейс€ сверху
   memDN=LEV[um][P]*Point; // запоминаем значени€ уровн€, чтобы не повтор€ть сигнал
   sDN=MathMax(1,iBar);  //LINE("memDN="+DoubleToStr(memDN,Digits), 0,memDN+0.003, 0,0, clrGold);
   s.Sell=memDN; // шорт от пробитого дна
   s.SellStp=High[iHighest(NULL,0,MODE_HIGH,Shift,0)]; // ѕри шорте -
   s.SellPrf=Low [iLowest (NULL,0,MODE_LOW ,Shift,0)]; // аналогично 
   }     
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆
void SIG_FLAT(){// ќ“–јЅќ“ ј ‘ЋЁ“ј. ѕриближение к границам(+) / пробой(-)
   if (Trend!=0) {sUP=0; sDN=0; return;} // флэт кончилс€
   double LevContact=MathAbs(iLevContact)*Pic.Lim; // "погрешность приближени€ к уровн€м" 
   LINE("FlatLo",0,FlatLo, 0,0, cSIG1);   LINE("FlatHi",0,FlatHi, 0,0, cSIG1);
   if (FlatHi-FlatLo<iParam*ATR) return; // узкие флэты пропускаем
   if (memUP!=FlatLo){ 
      if (iBar==0) sUP=0;   // уровни сигнала сменились,  удал€ем сигналы
      if (iLevContact >0 && Low [bar]>FlatLo && Low [bar]<FlatLo+LevContact) FLAT_UP(); // сигнал вверх при подходе к нижней границе флэта
      if (iLevContact==0 && High[bar]>FlatHi+LevContact) FLAT_UP(); // сигнал вверх при пробое верхней границы флэта 
      if (iLevContact <0 && Low [bar]<FlatLo && Low [bar]>FlatLo-LevContact) FLAT_UP(); // сигнал вверх при выходе за нижнюю границу флэта
      }
   if (memDN!=FlatHi){
      if (iBar==0) sDN=0;  // уровни сигнала сменились,  удал€ем сигналы
      if (iLevContact >0 && High[bar]<FlatHi && High[bar]>FlatHi-LevContact) FLAT_DN(); // сигнал вниз при подходе к верхней границе флэта
      if (iLevContact==0 && Low [bar]<FlatLo-LevContact) FLAT_DN(); // сигнал вниз при пробое нижней границы флэта 
      if (iLevContact <0 && High[bar]>FlatHi && High[bar]<FlatHi+LevContact) FLAT_DN(); // сигнал вниз при выходе за верхнюю границу флэта
   }  }   
void FLAT_UP(){// —»√ЌјЋ ¬¬≈–’ при подходе к нижней границе флэта, либо пробое верхней 
   memUP=FlatLo;
   sUP=MathMax(1,iBar);
   if (iLevContact==0) {s.Buy =FlatHi;   s.BuyStp =FlatLo;   s.BuyPrf =FlatHi+(FlatHi-FlatLo);}
   else {s.Buy =FlatLo;   s.BuyStp =FlatLo-ATR;   s.BuyPrf =FlatHi;}
   }
void FLAT_DN(){// —»√ЌјЋ ¬Ќ»« при подходе к верхней границе флэта, либо пробое нижней
   memDN=FlatHi;
   sDN=MathMax(1,iBar);
   if (iLevContact==0) {s.Sell=FlatLo;   s.SellStp=FlatHi;   s.SellPrf=FlatLo-(FlatHi-FlatLo);}
   else {s.Sell=FlatHi;   s.SellStp=FlatHi+ATR;   s.SellPrf=FlatLo;}
   }            
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆   
void SIG_FALSE_LEV(){// Ћќ∆Ќџ… ѕ–ќЅќ…
   switch (iParam){// – ј — „ ≈ “   Ћ ќ ∆ Ќ я   ќ ¬ , т.е. ложн€к формируетс€ при пробитии:    
      case 0: FALSE_LEVELS (Pic.Hi,HiTime, Pic.Lo,LoTime, iLevContact); break;  // последнего пика
      case 1: FALSE_LEVELS (UP1_2,Tup1_2, DN1_2,Tdn1_2, iLevContact); break;  // ближайшего уровн€ c одним и более отскоком
      case 2: FALSE_LEVELS (UP2_2,Tup2_2, DN2_2,Tdn2_2, iLevContact); break;  // сильного флэтового уровн€ с двум€ и более отскоками
      case 3: if (Trend==0) FALSE_LEVELS (FlatHi,FlatHiTime, FlatLo,FlatLoTime, iLevContact); break;  // флэтового уровн€ образовавшегос€ канала
      case 4: FALSE_LEVELS (Poc.UpLev,Poc.StartTime, Poc.DnLev,Poc.StartTime, iLevContact); break;
      }
   if (Fls.UP!=4) sDN=0; 
   else{// пробилс€ уровень покупки ложн€ка     //if (Prn) Print(ttt,"SIG_FALSE_LEV(): Fls.UP=",Fls.UP);
      sDN=MathMax(1,iBar);
      s.Sell =Fls.UPuplev; // пробита€ ложн€ком верхн€€ граница
      s.SellStp=Fls.Max;   
      s.SellPrf=Fls.UPdnlev;   // противоположна€ граница флэта, дл€ регистрации отработки ложн€ка 
      }
   if (Fls.DN!=4) sUP=0; 
   else{// пробилс€ уровень продажи ложн€ка
      sUP=MathMax(1,iBar); 
      s.Buy=Fls.DNdnlev; // пробита€ ложн€ком нижн€€ граница
      s.BuyStp =Fls.Min;   
      s.BuyPrf =Fls.DNuplev;
   }  }   
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆   
void SIG_FALSE_LEV_2(){// неправильный Ћќ∆Ќџ… ѕ–ќЅќ… сигнал поступает не на пробитии уровн€ покупки (Fls.UP=4), а при первом откате (Fls.UP=3)
   switch (iParam){// – ј — „ ≈ “   Ћ ќ ∆ Ќ я   ќ ¬ , т.е. ложн€к формируетс€ при пробитии:    
      case 0: FALSE_LEVELS (Pic.Hi,HiTime, Pic.Lo,LoTime, iLevContact); break;  // последнего пика
      case 1: FALSE_LEVELS (UP1_2,Tup1_2, DN1_2,Tdn1_2, iLevContact); break;  // ближайшего уровн€ c одним и более отскоком
      case 2: FALSE_LEVELS (UP2_2,Tup2_2, DN2_2,Tdn2_2, iLevContact); break;  // сильного флэтового уровн€ с двум€ и более отскоками
      case 3: if (Trend==0) FALSE_LEVELS (FlatHi,FlatHiTime, FlatLo,FlatLoTime, iLevContact); break;  // флэтового уровн€ образовавшегос€ канала
      case 4: FALSE_LEVELS (Poc.UpLev,Poc.StartTime, Poc.DnLev,Poc.StartTime, iLevContact); break;
      }
   if (Fls.UP!=3) sDN=0; 
   else{// пробилс€ уровень покупки ложн€ка     //if (Prn) Print(ttt,"SIG_FALSE_LEV(): Fls.UP=",Fls.UP);
      sDN=MathMax(1,iBar);
      s.Sell =Fls.UPuplev; // пробита€ ложн€ком верхн€€ граница
      s.SellStp=Fls.Max;   
      s.SellPrf=Fls.UPdnlev;   // противоположна€ граница флэта, дл€ регистрации отработки ложн€ка 
      }
   if (Fls.DN!=3) sUP=0; 
   else{// пробилс€ уровень продажи ложн€ка
      sUP=MathMax(1,iBar); 
      s.Buy=Fls.DNdnlev; // пробита€ ложн€ком нижн€€ граница
      s.BuyStp =Fls.Min;   
      s.BuyPrf =Fls.DNuplev;
   }  }      
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆   
void SIG_NULL(){// ќ“—”“—“¬»≈ √ЋќЅјЋ№Ќќ√ќ —»√ЌјЋј (вход только по фильтрам)
   sUP=1; s.Buy =Ask;
   sDN=1; s.Sell=Bid; 
   }     
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆
int Friday, LastMonth;
void NON_FARM(){// Ќќ¬ќ—“»  ј∆ƒ”ё ѕ≈–¬”ё ѕя“Ќ»÷” в 16 мск
   bool NonFarm=false;
   if (TimeHour(Time[bar])<TimeHour(Time[bar+1])){ // новый день 
      if (Month()!=LastMonth){// сменилс€ мес€ц
         LastMonth=Month();
         Friday=0;
         }
      if (DayOfWeek()==5) {Friday++; TEXT("UP","Friday="+DoubleToStr(Friday,0), Low[bar]-0.002);}  
      }
      
   if (DayOfWeek()==5 && Friday==1) NonFarm=true; // перва€ п€тница мес€ца
   if (NonFarm && Hour()==15){// 
      
      sUP=MathMax(1,iBar);
      sDN=MathMax(1,iBar);
      s.Buy =UP1; s.BuyStp =DN1;   s.BuyPrf =UP3; 
      s.Sell=DN1; s.SellStp=UP1;   s.SellPrf=DN3;
      //TEXT("UP","SetBUY "+DoubleToStr(SetBUY ,Digits-1)+" "+DoubleToStr(s.BuyStp ,Digits-1)+" "+DoubleToStr(s.BuyPrf ,Digits-1)+" UP3="+DoubleToStr(UP3 ,Digits-1), Low [bar]-0.005);
      //TEXT("DN","SetSELL"+DoubleToStr(SetSELL,Digits-1)+" "+DoubleToStr(s.SellStp,Digits-1)+" "+DoubleToStr(s.SellPrf,Digits-1)+" DN3="+DoubleToStr(DN3 ,Digits-1), High[bar]+0.005);
      }
   
      
   }



/*
switch(D){// цены входа от уровн€ возникновени€ сигнала
      case  3: s.Buy=Pic.MirDn+ATR*0.5;   s.Sell=Pic.MirUp-ATR*0.5;  break;
      case  2: s.Buy=Pic.MirDn+ATR*0.2;   s.Sell=Pic.MirUp-ATR*0.2;  break;
      case  1: s.Buy=Pic.MirDn;           s.Sell=Pic.MirUp;          break;
      case  0: s.Buy=Pic.MirDn-ATR*0.2;   s.Sell=Pic.MirUp+ATR*0.2;  break;
      case -1: s.Buy=Pic.MirDn-ATR*0.5;   s.Sell=Pic.MirUp+ATR*0.5;  break;
      case -2: s.Buy =Low [iHighest(NULL,0,MODE_LOW ,PicPer*2+1,iBarShift(NULL,0,Pic.MirDnTime,false)-PicPer)];            // лонг от трендового уровн€ пика, от которого был отскок
               s.Sell=High[iLowest (NULL,0,MODE_HIGH,PicPer*2+1,iBarShift(NULL,0,Pic.MirUpTime,false)-PicPer)];   break; 
      case -3: s.Buy =Low [iBarShift(NULL,0,Pic.MirDnTime,false)]-ATR*0.5;          // лонг от лоу пика, от которого был отскок  
               s.Sell=High[iBarShift(NULL,0,Pic.MirUpTime,false)]+ATR*0.5;  break;  // шорт от ха€ пика, от которого был отскок 
      }
   switch(S){// цены стопа на уровне возникновени€ сигнала
      case 1: s.BuyStp =Low [iLowest (NULL,0,MODE_LOW ,iBarShift(NULL,0,Pic.MirDnTime,false),bar)]; // при лонге стоп за минимальную цену от текущего бара до пика, от которого был отскок 
              s.SellStp=High[iHighest(NULL,0,MODE_HIGH,iBarShift(NULL,0,Pic.MirUpTime,false),bar)]; break;
      case 2: s.BuyStp =Low [iLowest (NULL,0,MODE_LOW ,iBarShift(NULL,0,Pic.MirDnTime,false),bar)]; // при лонге стоп за минимальную цену от текущего бара до пика, от которого был отскок 
              s.SellStp=High[iHighest(NULL,0,MODE_HIGH,iBarShift(NULL,0,Pic.MirUpTime,false),bar)]; break;//   
   } }
   
   
   
   switch(D){
      case  2: s.Buy=FlatLo+ATR*0.5;   s.Sell=FlatHi-ATR*0.5;  break;
      case  1: s.Buy=FlatLo;           s.Sell=FlatHi;          break;
      case  0: s.Buy=FlatLo-ATR*0.5;   s.Sell=FlatHi+ATR*0.5;  break;
      case -1: s.Buy=FlatLo-ATR;       s.Sell=FlatHi+ATR;      break;
      } 
   switch(S){
      case 1: SetPROFIT_BUY =FlatLo-ATR*0.5;   SetPROFIT_SELL=FlatHi+ATR*0.5;  break; // противоположна€ граница флэта
      case 2: SetPROFIT_BUY =FlatLo-ATR;       SetPROFIT_SELL=FlatHi+ATR;      break;// противоположна€ граница флэта
      }  
   
    
   */ 

    
 
 