void Output(){ 
   if (OUT==0 || (!BUY && !SELL)) return;
   double   CloseSell, CloseBuy; // ����, �� ������� ����������� �����������
   int k;
   Signal(1,OUT,Ok,1); // Signal (int SigMode, int SigType, int Sk, int bar) 
   if (Orev==-1)   {k=Up; Up=Dn; Dn=k;} // ��������� �������
   if (!Up && !Dn) return;
      
// � � � � � �  � � � � � �  � �  � � � � � ////////////////////////////////////////////////////////////////     
   switch (Oprice){  // ������ ���� �������: 
      case  1: // �� �����
         CloseBuy=Bid;     
         CloseSell=Ask;    
      break;   
      case  2: // ������ �� ����������� ����������� � ������ ����
         CloseBuy=MaxFromBuy; 
         CloseSell=MinFromSell; 
      break;   
      }        
   if (BUY>0 && Dn==1){// ������� �� �������  
      if (CloseBuy<BUY+Present) CloseBuy=BUY+Present; // ������ ����� �����, ���� ������ ����
      if (CloseBuy<PROFIT_BUY || PROFIT_BUY==0) // ���� ����� ���� ������ �������, ��� ������� ��� �����
         if (CloseBuy-Bid<StopLevel) BUY=0;   else   PROFIT_BUY=CloseBuy;  
      }  
   if (SELL>0 && Up==1){// ������� �� ��������  
      if (CloseSell>SELL-Present) CloseSell=SELL-Present;  // ������ ����� ����, ���� ������ ����
      if (CloseSell>PROFIT_SELL || PROFIT_SELL==0)      
         if (Ask-CloseSell<StopLevel) SELL=0;   else   PROFIT_SELL=CloseSell;  // ���� �������� ����� � ���� ��� ������� ��������, ���� ��� ������ �����������
   }  }   
     




