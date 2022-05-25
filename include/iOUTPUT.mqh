uchar OutGlob, OutLoc, OutImp; // �������� ��������� �������������� �� ������� ���������� Out
void OUTPUT(){
   if (Out==0) return;
   SetPROFIT_BUY=0;  SetPROFIT_SELL=0; // �������� ������ ��� ���������� ������� 
   switch (oPrice){// ����������� ��� ���������� �������� �� ������� �������� MovUP � MovDN  
      case 1:  SetPROFIT_BUY=Bid;  // ����������� �������� 
               SetPROFIT_SELL=Ask;  break; // ����
      case 2:  CHOOSE_PROFIT(0);    break; //  ����������� ����� �� ��������� �������   (1-��������, 0-����������� ����) ����� �������: UP1, UP2, ATR*pAtr, UP3, Poc.UpLev, TargetUp
      case 3:  SetPROFIT_BUY=MaxFromBuy;   // ����������� ����� �� ������������ ���� � ������� �������� ����
               SetPROFIT_SELL=MinFromSell; break;   
      }
   SetPROFIT_BUY +=DELTA(oD);  //  ������������� ������
   SetPROFIT_SELL-=DELTA(oD);  //  ATR = ATR*dAtr*0.1,  D=-5..5,    dAtr=6..12     
   if (BUY &&
     ((OutGlob && GlobalTrend<0) || // ���������� ����� �����������
      (OutLoc  && Trend<0) ||       // ��������� ����� �����������
      (OutImp  && Imp.Sig<0))){     // �������� �������
      if (SetPROFIT_BUY <PROFIT_BUY)  PROFIT_BUY=SetPROFIT_BUY; // ����������� ���� ����� 
      if (SetPROFIT_BUY-Bid<StopLevel) BUY=0;  // �����������
      }  
   if (SELL && 
     ((OutGlob && GlobalTrend>0) || // ���������� ����� �����������
      (OutLoc  && Trend>0) ||       // ��������� ����� �����������
      (OutImp  && Imp.Sig>0))){     // �������� �������
      if (SetPROFIT_SELL>PROFIT_SELL) PROFIT_SELL=SetPROFIT_SELL;
      if (Ask-SetPROFIT_SELL<StopLevel)  SELL=0;
   }  }  
// ����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������
// ����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������          
void TRAILING(){//    - T R A I L I N G   S T O P -
   if (Trl==0) return;
   SetBUY=Low[bar];  SetSELL=High[bar]; // � �.-��� CHOOSE_STOP() ���� �������� �� ��������������� ���� ��������, ������ ������
   SetSTOP_BUY=0;    SetSTOP_SELL=0; // �������� ������ ��� ���������� �������
   CHOOSE_STOP(0); //  ����������� ����� �� ��������� �������   (1-��������, 0-����������� ����) ����� �������: DN1, DN2, ATR*sAtr, DN3Pic, Poc.DnLev, TargetDn
   if (BUY && 
      (SetSTOP_BUY>BUY || Trl<0)  && // ��� Trl>0 �������� �� �����
      SetSTOP_BUY>STOP_BUY){   X("TRAILING_BUY="+DoubleToStr(SetSTOP_BUY,Digits)+" BUY="+DoubleToStr(BUY,Digits) , SetSTOP_BUY , clrWhite);
      STOP_BUY=SetSTOP_BUY;} // ����������� ���� �����    
   if (SELL && SetSTOP_SELL>0 &&
      (SetSTOP_SELL<SELL || Trl<0) && 
      SetSTOP_SELL<STOP_SELL){ X("TRAILING_SELL", SetSTOP_SELL, clrWhite);
      STOP_SELL=SetSTOP_SELL;}
   }

   