void ORDERS_SET(){
   bool repeat;   int ticket;   double TradeRisk=0; 
   if (ExpirBars>0)  Expiration=Time[0]+ExpirBars*Period()*60; else Expiration=0;// ��������� ������ �� 30���, ���� ��������� � ������ 
   if (SetBUY>0){ 
      repeat=true; 
      if (Real){
         ERROR_CHECK();// ����� ������ ������
         MARKET_INFO();
         if (StopBuy<=0) {Report("StopBuy<=0"); return;}
         Lot=MM(StopBuy); if (Lot<0) {Report("Lot<0"); return;} 
         TradeRisk=RiskChecker(Lot,SetBUY-SetSTOP_BUY,Symbol());   //   Print("Lot=",Lot," StopBuy=",StopBuy," TradeRisk=",TradeRisk," SetBUY=",SetBUY," SetSTOP_BUY=",SetSTOP_BUY," SetPROFIT_BUY=",SetPROFIT_BUY);
         if (TradeRisk>MaxRisk) {Report("RiskChecker="+DoubleToStr(TradeRisk,1)+"% too BIG!!! Lot="+DoubleToStr(Lot,LotDigits)+" Balance="+DoubleToStr(AccountBalance(),0)+" Stop="+DoubleToStr(SetBUY-SetSTOP_BUY,Digits-1)+" SetBUY="+DoubleToStr(SetBUY,Digits-1)+" SetSTOP_BUY="+DoubleToStr(SetSTOP_BUY,Digits-1)); return;}
         TerminalHold(60); // ���� 60��� ������������ ���������
         }
      while (repeat && BUY==0 && BUYSTOP==0 && BUYLIMIT==0){ // ����� ��������� ��������� ����������� ��� ������ 128
         if (SetBUY-Ask>StopLevel)  {str="Set BuyStp ";   ticket=OrderSend(Symbol(),OP_BUYSTOP, Lot, SetBUY, 3, SetSTOP_BUY, SetPROFIT_BUY, "BuyStop" ,Magic,Expiration,CornflowerBlue);}   else
         if (Ask-SetBUY>StopLevel)  {str="Set BuyLim ";   ticket=OrderSend(Symbol(),OP_BUYLIMIT,Lot, SetBUY, 3, SetSTOP_BUY, SetPROFIT_BUY, "BuyLimit",Magic,Expiration,CornflowerBlue);}   else
                      {SetBUY=Ask;   str="Set Buy ";      ticket=OrderSend(Symbol(),OP_BUY,     Lot, SetBUY, 3, SetSTOP_BUY, SetPROFIT_BUY, "Buy",     Magic,    0        ,CornflowerBlue);}
         if (Real)    {Report(str+DoubleToStr(SetBUY,Digits)+"/"+DoubleToStr(SetSTOP_BUY,Digits)+"/"+DoubleToStr(SetPROFIT_BUY,Digits)+"/"+DoubleToStr(Lot,LotDigits)+"x"+DoubleToStr(TradeRisk,1)+"% Expir="+TimeToString(Expiration,TIME_DATE | TIME_SECONDS)); OrderCheck();}
         if (ticket<0) repeat=ERROR_CHECK(); else repeat=false; 
      }  }
   if (SetSELL>0){ 
      repeat=true; 
      if (Real){
         ERROR_CHECK();// ����� ������ ������
         MARKET_INFO();
         if (StopSell<=0) {Report("StopSell<=0"); return;}
         Lot=MM(StopSell); if (Lot<0) {Report("Lot<0"); return;}
         TradeRisk=RiskChecker(Lot,SetSTOP_SELL-SetSELL,Symbol());
         if (TradeRisk>MaxRisk) {Report("RiskChecker="+DoubleToStr(TradeRisk,1)+"% too BIG!!! Lot="+DoubleToStr(Lot,LotDigits)+" Balance="+DoubleToStr(AccountBalance(),0)+" Stop="+DoubleToStr(SetSTOP_SELL-SetSELL,Digits-1)+" SetSELL="+DoubleToStr(SetSELL,Digits-1)+" SetSTOP_SELL="+DoubleToStr(SetSTOP_SELL,Digits-1)); return;}
         TerminalHold(60); // ���� 60��� ������������ ���������
         }
      while (repeat &&  SELL==0 && SELLSTOP==0 && SELLLIMIT==0){
         if (Bid-SetSELL>StopLevel) {str="Set SellStp ";   ticket=OrderSend(Symbol(),OP_SELLSTOP, Lot, SetSELL, 3, SetSTOP_SELL, SetPROFIT_SELL, "SellStop", Magic,Expiration,Tomato);}   else
         if (SetSELL-Bid>StopLevel) {str="Set SellLim ";   ticket=OrderSend(Symbol(),OP_SELLLIMIT,Lot, SetSELL, 3, SetSTOP_SELL, SetPROFIT_SELL, "SellLimit",Magic,Expiration,Tomato);}   else
                      {SetSELL=Bid;  str="Set Sell ";      ticket=OrderSend(Symbol(),OP_SELL,     Lot, SetSELL, 3, SetSTOP_SELL, SetPROFIT_SELL, "Sell",     Magic,      0       ,Tomato);}
         if (Real)    {Report(str+DoubleToStr(SetSELL,Digits)+"/"+DoubleToStr(SetSTOP_SELL,Digits)+"/"+DoubleToStr(SetPROFIT_SELL,Digits)+"/"+DoubleToStr(Lot,LotDigits)+"x"+DoubleToStr(TradeRisk,1)+"% Expir="+TimeToString(Expiration,TIME_DATE | TIME_SECONDS));    OrderCheck();}
         if (ticket<0) repeat=ERROR_CHECK(); else repeat=false; 
      }  }//�������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������
   TerminalFree();
   }  

void Modify(){   // ������� ����������� ����/����� ������: �������� ���� Buy/Sell=0 �����������������������������������������������������������������������������������������������������������������������������������������������������������      
   int Orders, Ord; 
   bool ReSelect=true, repeat, make=0;      // ���� �������� �����-�� �����, ���� ��������� ������� �������, �.�. OrdersTotal ����������, �.�. ��� ��� ���������������� 
   while (ReSelect){        // � ���������� ReSelect ������� �� ��������� �������        
      ReSelect=false; Orders=OrdersTotal();
      ERROR_CHECK();// ����� ������ ������
      for(Ord=0; Ord<Orders; Ord++){ 
         if (OrderSelect(Ord, SELECT_BY_POS, MODE_TRADES)==true && OrderMagicNumber()==Magic){
            Order=OrderType();
            repeat=true;  str="";
            MARKET_INFO();
            while (repeat){// ��������� �������� ��� �������, ���� �� ��������� ����������
               switch(Order){
                  case OP_SELL:        //  C L O S E   A N D   M O D I F Y    S E L L  //
                     if (SELL==0) {TerminalHold(60); make=OrderClose(OrderTicket(),OrderLots(),Ask,3,Tomato); if (Real) str="Close SELL "+DoubleToStr(OrderOpenPrice(),Digits-1); break;}     
                     if (STOP_SELL==OrderStopLoss() && PROFIT_SELL==OrderTakeProfit()) break; // ���� �� ���������� �����������, ���� ������
                     str="Modify Sell";  
                     if (STOP_SELL!=OrderStopLoss())      {if (Real) str=str+"Stop "+DoubleToStr(OrderStopLoss(),Digits);      if (STOP_SELL-Ask<StopLevel)    {STOP_SELL=Ask+StopLevel;   if (STOP_SELL>OrderStopLoss())      STOP_SELL=OrderStopLoss();}}
                     if (PROFIT_SELL!=OrderTakeProfit())  {if (Real) str=str+"Profit "+DoubleToStr(OrderTakeProfit(),Digits);  if (Ask-PROFIT_SELL<StopLevel)  {PROFIT_SELL=Ask-StopLevel; if (PROFIT_SELL<OrderTakeProfit())  PROFIT_SELL=OrderTakeProfit();}}//Print(" ord=",ord," STOP_SELL=",STOP_SELL," OrderStopLoss=",OrderStopLoss()," PROFIT_SELL=",PROFIT_SELL," OrderTakeProfit=",OrderTakeProfit());
                     if (MathAbs(STOP_SELL-OrderStopLoss()) + MathAbs(PROFIT_SELL-OrderTakeProfit())<1*MarketInfo(Symbol(),MODE_POINT)) str=""; // ����������� ������� �� ������������� 
                     else  {TerminalHold(60); make=OrderModify(OrderTicket(), OrderOpenPrice(), STOP_SELL, PROFIT_SELL,OrderExpiration(),Tomato);}   //Print(" ord=",ord," STOP_SELL=",STOP_SELL," OrderStopLoss=",OrderStopLoss()," PROFIT_SELL=",PROFIT_SELL," OrderTakeProfit=",OrderTakeProfit());
                     break; 
                  case OP_SELLSTOP:    //  D E L   S E L L S T O P  //
                     if (SELLSTOP==0){ 
                        if (Bid-OrderOpenPrice()>StopLevel){if (Real) str="Del SellStop "+DoubleToStr(OrderOpenPrice(),Digits); TerminalHold(60); make=OrderDelete(OrderTicket(),Tomato);}
                        else Report("CanNot Del SELLSTOP near market! Bid="+DoubleToStr(Bid,Digits)+" OpenPrice="+DoubleToStr(OrderOpenPrice(),Digits)+" StopLevel="+DoubleToStr(StopLevel,Digits));}
                     break;
                  case OP_SELLLIMIT:   //  D E L   S E L L L I M I T  //
                     if (SELLLIMIT==0){
                        if (OrderOpenPrice()-Bid>StopLevel) {if (Real) str="Del SellLimit "+DoubleToStr(OrderOpenPrice(),Digits);  TerminalHold(60); make=OrderDelete(OrderTicket(),Tomato);}
                        else Report("CanNot Del SELLLIMIT! near market, Bid="+DoubleToStr(Bid,Digits)+" OpenPrice="+DoubleToStr(OrderOpenPrice(),Digits)+" StopLevel="+DoubleToStr(StopLevel,Digits)); }   
                     break;
                  case OP_BUY: //  C L O S E   A N D   M O D I F Y      B U Y  //////////////////////////////////////////////////////////////
                     if (BUY==0){TerminalHold(60); make=OrderClose(OrderTicket(),OrderLots(),Bid,3,CornflowerBlue); if (Real) str="Close BUY "+DoubleToStr(OrderOpenPrice(),Digits);  break;}    
                     if (STOP_BUY==OrderStopLoss() && PROFIT_BUY==OrderTakeProfit()) break;
                     str="Modify Buy";  
                     if (STOP_BUY!=OrderStopLoss())      {if (Real) str=str+"Stop "+DoubleToStr(OrderStopLoss(),Digits);     if (Bid-STOP_BUY<StopLevel)   {STOP_BUY=Bid-StopLevel;   if (STOP_BUY<OrderStopLoss())       STOP_BUY=OrderStopLoss();}} 
                     if (PROFIT_BUY!=OrderTakeProfit())  {if (Real) str=str+"Profit "+DoubleToStr(OrderTakeProfit(),Digits); if (PROFIT_BUY-Bid<StopLevel) {PROFIT_BUY=Bid+StopLevel; if (PROFIT_BUY>OrderTakeProfit())   PROFIT_BUY=OrderTakeProfit();}}//Print(" ord=",ord," STOP_BUY=",STOP_BUY," OrderStopLoss=",OrderStopLoss()," PROFIT_BUY=",PROFIT_BUY," OrderTakeProfit=",OrderTakeProfit());
                     if (MathAbs(STOP_BUY-OrderStopLoss()) + MathAbs(PROFIT_BUY-OrderTakeProfit())<1*MarketInfo(Symbol(),MODE_POINT)) str="";// ����������� ������� �� �������������
                     else  {TerminalHold(60); make=OrderModify(OrderTicket(), OrderOpenPrice(), STOP_BUY, PROFIT_BUY,OrderExpiration(),CornflowerBlue);}   //Print(" ord=",ord," STOP_BUY=",STOP_BUY," OrderStopLoss=",OrderStopLoss()," PROFIT_BUY=",PROFIT_BUY," OrderTakeProfit=",OrderTakeProfit());
                     break; 
                  case OP_BUYSTOP:  //  D E L  B U Y S T O P  //
                     if (BUYSTOP==0){
                        if (OrderOpenPrice()-Ask>StopLevel){if (Real) str="Del BuyStop "+DoubleToStr(OrderOpenPrice(),Digits); TerminalHold(60); make=OrderDelete(OrderTicket(),CornflowerBlue);}
                        else Report("CanNot Del BUYSTOP near market! Ask="+DoubleToStr(Ask,Digits)+" OpenPrice="+DoubleToStr(OrderOpenPrice(),Digits)+" StopLevel="+DoubleToStr(StopLevel,Digits));}
                     break; 
                  case OP_BUYLIMIT: //  D E L  B U Y L I M I T  //
                     if (BUYLIMIT==0){
                        if (Ask-OrderOpenPrice()>StopLevel){if (Real) str="Del BuyLimit "+DoubleToStr(OrderOpenPrice(),Digits); TerminalHold(60); make=OrderDelete(OrderTicket(),CornflowerBlue);}
                     else Report("CanNot Del BUYLIMIT near market! Ask="+DoubleToStr(Ask,Digits)+" OpenPrice="+DoubleToStr(OrderOpenPrice(),Digits)+" StopLevel="+DoubleToStr(StopLevel,Digits));}
                     break;
                  }
               if (Real && str!="") Report(str);
               if (!make) repeat=ERROR_CHECK(); else repeat=false; // ���� �����-�� �������� �� �����������, ������ �������                 
            }  }//while(repeat)
         if (Orders!=OrdersTotal()) {ReSelect=true; break;} // ��� ������� ��� ��������� ���-�� ������� ���� ������ ���������� ������ (������� �� ����� "for"), �.�. ������ ������� ����������
         }//if (OrderSelect      
      }//while(ReSelect)     
   TerminalFree();
   }  //�������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������


     
void OrderCheck(){   // ������ ����������� �������� ���//�����������������������������������������������������������������������������������������������������������������������������������������������������
   BUY=0; BUYSTOP=0; BUYLIMIT=0; SELL=0; SELLSTOP=0; SELLLIMIT=0;  STOP_BUY=0; PROFIT_BUY=0; STOP_SELL=0; PROFIT_SELL=0;
   int Ord;
   for (Ord=0; Ord<OrdersTotal(); Ord++){ 
      if (OrderSelect(Ord, SELECT_BY_POS, MODE_TRADES)==true && OrderMagicNumber()==Magic){
         if (OrderType()==6) continue; // ��������� �� ����������
         switch(OrderType()){
            case OP_BUYSTOP:  BUYSTOP=OrderOpenPrice();  STOP_BUY=OrderStopLoss();  PROFIT_BUY=OrderTakeProfit();   BuyStopTime=OrderOpenTime();     break;
            case OP_BUYLIMIT: BUYLIMIT=OrderOpenPrice(); STOP_BUY=OrderStopLoss();  PROFIT_BUY=OrderTakeProfit();   BuyLimitTime=OrderOpenTime();    break;
            case OP_BUY:      BUY=OrderOpenPrice();      STOP_BUY=OrderStopLoss();  PROFIT_BUY=OrderTakeProfit();   BuyTime=OrderOpenTime();         break;
            case OP_SELLSTOP: SELLSTOP=OrderOpenPrice(); STOP_SELL=OrderStopLoss(); PROFIT_SELL=OrderTakeProfit();  SellStopTime=OrderOpenTime();    break;
            case OP_SELLLIMIT:SELLLIMIT=OrderOpenPrice();STOP_SELL=OrderStopLoss(); PROFIT_SELL=OrderTakeProfit();  SellLimitTime=OrderOpenTime();   break;
            case OP_SELL:     SELL=OrderOpenPrice();     STOP_SELL=OrderStopLoss(); PROFIT_SELL=OrderTakeProfit();  SellTime=OrderOpenTime();        break;
      }  }  }
   }//�������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������   



void BalanceCheck(){// ��������  ��������� ������� ��� ��������� ���� ������� ����������  (��� �������������� ��� ����� ������� ������) ������������������������������������������������������������������������������������������������������������
   if (!Real) return; 
   double BalanceChange=(GlobalVariableGet("LastBalance")-AccountBalance())*100/AccountBalance();
   if (MathAbs(BalanceChange)<10  || AccountBalance()<1) return; // ������ ��������� ����� 10%
   // ����� ������, ���� ���������� ������ 
   Print(Magic,": BalanceCheck(): ������ ��������� �� ", BalanceChange, "%, ������� ��������� �������� ��� ��������� �������"); 
   GlobalVariableSetOnCondition("CanTrade",Magic,0); // ������� �������� ����� ������� � ���������    
   Sleep(100);
   if (GlobalVariableGet("CanTrade")!=Magic) return;// ������� ��������� ���� ������� � ���������
   Print(Magic,": BalanceCheck(): ��������� �������� ��� ��������� �������");
   if (BalanceChange>0) str="increase"; else str="decrease";
   Report("Balance "+str+" on "+ DoubleToStr(MathAbs(BalanceChange),0) +"%, recount orders");
   GlobalVariableSet("LastBalance",AccountBalance()); Sleep(100);
   GlobalVariableSet("CanTrade",0); // ���������� ������
   
//   GlobalOrdersSet(); // ����������� ������
   
   }//������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������� 

string OrdToStr(int Type){//������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������� 
   switch(Type){
      case 0:  return ("BUY"); 
      case 1:  return ("SELL");
      case 2:  return ("BUYLIMIT"); 
      case 3:  return ("SELLLIMIT");
      case 4:  return ("BUYSTOP");
      case 5:  return ("SELLSTOP");
      case 10: return ("SetBUY");
      case 11: return ("SetSELL");
      default: return ("-");
   }  }//������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������� 
   

