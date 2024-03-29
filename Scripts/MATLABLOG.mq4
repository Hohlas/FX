#property copyright "Hohla"
#property link      "http://www.mql5.com"
#property version   "1.00"
#property strict

#define  EXPERTS_LIM  255  // максимальное кол-во проверяемых экспертов
#define  ORDERS_LIM   65535  // максимальное кол-во сделок одного эксперта за последние два года
#define  Real         true

struct AllExperts{  //  C Т Р У К Т У Р А   P I C
   int      magic;
   int      trade[ORDERS_LIM];
   datetime time[ORDERS_LIM];
   float    tickval;
   };
AllExperts Expert[EXPERTS_LIM];   
uchar Experts=0; // общее количество экспертов   
datetime HistoryPeriod=3600*24*365*3; // анализ истории не глубже 3 лет

void OnStart(){
   datetime FirstTrade=0;
   int TradeCnt[EXPERTS_LIM], TradesTotal=0; // счетчик сделок
   int Pips=0;
   float TotalProfit=0;
   string FileName; 
   ArrayInitialize(TradeCnt,0);
   if (Real) {FileName="MatLab"+AccountCurrency()+".csv"; FileDelete(FileName);} // каждый час создаем новый файл
   else      {FileName="MatLabTest.csv";}//  
   if (FileIsExist(FileName))  if (!FileDelete(FileName)) Alert("Error, while delete "+FileName);
   int MgcFile, File=FileOpen(FileName, FILE_READ | FILE_WRITE); 
   if (File<0) {Alert("MatLabLog(): Can not open file "+ FileName); return;}
   
   
   if (FileIsExist("AllTrades.csv"))  if (!FileDelete("AllTrades.csv")) Alert("Error, while delete AllTrades.csv");
   int AllTradesFile=FileOpen("AllTrades.csv", FILE_READ | FILE_WRITE); 
   FileWrite(File, "Magic","TickVal","Risk","Deal/Time..."); // прописываем в первую строку названия столбцов
   FileWrite(AllTradesFile,"magic", "ticket","OpenTime","CloseTime","OpenPrice","ClosePrice","Pips","Profit$","Comission");
   for(int i=0; i<OrdersHistoryTotal(); i++){// перебераем историю сделок эксперта
      if (OrderSelect(i, SELECT_BY_POS,MODE_HISTORY)==false || OrderMagicNumber()==0 || OrderCloseTime()==0 || OrderProfit()==0) continue;
      if (TradesTotal==0) FirstTrade=OrderOpenTime(); // 
      if (Time[0]-OrderCloseTime()>HistoryPeriod) continue; // Пропускаем все ордера старше двух лет, чтобы не переполнять масссив. Для гарфического анализа они не пригодятся.  
      uchar e=0;
      EXPERTS_PARAMS(e, OrderMagicNumber(), MgcFile);
      Expert[e].trade[TradeCnt[e]]=int((OrderProfit()+OrderSwap()+OrderCommission())/OrderLots()/MarketInfo(OrderSymbol(),MODE_TICKVALUE));
      Expert[e].time[TradeCnt[e]]=OrderCloseTime();  //Print(" TrdCnt[",e,"]=",TradeCnt[e]," trade=",Expert[e].trade[TradeCnt[e]]," time=",Expert[e].time[TradeCnt[e]]);
      FileWrite(AllTradesFile,OrderMagicNumber(),OrderTicket(), OrderOpenTime(),OrderCloseTime(),OrderOpenPrice(),OrderClosePrice(),Expert[e].trade[TradeCnt[e]],OrderProfit()+OrderSwap()+OrderCommission(),OrderSwap()+OrderCommission()); 
      TradeCnt[e]++; TradesTotal++;
      Pips+=int((OrderProfit()+OrderSwap()+OrderCommission())/OrderLots()/MarketInfo(OrderSymbol(),MODE_TICKVALUE)); Print("Pips=",Pips);
      TotalProfit+=float(OrderProfit()+OrderSwap()+OrderCommission());
      }  
   FileWrite(AllTradesFile," "," "," "," "," "," ","TotalPips","TotalProfit");
   FileWrite(AllTradesFile," "," "," "," "," "," ",DoubleToStr(Pips,0),DoubleToStr(TotalProfit,0));     
   for (uchar e=0; e<=Experts; e++){
      short order=1; // Alert("magic[",e,"]=",magic[e]);
      FileSeek (File,0,SEEK_END); // перемещаемся в конец файла MatLabTest.csv
      FileWrite(File, DoubleToStr(Expert[e].magic,0)+";"+DoubleToStr(Expert[e].tickval,5)+";"+"0.1"); // прописываем в первую ячейку magic,
      for (ushort t=0; t<=TradeCnt[e]; t++){ //
         if (Expert[e].trade[t]==0) continue;  
         FileSeek (File,-2,SEEK_END); // потом дописываем
         FileWrite(File,  ""    , DoubleToStr(Expert[e].trade[t],0)+"/"+TimeToStr(Expert[e].time[t],TIME_DATE|TIME_MINUTES));    // ежедневные профиты/время сделки из созданного массива    
      }  }
   Alert("Trades:",TradesTotal,",  Experts:", Experts,",  LastTrade:",TimeToStr(OrderOpenTime(),TIME_DATE),",  FirstTrade:",TimeToStr(FirstTrade,TIME_DATE),",  OrdersHistoryTotal=",OrdersHistoryTotal() );   
   FileClose(File); 
   FileClose(AllTradesFile);
   }  
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ 
void EXPERTS_PARAMS(uchar& ExpCnt, int ExpMagic, int& File){// создание массива параметров для всех экспертов
   string FileName="Trades"+DoubleToStr(ExpMagic,0)+".csv"; 
   for (ExpCnt=0; ExpCnt<EXPERTS_LIM; ExpCnt++){
      if (Expert[ExpCnt].magic==ExpMagic) break;
      if (Expert[ExpCnt].magic==0){// first time //отдельный для каждого эксперта файл со списком сделок
         
         if (FileIsExist(FileName))  if (!FileDelete(FileName)) Alert("Error, while delete "+FileName);
         File=FileOpen(FileName, FILE_READ | FILE_WRITE); 
         FileWrite(File, "ticket","OpenTime","CloseTime","OpenPrice","ClosePrice","ProfitPips","Profit$","Comission");
         FileClose(File);
         Expert[ExpCnt].magic=ExpMagic;
         Expert[ExpCnt].tickval=float(MarketInfo(OrderSymbol(),MODE_TICKVALUE));
         Experts=ExpCnt;
         break;
         }
      if (ExpCnt>=EXPERTS_LIM) {Alert("WARNING!!! Experts>",EXPERTS_LIM, " Can't create MatLabLog File"); }   
      }
   //отдельный для каждого эксперта файл со списком сделок
   File=FileOpen(FileName, FILE_READ | FILE_WRITE);
   FileSeek (File,0,SEEK_END); // потом дописываем
   FileWrite(File,OrderTicket(), OrderOpenTime(),OrderCloseTime(),OrderOpenPrice(),OrderClosePrice(),(OrderProfit()+OrderSwap()+OrderCommission())/OrderLots()/MarketInfo(OrderSymbol(),MODE_TICKVALUE),OrderProfit()+OrderSwap()+OrderCommission(),OrderSwap()+OrderCommission());     
   FileClose(File);
   }    
//ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
//ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
string OrdToStr(int Type){ 
   switch(Type){
      case 0:  return ("BUY"); 
      case 1:  return ("SELL");
      case 2:  return ("BUYLIMIT"); 
      case 3:  return ("SELLLIMIT");
      case 4:  return ("BUYSTOP");
      case 5:  return ("SELLSTOP");
      case 6:  return ("RollOver");
      case 10: return ("SetBUY");
      case 11: return ("SetSELL");
      default: return ("-");
   }  }