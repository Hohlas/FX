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
      Signal(3,2,MathAbs(Out2)); // Signal (int SigMode, int SigType, int Sk, int bar) 
      if (Out2<0)   {bool k=Up; Up=Dn; Dn=k;} // реверснем сигналы
      TrUp&=!Dn; TrDn&=!Up;
      }
   if (Out3){
      Signal(3,3,MathAbs(Out3)); // Signal (int SigMode, int SigType, int Sk, int bar) 
      if (Out3<0)   {bool k=Up; Up=Dn; Dn=k;} // реверснем сигналы
      TrUp&=!Dn; TrDn&=!Up;
      }   
   if (Out4){
      Signal(3,4,MathAbs(Out4)); // Signal (int SigMode, int SigType, int Sk, int bar) 
      if (Out3<0)   {bool k=Up; Up=Dn; Dn=k;} // реверснем сигналы
      TrUp&=!Dn; TrDn&=!Up;
      }
   if (Out5){
      Signal(3,5,MathAbs(Out5)); // Signal (int SigMode, int SigType, int Sk, int bar) 
      if (Out3<0)   {bool k=Up; Up=Dn; Dn=k;} // реверснем сигналы
      TrUp&=!Dn; TrDn&=!Up;
      }
   if (Out6){
      Signal(3,6,MathAbs(Out6)); // Signal (int SigMode, int SigType, int Sk, int bar) 
      if (Out3<0)   {bool k=Up; Up=Dn; Dn=k;} // реверснем сигналы
      TrUp&=!Dn; TrDn&=!Up;
      }         
   if (Out7){
      Signal(3,7,MathAbs(Out7)); // Signal (int SigMode, int SigType, int Sk, int bar) 
      if (Out3<0)   {bool k=Up; Up=Dn; Dn=k;} // реверснем сигналы
      TrUp&=!Dn; TrDn&=!Up;
      }
   if (Out8){
      Signal(3,8,MathAbs(Out8)); // Signal (int SigMode, int SigType, int Sk, int bar) 
      if (Out3<0)   {bool k=Up; Up=Dn; Dn=k;} // реверснем сигналы
      TrUp&=!Dn; TrDn&=!Up;
      }      
   if (OTr){// пропадание сигнала тренда
      Signal(1,TR,TRk); // Signal (int SigMode, int SigType, int Sk, int bar) 
      if (TR<0)   {bool k=Up; Up=Dn; Dn=k;} // реверснем сигналы
      TrUp&=Up; TrDn&=Dn;
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
         CloseBuy=HI-ATR; 
         CloseSel=LO+ATR; 
      break; 
      }        
   if (BUY.Val && !TrUp){// Выходим из длинной  
      if (CloseBuy<BUY.Val+Present) CloseBuy=BUY.Val+Present; // двинем выход вверх, если требует жаба
      if (CloseBuy<BUY.Prf || BUY.Prf==0){ // если выход ниже профит таргета, или таргета нет вовсе
         if (CloseBuy-Bid<StopLevel) BUY.Val=0;   else   BUY.Prf=CloseBuy;} 
      X("CloseBuy, Present="+S4(Present), CloseBuy, bar, clrGreenYellow);   // Print("CloseBuy=",CloseBuy," Buy.Val=",BUY.Val);  
      }  
   if (SEL.Val && !TrDn){// Выходим из короткой  
      if (CloseSel>SEL.Val-Present) CloseSel=SEL.Val-Present;  // двинем выход вниз, если требует жаба
      if (CloseSel>SEL.Prf || SEL.Prf==0){      
         if (Ask-CloseSel<StopLevel) SEL.Val=0;   else   SEL.Prf=CloseSel;}  // цена закрытия блеже к цене чем текущее значение, если оно вообще установлено
      X("CloseSel, Present="+S4(Present), CloseSel, bar, clrGreenYellow);  // Print("CloseSel=",CloseSel," Sel.Val=",SEL.Val);   
      }  
   ERROR_CHECK("Output");
   }   
     




