int  sUP, sDN; // �������
bool fUP, fDN; // ���������� ������� �����������
double StopBuy, StopSell, ProfitBuy, ProfitSell;

void INPUT(){
   SetBUY=0;   SetSTOP_BUY=0;    SetPROFIT_BUY=0; SetSELL=0;  SetSTOP_SELL=0;   SetPROFIT_SELL=0; // �������� ������� 
   if (iBar>0) sUP--; sDN--; // ��� iParam=0 ������� ��������� � �� ��������, ��� >0 ����� iParam ���
   fUP=!BUY; 
   fDN=!SELL; 
   FILTERS(fNewPic, fGlbTrnd, fLocTrnd, fImpulse, fTrndLev);  // ������� ����������� ����������� ��������� ������� MovUP � MovDN 
   //TEXT("UP","BUY="+DoubleToStr(BUY,Digits-1)+" MovUP="+DoubleToStr(MovUP,Digits-1), Low[bar]-0.005);
   //TEXT("DN","SELL="+DoubleToStr(SELL,Digits-1)+" MovDN="+DoubleToStr(MovDN,Digits-1), High[bar]+0.005);
   switch(iSignal){// ������������� ���������� ��������. ���������� �������� UP � DN, ��� ���������� ������ � �-�� ��������, ������� �� ������ ���������� �� ������ ����
      case 1:  SIG_MIRROR_LEVELS(); break;   // ������ �� ���������� �������� �������
      case 2:  SIG_FLAT();          break;   // ������ �� ������ �����
      case 3:  SIG_FALSE_LEV();     break;   // ������ ������
      case 4:  SIG_FALSE_LEV_2();   break;   // 
      default: SIG_NULL();          break;   // ��� ��������
      }
   SIG_LINES(fUP,"fUP BUY="+DoubleToStr(BUY,Digits), fDN,"fDN SELL="+DoubleToStr(SELL,Digits), 0x303030); // ����� �������� MovUP � MovDN: (�������, �������� �� H/L, ����)   
   SIG_LINES(sUP,"sUP="    +DoubleToStr(sUP,0),      sDN,"sDN="     +DoubleToStr(sDN,0),0x505050);// ����� �������� UP � DN: (�������, ����)   
   if (sUP<=0) fUP=false;
   if (sDN<=0) fDN=false;
   if (ExpirBars==0){// �������� ���������� ��� ���������� �������
      if (!fDN && (SELLSTOP>0 || SELLLIMIT>0))  {SELLSTOP=0; SELLLIMIT=0; Modify();}
      if (!fUP && (BUYSTOP>0  ||  BUYLIMIT>0))  {BUYSTOP=0;  BUYLIMIT=0;  Modify();}    
      }
   if (!fUP && !fDN) return;  // �������� �� ���� ���
         //  � � � �   � � � � �
   switch (Iprice){ 
      case 0: SetBUY=s.Buy;         SetSELL=s.Sell;         break;// ���������� ���� �� ������� ��������
      case 1: SetBUY=Ask;           SetSELL=Bid;            break;// �� ������� ���� �������� (ask � bid ��������� �� Open[0], ���� ��������� �� �������� �� ������� ������)
      case 2: SetBUY=DN1;           SetSELL=UP1;            break;// �� ��������� �����
      case 3: SetBUY=DN2;           SetSELL=UP2;            break;// �� �������� ������� � ����������� ��������� 
      case 4: SetBUY=DnCenter;      SetSELL=UpCenter;       break;// �� ��������� ������� 
      case 5: SetBUY=Poc.DnLev;     SetSELL=Poc.UpLev;      break;// �� ������� ������������ POC
      case 6: SetBUY=TargetDn;      SetSELL=TargetUp;       break;// �� �������
      case 7: SetBUY=FirstDnCenter; SetSELL=FirstUpCenter;  break;// �� ������ �������
      }
   if (fUP && SetBUY>0)  SetBUY =NormalizeDouble(SetBUY +DELTA(D),Digits);  else  SetBUY=0;
   if (fDN && SetSELL>0) SetSELL=NormalizeDouble(SetSELL-DELTA(D),Digits);  else  SetSELL=0;
   CHOOSE_STOP(1);   // � � � � �   � � � � � �  (1-��������, 0-����������� ����) ����� �������: DN1, DN2, s.BuyStp, ATR*sAtr, DN3Pic, Poc.DnLev, TargetDn, FirstDnPic.
   CHOOSE_PROFIT(1); // � � � � �   � � � � � �  (1-��������, 0-����������� ����) ����� �������: UP1, UP2, s.BuyPrf, ATR*pAtr, UP3, Poc.UpLev, TargetUp, FirstUp
   double PL=MathAbs(minPL)*0.5;
   // �������� �����������  Profit / Loss
   if (SetBUY>0  && ProfitBuy/StopBuy <PL){// ��� ������ ����������� P/L:
      if (minPL<0) SetBUY=0;  // ���� �� �����������, ����   
      if (minPL>0){           // ���� �������� ������������ ��� �������������� ��������� PL
         StopBuy=(StopBuy+ProfitBuy)/(1+PL); // �����������, ����� ������ ���� ����                                        //   X("Old BUY", SetBUY, clrWhite);
         SetBUY=NormalizeDouble(SetSTOP_BUY+StopBuy,Digits);   // ������� ���� ��������
         StopBuy =SetBUY-SetSTOP_BUY;     ProfitBuy =SetPROFIT_BUY-SetBUY;
      }  }
   if (SetSELL>0 && ProfitSell/StopSell<PL){// ��� ������ ����������� P/L:
      if (minPL<0) SetSELL=0; // ���� �� �����������, ���� 
      if (minPL>0){// ���� �������� ������������ ��� �������������� ��������� PL
         StopSell=(StopSell+ProfitSell)/(1+PL);                                     //  X("Old SELL", SetSELL, clrWhite);  
         SetSELL=NormalizeDouble(SetSTOP_SELL-StopSell,Digits);
         StopSell=SetSTOP_SELL-SetSELL;   ProfitSell=SetSELL-SetPROFIT_SELL; 
      }  }  
   // ������������� �������� ������� ������
   if (SetBUY >0 && MathAbs(SetBUY -Ask)<=StopLevel) {SetBUY =Ask; StopBuy =SetBUY-SetSTOP_BUY;     ProfitBuy =SetPROFIT_BUY-SetBUY;}
   if (SetSELL>0 && MathAbs(SetSELL-Bid)<=StopLevel) {SetSELL=Bid; StopSell=SetSTOP_SELL-SetSELL;   ProfitSell=SetSELL-SetPROFIT_SELL;}
   if (StopBuy <=StopLevel || ProfitBuy <=StopLevel) SetBUY=0;
   if (StopSell<=StopLevel || ProfitSell<=StopLevel) SetSELL=0;
   if (Del==1){   // ��� ��������� ������ ������� ������� ������ ��������;     
      if (SetBUY>0)  {BUYSTOP=0;    BUYLIMIT=0;    Modify();}  
      if (SetSELL>0) {SELLSTOP=0;   SELLLIMIT=0;   Modify();}  
      }  
   SIG_LINES(SetBUY,"SetBUY="+DoubleToStr(SetBUY,Digits), SetSELL,"SetSELL="+DoubleToStr(SetSELL,Digits),0x707070); // ����� �������� UP � DN: (�������, ����)
   ORDERS_SET(); // � � � � � � � � � � �    � � � � �    � � � � � � �
   }
// ��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������   
// ��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������     
double MAX(double price1, double price2){
   if (price1>price2) return (price1); else return (price2);
   } 
double MIN(double price1, double price2){// ���������� �������, �� �� ������� ��������
   if (price1==0) return (price2);
   if (price2==0) return (price1);
   if (price1<price2) return (price1); else return (price2);
   }  
double DELTA(int delta){
   if (delta>0) return( MathPow(delta+1,2)*0.1*ATR);    
   if (delta<0) return(-MathPow(delta-1,2)*0.1*ATR); //  ATR = ATR*dAtr*0.1,     
   return (0);
   } 
// ��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������   
// ��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������   
void CHOOSE_STOP(bool OrdSet){// � � � � �   � � �   � � � � � �   (OrdSet=1-��������, 0-����������� ����) ����� �������: DN1, DN2, s.BuyStp, ATR*sAtr, DN3Pic, Poc.DnLev, TargetDn, FirstDnPic.
   switch (Sprice){// ��������� ����   
      case 0:  SET_STOP(OrdSet, SetBUY-ATR, SetSELL+ATR); break;   // ������� ATR
      case 1:  SET_STOP(OrdSet, MAX(DN1,DN2), MIN(UP1,UP2)); break;   // �� ������ �� ����� � ����� � ����������� ���������
      case 2:  SET_STOP(OrdSet, MIN(DN1,DN2), MAX(UP1,UP2)); break;}  // �� ������� �� ����� � ����� � ����������� ��������� 
   if (sTrd>0) SET_STOP(OrdSet, DN3Pic,UP3Pic);      // �� ��� ����������� ����������          
   if (sPoc>0) SET_STOP(OrdSet, Poc.Dn,Poc.Up);// �� ������ ������������ POC          
   if (sTgt>0) SET_STOP(OrdSet, TargetDn,TargetUp);  // �� ������� ������          
   if (OrdSet){// ����� �� ���������� � ������� ������� ����������� ������ ��� �������� ������, ��� ���������� �� �������
      if (sSig>0) SET_STOP(OrdSet, s.BuyStp,s.SellStp);    // C��������� ����� �� ������� ��������
      if (sFst>0) SET_STOP(OrdSet, FirstDnPic,FirstUpPic); // ���� ������ �������
      }    
   if (SetSTOP_BUY>0)   {SetSTOP_BUY =NormalizeDouble(SetSTOP_BUY -DELTA(S),Digits);   StopBuy =SetBUY-SetSTOP_BUY;  }  else {SetBUY =0;  StopBuy=0;}   // ������, ������������ ���� ��   
   if (SetSTOP_SELL>0)  {SetSTOP_SELL=NormalizeDouble(SetSTOP_SELL+DELTA(S),Digits);   StopSell=SetSTOP_SELL-SetSELL;}  else {SetSELL=0;  StopSell=0;}// ���������� ������, ��� ATR=dAtr*0.1*ATR
   }
// ��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������   
// ��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������   
void SET_STOP (bool OrdSet,  double NewStpBuy,  double NewStpSel) {// �������� ������ �������� ����� ����� ����������
   double MinStop=MathMax(StopLevel,MathAbs(sMin)*ATR), BuyPrice, SellPrice;
   double MaxStop=MinStop+MathAbs(sMax)*ATR;
   if (OrdSet) {BuyPrice=SetBUY;    SellPrice=SetSELL;}     // ����������� ���� ��� �������� ����,
   else        {BuyPrice=Low[bar];  SellPrice=High[bar];}   // ��� �� ������������ (���������)
   if (SetBUY>0 && NewStpBuy>0){ 
      if (BuyPrice -NewStpBuy < MinStop){// ���� ������� ������
         if (sMin<0)  NewStpBuy=0; else NewStpBuy=BuyPrice -MinStop;}// ����� ����, ���� ���������� ����
      if (BuyPrice -NewStpBuy > MaxStop && NewStpBuy>0){// ���� ������� ������ 
         if (sMax<0)  NewStpBuy=0;                                   // ����� ����, ����
         if (sMax>0 && OrdSet) SetBUY=NormalizeDouble(NewStpBuy+MaxStop,Digits);}// ����������� ���� � �����
      if ((SetSTOP_BUY==0  || NewStpBuy<SetSTOP_BUY) && NewStpBuy>0)    SetSTOP_BUY=NewStpBuy; // ����� ���� ������ �������� �� ������� ���� 
      }
   if (SetSELL>0 && NewStpSel>0){
      if (NewStpSel-SellPrice < MinStop){// ���� ������� ������
         if (sMin<0)  NewStpSel=0; else NewStpSel=SellPrice+MinStop;}// ����� ����, ���� ���������� ����
      if (NewStpSel-SellPrice > MaxStop && NewStpSel>0){// ���� ������� ������
         if (sMax<0)  NewStpSel=0;                                   // ����� ����, ����
         if (sMax>0 && OrdSet) SetSELL=NormalizeDouble(NewStpSel-MaxStop,Digits);}// ����������� ���� � �����
      if ((SetSTOP_SELL==0 || NewStpSel>SetSTOP_SELL) && NewStpSel>0)   SetSTOP_SELL=NewStpSel; // ����� ���� ������ �������� �� ������� ����  
   }  }  
// ��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������   
// ��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������   
void CHOOSE_PROFIT(bool OrdSet){// � � � � �   � � �   � � � � � �  (OrdSet=1-��������, 0-����������� ����)  ����� �������: UP1, UP2, s.BuyPrf, ATR*pAtr, UP3, Poc.UpLev, TargetUp, FirstUp.
   if (SetBUY>0)  SetPROFIT_BUY =SetBUY +20*SlowAtr;  // �� ���������� ����
   if (SetSELL>0) SetPROFIT_SELL=SetSELL-20*SlowAtr;  // � �������������
   switch (Pprice){ 
      case 1: SET_PROFIT(MIN(UP1,UP2),MAX(DN1,DN2));  break;   // �� ������ �� ����� � ����� � ����������� ���������
      case 2: SET_PROFIT(MAX(UP1,UP2),MIN(DN1,DN2));  break;}  // �� ������� �� ����� � ����� � ����������� ��������� 
   if (pTrd>0) SET_PROFIT(UP3,DN3);             // ��������� ����� (������� �� ���������� � ����������)      
   if (pPoc>0) SET_PROFIT(Poc.Up,Poc.Dn); // POC ����� (������� �� ���������� � �� ������ ������������ POC)      
   if (pTgt>0) SET_PROFIT(TargetUp,TargetDn);   // ������� ����� (������� �� ���������� � �� ������� ������) 
   if (OrdSet){// ������ ��� �������� ������ �� �� ��� �����������
      if (pSig>0) SET_PROFIT(s.BuyPrf, s.SellPrf); // C��������� ����� �� ������� �������� (������� �� ���������� � �����������)  
      if (pFst>0) SET_PROFIT(FirstUp,FirstDn);     // ������ ������ (������� �� ���������� � �� ������ ������)  
      if (pMax>0){// �������� �� ��������� ����� �� ���� ��������
         double MaxProfit=(pMax+1)*ATR;
         if (SetPROFIT_BUY-SetBUY >MaxProfit)   SetPROFIT_BUY=SetBUY+MaxProfit;  // 
         if (SetSELL-SetPROFIT_SELL>MaxProfit)  SetPROFIT_SELL=SetSELL-MaxProfit;
      }  }    
   if (SetPROFIT_BUY >0)   {SetPROFIT_BUY =NormalizeDouble(SetPROFIT_BUY -DELTA(Prf),Digits);   ProfitBuy =SetPROFIT_BUY-SetBUY;}     else  {SetBUY =0;  ProfitBuy=0;}  
   if (SetPROFIT_SELL>0)   {SetPROFIT_SELL=NormalizeDouble(SetPROFIT_SELL+DELTA(Prf),Digits);   ProfitSell=SetSELL-SetPROFIT_SELL;}   else  {SetSELL=0;  ProfitSell=0;}  
   }  
// ��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������   
// ��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������   
void SET_PROFIT (double NewPrfBuy,double NewPrfSel) {// �������� ������ �������� ����� ����� ����������
   if (SetBUY>0  && NewPrfBuy>0 && NewPrfBuy<SetPROFIT_BUY)  SetPROFIT_BUY=NewPrfBuy;   // ����� ���� ����� �������� � ������� ����  if (Prn) Print(" NewPrfBuy=",NewPrfBuy," UP1=",UP1," SetBUY=",SetBUY," ASK=",Ask);
   if (SetSELL>0 && NewPrfSel>0 && NewPrfSel>SetPROFIT_SELL) SetPROFIT_SELL=NewPrfSel;  // ����� ���� ����� �������� � ������� ����   
   } 
// ��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������   
// ��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������   


     