void Output(){ 
   if (OUT==0 || (!BUY.Val && !SEL.Val)) return;
   double   CloseSell=0, CloseBuy=0; // цена, по которой планируется закрываться
   Signal(3,OUT,Ok); // Signal (int SigMode, int SigType, int Sk, int bar) 
   if (OUT<0)   {int k=Up; Up=Dn; Dn=k;} // реверснем сигналы
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
   if (BUY.Val>0 && Dn==1){// Выходим из длинной  
      if (CloseBuy<BUY.Val+Present) CloseBuy=BUY.Val+Present; // двинем выход вверх, если просит жаба
      if (CloseBuy<BUY.Prf || BUY.Prf==0) // если выход ниже профит таргета, или таргета нет вовсе
         if (CloseBuy-Bid<StopLevel) BUY.Val=0;   else   BUY.Prf=CloseBuy;  
      }  
   if (SEL.Val>0 && Up==1){// Выходим из короткой  
      if (CloseSell>SEL.Val-Present) CloseSell=SEL.Val-Present;  // двинем выход вниз, если просит жаба
      if (CloseSell>SEL.Prf || SEL.Prf==0)      
         if (Ask-CloseSell<StopLevel) SEL.Val=0;   else   SEL.Prf=CloseSell;  // цена закрытия блеже к цене чем текущее значение, если оно вообще установлено
      }  
   ERROR_CHECK("Output");
   }   
     




