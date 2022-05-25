int  sUP, sDN; // сигналы
bool fUP, fDN; // глобальные фильтры направлени€
double StopBuy, StopSell, ProfitBuy, ProfitSell;

void INPUT(){
   SetBUY=0;   SetSTOP_BUY=0;    SetPROFIT_BUY=0; SetSELL=0;  SetSTOP_SELL=0;   SetPROFIT_SELL=0; // значени€ ордеров 
   if (iBar>0) sUP--; sDN--; // при iParam=0 сигналы снимаютс€ в их функци€х, при >0 через iParam бар
   fUP=!BUY; 
   fDN=!SELL; 
   FILTERS(fNewPic, fGlbTrnd, fLocTrnd, fImpulse, fTrndLev);  // ‘»Ћ№“–џ √ЋќЅјЋ№Ќќ√ќ Ќјѕ–ј¬Ћ≈Ќ»я формируют сигналы MovUP и MovDN 
   //TEXT("UP","BUY="+DoubleToStr(BUY,Digits-1)+" MovUP="+DoubleToStr(MovUP,Digits-1), Low[bar]-0.005);
   //TEXT("DN","SELL="+DoubleToStr(SELL,Digits-1)+" MovDN="+DoubleToStr(MovDN,Digits-1), High[bar]+0.005);
   switch(iSignal){// ѕ≈–≈ Ћё„ј“≈Ћ№ √ЋќЅјЋ№Ќџ’ —»√ЌјЋќ¬. ¬озвращает признаки UP и DN, они отмен€ютс€ только в ф-€х сигналов, поэтому из запуск об€зателен на каждом баре
      case 1:  SIG_MIRROR_LEVELS(); break;   // ќ“— ќ  ќ“ «≈– јЋ№Ќџ’ ‘ЋЁ“ќ¬џ’ ”–ќ¬Ќ≈…
      case 2:  SIG_FLAT();          break;   // ќ“— ќ  ќ“ √–јЌ»÷ ‘ЋЁ“ј
      case 3:  SIG_FALSE_LEV();     break;   // Ћќ∆Ќџ… ѕ–ќЅќ…
      case 4:  SIG_FALSE_LEV_2();   break;   // 
      default: SIG_NULL();          break;   // Ѕ≈« √ЋќЅјЋќ¬
      }
   SIG_LINES(fUP,"fUP BUY="+DoubleToStr(BUY,Digits), fDN,"fDN SELL="+DoubleToStr(SELL,Digits), 0x303030); // линии сиглалов MovUP и MovDN: (сигналы, смещение от H/L, цвет)   
   SIG_LINES(sUP,"sUP="    +DoubleToStr(sUP,0),      sDN,"sDN="     +DoubleToStr(sDN,0),0x505050);// линии сиглалов UP и DN: (сигналы, цвет)   
   if (sUP<=0) fUP=false;
   if (sDN<=0) fDN=false;
   if (ExpirBars==0){// удаление отложников при пропадании сигнала
      if (!fDN && (SELLSTOP>0 || SELLLIMIT>0))  {SELLSTOP=0; SELLLIMIT=0; Modify();}
      if (!fUP && (BUYSTOP>0  ||  BUYLIMIT>0))  {BUYSTOP=0;  BUYLIMIT=0;  Modify();}    
      }
   if (!fUP && !fDN) return;  // сигналов на вход нет
         //  ÷ ≈ Ќ џ   ¬ ’ ќ ƒ ј
   switch (Iprice){ 
      case 0: SetBUY=s.Buy;         SetSELL=s.Sell;         break;// сигнальна€ цена из функций сигналов
      case 1: SetBUY=Ask;           SetSELL=Bid;            break;// по текущей цене открыти€ (ask и bid формируем из Open[0], чтоб отложники не зависели от шустрых движух)
      case 2: SetBUY=DN1;           SetSELL=UP1;            break;// от ближайших пиков
      case 3: SetBUY=DN2;           SetSELL=UP2;            break;// от флэтовых уровней с несколькими отскоками 
      case 4: SetBUY=DnCenter;      SetSELL=UpCenter;       break;// от трендовых уровней 
      case 5: SetBUY=Poc.DnLev;     SetSELL=Poc.UpLev;      break;// от уровней консолидации POC
      case 6: SetBUY=TargetDn;      SetSELL=TargetUp;       break;// от целевых
      case 7: SetBUY=FirstDnCenter; SetSELL=FirstUpCenter;  break;// от ѕервых ”ровней
      }
   if (fUP && SetBUY>0)  SetBUY =NormalizeDouble(SetBUY +DELTA(D),Digits);  else  SetBUY=0;
   if (fDN && SetSELL>0) SetSELL=NormalizeDouble(SetSELL-DELTA(D),Digits);  else  SetSELL=0;
   CHOOSE_STOP(1);   // ¬ џ Ѕ ќ –   — “ ќ ѕ ќ ¬  (1-открытие, 0-модификаци€ позы) среди уровней: DN1, DN2, s.BuyStp, ATR*sAtr, DN3Pic, Poc.DnLev, TargetDn, FirstDnPic.
   CHOOSE_PROFIT(1); // ¬ џ Ѕ ќ –   “ ≈ …   ќ ¬  (1-открытие, 0-модификаци€ позы) среди уровней: UP1, UP2, s.BuyPrf, ATR*pAtr, UP3, Poc.UpLev, TargetUp, FirstUp
   double PL=MathAbs(minPL)*0.5;
   // ѕ–ќ¬≈– ј —ќќ“ЌќЎ≈Ќ»я  Profit / Loss
   if (SetBUY>0  && ProfitBuy/StopBuy <PL){// при худшем соотношении P/L:
      if (minPL<0) SetBUY=0;  // поза не открываетс€, либо   
      if (minPL>0){           // цена открыти€ перемещаетс€ дл€ удовлетворени€ отношени€ PL
         StopBuy=(StopBuy+ProfitBuy)/(1+PL); // пересчитаем, каким должен быть стоп                                        //   X("Old BUY", SetBUY, clrWhite);
         SetBUY=NormalizeDouble(SetSTOP_BUY+StopBuy,Digits);   // сместим цену открыти€
         StopBuy =SetBUY-SetSTOP_BUY;     ProfitBuy =SetPROFIT_BUY-SetBUY;
      }  }
   if (SetSELL>0 && ProfitSell/StopSell<PL){// при худшем соотношении P/L:
      if (minPL<0) SetSELL=0; // поза не открываетс€, либо 
      if (minPL>0){// цена открыти€ перемещаетс€ дл€ удовлетворени€ отношени€ PL
         StopSell=(StopSell+ProfitSell)/(1+PL);                                     //  X("Old SELL", SetSELL, clrWhite);  
         SetSELL=NormalizeDouble(SetSTOP_SELL-StopSell,Digits);
         StopSell=SetSTOP_SELL-SetSELL;   ProfitSell=SetSELL-SetPROFIT_SELL; 
      }  }  
   // ќкончательна€ проверка уровней стопов
   if (SetBUY >0 && MathAbs(SetBUY -Ask)<=StopLevel) {SetBUY =Ask; StopBuy =SetBUY-SetSTOP_BUY;     ProfitBuy =SetPROFIT_BUY-SetBUY;}
   if (SetSELL>0 && MathAbs(SetSELL-Bid)<=StopLevel) {SetSELL=Bid; StopSell=SetSTOP_SELL-SetSELL;   ProfitSell=SetSELL-SetPROFIT_SELL;}
   if (StopBuy <=StopLevel || ProfitBuy <=StopLevel) SetBUY=0;
   if (StopSell<=StopLevel || ProfitSell<=StopLevel) SetSELL=0;
   if (Del==1){   // при по€влении нового сигнала удал€ем старый отложник;     
      if (SetBUY>0)  {BUYSTOP=0;    BUYLIMIT=0;    Modify();}  
      if (SetSELL>0) {SELLSTOP=0;   SELLLIMIT=0;   Modify();}  
      }  
   SIG_LINES(SetBUY,"SetBUY="+DoubleToStr(SetBUY,Digits), SetSELL,"SetSELL="+DoubleToStr(SetSELL,Digits),0x707070); // линии сиглалов UP и DN: (сигналы, цвет)
   ORDERS_SET(); // ¬ џ — “ ј ¬ Ћ ≈ Ќ » ≈    Ќ ќ ¬ џ ’    ќ – ƒ ≈ – ќ ¬
   }
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆   
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆     
double MAX(double price1, double price2){
   if (price1>price2) return (price1); else return (price2);
   } 
double MIN(double price1, double price2){// возвращает меньшее, но не нулевое значение
   if (price1==0) return (price2);
   if (price2==0) return (price1);
   if (price1<price2) return (price1); else return (price2);
   }  
double DELTA(int delta){
   if (delta>0) return( MathPow(delta+1,2)*0.1*ATR);    
   if (delta<0) return(-MathPow(delta-1,2)*0.1*ATR); //  ATR = ATR*dAtr*0.1,     
   return (0);
   } 
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆   
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆   
void CHOOSE_STOP(bool OrdSet){// ¬ џ Ѕ ќ –   ÷ ≈ Ќ   — “ ќ ѕ ќ ¬   (OrdSet=1-открытие, 0-модификаци€ позы) среди уровней: DN1, DN2, s.BuyStp, ATR*sAtr, DN3Pic, Poc.DnLev, TargetDn, FirstDnPic.
   switch (Sprice){// Ќј„јЋ№Ќџ… стоп   
      case 0:  SET_STOP(OrdSet, SetBUY-ATR, SetSELL+ATR); break;   // простой ATR
      case 1:  SET_STOP(OrdSet, MAX(DN1,DN2), MIN(UP1,UP2)); break;   // за ближий из пиков с одним и несколькими отскоками
      case 2:  SET_STOP(OrdSet, MIN(DN1,DN2), MAX(UP1,UP2)); break;}  // за дальний из пиков с одним и несколькими отскоками 
   if (sTrd>0) SET_STOP(OrdSet, DN3Pic,UP3Pic);      // за пик непробитого трендового          
   if (sPoc>0) SET_STOP(OrdSet, Poc.Dn,Poc.Up);// за уровни консолидации POC          
   if (sTgt>0) SET_STOP(OrdSet, TargetDn,TargetUp);  // за целевые уровни          
   if (OrdSet){// стопы по сигнальным и пиковым уровн€м провер€ютс€ только при открытии ордера, при трейлингах не активны
      if (sSig>0) SET_STOP(OrdSet, s.BuyStp,s.SellStp);    // Cигнальные стопы из функций сигналов
      if (sFst>0) SET_STOP(OrdSet, FirstDnPic,FirstUpPic); // ѕики первых уровней
      }    
   if (SetSTOP_BUY>0)   {SetSTOP_BUY =NormalizeDouble(SetSTOP_BUY -DELTA(S),Digits);   StopBuy =SetBUY-SetSTOP_BUY;  }  else {SetBUY =0;  StopBuy=0;}   // дельта, отодвигающа€ стоп от   
   if (SetSTOP_SELL>0)  {SetSTOP_SELL=NormalizeDouble(SetSTOP_SELL+DELTA(S),Digits);   StopSell=SetSTOP_SELL-SetSELL;}  else {SetSELL=0;  StopSell=0;}// расчетного уровн€, где ATR=dAtr*0.1*ATR
   }
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆   
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆   
void SET_STOP (bool OrdSet,  double NewStpBuy,  double NewStpSel) {// ѕ–ќ¬≈– ј Ќќ¬ќ√ќ «Ќј„≈Ќ»я —“ќѕј ѕ≈–≈ƒ ”—“јЌќ¬ ќ…
   double MinStop=MathMax(StopLevel,MathAbs(sMin)*ATR), BuyPrice, SellPrice;
   double MaxStop=MinStop+MathAbs(sMax)*ATR;
   if (OrdSet) {BuyPrice=SetBUY;    SellPrice=SetSELL;}     // провер€ема€ цена при открытии позы,
   else        {BuyPrice=Low[bar];  SellPrice=High[bar];}   // при ее модификациии (“рейлинге)
   if (SetBUY>0 && NewStpBuy>0){ 
      if (BuyPrice -NewStpBuy < MinStop){// стоп слишком близко
         if (sMin<0)  NewStpBuy=0; else NewStpBuy=BuyPrice -MinStop;}// херим позу, либо отодвигаем стоп
      if (BuyPrice -NewStpBuy > MaxStop && NewStpBuy>0){// стоп слишком далеко 
         if (sMax<0)  NewStpBuy=0;                                   // херим позу, либо
         if (sMax>0 && OrdSet) SetBUY=NormalizeDouble(NewStpBuy+MaxStop,Digits);}// пододвигаем вход к стопу
      if ((SetSTOP_BUY==0  || NewStpBuy<SetSTOP_BUY) && NewStpBuy>0)    SetSTOP_BUY=NewStpBuy; // новый стоп дальше прежнего от текущей цены 
      }
   if (SetSELL>0 && NewStpSel>0){
      if (NewStpSel-SellPrice < MinStop){// стоп слишком близко
         if (sMin<0)  NewStpSel=0; else NewStpSel=SellPrice+MinStop;}// херим позу, либо отодвигаем стоп
      if (NewStpSel-SellPrice > MaxStop && NewStpSel>0){// стоп слишком далеко
         if (sMax<0)  NewStpSel=0;                                   // херим позу, либо
         if (sMax>0 && OrdSet) SetSELL=NormalizeDouble(NewStpSel-MaxStop,Digits);}// пододвигаем вход к стопу
      if ((SetSTOP_SELL==0 || NewStpSel>SetSTOP_SELL) && NewStpSel>0)   SetSTOP_SELL=NewStpSel; // новый стоп дальше прежнего от текущей цены  
   }  }  
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆   
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆   
void CHOOSE_PROFIT(bool OrdSet){// ¬ џ Ѕ ќ –   ÷ ≈ Ќ   “ ≈ …   ќ ¬  (OrdSet=1-открытие, 0-модификаци€ позы)  среди уровней: UP1, UP2, s.BuyPrf, ATR*pAtr, UP3, Poc.UpLev, TargetUp, FirstUp.
   if (SetBUY>0)  SetPROFIT_BUY =SetBUY +20*SlowAtr;  // по умолчаению тейк
   if (SetSELL>0) SetPROFIT_SELL=SetSELL-20*SlowAtr;  // в бесконечность
   switch (Pprice){ 
      case 1: SET_PROFIT(MIN(UP1,UP2),MAX(DN1,DN2));  break;   // за ближий из пиков с одним и несколькими отскоками
      case 2: SET_PROFIT(MAX(UP1,UP2),MIN(DN1,DN2));  break;}  // за дальний из пиков с одним и несколькими отскоками 
   if (pTrd>0) SET_PROFIT(UP3,DN3);             // “рендовые тейки (ближний из Ќј„јЋ№Ќќ√ќ и трендового)      
   if (pPoc>0) SET_PROFIT(Poc.Up,Poc.Dn); // POC тейки (ближний из Ќј„јЋ№Ќќ√ќ и на уровни консолидации POC)      
   if (pTgt>0) SET_PROFIT(TargetUp,TargetDn);   // ÷елевые тейки (ближний из Ќј„јЋ№Ќќ√ќ и на целевые уровни) 
   if (OrdSet){// только при открытии ордера но не при модификации
      if (pSig>0) SET_PROFIT(s.BuyPrf, s.SellPrf); // Cигнальные тейки из функций сигналов (ближний из Ќј„јЋ№Ќќ√ќ и сигнального)  
      if (pFst>0) SET_PROFIT(FirstUp,FirstDn);     // ѕервые уровни (ближний из Ќј„јЋ№Ќќ√ќ и на ѕервые уровни)  
      if (pMax>0){// проверка на дальность тейка от цены открыти€
         double MaxProfit=(pMax+1)*ATR;
         if (SetPROFIT_BUY-SetBUY >MaxProfit)   SetPROFIT_BUY=SetBUY+MaxProfit;  // 
         if (SetSELL-SetPROFIT_SELL>MaxProfit)  SetPROFIT_SELL=SetSELL-MaxProfit;
      }  }    
   if (SetPROFIT_BUY >0)   {SetPROFIT_BUY =NormalizeDouble(SetPROFIT_BUY -DELTA(Prf),Digits);   ProfitBuy =SetPROFIT_BUY-SetBUY;}     else  {SetBUY =0;  ProfitBuy=0;}  
   if (SetPROFIT_SELL>0)   {SetPROFIT_SELL=NormalizeDouble(SetPROFIT_SELL+DELTA(Prf),Digits);   ProfitSell=SetSELL-SetPROFIT_SELL;}   else  {SetSELL=0;  ProfitSell=0;}  
   }  
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆   
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆   
void SET_PROFIT (double NewPrfBuy,double NewPrfSel) {// ѕ–ќ¬≈– ј Ќќ¬ќ√ќ «Ќј„≈Ќ»я “≈… ј ѕ≈–≈ƒ ”—“јЌќ¬ ќ…
   if (SetBUY>0  && NewPrfBuy>0 && NewPrfBuy<SetPROFIT_BUY)  SetPROFIT_BUY=NewPrfBuy;   // новый тейк ближе прежнего к текущей цене  if (Prn) Print(" NewPrfBuy=",NewPrfBuy," UP1=",UP1," SetBUY=",SetBUY," ASK=",Ask);
   if (SetSELL>0 && NewPrfSel>0 && NewPrfSel>SetPROFIT_SELL) SetPROFIT_SELL=NewPrfSel;  // новый тейк ближе прежнего к текущей цене   
   } 
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆   
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆   


     