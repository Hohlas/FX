void Output() 
   {
   double   CloseSell, CloseBuy; // цена, по которой планируется закрываться
   if (OUT==0 && Otr==0) return;
   switch (Otr){ // Обработка сигналов тренда
      case 1:  Up=UpTr; Dn=DnTr;  break;   // без переворота
      case 0:  Up=1;    Dn=1;     break;   // игнорирование тренда
      case -1: Up=DnTr; Dn=UpTr;  break;   // реверсируем сигналы тренда
      }
   Up=(Up && SELL); // если тренд способствует сигналу на закрытие короткой позы и есть короткая поза 
   Dn=(Dn && BUY);   
   if (!Up && !Dn) return;
   bool tmpUp=Up, tmpDn=Dn; // Временное сохранение переменных Up и Dn 
   int k;
   Signal(3,OUT,Ok,1); // Signal (int SigMode, int SigType, int Sk, int bar) 
   if (Orev==-1)   {k=Up; Up=Dn; Dn=k;} // реверснем сигналы
   Up=(Up && tmpUp); 
   Dn=(Dn && tmpDn);
   if (!Up && !Dn) return;
      
// С П О С О Б  В Ы Х О Д А  И З  Р Ы Н К А ////////////////////////////////////////////////////////////////     
   switch (Oprice){  // расчет цены выходов: 
      case -1: CloseBuy=L;  CloseSell=H ;break;   // ставим стоп на последнем минимуме
      case  0: CloseBuy=Bid;     CloseSell=Ask;    break;   // по рынку
      case  1: CloseBuy=MaxFromBuy; CloseSell=MinFromSell; break;   // профит на максимально достигнутой в сделке цене
      }        
// Выходим из короткой   
   if (SELL>0 && Up==1 && CloseSell<SELL-Present){ // получен сигнал на выход из короткой и цена закрытия выгоднее установленного значения (StopShortVal*P*0.5 - Величина минимальной прибыли, при которой уже можно закрываться)
      if (MathAbs(Ask-CloseSell)<StopLevel) SELL=0;    // Выходим по рынку,
      if (Ask-CloseSell>StopLevel && (CloseSell>PROFIT_SELL || PROFIT_SELL==0)) PROFIT_SELL=CloseSell;  // цена закрытия блеже к цене чем текущее значение, если оно вообще установлено
      if (CloseSell-Ask>StopLevel &&  CloseSell<STOP_SELL)                      STOP_SELL=CloseSell;    // цена закрытия блеже к цене чем текущее значение
      }   
// Выходим из длинной  
   if (BUY>0 && Dn==1 && CloseBuy>BUY+Present){// Выходим из длинной 
      if (MathAbs(Bid-CloseBuy)<StopLevel) BUY=0;
      if (CloseBuy-Bid>StopLevel && (CloseBuy<PROFIT_BUY || PROFIT_BUY==0))     PROFIT_BUY=CloseBuy;  // цена закрытия блеже к цене чем текущее значение, если оно вообще установлено
      if (Bid-CloseBuy>StopLevel &&  CloseBuy>STOP_BUY)                         STOP_BUY=CloseBuy;    // цена закрытия блеже к цене чем текущее значение
      }   
   
   
   }  




