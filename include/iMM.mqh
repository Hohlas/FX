double MM(double Stop){
   double   MinLot =MarketInfo(Symbol(),MODE_MINLOT), // CurDD - ����������, �.�. ���������� � �. TradeHistoryWrite() 
            MaxLot =MarketInfo(Symbol(),MODE_MAXLOT);        
   if (Risk==0) {Lot=MinLot;   return(Lot);} 
   if (Risk>MaxRisk) Risk=MaxRisk*0.95;// �������� �� ��������� �������� �����
   int CurDD=CURRENT_DD(); // ��������� ���������� �������� �������� (�� ������������) 
   if (Stop<=0)                                 {Report("MM: Stop<=0!");    return (-MinLot);}
   if (MarketInfo(Symbol(),MODE_POINT)<=0)      {Report("MM: POINT<=0!");   return (-MinLot);}
   if (MarketInfo(Symbol(),MODE_TICKVALUE)<=0)  {Report("MM: TICKVAL<0!");  return (-MinLot);}
   if (CurDD>HistDD)                            {Report("MM: CurDD>HistDD!: "+DoubleToStr(CurDD,0)+">"+DoubleToStr(HistDD,0));return (-MinLot);}
   // ��.������ ������ http://www.alpari.ru/ru/help/forex/?tab=1&slider=margins#margin1
   // Margin = Contract*Lot/Leverage = 100000*Lot/100  
   // MaxLotForMargin=NormalizeDouble(AccountFreeMargin()/MarketInfo(Symbol(),MODE_MARGINREQUIRED),LotDigits) // ����. ���-�� ����� ��� ������� �����
   Lot = NormalizeDouble(Depo(MM)*Risk*0.01 / (Stop/MarketInfo(Symbol(),MODE_POINT)*MarketInfo(Symbol(),MODE_TICKVALUE)), LotDigits); // ������ ����� ����� ��������� ������. ��. ����������� �������� http://www.alpari.ru/ru/calculator/
   if (Lot<MinLot) Lot=MinLot;   // �������� �� ������������ �������� ��
   if (Lot>MaxLot) Lot=MaxLot; //Print("Risk=",Risk," RiskChecker=",RiskChecker(Lot,Stop));
   if (RiskChecker(Lot,Stop,Symbol())>MaxRisk) {Report("MM: RiskChecker="+DoubleToStr(RiskChecker(Lot,Stop,Symbol()),2)+"% - Trade Disable!"); return (-MinLot);}// �� ��������� ��������� ���� MaxRisk%! 
   return (Lot);
   }
// �������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������   
// �������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������
double RiskChecker(double lot, double Stop, string SYMBOL){// ��������, ������ ����� ����� ��������������� ����������� ���:  
   if (MarketInfo(SYMBOL,MODE_TICKVALUE)<=0) {Report("RiskChecker(): "+SYMBOL+" TickValue<0"); return (100);}
   if (MarketInfo(SYMBOL,MODE_POINT)<=0)     {Report("RiskChecker(): POINT<=0!"); return (-1);}
   return (NormalizeDouble(lot * (Stop/MarketInfo(SYMBOL,MODE_POINT)*MarketInfo(SYMBOL,MODE_TICKVALUE)) / AccountBalance()*100,2));
   }
// �������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������   
// �������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������   
int CURRENT_DD(){// ������ ��������� ���������� �������� �������� (�� ������������)  
   int  Ord;
   double MaxExpertProfit=LastTestDD, ExpertProfit=0, profit=0;
   for(Ord=0; Ord<OrdersHistoryTotal(); Ord++){// ������� ����� ���� ������� ������ �������� ��������� �������� � �������� �� �� ������� ������� �� �������� �������� (�� �� ������������!)
      if (OrderSelect(Ord,SELECT_BY_POS,MODE_HISTORY)==true && OrderMagicNumber()==Magic && OrderCloseTime()>TestEndTime){
         profit=OrderProfit()+OrderSwap()+OrderCommission(); // ������� �� ���������� ������ � �������
         if (profit!=0){ 
            profit=profit/OrderLots()/MarketInfo(Symbol(),MODE_TICKVALUE)*0.1;
            ExpertProfit+=profit; // ������� ������� ��������
            if (ExpertProfit>MaxExpertProfit) MaxExpertProfit=ExpertProfit; // Print(" CurDD(): magic=",Magic," profit=",profit," MaxExpertProfit=",MaxExpertProfit," ExpertProfit=",ExpertProfit," OrderCloseTime()=",TimeToStr(OrderCloseTime(),TIME_SECONDS));// ������������ ������� ��������                  
      }  }  } 
   return (int(MaxExpertProfit-ExpertProfit)); // �������� ��������� ���������� �������� �������� (�� ������������)
   }
// �������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������   
// ������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������� 
int Depo(int TypeMM){ // ������ ����� ��������, �� ������� ������� ������� ��� ���������� ������ 
   double Deposite=0, ExpMaxBalance=AccountBalance(); // �������������� ����������, ������ ��������� � ����� � ���������� �����������
   switch (TypeMM){
      case 1: // ������������ ��������������
         Deposite=AccountBalance();   //Print("ExpMaxDD=",ExpMaxDD," CarrentDD=",cDD," Balance=",AccountBalance()," Deposite=",Deposite, " K=",100*(ExpMaxDD-cDD)/ExpMaxDD,"%");// ������������� ��������� ���� �������� ��������������� ������� ��� ������� ��������      
      break; 
      case 2: // �������������� ������. ����������� ������ �������������� �������� � ���� �������� ������������� �� ������ �� ��� �� ���� �������� ������� �� ���������� ������. 
         // �� �� ��������� �������������� ����� ��� ������ �������, ���� ������ ���������� ���������.  
         if (CURRENT_DD()==0 && AccountBalance()>ExpMaxBalance) ExpMaxBalance=AccountBalance(); // ��� ������������� ������ ���� ������� � ����� � ����� ������ ������. �.�. ���� ������ ������� �� �������. 
         Deposite=MathMin(ExpMaxBalance,AccountBalance()); // �� ��������� �������������� �����
      break; 
      case 3: // ������� �� ������ ����������� ������������ �������.
         // ��� �������� ��������� ��� �� ���������� (���� ������ ������ �� 10%). 
         // ����� �� �������� �������������� � ������� ��������� �� ���� ��������� ������� �� ������ ������. 
         // ��� ���� ����������� ������������� ������� ��������� ������ �� ����� ������. 
         Deposite=GlobalVariableGet("MaxBalance");
         if (AccountBalance()>Deposite) Deposite=AccountBalance();
         GlobalVariableSet("MaxBalance",Deposite);
      break;
      case 4: // ����� ������ � �������������� ����������� ����� ��� �������������� ��������
         Deposite=AccountBalance()-CURRENT_DD();  // ������������� ��������� ���� �������� ��������������� ������� ��� ������� ��������      
      break; 
      //case 5: // ����� ������ � �������������� ����������� ����� ��� �������������� ��������
      //   Deposite=AccountBalance()*(HistDD-CurDD)/HistDD;   //Print("ExpMaxDD=",ExpMaxDD," CarrentDD=",cDD," Balance=",AccountBalance()," Deposite=",Deposite, " K=",100*(ExpMaxDD-cDD)/ExpMaxDD,"%");// ������������� ��������� ���� �������� ��������������� ������� ��� ������� ��������      
      //break; 
      default: Deposite=AccountBalance(); //Deposite=AccountBalance(); // ������������ ��������������
      }
   return (int(Deposite));
   }
// �������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������   
// �������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������
