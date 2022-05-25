//    Ќе жизнь, а работа,
//    Ќе пь€нки, а рвота.
//    ћы просто пехота,
//    ј в небо охота...

#property copyright "Skycat"
#property link "skycat@pisem.net"

extern int  BackTest=0;
extern int  Opt_Trades=10;// ¬ли€ет только на оптимизацию, остальные параметры и на опт ина бэктест
extern double RF_=3; // ѕри оптимизаци€х отбрасываем
extern double PF_=2; // резы с худшими показател€ми
extern double MO_=0.2; // с худшими показател€ми
extern double Risk= 0; // процент депо в сделке (на реале задаетс€ в файле #.csv) ≈сли в настройках выставить Risk>0, то риск, считанный из #.csv будет увеличен в данное количество раз
extern int  MM=1;    // 1..4 см. ћћ: 
extern bool Real=false;  //
extern bool Check=false; 

extern string z2=" -  ѕ ≈ – ≈ ћ ≈ Ќ Ќ џ ≈   Ё   — ѕ ≈ – “ ј  - ";  
extern int  HL=2;    // 1..6  (1)  расчет экстремумов HL 
extern int  HLk=2;   // 1..9  (1)  переменна€ дл€ расчета HL
extern int  TR=2;    // 1..10 (1)  расчет направлени€ тренда 
extern int  TRk=2;   // 1..9  (1)  переменна€ дл€ расчета тренда
extern int  PerCnt=0; // 0..2  (1) 0-–асчет периода индикаторов классическими периодами, 1-метод "веревочки", 2-метод смены тренда
 
extern int  Itr=1;   // -1..1 (1)  обработка сигналов “ренда 1-без переворота, 0-игнорирование тренда, -1-реверс 
extern int  IN=9;    // 1..10 (1)  виды входных фильтров 
extern int  Ik=8;    // 1..9  (1)  переменна€ дл€ фильтра входа 
extern int  Irev=1;  // -1..1 (2)  переворот сигналов входа  

extern int  Del=1;   // 0..2  (1)  удаление отложников 0=не трогаем;  1=при по€влении нового сигнала удал€ем; 2=при по€влении нового сигнала удал€ем противоположный или если ордер осталс€ один;
extern int  Rev=0;   // 0..3  (1)  стоп переворот: 0=нет;  1-Profit=Stop-0.3*Stop; 2-Profit=Stop; 3-Profit=Stop+0.3*Stop
extern int  D=-2;    // -5..5 (1)  дельта дл€ прибавлени€ к ценам входа
extern int  Iprice=1;// 1..2  (2)  цена входа 1-–ынок+/-Delta, 2-‘иба от H/L
extern int  S  = 6;  // 1..9  (1)  S=ATR*(S*S*0.1+1); на “‘>30 ставить выше 8 не имеет смысла, т.к. стоп ограничен до 7 часовых ATR
extern int  P=5;     // 1..10 (1)  P=ATR*(P*P*0.1+1), при –>9 без профиттаргета
extern int  PM=2;    // 1..3  (1)  вид модификации ѕрофит“аргета: 1-если обратное движение будет больше ATR*P, то профит зафиксируетс€, 2-приближение ѕрофита при каждом откате цены против сделки, 3-приближение плавающего ѕрофит“аргета  при каждом откате цены против сделки
extern int  Pm=3;    // 1..4  (1)  степень модификации ѕрофит“аргета

extern int  T=7;     // 1..10 (1)  “рейлинг T*T+1; при “>9 без трейлинга; 
extern int  TS=0;    // 0..1  (1)  Ќачало работы трейлинга 0-пр€м от стопа; 1-от цены открыти€   
extern int  Tk=2;    // 1..3  (1)  —тратеги€ трейлинга: 1-ќбычный, 2-Ћюстра, 3-‘»Ѕџ
extern int  TM=2;    // 1..4  (1)  вид модификации “рала: 0-без модификаций,  1-дальше от входа=меньше трал,  2-дальше от входа=больше трал,  3-перемещение с заданным шагом,  4-постепенное перемещение стопа к новому значению
extern int  Tm=4;    // 1..4  (1)  степень модификации “рала
 
extern int  Otr=0;   // -1..1 (1)  обработка сигналов “ренда 1-без переворота, 0-игнорирование тренда, -1-реверс
extern int  Op= 2;   // -1..4 (1)  сигнал к закрытию принимаетс€ если прибыль больше Op*Op*0.1*ATR, при Op<0 безусловное закрытие. –аботает дл€ ќсновного выхода и выхода по времени
extern int  OUT=6;   // 1..6  (1)  виды выходных фильтров 
extern int  Ok=2;    // 1..9  (1)  переменна€ дл€ фильтра выхода 
extern int  Orev=1;  // -1..1 (2)  переворот сигналов выхода  
extern int  Oprice=1;// -1..1 (1)  цена выхода -1- стоп на последнем минимуме, 0-ask/bid, 1-профит на максимально достигнутой в сделке цене

extern int  A=15;    // 7..28 (7)  кол-во баров  дл€ долгосрочной ATR (49,196,441,784 баров) 
extern int  a=5;     // 3..6  (1)  кол-во баров дл€ краткосрочной atr

extern int  tk=0;    // 0..3  (1)  (0..6 дл€ 30минуток) 0-без временного фильтра,  >0-разрешена торговл€ с Tin=(tk-1)*8+T0 до Tin+T1, потом все позы хер€тс€.  ажда€ единица прибавл€ет 8 часов к времени “0  
extern int  T0=7;    // 1..8  (1)  при tk=0 определ€ет GTC: 1,2,3,5,8,13,21 бесконечно. ѕри tk>0 врем€ входа Tin=((8*(tk-1)+T0-1). ¬се в Ѕј–ј’
extern int  T1=8;    // 1..8  (1)  при tk=0 определ€ет скока баров держать открытую позу: 1,3,5,8,16,24,36,бесконечно. ѕри tk>0 количество баров в течении которых разрешена работа  с момента T0. ѕри T1=0 || T1=8 ограничени€ по времени не работают  
extern int  X=6;     // 2..6  (1)  см. Signal 6 и расчет ATR -переменна€ дл€ подстройки вс€ких новых идей

datetime Bar;
bool     UpTr, DnTr, Up, Dn, FineTime, Stock;
int      Magic, OrdersHistory,  Order, sig, iHL, DailyConfirmation[100000], day, Today, LastYear, Per, 
         ExpirHours, Expiration, Trades,  TestEndTime, BuyTime, SellTime, BuyStopTime, BuyLimitTime, SellStopTime, SellLimitTime, 
         HourIn, MinuteIn, HourOut, MinuteOut, RandomTime,  LastDay, file, TesterFile, DIGITS,  CanTrade, ExpMemory;
double   InitDeposit, Equity, DayMinEquity, MaxEquity, MinEquity, DrawDown,  HistDD, CurDD, LastTestDD, FullDD, Aggress,
         BUY, SELL, BUYSTOP, SELLSTOP, BUYLIMIT, SELLLIMIT, STOP_BUY, PROFIT_BUY, STOP_SELL, PROFIT_SELL, PS[30],  
         SetBUY, SetSELL, SetSTOP_BUY, SetPROFIT_BUY, SetSTOP_SELL, SetPROFIT_SELL,  
         MaxFromBuy, MinFromBuy, MaxFromSell, MinFromSell, RevBUY, RevSELL, MaxRisk=5,  MaxMargin=0.7, // максимальный суммарный риск всех позиций в одну сторону (все лонги или все шорты), максимальна€ загрузка маржи
         StopLevel, Spred, Present, ASK, BID, ATR, atr, H, L, Mid1, Mid2, temp,
          Lot, BuyLot, SellLot, LotDigits, Tout, Tin, Tper; 
int      aPer[100], aHistDD[100], aLastTestDD[100], aMagic[100], aTestEndTime[100], aExpMemory[100], aExpParams[100][50], aBar[100], SessionEnd, SessionStart; // [номер эксперта] [входные параметры]
string   aSym[100], aName[100];
double   aRisk[100],aOrdRem[2][10], aRevBUY[100], aRevSELL[100];  // [номер эксперта] [параметры ордера]  
string   history, str, SYMBOL, Date, Hist, filename, ExpertName="$kc", TesterFileName,
         Prm1,Prm2,Prm3,Prm4,Prm5,Prm6,Prm7,Prm8,Prm9,Prm10,Prm11,Prm12,Prm13, OptPeriod,
         Str1,Str2,Str3,Str4,Str5,Str6,Str7,Str8,Str9,Str10,Str11,Str12,Str13; 

#include <Service.mqh>       // сохранение/восстановление параметров, отчеты и др. заморочки
#include <ErrorCheck.mqh>    // проверка исполнени€
#include <MoneyManagement.mqh> 
#include <OrdersProcessing.mqh>
#include <$_Input.mqh>
#include <$_Output.mqh>
#include <$_Trailing.mqh>
#include <$_Count.mqh>
#include <$_Signal.mqh>
#include <AlpariTime.mqh>

void OnTick(){
   if (Time[0]==Bar) {BalanceCheck(); return;}  // —равниваем врем€ открыти€ текущего(0) бара
   Statist(); // расчет параметров DD, Trades, массив с резами сделок
   for(;;){// осуществление перебора всех строк с входными параметрами за один тик (только дл€ реала) 
      if (Before()) break; // добрались до конца файла с параметрами (дл€ реала)
      OrderCheck();  // ”знаем подробности открытых и отложенных поз  Print("SELLSTOP=",SELLSTOP," BUYSTOP=",BUYSTOP);
      Count();       // –асчет основных параметров, должен сто€ть после OrderCheck!
      if (ATR==0) return; // дожидаемс€ пока просчитаютс€ все индюки (сравнение по ј“–, т.к. он самый длинный)
      if (tk>0 && FineTime==false) StandBy();  // ќпредел€ем врем€ в которое разрешено торговать 
      else{
         if (tk==0 && Tper>0) PositionTimer(); // «акрываемс€ по истечении заданного "времени жизни позиции"
         StopLimitDel(); // удаление отложника, если осталс€ один (при Del=2)
         StopReverse();  // стоп с переворотом
         if (BUY>0 || SELL>0){
            TrailingStop();
            TrailingProfit();
            Output();   // стратегии выходов  
            }
         Input();
         //WeekEnd(); // закрываемс€ в конце сессии, чтоб не платить своп за овернайт 
         Modify();  // ”дал€ем, модифицируем ордера перед расстановкой новых
         if (SetBUY!=0 || SetSELL!=0){ // если осалась потребность выставлени€ нового ордера 
            if (!Real){// на тестах ставим сразу, расчита€ лот
               if (Risk>0) Lot=MoneyManagement(MathMax(SetBUY-SetSTOP_BUY,SetSTOP_SELL-SetSELL)); else Lot=0.1;
               OrdersSet();
               }  
            else OrdersCollect();   // не реале собираем в файл, чтобы потом разом выставить, разделив маржу поровну с учетом ролловера
         }  }
      if (Check) ValueCheck();   // сравнение значений индикаторов Real/Test
      if (!Real) break; // выход из бесконечного цикла организован только на реале при окончании строк с входными параметрами в файле ExpertName.csv, поэтому на тестах выходим так
      After();
      }
   TheEnd(); // Print("After Bar=",Bar);  // отчет о проведенных операци€х, сохранение текущих параметров       
   Bar=Time[0];   //Print("New Bar=",Bar);     
   }// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆

void WeekEnd(){   // закрываемс€ в конце недели /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////   
   if (TimeDayOfWeek(Time[1])==5 && TimeHour(AlpariTime(0))>21){  // && TimeMinute(Time[0])>=60-Period()
      BUY=0; SELL=0; SetBUY=0; SetSELL=0; SetBUY=0; SetSELL=0;
   }  }// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆
   
void StopLimitDel(){// ”ƒјЋ≈Ќ»≈ ќ“Ћќ∆Ќ» ј, ≈—Ћ» ќ—“јЋ—я ќƒ»Ќ  /////////////////////////////////////////////////////////////////////////////////////////////////
   if (Del!=2)  return;
   if (BUY>0){ 
      if (SELLSTOP!=0 && SELLSTOP!=RevSELL)  SELLSTOP=0;   
      if (SELLLIMIT!=0)                      SELLLIMIT=0;  
      }
   if (SELL>0){
      if (BUYSTOP!=0  && BUYSTOP!=RevBUY)    BUYSTOP=0;    
      if (BUYLIMIT!=0)                       BUYLIMIT=0;   
   }  }// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆

void StopReverse(){ // –≈¬≈–— ќ“ –џ“џ’ ѕќ«  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   switch(Rev){// расчет времени удержани€ отложников (актуально при tk=0) 
      case 1: temp=-0.3;  break; 
      case 2: temp=0;     break;     
      case 3: temp=0.3;   break;
      default: return;    break;
      } 
   if (BUY>0 && STOP_BUY<BUY && BUY!=RevBUY && SELL==0 && SELLSTOP!=STOP_BUY){ // если есть открытый лонг, не закрепленный стопом, и это не переворотник от —елла и нет села, и переворотник еще не выставлен
      if (SELLSTOP!=0 || SELLLIMIT!=0) {SELLSTOP=0; SELLLIMIT=0;} // херим оставшиес€ короткие позы
      RevSELL=STOP_BUY; // запомним цену отложника, чтоб не открывать по нему больше переворотников  
      SetSELL=STOP_BUY; 
      SetSTOP_SELL=BUY;
      SetPROFIT_SELL=SetSELL-(SetSTOP_SELL-SetSELL)-temp*(BUY-STOP_BUY); //  Print(" ўас поставим переворот на имеющийс€ BUY setSELL=",SetSELL," STOP_SELL=",STOP_SELL," PROFIT_SELL=",PROFIT_SELL," RevSELL=",RevSELL);
      }
   if (SELL>0 && STOP_SELL>SELL && SELL!=RevSELL && BUY==0 && BUYSTOP!=STOP_SELL){           //Print("BUYSTOP=",BUYSTOP," STOP_SELL=",STOP_SELL," RevBUY=",RevBUY);
      if (BUYSTOP!=0 || BUYLIMIT!=0) {BUYSTOP=0; BUYLIMIT=0;} 
      RevBUY=STOP_SELL; // запомним цену отложника, чтоб не открывать по нему больше переворотников 
      SetBUY=STOP_SELL; 
      SetSTOP_BUY=SELL; //Print("  ўас поставим переворот на имеющийс€ SELL 
      SetPROFIT_BUY=SetBUY+(SetBUY-SetSTOP_BUY)+temp*(STOP_SELL-SELL);
      }
   if (SELLSTOP==RevSELL && (BUY==0  || STOP_BUY>BUY))   SELLSTOP=0; // если вышли в безубыток или вовсе закрылись, снимаем переворотник
   if (BUYSTOP==RevBUY   && (SELL==0 || STOP_SELL<SELL)) BUYSTOP=0;  // штоб не спутать его с системным ордером, провер€ем по цене RevBUY/RevSELL
   }// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆ 

void PositionTimer(){   // ¬–≈ћя ”ƒ≈–∆јЌ» ќ“ –џ“џ’ ѕќ« (¬ Ѕарах) /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////   
   if (BUY>0 && (AlpariTime(0)-BuyTime)/60/Period()>=Tper-1){ //Print("dTime=",(Time[0]-BuyTime)/3600.0);
      if (Bid-BUY>Present) BUY=0; // если поза принесла прибыль, закрываем
      else if (BUY+Present<PROFIT_BUY || PROFIT_BUY==0)     PROFIT_BUY=BUY+Present;     // закрываем тока прибыльные позы,
      } 
   if (SELL>0 && (AlpariTime(0)-SellTime)/60/Period()>=Tper-1){
      if (SELL-Ask>Present) SELL=0; // если поза принесла прибыль, закрываем
      else if (SELL-Present>PROFIT_SELL || PROFIT_SELL==0)  PROFIT_SELL=SELL-Present;
   }  }// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆

void StandBy(){ // ¬pем€ в которое разрешено торговать //////////////////////////////////////////////////////////////////////////////////////////////////////
   if (BUY>0){//Print("Buy=",BUY);
      if (Bid-BUY>Present)  BUY=0;  // достаточно профита, чтоб сразу закрытьс€
      else  if (PROFIT_BUY==0 || PROFIT_BUY>BUY+Present)  PROFIT_BUY=BUY+Present; // ѕеретащим профит на уровень жадности
      }
   if (SELL>0){//Print("Sell=",SELL);
      if (SELL-Ask>Present) SELL=0;  
      else  if (PROFIT_SELL==0 || PROFIT_SELL<SELL-Present)  PROFIT_SELL=SELL-Present;
      }
   BUYSTOP=0; BUYLIMIT=0; SELLSTOP=0; SELLLIMIT=0; // ≈сли остались отложники, херим все
   Modify();// все закрываем, удал€ем, модифицируем
   }// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆     
         
   
   