double MoneyManagement(double Stop){// �� ������������������������������������������������������������������������������������������������������������������
   if (Risk==0) {Lot=0;   return(Lot);} 
   double   MinLot =MarketInfo(SYMBOL,MODE_MINLOT), // CurDD - ����������, �.�. ���������� � �. TradeHistoryWrite() 
            MaxLot =MarketInfo(SYMBOL,MODE_MAXLOT);        
   if (Risk>MaxRisk) Risk=MaxRisk*0.95;// �������� �� ��������� �������� �����
   CurDD=CurrentDD(); // ��������� ���������� �������� �������� (�� ������������) 
   if (Stop<=0)                              {Report("MM: Stop<=0!");    return (-MinLot);}
   if (MarketInfo(SYMBOL,MODE_POINT)<=0)     {Report("MM: POINT<=0!");   return (-MinLot);}
   if (MarketInfo(SYMBOL,MODE_TICKVALUE)<=0) {Report("MM: TICKVAL<0!");  return (-MinLot);}
   if (CurDD>HistDD)                         {Report("MM: CurDD>HistDD!: "+DoubleToStr(CurDD,0)+">"+DoubleToStr(HistDD,0));return (-MinLot);}
   // ��.������ ������ http://www.alpari.ru/ru/help/forex/?tab=1&slider=margins#margin1
   // Margin = Contract*Lot/Leverage = 100000*Lot/100  
   // MaxLotForMargin=NormalizeDouble(AccountFreeMargin()/MarketInfo(SYMBOL,MODE_MARGINREQUIRED),LotDigits) // ����. ���-�� ����� ��� ������� �����
   Lot = NormalizeDouble(Depo(MM)*Risk*0.01 / (Stop/MarketInfo(SYMBOL,MODE_POINT)*MarketInfo(SYMBOL,MODE_TICKVALUE)), LotDigits); // ������ ����� ����� ��������� ������. ��. ����������� �������� http://www.alpari.ru/ru/calculator/
   if (Lot<MinLot) Lot=MinLot;   // �������� �� ������������ �������� ��
   if (Lot>MaxLot) Lot=MaxLot; //Print("Risk=",Risk," RiskChecker=",RiskChecker(Lot,Stop));
   if (RiskChecker(Lot,Stop,SYMBOL)>MaxRisk) {Report("MM: RiskChecker="+DoubleToStr(RiskChecker(Lot,Stop,SYMBOL),2)+"% - Trade Disable!"); return (-MinLot);}// �� ��������� ��������� ���� MaxRisk%! 
   return (Lot);
   }//������������������������������������������������������������������������������������������������������������������������������������������������������

double RiskChecker(double lot, double Stop, string SYM){// ��������, ������ ����� ����� ��������������� ����������� ���:  //�������������������������������������������������������������������������������������������������������������������
   if (MarketInfo(SYM,MODE_TICKVALUE)<=0) {Report("RiskChecker(): "+SYM+" TickValue<0"); return (100);}
   if (MarketInfo(SYM,MODE_POINT)<=0)     {Report("RiskChecker(): POINT<=0!"); return (-1);}
   return (NormalizeDouble(lot * (Stop/MarketInfo(SYM,MODE_POINT)*MarketInfo(SYM,MODE_TICKVALUE)) / AccountBalance()*100,2));
   }//������������������������������������������������������������������������������������������������������������������������������������������������������
   
double CurrentDD(){// ������ ��������� ���������� �������� �������� (�� ������������)  ������������������������������������������������������������������������������������������������������������������
   double MaxExpertProfit=LastTestDD, ExpertProfit, profit;
   int Ord;
   for(Ord=0; Ord<OrdersHistoryTotal(); Ord++){// ������� ����� ���� ������� ������ �������� ��������� �������� � �������� �� �� ������� ������� �� �������� �������� (�� �� ������������!)
      if (OrderSelect(Ord,SELECT_BY_POS,MODE_HISTORY)==true && OrderMagicNumber()==Magic && OrderCloseTime()>TestEndTime){
         profit=OrderProfit()+OrderSwap()+OrderCommission(); // ������� �� ���������� ������ � �������
         if (profit!=0){ 
            profit=profit/OrderLots()/MarketInfo(SYMBOL,MODE_TICKVALUE)*0.1;
            ExpertProfit+=profit; // ������� ������� ��������
            if (ExpertProfit>MaxExpertProfit) MaxExpertProfit=ExpertProfit; // Print(" CurDD(): magic=",Magic," profit=",profit," MaxExpertProfit=",MaxExpertProfit," ExpertProfit=",ExpertProfit," OrderCloseTime()=",TimeToStr(OrderCloseTime(),TIME_SECONDS));// ������������ ������� ��������                  
      }  }  } 
   return (MaxExpertProfit-ExpertProfit); // �������� ��������� ���������� �������� �������� (�� ������������)
   }//������������������������������������������������������������������������������������������������������������������������������������������������������
 
double Depo(int TypeMM){ // ������ ����� ��������, �� ������� ������� ������� ��� ���������� ������  ������������������������������������������������������������������������������������������������������������������
   double Deposite;
   switch (TypeMM){
      case 1: // ������������ ��������������
         Deposite=AccountBalance();   //Print("ExpMaxDD=",ExpMaxDD," CarrentDD=",cDD," Balance=",AccountBalance()," Deposite=",Deposite, " K=",100*(ExpMaxDD-cDD)/ExpMaxDD,"%");// ������������� ��������� ���� �������� ��������������� ������� ��� ������� ��������      
      break; 
      case 2: // �������������� ������. ����������� ������ �������������� �������� � ���� �������� ������������� �� ������ �� ��� �� ���� �������� ������� �� ���������� ������. 
         // �� �� ��������� �������������� ����� ��� ������ �������, ���� ������ ���������� ���������.  
         int ExpMaxBalance=AccountBalance(); // �������������� ����������, ������ ��������� � ����� � ���������� �����������
         if (CurrentDD()==0 && AccountBalance()>ExpMaxBalance) ExpMaxBalance=AccountBalance(); // ��� ������������� ������ ���� ������� � ����� � ����� ������ ������. �.�. ���� ������ ������� �� �������. 
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
         Deposite=AccountBalance()-CurrentDD();  // ������������� ��������� ���� �������� ��������������� ������� ��� ������� ��������      
      break; 
      case 5: // ����� ������ � �������������� ����������� ����� ��� �������������� ��������
         Deposite=AccountBalance()*(HistDD-CurDD)/HistDD;   //Print("ExpMaxDD=",ExpMaxDD," CarrentDD=",cDD," Balance=",AccountBalance()," Deposite=",Deposite, " K=",100*(ExpMaxDD-cDD)/ExpMaxDD,"%");// ������������� ��������� ���� �������� ��������������� ������� ��� ������� ��������      
      break; 
      default: Deposite=AccountBalance(); //Deposite=AccountBalance(); // ������������ ��������������
      }
   return (Deposite);
   }//������������������������������������������������������������������������������������������������������������������������������������������������������

