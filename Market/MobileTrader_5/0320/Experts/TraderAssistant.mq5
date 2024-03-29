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

#define DAY_SECONDS 86400 // = 3600 x 24
 
bool Real;
ulong ticket;
//ENUM_POSITION_TYPE OrderType;
int LotDigits=2, LossTrades, bar, DIGITS;
double TickVal, Balance, MaxDayDD, ATR, MinLot, MaxDayBalance, MaxSpred, point, NewStop=0, NewProfit=0;
datetime LastLossTime, LastOrderOpenTime=0;
string Company, SYMBOL, DelMissage="", LastOrdInf, LastOrdMsg;
//#include <stderror.mqh>

#include <iGRAPH.mqh> 
#include <iERROR.mqh> 
//#import "stdlib.ex4"
//#import "stderror.ex4"
int OnInit(){//| Expert initialization function 
   if (SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_STEP)<0.1) LotDigits=2; else LotDigits=1; 
   MinLot =  SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_MIN);
   Balance=AccountInfoDouble(ACCOUNT_BALANCE); 
   if (RISK<=0){Alert("Wrong input parameter: RISK<=0"); return(INIT_FAILED);}
   if (DD<0){Alert("Wrong input parameter: Day Drawdown<0"); return(INIT_FAILED);}
   if (DayLosses<0){Alert("max Loss Trades per day should be >=0"); return(INIT_FAILED);}
   if (LossPause<0){Alert("waiting time after Loss should be >=0"); return(INIT_FAILED);}
   if (SL<0 || TP<0){Alert("Stop and Profit values should be > 0"); return(INIT_FAILED);}
   Print("ORDER_TYPE_BUY=",ORDER_TYPE_BUY," ORDER_TYPE_SELL=",ORDER_TYPE_SELL);
   ERROR_CHECK(__FUNCTION__); 
   return(INIT_SUCCEEDED);
   }
   
void OnTick(){  
   LastOrdInf="";
   DelMissage="";
   CURRENT_ORDERS(); // проверка текущих отложников на стоп / риск / возможность торговли
   CURRENT_POSITIONS();// проверка рыночных ордеров на стоп / возможность торговли
   HISTORY_DEALS(); // проверка результатов за день
   HISTORY_ORDERS();// установка Алертов по последним отложникам
   if (DelMissage!="") REPORT(DelMissage+".\n Trading Disabled");  // если были удаления, отправка сообщения
   if (LastOrdInf!="" && LastOrdInf!=LastOrdMsg){// инфа о последнем отложнике обновилась
      REPORT(LastOrdInf); // шлем миссадж
      LastOrdMsg=LastOrdInf;  
   }  }

void CURRENT_ORDERS(){ // проверка текущих отложников
   double price, stop, profit, NewLot=0, lot;
   datetime time;
   int type;
   string TYPE;
   uint     total=OrdersTotal();
   for (uint Ord=0; Ord<total; Ord++){
      ticket=OrderGetTicket(Ord);
      if (ticket<=0 || OrderGetInteger(ORDER_MAGIC)!=Magic) continue;
      price       =OrderGetDouble(ORDER_PRICE_OPEN); 
      stop        =OrderGetDouble(ORDER_SL);
      profit      =OrderGetDouble(ORDER_TP);
      lot         =OrderGetDouble(ORDER_VOLUME_INITIAL);
      time  =(datetime)OrderGetInteger(ORDER_TIME_SETUP); 
      SYMBOL      =OrderGetString(ORDER_SYMBOL); 
      ATR=iATR(SYMBOL,PERIOD_H1,24);
      point  =SymbolInfoDouble(SYMBOL,SYMBOL_POINT);
      TickVal=SymbolInfoDouble(SYMBOL,SYMBOL_TRADE_TICK_VALUE_LOSS);
      type        =(int)OrderGetInteger(ORDER_TYPE); 
      switch(type){
         case  ORDER_TYPE_BUY:   TYPE="Buy";    NewStop=N5(price-ATR*SL);  NewProfit=N5(price+ATR*TP);  break;
         case  ORDER_TYPE_SELL:  TYPE="Sell";   NewStop=N5(price+ATR*SL);  NewProfit=N5(price-ATR*TP);  break;
         case  ORDER_TYPE_BUY_STOP:    TYPE="BuyStop";   NewStop=N5(price-ATR*SL);  NewProfit=N5(price+ATR*TP);    break;
         case  ORDER_TYPE_BUY_LIMIT:   TYPE="BuyLimit";  NewStop=N5(price-ATR*SL);  NewProfit=N5(price+ATR*TP);    break;
         case  ORDER_TYPE_SELL_STOP:   TYPE="SellStop";  NewStop=N5(price+ATR*SL);  NewProfit=N5(price-ATR*TP);    break;
         case  ORDER_TYPE_SELL_LIMIT:  TYPE="SellLimit"; NewStop=N5(price+ATR*SL);  NewProfit=N5(price-ATR*TP);    break;
         default: continue;
         }
      if (!TRADE_ENABLE(time)) {ORDER_DELETE(); continue;}
      if (stop==0) {stop=NewStop; profit=NewProfit;}
      if (MathAbs(price-stop)>0) NewLot = NormalizeDouble(Balance*RISK*0.01 / (MathAbs(price-stop)/point*TickVal), LotDigits);
      else continue;
      if (NewLot<MinLot) NewLot=MinLot;
      if (lot!=NewLot || stop==0) PENDING_ORDER_MODIFY(stop, profit, NewLot);
      if (TimeCurrent()-time>AlertSeconds && TimeCurrent()-time<AlertSeconds+10) // Ордер не удален в течении AlertSeconds сек после выставления, но не более AlertSeconds+10сек
         LastOrdInf=("Set "+TYPE+" "+S4(price)+"/"+S4(stop)+"/"+S4(profit)+"/"+S1(lot*(MathAbs(price-stop)/point*TickVal)/Balance*100)+"%");
      } 
   ERROR_CHECK(__FUNCTION__);
   }
   
           
void CURRENT_POSITIONS(){// проверка открытых сделок
   double price, stop, profit, lot;
   datetime time;
   int type;
   string TYPE;
   for (int Ord=0; Ord<PositionsTotal(); Ord++){// перебераем все открытые      OrdersTotal(); // количество установленных отложенных ордеров
      ticket=PositionGetTicket(Ord);  // тикет позиции по индексу, выбор для дальнейшей работы                                    
      string sym=PositionGetSymbol(Ord); // Справочник / Торговые функции 
      if (PositionGetInteger(POSITION_MAGIC)!=Magic) continue; // OrderType()=6 - ролловер
      price =PositionGetDouble(POSITION_PRICE_OPEN); 
      time  =(datetime)PositionGetInteger(POSITION_TIME); 
      stop=PositionGetDouble(POSITION_SL);
      profit=PositionGetDouble(POSITION_TP);
      lot=PositionGetDouble(POSITION_VOLUME);
      SYMBOL=PositionGetString(POSITION_SYMBOL); 
      ATR=iATR(SYMBOL,PERIOD_H1,24); 
      type=(int)PositionGetInteger(POSITION_TYPE);                       
      switch(type){
         case  POSITION_TYPE_BUY:   TYPE="Buy";    NewStop=N5(price-ATR*SL);  NewProfit=N5(price+ATR*TP);  break;
         case  POSITION_TYPE_SELL:  TYPE="Sell";   NewStop=N5(price+ATR*SL);  NewProfit=N5(price-ATR*TP);  break;
         default: continue;
         }
      if (!TRADE_ENABLE(time)) {ORDER_CLOSE(); continue;}
      if (stop==0){
         POSITION_MODIFY(NewStop, NewProfit);
         REPORT("Modify "+TYPE+" "+S4(price)+"/"+S4(NewStop)+"/"+S4(NewProfit)+"/"+S1(lot*(MathAbs(price-NewStop)/point*TickVal)/Balance*100)+"%"); 
         }
      // оповещение об только что открывшемся ордере    
      if (TimeCurrent()-time<60 && LastOrderOpenTime<time){// самый последний толко что из открывшихся
         LastOrderOpenTime=time; // запоминаем его время
         REPORT("Open "+TYPE+" "+S4(price)+"/"+S4(stop)+"/"+S4(profit)+"/"+S1(lot*(MathAbs(price-stop)/point*TickVal)/Balance*100)+"%"); 
         }   
      }
   ERROR_CHECK(__FUNCTION__);
   }


bool TRADE_ENABLE(datetime OrdTime){
   if (DayLosses>0 && LossTrades>DayLosses)                                      {DelMissage="LossTrades>"+S0(DayLosses);        return(false);}
   if (LossPause>0 && OrdTime-LastLossTime<LossPause*60 && OrdTime>LastLossTime) {DelMissage="LastLossTime<"+S0(LossPause)+"min";return(false);} 
   if (DD>0 && MaxDayDD>DD)                                                      {DelMissage="Day DrawDown > "+S1(DD)+"%";       return(false);}
   return(true);
   }

void HISTORY_DEALS(){// проверка результатов за день
   double MaxProfit=0, DayProfit=0, DayLoss=0,  LastTrade=0;
   datetime LastOrdTime=0;
   MaxDayDD=0; LossTrades=0;
   uint total=HistoryDealsTotal();
   HistorySelect(TimeCurrent()-DAY_SECONDS, TimeCurrent()); // select history for last 24H
   for (uint Ord=0; Ord<total; Ord++){ 
      ticket=HistoryDealGetTicket(Ord);
      if (ticket<=0 || HistoryDealGetInteger(ticket,DEAL_MAGIC)!=Magic)   continue;  
      //price =HistoryDealGetDouble(ticket,DEAL_PRICE); 
      SYMBOL=HistoryDealGetString(ticket,DEAL_SYMBOL); 
      LastTrade=HistoryDealGetDouble(ticket,DEAL_PROFIT);
      DayProfit+=LastTrade;
      if (LastTrade<0){ 
         DayLoss+=LastTrade;        
         LossTrades++;  
         LastLossTime=(datetime)HistoryDealGetInteger(ticket,DEAL_TIME);} // время последнего лося
      if (DayProfit>MaxProfit) MaxProfit=DayProfit;
      if (MaxProfit-DayProfit>MaxDayDD) MaxDayDD=MaxProfit-DayProfit;
      }
   double CurBalance=AccountInfoDouble(ACCOUNT_BALANCE);
   MaxDayDD=MaxDayDD/(CurBalance-DayProfit)*100; // пересчет просадки в проценты
   DayProfit=DayProfit/(CurBalance-DayProfit)*100; // процентное изменение баланса за сегодняшний день
   LastTrade=LastTrade/(CurBalance-LastTrade)*100;
   if (Balance!=CurBalance){ // 
      Balance=CurBalance;
      string profit,trade;
      if (LastTrade>0) trade="Win="; else trade="Loss=";
      if (DayProfit>0) profit="DayProfit="; else profit="DayLoss=";
      REPORT(trade+S1(LastTrade)+"% "+profit+S1(DayProfit)+"% \n DayDrawDown="+S1(MaxDayDD)+"%");
      }
   ERROR_CHECK(__FUNCTION__);    
   }   
   
   
void HISTORY_ORDERS(){ // установка Алертов по последним отложникам
   double MaxProfit=0, DayProfit=0, DayLoss=0,  LastTrade=0;
   MaxDayDD=0; LossTrades=0;
   double LastOrdPrice=0;
   datetime LastOrdTime=0;
   HistorySelect(TimeCurrent()-DAY_SECONDS, TimeCurrent()); // select history for last 24H
   for (int Ord=0; Ord<HistoryOrdersTotal(); Ord++){
      ticket=HistoryOrderGetTicket(Ord);
      if (ticket<=0 || HistoryOrderGetInteger(ticket,ORDER_MAGIC)!=Magic)   continue;  
      datetime TimeSetup=(datetime)HistoryOrderGetInteger(ticket,ORDER_TIME_SETUP);
      datetime TimeDone=(datetime)HistoryOrderGetInteger(ticket,ORDER_TIME_DONE);
      if (HistoryOrderGetInteger(ticket,ORDER_STATE)==ORDER_STATE_CANCELED) // ORDER_STATE_PLACED 
         Print("order  Canceled: TimeSetup=",TimeSetup," TumeDone=",TimeDone);
      if (HistoryOrderGetInteger(ticket,ORDER_TYPE)>ORDER_TYPE_SELL){ // фиксируем параметры последнего отложника для выставления алерта
         if (TimeCurrent()-TimeSetup<AlertSeconds+10 && TimeDone-TimeSetup<AlertSeconds && TimeDone-TimeSetup>1){ // свежий, удаленный ранее минуты, но дольше 1 сек    
            LastOrdTime=TimeSetup;
            LastOrdPrice=HistoryOrderGetDouble(ticket,ORDER_PRICE_OPEN);
            SYMBOL=HistoryOrderGetString(ticket,ORDER_SYMBOL);
            }
         continue; // дальше проверка только рыночных ордеров 
      }  }
   SET_ALERTS(LastOrdTime, LastOrdPrice); // выставление алерта по последнему отложнику 
   ERROR_CHECK(__FUNCTION__);
   }  
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ      
void PENDING_ORDER_MODIFY(double sl, double tp, double lot){
   MqlTradeRequest request;   ZeroMemory(request);
   MqlTradeResult  result;    ZeroMemory(result);
   double CurSL=OrderGetDouble(ORDER_SL);                                // текущий Stop Loss ордера
   double CurTP=OrderGetDouble(ORDER_TP);                                // текущий Take Profit ордера
   double price=OrderGetDouble(ORDER_PRICE_OPEN);  
   request.action  =TRADE_ACTION_MODIFY; // Изменить параметры ранее установленного торгового ордера
   request.order  =ticket;    // тикет ордера
   request.symbol =SYMBOL;    // символ
   request.deviation=5;       // допустимое отклонение от цены
   request.sl      =sl;       // Stop Loss позиции
   request.tp      =tp;       // Take Profit позиции
   request.price  =price;     
   request.volume   =lot; 
   PrintFormat("Modify #%I64d %s %s",ticket,SYMBOL);
   if (!OrderSend(request,result))  ERROR_CHECK(__FUNCTION__); 
   PrintFormat("retcode=%u  deal=%I64u  order=%I64u",result.retcode,result.deal,result.order);
   }
void POSITION_MODIFY(double sl, double tp){
   MqlTradeRequest request;   ZeroMemory(request);
   MqlTradeResult  result;    ZeroMemory(result);
   request.action  =TRADE_ACTION_SLTP; // Изменить значения Stop Loss и Take Profit у открытой позиции
   request.position=ticket;   // тикет позиции
   request.symbol=SYMBOL;     // символ 
   request.sl      =sl;       // Stop Loss позиции
   request.tp      =tp;       // Take Profit позиции
   request.magic=Magic;       // MagicNumber позиции
   PrintFormat("Modify #%I64d %s %s",ticket,SYMBOL);
   if (!OrderSend(request,result))  ERROR_CHECK(__FUNCTION__); 
   PrintFormat("retcode=%u  deal=%I64u  order=%I64u",result.retcode,result.deal,result.order);
   }
void ORDER_DELETE(){// удаление отложников
   MqlTradeRequest request={0};  ZeroMemory(request);
   MqlTradeResult  result={0};   ZeroMemory(result);
   request.action=TRADE_ACTION_REMOVE;             // тип торговой операции
   request.order = ticket;                         // тикет ордера
   if (!OrderSend(request,result))  ERROR_CHECK(__FUNCTION__);  
   PrintFormat("retcode=%u  deal=%I64u  order=%I64u",result.retcode,result.deal,result.order);
   }
void ORDER_CLOSE(){// закрытие BUY / SELL ордеров
   MqlTradeRequest request;   ZeroMemory(request);
   MqlTradeResult  result;    ZeroMemory(result);
   request.action   =TRADE_ACTION_DEAL;   // тип торговой операции
   request.position =ticket;     // тикет позиции
   request.symbol   =PositionGetString(POSITION_SYMBOL);     // символ 
   request.volume   =PositionGetDouble(POSITION_VOLUME);              // объем позиции
   request.deviation=5;                   // допустимое отклонение от цены
   request.magic    =PositionGetInteger(POSITION_MAGIC);                                  
   int OrderType=(int)PositionGetInteger(POSITION_TYPE);    // тип позиции
   switch(OrderType){
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
   Print("Close ",EnumToString(ENUM_POSITION_TYPE(OrderType)));
   if (!OrderSend(request,result))  ERROR_CHECK(__FUNCTION__);   
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
#define MSG_PER_MINUTE 10 // предельное кол-во сообщений в минуту
datetime PushCnt[MSG_PER_MINUTE];    
void REPORT(string txt){
   if (Push){ 
      if (TimeLocal()-PushCnt[0]>1 && TimeLocal()-PushCnt[MSG_PER_MINUTE-1]>65){ // вызов SendNotification() не более 2-х вызовов в секунду и не более 10 вызовов в минуту
         SendNotification(SYMBOL+" "+txt);
         for (int i=MSG_PER_MINUTE-1; i>0; i--) PushCnt[i]=PushCnt[i-1];
         PushCnt[0]=TimeLocal(); // время последнего обращения к ф. SendNotification()
      }else{   Print("Too often PushNotifications");}
      }  
   if (Mail) SendMail(SYMBOL,txt);              // TimeToStr(TimeCurrent(),TIME_MINUTES)
   if (TerminalAlerts)  Alert(SYMBOL," ",txt);
   else                 Print(SYMBOL," ",txt);
   ERROR_CHECK(__FUNCTION__);
   }  
string ORDER(int type){
   switch(type){
      case ORDER_TYPE_BUY:       return("Buy");       
      case ORDER_TYPE_SELL:      return("Sell");        
      case ORDER_TYPE_BUY_STOP:  return("BuyStop");     
      case ORDER_TYPE_BUY_LIMIT: return("BuyLimit");    
      case ORDER_TYPE_SELL_STOP: return("SellStop");    
      case ORDER_TYPE_SELL_LIMIT:return("SellLimit"); 
      case ORDER_TYPE_BUY_STOP_LIMIT: return("BuyStopLimit"); 
      case ORDER_TYPE_SELL_STOP_LIMIT:return("SellStopLimit");  
      default:          return("none");
   }  }     
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