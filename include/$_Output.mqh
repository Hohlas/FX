void Output() 
   {
   double   CloseSell, CloseBuy; // ����, �� ������� ����������� �����������
   if (OUT==0 && Otr==0) return;
   switch (Otr){ // ��������� �������� ������
      case 1:  Up=UpTr; Dn=DnTr;  break;   // ��� ����������
      case 0:  Up=1;    Dn=1;     break;   // ������������� ������
      case -1: Up=DnTr; Dn=UpTr;  break;   // ����������� ������� ������
      }
   Up=(Up && SELL); // ���� ����� ������������ ������� �� �������� �������� ���� � ���� �������� ���� 
   Dn=(Dn && BUY);   
   if (!Up && !Dn) return;
   bool tmpUp=Up, tmpDn=Dn; // ��������� ���������� ���������� Up � Dn 
   int k;
   Signal(3,OUT,Ok,1); // Signal (int SigMode, int SigType, int Sk, int bar) 
   if (Orev==-1)   {k=Up; Up=Dn; Dn=k;} // ��������� �������
   Up=(Up && tmpUp); 
   Dn=(Dn && tmpDn);
   if (!Up && !Dn) return;
      
// � � � � � �  � � � � � �  � �  � � � � � ////////////////////////////////////////////////////////////////     
   switch (Oprice){  // ������ ���� �������: 
      case -1: CloseBuy=L;  CloseSell=H ;break;   // ������ ���� �� ��������� ��������
      case  0: CloseBuy=Bid;     CloseSell=Ask;    break;   // �� �����
      case  1: CloseBuy=MaxFromBuy; CloseSell=MinFromSell; break;   // ������ �� ����������� ����������� � ������ ����
      }        
// ������� �� ��������   
   if (SELL>0 && Up==1 && CloseSell<SELL-Present){ // ������� ������ �� ����� �� �������� � ���� �������� �������� �������������� �������� (StopShortVal*P*0.5 - �������� ����������� �������, ��� ������� ��� ����� �����������)
      if (MathAbs(Ask-CloseSell)<StopLevel) SELL=0;    // ������� �� �����,
      if (Ask-CloseSell>StopLevel && (CloseSell>PROFIT_SELL || PROFIT_SELL==0)) PROFIT_SELL=CloseSell;  // ���� �������� ����� � ���� ��� ������� ��������, ���� ��� ������ �����������
      if (CloseSell-Ask>StopLevel &&  CloseSell<STOP_SELL)                      STOP_SELL=CloseSell;    // ���� �������� ����� � ���� ��� ������� ��������
      }   
// ������� �� �������  
   if (BUY>0 && Dn==1 && CloseBuy>BUY+Present){// ������� �� ������� 
      if (MathAbs(Bid-CloseBuy)<StopLevel) BUY=0;
      if (CloseBuy-Bid>StopLevel && (CloseBuy<PROFIT_BUY || PROFIT_BUY==0))     PROFIT_BUY=CloseBuy;  // ���� �������� ����� � ���� ��� ������� ��������, ���� ��� ������ �����������
      if (Bid-CloseBuy>StopLevel &&  CloseBuy>STOP_BUY)                         STOP_BUY=CloseBuy;    // ���� �������� ����� � ���� ��� ������� ��������
      }   
   
   
   }  




