void Output(){ 
   if (OUT==0 || (!BUY && !SELL)) return;
   double   CloseSell, CloseBuy; // цена, по которой планируется закрываться
   int k;
   Signal(1,OUT,Ok,1); // Signal (int SigMode, int SigType, int Sk, int bar) 
   if (Orev==-1)   {k=Up; Up=Dn; Dn=k;} // реверснем сигналы
   if (!Up && !Dn) return;
      
// С П О С О Б  В Ы Х О Д А  И З  Р Ы Н К А ////////////////////////////////////////////////////////////////     
   switch (Oprice){  // расчет цены выходов: 
      case  1: // по рынку
         CloseBuy=Bid;     
         CloseSell=Ask;    
      break;   
      case  2: // профит на максимально достигнутой в сделке цене
         CloseBuy=MaxFromBuy; 
         CloseSell=MinFromSell; 
      break;   
      }        
   if (BUY>0 && Dn==1){// Выходим из длинной  
      if (CloseBuy<BUY+Present) CloseBuy=BUY+Present; // двинем выход вверх, если просит жаба
      if (CloseBuy<PROFIT_BUY || PROFIT_BUY==0) // если выход ниже профит таргета, или таргета нет вовсе
         if (CloseBuy-Bid<StopLevel) BUY=0;   else   PROFIT_BUY=CloseBuy;  
      }  
   if (SELL>0 && Up==1){// Выходим из короткой  
      if (CloseSell>SELL-Present) CloseSell=SELL-Present;  // двинем выход вниз, если просит жаба
      if (CloseSell>PROFIT_SELL || PROFIT_SELL==0)      
         if (Ask-CloseSell<StopLevel) SELL=0;   else   PROFIT_SELL=CloseSell;  // цена закрытия блеже к цене чем текущее значение, если оно вообще установлено
   }  }   
     




