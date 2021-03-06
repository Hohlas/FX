// Вот теперь может и сбудется...    
#define VERSION   "190.214"
#define MAX_RISK  10
#property version    VERSION // yym.mdd
#property copyright  "Hohla"
#property link       "hohla.ru"
#property strict // Указание компилятору на применение особого строгого режима проверки ошибок 

extern short   BackTest=0;
extern short   Opt_Trades=5;  // Opt_Trades Влияет только на оптимизацию, остальные параметры и на опт ина бэктест
extern float   RF_=0;         // RF_ При оптимизациях отбрасываем
extern float   PF_=1;         // PF_ резы с худшими показателями
extern float   MO_=0;         // MO_ множитель спреда, т.е. MO=MO_ * Spred
extern float   Risk= 0;       // Risk процент депо в сделке (на реале задается в файле #.csv) Если в настройках выставить Risk>0, то риск, считанный из #.csv будет увеличен в данное количество раз
extern char    MM=1;          // MM 1..4 см. ММ: 
extern bool    Real=false;    // Real
extern char    CustMax=0;      // 0-Bal, 1-RF, 2-iRF, 3-MO/SD - максимизируемый при оптимизации параметр
extern string  SkipPer="";    // пропустить период при оптимизации

extern string z2=" -  П Е Р Е М Е Н Н Ы Е   Э К С П Е Р Т А  - ";  
extern char  HL=1;    // HL=1..9  (1)  расчет экстремумов HL 
extern char  HLk=1;   // HLk=1..8 (1)  переменная для расчета HL
extern char  TR=1;    // TR=-10..10 (1)  расчет направления тренда 
extern char  TRk=1;   // TRk=1..9  (1)  переменная для расчета тренда
extern char  IN=1;    // IN=-10..10 (1)  виды входных фильтров 
extern char  Ik=1;    // Ik=1..9  (1)  переменная для фильтра входа 

extern char  Del=1;   // Del=0..2  (1)  удаление отложников 0=не трогаем;  1=при появлении нового сигнала удаляем; 2=при появлении нового сигнала удаляем противоположный или если ордер остался один;
extern char  Rev=0;   // Rev=0..3  (1)  стоп переворот: 0=нет;  1-Profit=Stop-0.3*Stop; 2-Profit=Stop; 3-Profit=Stop+0.3*Stop
extern char  D=-2;    // D=-5..5 (1)  дельта для прибавления к ценам входа
extern char  Iprice=1;// Iprice=0..3  цена входа 0-HI/LO, 1-Рынок+/-Delta, 2-Фиба от HI/LO
extern char  S  = 6;  // S  =1..9  (1)  S=ATR*(S*S*0.1+1); на ТФ>30 ставить выше 8 не имеет смысла, т.к. стоп ограничен до 7 часовых ATR
extern char  P=5;     // P=1..10 (1)  P=ATR*(P*P*0.1+1), при Р>9 без профиттаргета
extern char  PM1=2;    // PM1=0..3  (1)  приближение профита при каждом откате
extern char  PM2=3;    // PM2=0..4  (1)  если цена провалится от максимальнодостигнутого на xATR, выставляется тейк на максимальнодостигнутый уровень
extern char  TS=0;    // TS=-1..1 (1)  Трейлинг от 0-стопа; 1-входа; -1-без трала   

extern char  Out1=0;  // Out1=0..9  (1)  выходы $Layers при N>3
extern char  Out2=0;  // Out2=0..9  (1)  выходы $Layers при N<3
extern char  Out3=0;  // Out3=-8..8 (2)  выходы
extern char  Out4=0;  // Out4=0..9  (1)
extern char  Out5=0;  // Out5=0..9  (1)
extern char  Out6=0;  // Out6=0..9  (1)
extern char  Out7=0;  // Out7=0..9  (1)
extern char  Out8=0;  // Out8=0..9  (1)
extern char  OTr=0;   // OTr=0..1    (1)  пропадание сигнала тренда
extern char  Oprc=1;  // Oprc=1..3   (1)  цена выхода 1-ask/bid, 2-MaxFromBuy, 3-HI-ATR
extern char  Oprf= 2; // Oprf=-1..5  (1)  сигнал к закрытию принимается если прибыль больше Op*Op*0.1*ATR, при Op<0 безусловное закрытие. Работает для Основного выхода и выхода по времени

extern char  A=15;    // A=7..28 (7)  кол-во баров  для долгосрочной ATR (49,196,784 баров) 
extern char  a=5;     // a=3..6  (1)  кол-во баров для краткосрочной atr
extern char  AtrLim=0;// AtrLim=0..30 (10) %ATR прибавляемый к уровням стопов

extern char  tk=0;    // tk=0..3  (1)  (0..6 для 30минуток) 0-без временного фильтра,  >0-разрешена торговля с Tin=(tk-1)*8+T0 до Tin+T1, потом все позы херятся. Каждая единица прибавляет 8 часов к времени Т0  
extern char  T0=7;    // T0=1..8  (1)  при tk=0 определяет GTC: 1,2,3,5,8,13,21 бесконечно. При tk>0 время входа Tin=((8*(tk-1)+T0-1). Все в БАРАХ
extern char  T1=8;    // T1=1..8  (1)  при tk=0 определяет скока баров держать открытую позу: 1,3,5,8,16,24,36,бесконечно. При tk>0 количество баров в течении которых разрешена работа  с момента T0. При T1=0 || T1=8 ограничения по времени не работают  
extern char  tp=6;    // tp=-1..5  (1)  см. Signal 6 и расчет ATR -переменная для подстройки всяких новых идей

datetime BarTime, LastBarTime, ExpMemory, TestEndTime, BuyTime, SellTime, Expiration;
bool     Up, Dn;
short    ExpirBars, Per, Tout, Tin, Tper,  LotDigits, DIGITS, Exp, ExpTotal, FastAtrPer, SlowAtrPer, HistDD,  LastTestDD, SkipFrom=0, SkipTo=0;
int      bar=1, Magic, Today, TesterFile;
float    PS[20], ch[6], Present, MaxSpred, Lot, Aggress, Lim, MinProfit, PerAdapter,  MaxFromBuy, MinFromBuy, MaxFromSell, MinFromSell, CurDD,
         RevBUY, RevSELL, ATR, atr, ASK, BID, StopLevel, Spred, MaxRisk,  MaxMargin=float(0.7),  // максимальный суммарный риск всех позиций в одну сторону (все лонги или все шорты), максимальная загрузка маржи    
         InitDeposit, DayMinEquity, DrawDown, MaxEquity, MinEquity, Equity, FullDD;  
string   history="", SYMBOL, Hist, filename, ExpertName="Fa$t"+VERSION, ExpID, Company,
         Prm1,Prm2,Prm3,Prm4,Prm5,Prm6,Prm7,Prm8,Prm9,Prm10,Prm11,Prm12,Prm13, OptPeriod,
         Str1,Str2,Str3,Str4,Str5,Str6,Str7,Str8,Str9,Str10,Str11,Str12,Str13; 
ulong    MagicLong;

#include <stdlib.mqh> 
#include <stderror.mqh> 
#include <StdLibErr.mqh> 
#include <iGRAPH.mqh>
#include <Service.mqh>       // сохранение/восстановление параметров, отчеты и др. заморочки
#include <Errors.mqh>    // проверка исполнения
#include <MM.mqh> 
#include <i$$_Count.mqh>
#include <Orders.mqh>
#include <i$$_Input.mqh>
#include <i$$_Output.mqh>
#include <i$$_Trailing.mqh>
#include <i$$_Signal.mqh>
#include <i$$_Indicators.mqh>



 
double HH,LL;
void OnTick(){
   //if (TimeYear(Time[bar])<StartYear) return;
   if (Real && float(Ask-Bid)>MaxSpred) MaxSpred=float(Ask-Bid);
   if (Time[0]==BarTime) {CHECK_OUT(); return;}  // Сравниваем время открытия текущего(0) бара 
   
   //HI=float(iCustom(NULL,0,"$HLfast",HL,HLk,0,bar));  //
   //LO=float(iCustom(NULL,0,"$HLfast",HL,HLk,3,bar));  //
   //iHILO();
   //Print("DM(",HL,",",HLk,")=",HI," ",DM,"    min=",LO," ",DMmin); 
   //return;
   
   DAY_STATISTIC(); // расчет параметров DD, Trades, массив с резами сделок
   if (TimeYear(Time[bar])>=SkipFrom && TimeYear(Time[bar])<SkipTo){ORDER_CHECK(); StandBy(); return;}
   for (Exp=1; Exp<=ExpTotal; Exp++){// осуществление перебора всех строк с входными параметрами за один тик (только для реала) 
      if (!EXPERT_SET()) continue; // выбор параметров эксперта из строки Exp массива CSV, сформированного из файла #.csv
      ORDER_CHECK();  // подробности открытых и отложенных поз  Print("SELLSTOP=",SELLSTOP," BUYSTOP=",BUYSTOP);
      if (!FineTime()) StandBy();  // не торгуем и закрываем все позы в период запрета торговли
      else{
         if (Tper>0) PositionTimer(); // может пора закрыть открытые позы?
         if (Count()){     // Print(DoubleToStr(Magic,0),": S T A R T, BackTest=",BackTest," ExpBUY=",BUY.Val+BUYSTOP+BUYLIMIT," ExpSELL=",SEL.Val+SELLSTOP+SELLLIMIT," RevBUY=",RevBUY," ExpMemory=",ExpMemory); // Расчет основных параметров, должен стоять после OrderCheck!   
            StopLimitDel(); // удаление отложника, если остался один (при Del=2)
            StopReverse();  // стоп с переворотом
            if (BUY.Val>0 || SEL.Val>0){
               TRAILING_STOP();
               TRAILING_PROFIT();
               Output();   // стратегии выходов  
               }
            Input(); //Print("Input");
            //WeekEnd(); // закрываемся в конце сессии, чтоб не платить своп за овернайт
            MODIFY();  // Удаляем, модифицируем ордера перед расстановкой новых
            if (setBUY.Val!=0 || setSEL.Val!=0){ // если осалась потребность выставления нового ордера 
               if (!Real){// на тестах ставим сразу, расчитая лот
                  if (Risk>0) Lot=MM(MathMax(setBUY.Val-setBUY.Stp, setSEL.Stp-setSEL.Val), Risk, SYMBOL); else Lot=float(0.1);
                  ORDERS_SET(Risk);
                  }  
               else ORDERS_COLLECT();   // не реале собираем в файл, чтобы потом разом выставить, разделив маржу поровну с учетом ролловера
         }  }  }
      AFTER();
      }  
   END(); // Print("After BarTime=",BarTime);  // отчет о проведенных операциях, сохранение текущих параметров       
   BarTime=Time[0];   //Print("New BarTime=",BarTime); 
   }  
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ    
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ

void WeekEnd(){   // закрываемся в конце недели /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////   
   if (TimeDayOfWeek(Time[1])==5 && TimeHour(Time[0])>21){  // && TimeMinute(Time[0])>=60-Period()
      BUY.Val=0; SEL.Val=0; setBUY.Val=0; setSEL.Val=0; setBUY.Val=0; setSEL.Val=0;
   }  }
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ 
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ  
void StopLimitDel(){// УДАЛЕНИЕ ОТЛОЖНИКА, ЕСЛИ ОСТАЛСЯ ОДИН  
   if (Del!=2)  return;
   if (BUY.Val>0){ 
      if (SELSTP!=0 && SELSTP!=RevSELL)   SELSTP=0;   
      if (SELLIM!=0)                      SELLIM=0;  
      }
   if (SEL.Val>0){
      if (BUYSTP!=0 && BUYSTP!=RevBUY)    BUYSTP=0;    
      if (BUYLIM!=0)                      BUYLIM=0;   
   }  }
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ 
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
void StopReverse(){ // РЕВЕРС ОТКРЫТЫХ ПОЗ  
   float temp=0;
   switch(Rev){// расчет времени удержания отложников (актуально при tk=0) 
      case 1: temp=float(-0.3);  break; 
      case 2: temp=0;            break;     
      case 3: temp=float(0.3);   break;
      default: return;           break;
      } 
   if (BUY.Val>0 && BUY.Stp<BUY.Val && BUY.Val!=RevBUY && SEL.Val==0 && SELSTP!=BUY.Stp){ // если есть открытый лонг, не закрепленный стопом, и это не переворотник от Селла и нет села, и переворотник еще не выставлен
      if (SELSTP!=0 || SELLIM!=0) {SELSTP=0; SELLIM=0;} // херим оставшиеся короткие позы
      RevSELL=BUY.Stp; // запомним цену отложника, чтоб не открывать по нему больше переворотников  
      setSEL.Val=BUY.Stp; 
      setSEL.Stp=BUY.Val;
      setSEL.Prf=setSEL.Val-(setSEL.Stp-setSEL.Val)-temp*(BUY.Val-BUY.Stp); //  Print(" Щас поставим переворот на имеющийся BUY.Val setSELL=",setSEL.Val," SEL.Stp=",SEL.Stp," SEL.Prf=",SEL.Prf," RevSELL=",RevSELL);
      }
   if (SEL.Val>0 && SEL.Stp>SEL.Val && SEL.Val!=RevSELL && BUY.Val==0 && BUYSTP!=SEL.Stp){           //Print("BUYSTOP=",BUYSTOP," SEL.Stp=",SEL.Stp," RevBUY=",RevBUY);
      if (BUYSTP!=0 || BUYLIM!=0) {BUYSTP=0; BUYLIM=0;} 
      RevBUY=SEL.Stp; // запомним цену отложника, чтоб не открывать по нему больше переворотников 
      setBUY.Val=SEL.Stp; 
      setBUY.Stp=SEL.Val; //Print("  Щас поставим переворот на имеющийся SEL.Val 
      setBUY.Prf=setBUY.Val+(setBUY.Val-setBUY.Stp)+temp*(SEL.Stp-SEL.Val);
      }
   if (SELSTP==RevSELL && (BUY.Val==0 || BUY.Stp>BUY.Val)) SELSTP=0; // если вышли в безубыток или вовсе закрылись, снимаем переворотник
   if (BUYSTP==RevBUY  && (SEL.Val==0 || SEL.Stp<SEL.Val)) BUYSTP=0;  // штоб не спутать его с системным ордером, проверяем по цене RevBUY/RevSELL
   }
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ 
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
void PositionTimer(){   // ВРЕМЯ УДЕРЖАНИ ОТКРЫТЫХ ПОЗ (В Барах)  
   float TimeProfit; 
   if (tp<0)  TimeProfit=-20*ATR; // при отрицательных значениях tp поХ c каким кушем выходить
   else       TimeProfit=float((tp)*(tp)*0.1*ATR); // пороговая прибыль, без которой не закрываемся 0.1  0.4  0.9  1.6  2.5  3.6
   if (BUY.Val>0 && (Time[0]-BuyTime)/60/Period()>=Tper){ 
      if (Bid-BUY.Val>TimeProfit)  BUY.Val=0;  // достаточно профита, чтоб сразу закрыться
      else  if (BUY.Prf==0 || BUY.Prf>BUY.Val+TimeProfit)  BUY.Prf=BUY.Val+TimeProfit; // Перетащим профит на уровень жадности
      LINE("BuyPositionTimer", bar,BUY.Prf, bar+1,BUY.Prf, clrGreenYellow,0);    //Print("BuyPositionTimer=",(Time[0]-BuyTime)/60/Period()," CurProfit=",Bid-BUY.Val," TimeProfit=",TimeProfit); 
      } 
   if (SEL.Val>0 && (Time[0]-SellTime)/60/Period()>=Tper){ 
      if (SEL.Val-Ask>TimeProfit) SEL.Val=0;  
      else  if (SEL.Prf==0 || SEL.Prf<SEL.Val-TimeProfit)  SEL.Prf=SEL.Val-TimeProfit;
      LINE("SellPositionTimer", bar,SEL.Prf, bar+1,SEL.Prf, clrGreenYellow,0);   //Print("SellPositionTimer=",(Time[0]-SellTime)/60/Period()," CurProfit=",SEL.Val-Ask," TimeProfit=",TimeProfit); 
   }  }
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
void StandBy(){ // Закрытие всех поз в период запрета торговли 
   float TimeProfit;
   if (tp<0)  TimeProfit=-20*ATR; // при отрицательных значениях tp поХ c каким кушем выходить
   else       TimeProfit=float((tp)*(tp)*0.1*ATR); // пороговая прибыль, без которой не закрываемся 0.1  0.4  0.9  1.6  2.5  3.6
   if (BUY.Val>0){//Print("setBUY=",BUY.Val);
      if (Bid-BUY.Val>TimeProfit)  BUY.Val=0;  // достаточно профита, чтоб сразу закрыться
      else  if (BUY.Prf==0 || BUY.Prf>BUY.Val+TimeProfit)  BUY.Prf=BUY.Val+TimeProfit; // Перетащим профит на уровень жадности
      }
   if (SEL.Val>0){// Print("StandBy: Sell=",SEL.Val," SEL.Val-Ask=",SEL.Val-Ask, " TimeProfit=",TimeProfit," ATR=",ATR);
      if (SEL.Val-Ask>TimeProfit) SEL.Val=0;  
      else  if (SEL.Prf==0 || SEL.Prf<SEL.Val-TimeProfit)  SEL.Prf=SEL.Val-TimeProfit;
      }
   BUYSTP=0; BUYLIM=0; SELSTP=0; SELLIM=0; // Если остались отложники, херим все
   MODIFY();// все закрываем, удаляем, модифицируем
   }
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ   
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ

