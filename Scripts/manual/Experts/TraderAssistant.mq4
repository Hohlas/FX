#property copyright "Hohla"
#property link      "http://www.hohla.ru"
#property version   "2.00"
#property strict

#property description "Bot lets to set Price Alerts from MOBYLE terminal (android/ios) and send it by Email or Push,"
#property description "just place any pending order and delete it within 10 seconds, bot will remember the order price and create Alert." // 
#property description "Bot set Stop/Profit values, if it don't exist and changes pending orders lots by risk settings."
//#property description "Bot block your trading by closing all new orders when MaxDrowDown or MaxLosses per day exceeded,"
//#property description "it also block trading for 5 minutes after any loss trade, so it helps to avoid Tilt and reduce Trading Risk."

//sinput string  z1=" "; // Trader's Assistant
input int      Risk=1; // Risk percentage for Lot calculation
//input int      DayDD=2;// day Drawdown for trading disabling
//input int      DayLosses=3;// max Loss Trades per day for trading disabling
//input int      LossPause=5;// waiting time after Loss when trading disabled (minutes)  
input int      Stp=1;   // default StopLoss in ATR for new pending orders
input int      Prf=3;   // default TakeProfit in ATR for new pending orders
input int      AlertAwaiting=10;// Alert Awaiting (seconds)
input int      Magic=0;// Magic Number for orders identification
input bool     Mail=true;  // send Mail notifications
input bool     Push=true;  // send Push notifications
input bool     TerminalAlerts=true;  // computer Alerts 
int DayDD=0, DayLosses=0, LossPause=0;
// сразу после появления отложника автоматом ставятся стоп на расстоянии АТР(60) и профит 3хАТР с заданным риском.
// данный уровень запоминается, т.е. после удаления ордера при достижении ценой данного уровня выдается алерт.
//  
bool Real;
int LotDigits, LossTrades, bar, DIGITS;
double TickVal, LastBalance, MaxDayDD, ATR, MinLot, MaxDayBalance, MaxSpred, point;
datetime LastLossTime, LastOrderOpenTime=0;
string Company, SYMBOL, DelMissage="", LastOrdMsg;
//#include <stderror.mqh>
#include <stdlib.mqh>
#include <iGRAPH.mqh> 
//#import "stdlib.ex4"
//#import "stderror.ex4"
int OnInit(){//| Expert initialization function 
   if (MarketInfo(Symbol(),MODE_LOTSTEP)<0.1) LotDigits=2; else LotDigits=1;
   MinLot =MarketInfo(Symbol(),MODE_MINLOT);
   LastBalance=AccountBalance();
   if (Risk<=0){Alert("Wrong input parameter: Risk<=0"); return(INIT_FAILED);}
   if (DayDD<0){Alert("Wrong input parameter: Day Drawdown<0"); return(INIT_FAILED);}
   if (DayLosses<0){Alert("max Loss Trades per day should be >=0"); return(INIT_FAILED);}
   if (LossPause<0){Alert("waiting time after Loss should be >=0"); return(INIT_FAILED);}
   if (Stp<0 || Prf<0){Alert("Stop and Profit values should be > 0"); return(INIT_FAILED);}
   //Print("HistoryOrders:");
   //for (int Ord=0; Ord<OrdersHistoryTotal(); Ord++){// перебераем все открытые и отложенные ордера всех экспертов счета Ролловеры (OrderType=6) не смотрим.
   //   if (OrderSelect(Ord, SELECT_BY_POS, MODE_HISTORY )!=true  || TimeCurrent()-OrderOpenTime()>300) continue; //   SELECT_BY_POS     MODE_HISTORY MODE_TRADES
   //   Print(ORDER()," OpenTime=",OrderOpenTime()," OpenPrice=",OrderOpenPrice(),"   CloseTime=",OrderCloseTime()," ClosePrice=",OrderClosePrice());
   //   }
   //Print("CurrentOrders");
   //for (int Ord=0; Ord<OrdersTotal(); Ord++){// перебераем все открытые и отложенные ордера всех экспертов счета Ролловеры (OrderType=6) не смотрим.
   //   if (OrderSelect(Ord, SELECT_BY_POS, MODE_TRADES)!=true || OrderMagicNumber()!=Magic || OrderType()==6) continue; // OrderType()=6 - ролловер
   //   Print(ORDER()," OpenTime=",OrderOpenTime()," OpenPrice=",OrderOpenPrice(),"   CloseTime=",OrderCloseTime()," ClosePrice=",OrderClosePrice());
   //   }   
   return(INIT_SUCCEEDED);
   }
   
void OnTick(){//| Expert tick function  
   bool SetOrder=true;
   string Order, LastOrdInf="";
   double Stop, Lot=0, NewStop=0, NewProfit=0;
   ResetLastError();
   DelMissage=""; // сообщение в случае удаления ордеров
   for (int Ord=0; Ord<OrdersTotal(); Ord++){// перебераем все открытые и отложенные ордера всех экспертов счета Ролловеры (OrderType=6) не смотрим.
      if (OrderSelect(Ord, SELECT_BY_POS, MODE_TRADES)!=true || OrderMagicNumber()!=Magic || OrderType()==6) continue; // OrderType()=6 - ролловер
      SYMBOL=OrderSymbol();
      point  =MarketInfo(SYMBOL,MODE_POINT);
      TickVal=MarketInfo(SYMBOL,MODE_TICKVALUE);
      ATR=iATR(SYMBOL,60,24,1);
      switch(OrderType()){
         case OP_BUY:      Order="Buy";         NewStop=N5(OrderOpenPrice()-ATR*Stp);  NewProfit=N5(OrderOpenPrice()+ATR*Prf);    break;
         case OP_SELL:     Order="Sell";        NewStop=N5(OrderOpenPrice()+ATR*Stp);  NewProfit=N5(OrderOpenPrice()-ATR*Prf);    break;
         case OP_BUYSTOP:  Order="BuyStop";     NewStop=N5(OrderOpenPrice()-ATR*Stp);  NewProfit=N5(OrderOpenPrice()+ATR*Prf);    break;
         case OP_BUYLIMIT: Order="BuyLimit";    NewStop=N5(OrderOpenPrice()-ATR*Stp);  NewProfit=N5(OrderOpenPrice()+ATR*Prf);    break;
         case OP_SELLSTOP: Order="SellStop";    NewStop=N5(OrderOpenPrice()+ATR*Stp);  NewProfit=N5(OrderOpenPrice()-ATR*Prf);    break;
         case OP_SELLLIMIT:Order="SellLimit";   NewStop=N5(OrderOpenPrice()+ATR*Stp);  NewProfit=N5(OrderOpenPrice()-ATR*Prf);    break;
         }
      if (DayLosses>0 && LossTrades>DayLosses){
         DelMissage="LossTrades>"+S1(DayLosses)+", trading disabled"; // формируем сообщение о удалениии
         ORDERS_DELETE(); // удаление выбранного ордера
         continue;
         }
      if (LossPause>0 && OrderOpenTime()-LastLossTime<LossPause*60 && OrderOpenTime()>LastLossTime){ // проверка паузы с момента последнего лося
         DelMissage="LastLossTime<"+S0(LossPause)+"min, trading disabled"; // формируем сообщение о удалениии
         ORDERS_DELETE(); // удаление выбранного ордера
         continue;
         }
      if (DayDD>0 && MaxDayDD>DayDD){// проверка дневной просадки
         DelMissage="DrawDown Exceed "+S1(DayDD)+"%, trading disabled"; // формируем сообщение о удалениии
         ORDERS_DELETE(); // удаление выбранного ордера
         continue;
         }
      // Если рыночный ордер без стопов, ставим:
      if (OrderStopLoss()==0){ 
         if (OrderType()==OP_SELL){
            SetOrder=OrderModify(OrderTicket(),OrderOpenPrice(),NewStop, NewProfit,0,Blue); // в ордерах без стопа ставим сразу стоп в АТР
            if (!SetOrder) ERROR("SellOrder Modify");
            REPORT(Order+"/"+S2(OrderLots()*((OrderOpenPrice()-NewStop)/point*TickVal)/AccountBalance()*100)+"%");  
            } 
         if (OrderType()==OP_BUY){
            SetOrder=OrderModify(OrderTicket(),OrderOpenPrice(),NewStop,NewProfit,0,Blue); // в ордерах без стопа ставим сразу стоп в АТР 
            if (!SetOrder) ERROR("BuyOrder Modify");
            REPORT(Order+"/"+S2(OrderLots()*((NewStop-OrderOpenPrice())/point*TickVal)/AccountBalance()*100)+"%");  
            }
         ERROR("ReSet Order, Modify "+Order);
         }     
      // оповещение об только что открывшемся ордере   
      if (OrderType()<2){// открытый ордер BUY/SELL
         if (TimeCurrent()-OrderOpenTime()<60 && LastOrderOpenTime<OrderOpenTime()){// самый последний толко что из открывшихся
            LastOrderOpenTime=OrderOpenTime(); // запоминаем его время
            Stop=MathAbs(OrderOpenPrice()-OrderStopLoss());
            REPORT("Open "+Order+" "+S4(OrderOpenPrice())+"/"+S4(OrderStopLoss())+"/"+S4(OrderTakeProfit())+"/"+S1(OrderLots()*(Stop/point*TickVal)/AccountBalance()*100)+"%"); 
            }
         continue;  // BUY/SELL ордера больше не трогаем, 
         } 
      // дальше только в отложниках ставим стопы и проверяем риск
      if (OrderStopLoss()!=0) NewStop=OrderStopLoss();
      Stop=MathAbs(OrderOpenPrice()-NewStop); // для подсчета риска нужен стоп 
      if (Stop>0) Lot = NormalizeDouble(AccountBalance()*Risk*0.01 / (Stop/point*TickVal), LotDigits);
      if (Lot<MinLot) Lot=MinLot;
      SetOrder=false;
      if (Lot!=OrderLots() || OrderStopLoss()==0){ // корректируем размер позы если риск не равен 1%
         if (OrderSelect(Ord, SELECT_BY_POS, MODE_TRADES))
            SetOrder=OrderDelete(OrderTicket(),clrTomato); // true - флаг успешного удаления ордера
         Print("Try to Delete Order ",Order,", OrderDelete=",SetOrder);
         ERROR("Delete "+Order); 
         }
      if (SetOrder){ // если что-то удалили, надо выставить заново
         SetOrder=OrderSend(SYMBOL,OrderType(), Lot, OrderOpenPrice(), 3, NewStop, NewProfit, Order ,Magic,0,CLR_NONE); 
         //Print(SYMBOL+" TryToSet "+Order+" "+S4(OrderOpenPrice())+"/"+S4(StopPrice)+"/"+S1(Lot*(Stop/point*TickVal)/AccountBalance()*100)+"%");
         if (!SetOrder) ERROR("Set "+Order);
         }
      //else           REPORT("Set "+Order+" "+S4(OrderOpenPrice())+"/"+S4(NewStop)+"/"+S4(NewProfit)+"/"+S1(Lot*(Stop/point*TickVal)/AccountBalance()*100)+"%"); 
      if (TimeCurrent()-OrderOpenTime()>AlertAwaiting && TimeCurrent()-OrderOpenTime()<AlertAwaiting+10){ // Ордер не удален в течении AlertAwaiting сек после выставления, но не более AlertAwaiting+10сек
         LastOrdInf=("Set "+Order+" "+S4(OrderOpenPrice())+"/"+S4(OrderStopLoss())+"/"+S4(OrderTakeProfit())+"/"+S1(OrderLots()*(MathAbs(OrderOpenPrice()-OrderStopLoss())/point*TickVal)/AccountBalance()*100)+"%");
      }  }
   if (LastOrdInf!="" && LastOrdInf!=LastOrdMsg){// инфа о последнем отложнике обновилась
      REPORT(LastOrdInf); // шлем миссадж
      LastOrdMsg=LastOrdInf;}  
   if (DelMissage!="") REPORT(DelMissage+" Trading Disabled");  // если были удаления, отправка сообщения    
   ERROR(__FUNCTION__);
   CHECK_ALERTS();   
   CHECK_POINT(); // Проверка баланса    
   }         
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ  
void CHECK_POINT(){// проверка просадок за последние сутки 
   double MaxProfit=0, DayProfit=0, DayLoss=0,  LastTrade=0;
   MaxDayDD=0; LossTrades=0;
   double LastOrdPrice=0;
   datetime LastOrdTime=0;
   for (int Ord=0; Ord<OrdersHistoryTotal(); Ord++){// перебераем все открытые и отложенные ордера всех экспертов счета Ролловеры (OrderType=6) не смотрим.
      if (OrderSelect(Ord, SELECT_BY_POS, MODE_HISTORY)!=true || OrderMagicNumber()!=Magic || OrderType()==6 || TimeCurrent()-OrderOpenTime()>86400) continue; // 3600 х 24 = 86400
      if (OrderType()>1){ // фиксируем параметры последнего отложника для выставления алерта
         if (TimeCurrent()-OrderOpenTime()<AlertAwaiting+10 && OrderCloseTime()-OrderOpenTime()<AlertAwaiting && OrderCloseTime()-OrderOpenTime()>1){ // свежий, удаленный ранее минуты, но дольше 1 сек    
            LastOrdTime=OrderOpenTime();
            LastOrdPrice=OrderOpenPrice();
            SYMBOL=OrderSymbol();
            }
         continue; // дальше проверка только рыночных ордеров 
         }
      DayProfit+=OrderProfit();
      LastTrade=OrderProfit();
      if (LastTrade<0){             
         LossTrades++;  
         LastLossTime=OrderCloseTime();} // время последнего лося
      if (DayProfit>MaxProfit) MaxProfit=DayProfit;
      if (MaxProfit-DayProfit>MaxDayDD) MaxDayDD=MaxProfit-DayProfit;
      if (OrderProfit()<0){ 
         DayLoss+=OrderProfit();
         LossTrades++;
      }  }
   SET_ALERTS(LastOrdTime, LastOrdPrice); // выставление алерта по последнему отложнику  
   MaxDayDD=MaxDayDD/(AccountBalance()-DayProfit)*100; // пересчет просадки в проценты
   DayProfit=DayProfit/(AccountBalance()-DayProfit)*100; // процентное изменение баланса за сегодняшний день
   LastTrade=LastTrade/(AccountBalance()-LastTrade)*100;
   if (LastBalance!=AccountBalance()){ // 
      LastBalance=AccountBalance();
      string profit,trade;
      if (LastTrade>0) trade="Win="; else trade="Loss=";
      if (DayProfit>0) profit="DayProfit="; else profit="DayLoss=";
      REPORT(trade+S1(LastTrade)+"% "+profit+S1(DayProfit)+"% DD="+S1(MaxDayDD)+"%");
      }
   ERROR(__FUNCTION__);   
   }    
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ  
void ORDERS_DELETE(){// удаление выбранного ордера
   bool trade=true;
   switch(OrderType()){
      case OP_BUY:  trade=OrderClose(OrderTicket(),OrderLots(),Bid,5,Red); break;
      case OP_SELL: trade=OrderClose(OrderTicket(),OrderLots(),Ask,5,Red); break;
      default:      trade=OrderDelete(OrderTicket()); 
      }               
   ERROR(__FUNCTION__); 
   }
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ  
void SET_ALERTS(datetime time, double price){// установка алерта по цене текущего отложника
   if (price==0 || AlertAwaiting<=0) return; // 
   string dir;
   double AlertPrice=0;
   if (price>SymbolInfoDouble(SYMBOL,SYMBOL_ASK))  dir="UP"; else dir="DN";
   for (int g=0; g<GlobalVariablesTotal(); g++){ // перебор всех глобалов с Алертами
      string name=GlobalVariableName(g);
      if (StringSubstr(name,0,5)!="ALERT") continue;  // из глобала с Алертом
      if (SYMBOL==StringSubstr(name,6,6) && dir==StringSubstr(name,13,2)) // если у ордера совпадают символ и направление с одним из глобалов
         AlertPrice=GlobalVariableGet(name);  // запомним цену глобала для этого символа/направления. Т.е. алерт по данному символу уже выставлялся
      }  
   if (AlertPrice!=price){ // последний ордер отличается от установленного алерта, либо алерта нет (AlertPrice=0, при OrdPrice>0)
      GlobalVariableSet("ALERT_"+SYMBOL+"_"+dir, price);  
      REPORT("Set ALERT at "+S4(price));
      }  
   ERROR(__FUNCTION__);
   }
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ  
void CHECK_ALERTS(){
   for (int g=0; g<GlobalVariablesTotal(); g++){ // перебор всех глобалов с Алертами
      string name=GlobalVariableName(g);
      if (StringSubstr(name,0,5)!="ALERT") continue;  // из глобала с Алертом
      SYMBOL=StringSubstr(name,6,6);      // берем символ
      string dir=StringSubstr(name,13,2);     // направление
      double price=GlobalVariableGet(name);   // и цену
      double ask=SymbolInfoDouble(SYMBOL,SYMBOL_ASK); 
      double bid=SymbolInfoDouble(SYMBOL,SYMBOL_BID); 
      if (dir=="DN" && ask<price){
         REPORT("ALERT: ASK < "+S4(price)); 
         GlobalVariableDel(name);
         return;
         }
      if (dir=="UP" && bid>price){ 
         REPORT("ALERT: BID > "+S4(price));
         GlobalVariableDel(name);
         return;
      }  }
   ERROR(__FUNCTION__);   
   }         
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ  
void OnDeinit(const int reason){//| Expert deinitialization function  
   EventKillTimer(); //--- destroy timer
   }    
double OnTester(){//| Tester function 
   double ret=0.0;
   return(ret);
   }   
void REPORT(string txt){
   if (Push) SendNotification(SYMBOL+" "+txt); // DTIME(TimeToStr(TimeCurrent(),TIME_MINUTES)+" "+
   if (Mail) SendMail(SYMBOL,txt);              // TimeToStr(TimeCurrent(),TIME_MINUTES)
   if (TerminalAlerts)  Alert(SYMBOL," ",txt);
   else                 Print(SYMBOL," ",txt);
   ERROR(__FUNCTION__);
   }  
void ERROR(string ErrText){
   int Err=GetLastError();   
   if (Err>0) Print(ErrText," ERROR: ",ErrorDescription(Err)); 
   } 
string ORDER(){
   switch(OrderType()){
      case OP_BUY:      return("Buy");       
      case OP_SELL:     return("Sell");        
      case OP_BUYSTOP:  return("BuyStop");     
      case OP_BUYLIMIT: return("BuyLimit");    
      case OP_SELLSTOP: return("SellStop");    
      case OP_SELLLIMIT:return("SellLimit"); 
      case 6:           return("RollOver");  
      default:          return("none");
   }  }
      
    

  
