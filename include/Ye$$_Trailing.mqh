void TrailingStop(){   // ��������� ���������:
   if (T>9 || T==0) return;    
   double TrlBuy=0,TrlSell=0;
   temp=NormalizeDouble(atr*MathPow((T+3),1.8)*0.1,Digits); // 1.2ATR  1.8ATR  2.5ATR  3.3ATR  4.2ATR  5.2ATR  6.3ATR  7.5ATR  8.7ATR 
   switch (Tk){    
      case 1: // �������
         TrlBuy=Close[1]-temp;  
         TrlSell=Close[1]+temp;  
      break;   
      case 2:  // CandelStop (������ �� ���� ����)
         TrlBuy =MaxFromBuy-temp;  //Print("MaxFromBuy=",MaxFromBuy," MinFromSell=",MinFromSell); 
         TrlSell=MinFromSell+temp;   
      break;
      case 3: // ����  
         TrlBuy =Fibo(4-T);   
         TrlSell=Fibo(T-4);
      break;
      default: // ��������������������
         TrlBuy=Low[1];  
         TrlSell=High[1];
      break;    
      }  
   if (TM>0 && Tm>0){   
      switch (TM){ // ����������� ����������
         case 1:  // ��� ������ �� �����, ��� ������ ���� Tm = 0..4
            if (TrlBuy>BUY)   TrlBuy=TrlBuy+NormalizeDouble((TrlBuy-BUY)*Tm*Tm*0.1,Digits);    // 0.1  0.4  0.9  1.6  �� �������
            if (TrlSell<SELL) TrlSell=TrlSell-NormalizeDouble((SELL-TrlSell)*Tm*Tm*0.1,Digits); 
            break;
         case 2:  // ����������� � �������� �����
            temp=ATR*Tm*0.1; // ��� ��������� = ATR * 0.3  0.6  0.9  1.2
            if (TrlBuy-STOP_BUY<temp)    TrlBuy=STOP_BUY;
            if (STOP_SELL-TrlSell<temp)  TrlSell=STOP_SELL;   
            break;
         case 3:  // ����������� ����������� ����� � ������ ��������
            if (TrlBuy>STOP_BUY)   TrlBuy=STOP_BUY+NormalizeDouble((TrlBuy-STOP_BUY)*Tm*Tm*0.1,Digits);  // 0.1  0.4  0.9  1.6 
            if (TrlSell<STOP_SELL) TrlSell=STOP_SELL-NormalizeDouble((STOP_SELL-TrlSell)*Tm*Tm*0.1,Digits);
            break;
      }  }  
   temp=StopLevel+Spred;          
   if (BUY>0  && TrlBuy>STOP_BUY   && ((TrlBuy>BUY && TrlBuy<Bid-temp)    || TS==0))   STOP_BUY=TrlBuy;
   if (SELL>0 && TrlSell<STOP_SELL && ((TrlSell<SELL && TrlSell>Ask+temp) || TS==0))   STOP_SELL=TrlSell; //{Print("SELL=",SELL," TrlSell=",TrlSell);} 
   }
   
// ������������������������������������������������������������������������������������������������������������������������������������������������������������������������ 
// ������������������������������������������������������������������������������������������������������������������������������������������������������������������������   

void TrailingProfit(){ // ����������� ������� (������������ ���� ������������ � ���� ��������)  
   if (PM==0) return;
   double NewProfitBuy, NewProfitSell;
   switch (PM){
      case 1: // ������� ������ ������ + ���� ���� ���������� �� ����������������������� �� xATR, �� ���������� ������ �� ���������������������� �������
         temp=ATR*Pm; // 1  2  3  4
         if (BUY>0  && MaxFromBuy-Low[1]>temp)     NewProfitBuy=MaxFromBuy; 
         if (SELL>0 && High[1]-MinFromSell>temp)   NewProfitSell=MinFromSell; 
      break; 
      case 2: // ����������� ������������� ��� ������ ������ ���� ������ ������ �� �� ���� ���������������������� � ������ ����
         temp=NormalizeDouble((Mid2-Mid1)*(Pm+1)*(Pm+1)*0.1,Digits); // 0.4  0.9  1.6  2.5
         if (BUY>0 && temp>0){// ���� ��� �������� �����
            if (PROFIT_BUY==0) PROFIT_BUY=MaxFromBuy;
            if (PROFIT_BUY-temp>MaxFromBuy) NewProfitBuy=PROFIT_BUY-temp; // ������� ������ �� ���� ���������������������� � ������ ����                              
            }  
         if (SELL>0 &&  temp<0){
            if (PROFIT_SELL==0) PROFIT_SELL=MinFromSell; 
            if (PROFIT_SELL-temp<MinFromSell) NewProfitSell=PROFIT_SELL-temp; // �� ������� ������ ���� ��������������������� � ������ ����
            }
      break; 
      case 3: // ��� � �.2: ����������� ������������� ��� ������ ������ ���� ������ ������, �� ������ ��������� ���� ��������
         temp=NormalizeDouble((Mid2-Mid1)*(Pm+1)*(Pm+1)*0.1,Digits); // 0.4  0.9  1.6  2.5
         if (BUY>0 && temp>0){// ���� ��� �������� �����
            if (PROFIT_BUY==0) PROFIT_BUY=MaxFromBuy; 
            NewProfitBuy=PROFIT_BUY-temp; // ������� ������ �� ���� ���� ��������               
            }
         if (SELL>0 && temp<0){
            if (PROFIT_SELL==0) PROFIT_SELL=MinFromSell;  
            NewProfitSell=PROFIT_SELL-temp; 
            }  
      break;
      }
   if (NewProfitBuy>0   && (NewProfitBuy<PROFIT_BUY   || PROFIT_BUY==0))  PROFIT_BUY=NewProfitBuy;
   if (NewProfitSell>0  && (NewProfitSell>PROFIT_SELL || PROFIT_SELL==0)) PROFIT_SELL=NewProfitSell;
   }  
   
    
   
              