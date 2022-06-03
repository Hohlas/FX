double MoneyManagement(double Stop){// ћћ ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆
   if (Risk==0) {Lot=0;   return(Lot);} 
   double   MinLot =MarketInfo(SYMBOL,MODE_MINLOT), // CurDD - глобальна€, т.к. передаетс€ в ф. TradeHistoryWrite() 
            MaxLot =MarketInfo(SYMBOL,MODE_MAXLOT);        
   if (Risk>MaxRisk) Risk=MaxRisk*0.95;// проверка на ошибочное значение риска
   CurDD=CurrentDD(); // последн€€ незакрыта€ просадка эксперта (не максимальной) 
   if (Stop<=0)                              {Report("MM: Stop<=0!");    return (-MinLot);}
   if (MarketInfo(SYMBOL,MODE_POINT)<=0)     {Report("MM: POINT<=0!");   return (-MinLot);}
   if (MarketInfo(SYMBOL,MODE_TICKVALUE)<=0) {Report("MM: TICKVAL<0!");  return (-MinLot);}
   if (CurDD>HistDD)                         {Report("MM: CurDD>HistDD!: "+DoubleToStr(CurDD,0)+">"+DoubleToStr(HistDD,0));return (-MinLot);}
   // см.–асчет залога http://www.alpari.ru/ru/help/forex/?tab=1&slider=margins#margin1
   // Margin = Contract*Lot/Leverage = 100000*Lot/100  
   // MaxLotForMargin=NormalizeDouble(AccountFreeMargin()/MarketInfo(SYMBOL,MODE_MARGINREQUIRED),LotDigits) // ћакс. кол-во лотов дл€ текущей маржи
   Lot = NormalizeDouble(Depo(MM)*Risk*0.01 / (Stop/MarketInfo(SYMBOL,MODE_POINT)*MarketInfo(SYMBOL,MODE_TICKVALUE)), LotDigits); // размер стопа через —тоимость пункта. —м. калькул€тор трейдера http://www.alpari.ru/ru/calculator/
   if (Lot<MinLot) Lot=MinLot;   // ѕроверка на соответствие услови€м ƒ÷
   if (Lot>MaxLot) Lot=MaxLot; //Print("Risk=",Risk," RiskChecker=",RiskChecker(Lot,Stop));
   if (RiskChecker(Lot,Stop,SYMBOL)>MaxRisk) {Report("MM: RiskChecker="+DoubleToStr(RiskChecker(Lot,Stop,SYMBOL),2)+"% - Trade Disable!"); return (-MinLot);}// Ќе позвол€ем превышать риск MaxRisk%! 
   return (Lot);
   }//∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆

double RiskChecker(double lot, double Stop, string SYM){// ѕроверим, какому риску будет соответствовать расчитанный Ћот:  //∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆
   if (MarketInfo(SYM,MODE_TICKVALUE)<=0) {Report("RiskChecker(): "+SYM+" TickValue<0"); return (100);}
   if (MarketInfo(SYM,MODE_POINT)<=0)     {Report("RiskChecker(): POINT<=0!"); return (-1);}
   return (NormalizeDouble(lot * (Stop/MarketInfo(SYM,MODE_POINT)*MarketInfo(SYM,MODE_TICKVALUE)) / AccountBalance()*100,2));
   }//∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆
   
double CurrentDD(){// расчет последней незакрытой просадки эксперта (не максимальной)  ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆
   double MaxExpertProfit=LastTestDD, ExpertProfit, profit;
   int Ord;
   for(Ord=0; Ord<OrdersHistoryTotal(); Ord++){// находим среди всей истории сделок эксперта ѕќ—Ћ≈ƒЌёё просадку и измер€ем ее от макушки баланса до текущего значени€ (Ќе до минимального!)
      if (OrderSelect(Ord,SELECT_BY_POS,MODE_HISTORY)==true && OrderMagicNumber()==Magic && OrderCloseTime()>TestEndTime){
         profit=OrderProfit()+OrderSwap()+OrderCommission(); // прибыль от выбранного ордера в пунктах
         if (profit!=0){ 
            profit=profit/OrderLots()/MarketInfo(SYMBOL,MODE_TICKVALUE)*0.1;
            ExpertProfit+=profit; // текуща€ прибыль эксперта
            if (ExpertProfit>MaxExpertProfit) MaxExpertProfit=ExpertProfit; // Print(" CurDD(): magic=",Magic," profit=",profit," MaxExpertProfit=",MaxExpertProfit," ExpertProfit=",ExpertProfit," OrderCloseTime()=",TimeToStr(OrderCloseTime(),TIME_SECONDS));// максимальна€ прибыль эксперта                  
      }  }  } 
   return (MaxExpertProfit-ExpertProfit); // значение последней незакрытой просадки эксперта (не максимальной)
   }//∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆
 
double Depo(int TypeMM){ // –асчет части депозита, от которой беретс€ процент дл€ совершени€ сделки  ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆
   double Deposite;
   switch (TypeMM){
      case 1: //  лассический јнтимартингейл
         Deposite=AccountBalance();   //Print("ExpMaxDD=",ExpMaxDD," CarrentDD=",cDD," Balance=",AccountBalance()," Deposite=",Deposite, " K=",100*(ExpMaxDD-cDD)/ExpMaxDD,"%");// ƒополнительно уменьшаем риск эксперта пропорционально глубине его текущей просадки      
      break; 
      case 2: // »ндивидуальный баланс. ‘иксируетс€ начало индивидуальной просадки и риск начинает увеличиватьс€ до выхода из нее за счет прироста баланса от прибыльных систем. 
         // Ќо не превышает установленного риска дл€ данной системы, если баланс продолжает снижатьс€.  
         int ExpMaxBalance=AccountBalance(); // индивидуальна€ переменна€, должна хранитьс€ в файле с временными параметрами
         if (CurrentDD()==0 && AccountBalance()>ExpMaxBalance) ExpMaxBalance=AccountBalance(); // Ћот увеличиваетс€ только если система в плюсе и общий баланс растет. “.е. если другие системы не сливают. 
         Deposite=MathMin(ExpMaxBalance,AccountBalance()); // Ќе превышаем установленного риска
      break; 
      case 3: // ѕроцент от общего максимально достигнутого баланса.
         // ѕри просадке экспертов лот не понижаетс€ (риск растет вплоть до 10%). 
         // ¬ыход из просадки осуществл€етс€ с большей скоростью за счет растущего баланса от друхих систем. 
         // ѕри этом оказываетс€ значителььное вли€ние убыточных систем на общий баланс. 
         Deposite=GlobalVariableGet("MaxBalance");
         if (AccountBalance()>Deposite) Deposite=AccountBalance();
         GlobalVariableSet("MaxBalance",Deposite);
      break;
      case 4: // ќбщий баланс с дополнительным сокращением риска при индивидуальной просадке
         Deposite=AccountBalance()-CurrentDD();  // ƒополнительно уменьшаем риск эксперта пропорционально глубине его текущей просадки      
      break; 
      case 5: // ќбщий баланс с дополнительным сокращением риска при индивидуальной просадке
         Deposite=AccountBalance()*(HistDD-CurDD)/HistDD;   //Print("ExpMaxDD=",ExpMaxDD," CarrentDD=",cDD," Balance=",AccountBalance()," Deposite=",Deposite, " K=",100*(ExpMaxDD-cDD)/ExpMaxDD,"%");// ƒополнительно уменьшаем риск эксперта пропорционально глубине его текущей просадки      
      break; 
      default: Deposite=AccountBalance(); //Deposite=AccountBalance(); //  лассический јнтимартингейл
      }
   return (Deposite);
   }//∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆

