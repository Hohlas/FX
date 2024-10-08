#property copyright "Hohla"
#property link      "http://www.hohla.ru"
#property version   "2.00"
#property strict
#property description "Advanced Mobile Trading Bot lets to place price alerts from mobile terminal (android/ios) and send it by Email or Push."
#property description "Just place any pending order and delete it within 10 seconds, bot will remember the order price and create Alert." // 
#property description "You can place one alert above current price and one under for each available trading pair."
#property description "Bot add Stop/Profit values to any new order, and change pending orders lot in proportion to Risk."
#property description "Bot send commit message like: Loss=-0.2% DayProfit=2% DD=0.2%."
//#property description "Bot block your trading by closing all new orders when MaxDrowDown or MaxLosses per day exceeded,"
//#property description "it also block trading for 5 minutes after any loss trade, so it helps to avoid Tilt and reduce Trading Risk."

//sinput string  z1=" "; // Trader's Assistant
input int      RISK=1; // RISK -  deposit percent for order Lot calculation
//input int      DD=2;// Day Drawdown - max drawdown per day to disable trading for 24 hours
//input int      DayLosses=3;// Day Losses - max loss trades per day for trading disabling
//input int      LossPause=5;// LossPause (minutes) - waiting time  after every Loss when trading disabled   
input int      SL=1;   // SL - default StopLoss = SL x ATR(Average True Range)
input int      TP=3;   // TP - default TakeProfit = TP x ATR(Average True Range)
input int      AlertSeconds=10;// Alert_Seconds - delete order during this time to place Alert
input int      Magic=0;// Magic_Number for orders identification
input bool     Mail=true;  // send Mail notifications
input bool     Push=true;  // send Push notifications
input bool     TerminalAlerts=true;  // computer Alerts 
int DD=0, DayLosses=0, LossPause=0;
// сразу после появления отложника автоматом ставятся стоп на расстоянии АТР(60) и профит 3хАТР с заданным риском.
// данный уровень запоминается, т.е. после удаления ордера при достижении ценой данного уровня выдается алерт.
//  
bool Real;
ENUM_POSITION_TYPE OrderType;
int LotDigits=2, LossTrades, bar, DIGITS;
double TickVal, LastBalance, MaxDayDD, ATR, MinLot, MaxDayBalance, MaxSpred, point;
datetime LastLossTime, LastOrderOpenTime=0;
string Company, SYMBOL, DelMissage="", LastOrdMsg;
//#include <stderror.mqh>

#include <iGRAPH.mqh> 
#include <iERROR.mqh> 
//#import "stdlib.ex4"
//#import "stderror.ex4"
int OnInit(){//| Expert initialization function 
   if (SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_STEP)<0.1) LotDigits=2; else LotDigits=1; 
   MinLot =  SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_MIN);
   LastBalance=AccountInfoDouble(ACCOUNT_BALANCE); 
   if (RISK<=0){Alert("Wrong input parameter: RISK<=0"); return(INIT_FAILED);}
   if (DD<0){Alert("Wrong input parameter: Day Drawdown<0"); return(INIT_FAILED);}
   if (DayLosses<0){Alert("max Loss Trades per day should be >=0"); return(INIT_FAILED);}
   if (LossPause<0){Alert("waiting time after Loss should be >=0"); return(INIT_FAILED);}
   if (SL<0 || TP<0){Alert("Stop and Profit values should be > 0"); return(INIT_FAILED);}
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
   ERROR_CHECK(__FUNCTION__); 
   return(INIT_SUCCEEDED);
   }
   
void OnTick(){  
   bool SetOrder=true;
   string Order, LastOrdInf="";
   double Stop, Lot=0, NewStop=0, NewProfit=0;
   ResetLastError();
   DelMissage=""; // сообщение в случае удаления ордеров
   for (int Ord=0; Ord<PositionsTotal(); Ord++){// перебераем все открытые      OrdersTotal(); // количество установленных отложенных ордеров
      ulong  ticket=PositionGetTicket(Ord);  // тикет позиции по индексу, выбор для дальнейшей работы                                    
      if (PositionGetInteger(POSITION_MAGIC)!=Magic) continue; // OrderType()=6 - ролловер
      SYMBOL=PositionGetString(POSITION_SYMBOL);                        
      CLOSE_ORDERS(ticket);
      }
   
   }         

void CHECK_POINT(){
   HistorySelect(TimeCurrent()-86400,TimeCurrent());//--- select history for access
   double profit;
   for (int Ord=0; Ord<HistoryDealsTotal(); Ord++){
      ulong ticket=HistoryDealGetTicket(Ord);
      if (HistoryDealGetInteger(ticket,DEAL_MAGIC)!=Magic)   continue;  
      SYMBOL=HistoryDealGetString(ticket,DEAL_SYMBOL);
      profit=HistoryDealGetDouble(ticket,DEAL_PROFIT);
      
      
   }  }



void DELETE_ORDERS(ulong  ticket){// удаление отложников
   MqlTradeRequest request={0};
   MqlTradeResult  result={0};
   ZeroMemory(request);
   ZeroMemory(result);
   request.action=TRADE_ACTION_REMOVE;                   // тип торговой операции
   request.order = ticket;                         // тикет ордера
   if (!OrderSend(request,result))
      ERROR_CHECK(__FUNCTION__);  
   PrintFormat("retcode=%u  deal=%I64u  order=%I64u",result.retcode,result.deal,result.order);
   }

// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ  
void CLOSE_ORDERS(ulong  ticket){// закрытие BUY / SELL ордеров
   MqlTradeRequest request;
   MqlTradeResult  result;
   ZeroMemory(request);
   ZeroMemory(result);
   //--- установка параметров операции
   request.action   =TRADE_ACTION_DEAL;   // тип торговой операции
   request.position =ticket;     // тикет позиции
   request.symbol   =PositionGetString(POSITION_SYMBOL);     // символ 
   request.volume   =PositionGetDouble(POSITION_VOLUME);              // объем позиции
   request.deviation=5;                   // допустимое отклонение от цены
   request.magic    =PositionGetInteger(POSITION_MAGIC);                                  
   OrderType=(ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);    // тип позиции
   switch(int(OrderType)){
      case POSITION_TYPE_BUY:   
         request.price=SymbolInfoDouble(SYMBOL,SYMBOL_BID);
         request.type =ORDER_TYPE_SELL;
      break;
      case POSITION_TYPE_SELL:  
         request.price=SymbolInfoDouble(SYMBOL,SYMBOL_ASK);
         request.type =ORDER_TYPE_BUY;
      break;
      default: 
      break; 
      }   
   Print("Close ",EnumToString(OrderType));
   if(!OrderSend(request,result))
      ERROR_CHECK(__FUNCTION__);   
   PrintFormat("retcode=%u  deal=%I64u  order=%I64u",result.retcode,result.deal,result.order);
   }
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ  
void SET_ALERTS(datetime time, double price){// установка алерта по цене текущего отложника
   if (price==0 || AlertSeconds<=0) return; // 
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
   ERROR_CHECK(__FUNCTION__);
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
   ERROR_CHECK(__FUNCTION__);   
   }   
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ 
datetime PushCnt[10];    
void REPORT(string txt){
   if (Push){ 
      if (TimeLocal()-PushCnt[0]>1 && TimeLocal()-PushCnt[9]>65){ // вызов SendNotification() не более 2-х вызовов в секунду и не более 10 вызовов в минуту
         SendNotification(SYMBOL+" "+txt);
         for (int i=9; i>0; i--) PushCnt[i]=PushCnt[i-1];
         PushCnt[0]=TimeLocal(); // время последнего обращения к ф. SendNotification()
      }else{   Print("Too often PushNotifications");}
      }  
   if (Mail) SendMail(SYMBOL,txt);              // TimeToStr(TimeCurrent(),TIME_MINUTES)
   if (TerminalAlerts)  Alert(SYMBOL," ",txt);
   else                 Print(SYMBOL," ",txt);
   ERROR_CHECK(__FUNCTION__);
   }  
//string ORDER(){
//   switch(int(OrderType)){
//      case ORDER_TYPE_BUY:       return("Buy");       
//      case ORDER_TYPE_SELL:      return("Sell");        
//      case ORDER_TYPE_BUY_STOP:  return("BuyStop");     
//      case ORDER_TYPE_BUY_LIMIT: return("BuyLimit");    
//      case ORDER_TYPE_SELL_STOP: return("SellStop");    
//      case ORDER_TYPE_SELL_LIMIT:return("SellLimit"); 
//      case 6:           return("RollOver");  
//      default:          return("none");
//   }  }     
void OnDeinit(const int reason){
   string txt=" Деинициализация программы: ";
   switch(reason){
      case 0: Print(txt,"Эксперт прекратил свою работу"); break;
      case 1: Print(txt,"Программа удалена с графика"); break;
      case 2: Print(txt,"Программа перекомпилирована"); break;
      case 3: Print(txt,"Символ или период графика был изменен"); break;
      case 4: Print(txt,"График закрыт"); break;
      case 5: Print(txt,"Входные параметры были изменены пользователем"); break;
      case 6: Print(txt,"Активирован другой счет либо произошло переподключение к торговому серверу вследствие изменения настроек счета"); break;
      case 7: Print(txt,"Применен другой шаблон графика"); break;
      case 8: Print(txt,"Признак того, что обработчик OnInit() вернул ненулевое значение"); break;
      case 9: Print(txt,"Терминал был закрыт"); break;     
      default: Print(txt,"UnKnown reason ",reason); 
      }
   CLEAR_CHART(); 
   }