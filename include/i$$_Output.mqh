void Output(){ 
   if (!BUY.Val && !SEL.Val) return;
   float CloseSel=0, CloseBuy=0; // цена, по которой планируется закрываться
   bool  TrUp=BUY.Val, TrDn=SEL.Val;   
   if (Out1){
      Signal(3,1,MathAbs(Out1)); // Signal (int SigMode, int SigType, int Sk, int bar) 
      if (Out1<0)   {bool k=Up; Up=Dn; Dn=k;} // реверснем сигналы
      TrUp&=!Dn; TrDn&=!Up; // выход при появлении противоположного сигнала
      }
   if (Out2){
      Signal(3,1,MathAbs(Out2)); // Signal (int SigMode, int SigType, int Sk, int bar) 
      if (Out2<0)   {bool k=Up; Up=Dn; Dn=k;} // реверснем сигналы
      TrUp&=!Dn; TrDn&=!Up;
      }
      

   switch (Oprc){  // расчет цены выходов: 
      case  1: // по рынку
         CloseBuy=float(Bid);     
         CloseSel=float(Ask);    
      break;   
      case  2: // профит на максимально достигнутой в сделке цене
         CloseBuy=MaxFromBuy; 
         CloseSel=MinFromSell; 
      break;   
      case  3: // на ближайший фрактал
         CloseBuy=HI; 
         CloseSel=LO; 
      break; 
      }        
   if (BUY.Val && !TrUp){// Выходим из длинной  
      if (CloseBuy<BUY.Val+Present) CloseBuy=BUY.Val+Present; // двинем выход вверх, если просит жаба
      if (CloseBuy<BUY.Prf || BUY.Prf==0){ // если выход ниже профит таргета, или таргета нет вовсе
         if (CloseBuy-Bid<StopLevel) BUY.Val=0;   else   BUY.Prf=CloseBuy;} 
      LINE("CloseBuy", bar,CloseBuy, bar+1,CloseBuy, clrGreenYellow,0);  // Print("CloseBuy=",CloseBuy," Buy.Val=",BUY.Val);  
      }  
   if (SEL.Val && !TrDn){// Выходим из короткой  
      if (CloseSel>SEL.Val-Present) CloseSel=SEL.Val-Present;  // двинем выход вниз, если просит жаба
      if (CloseSel>SEL.Prf || SEL.Prf==0){      
         if (Ask-CloseSel<StopLevel) SEL.Val=0;   else   SEL.Prf=CloseSel;}  // цена закрытия блеже к цене чем текущее значение, если оно вообще установлено
      LINE("CloseSel", bar,CloseSel, bar+1,CloseSel, clrGreenYellow,0); // Print("CloseSel=",CloseSel," Sel.Val=",SEL.Val);   
      }  
   ERROR_CHECK("Output");
   }   
     




