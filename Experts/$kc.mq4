//    �� �����, � ������,
//    �� ������, � �����.
//    �� ������ ������,
//    � � ���� �����...

#property copyright "Skycat"
#property link "skycat@pisem.net"

extern int  BackTest=0;
extern int  Opt_Trades=10;// ������ ������ �� �����������, ��������� ��������� � �� ��� ��� �������
extern double RF_=3; // ��� ������������ �����������
extern double PF_=2; // ���� � ������� ������������
extern double MO_=0.2; // � ������� ������������
extern double Risk= 0; // ������� ���� � ������ (�� ����� �������� � ����� #.csv) ���� � ���������� ��������� Risk>0, �� ����, ��������� �� #.csv ����� �������� � ������ ���������� ���
extern int  MM=1;    // 1..4 ��. ��: 
extern bool Real=false;  //
extern bool Check=false; 

extern string z2=" -  � � � � � � � � � �   � � � � � � � �  - ";  
extern int  HL=2;    // 1..6  (1)  ������ ����������� HL 
extern int  HLk=2;   // 1..9  (1)  ���������� ��� ������� HL
extern int  TR=2;    // 1..10 (1)  ������ ����������� ������ 
extern int  TRk=2;   // 1..9  (1)  ���������� ��� ������� ������
extern int  PerCnt=0; // 0..2  (1) 0-������ ������� ����������� ������������� ���������, 1-����� "���������", 2-����� ����� ������
 
extern int  Itr=1;   // -1..1 (1)  ��������� �������� ������ 1-��� ����������, 0-������������� ������, -1-������ 
extern int  IN=9;    // 1..10 (1)  ���� ������� �������� 
extern int  Ik=8;    // 1..9  (1)  ���������� ��� ������� ����� 
extern int  Irev=1;  // -1..1 (2)  ��������� �������� �����  

extern int  Del=1;   // 0..2  (1)  �������� ���������� 0=�� �������;  1=��� ��������� ������ ������� �������; 2=��� ��������� ������ ������� ������� ��������������� ��� ���� ����� ������� ����;
extern int  Rev=0;   // 0..3  (1)  ���� ���������: 0=���;  1-Profit=Stop-0.3*Stop; 2-Profit=Stop; 3-Profit=Stop+0.3*Stop
extern int  D=-2;    // -5..5 (1)  ������ ��� ����������� � ����� �����
extern int  Iprice=1;// 1..2  (2)  ���� ����� 1-�����+/-Delta, 2-���� �� H/L
extern int  S  = 6;  // 1..9  (1)  S=ATR*(S*S*0.1+1); �� ��>30 ������� ���� 8 �� ����� ������, �.�. ���� ��������� �� 7 ������� ATR
extern int  P=5;     // 1..10 (1)  P=ATR*(P*P*0.1+1), ��� �>9 ��� �������������
extern int  PM=2;    // 1..3  (1)  ��� ����������� �������������: 1-���� �������� �������� ����� ������ ATR*P, �� ������ �������������, 2-����������� ������� ��� ������ ������ ���� ������ ������, 3-����������� ���������� �������������  ��� ������ ������ ���� ������ ������
extern int  Pm=3;    // 1..4  (1)  ������� ����������� �������������

extern int  T=7;     // 1..10 (1)  �������� T*T+1; ��� �>9 ��� ���������; 
extern int  TS=0;    // 0..1  (1)  ������ ������ ��������� 0-���� �� �����; 1-�� ���� ��������   
extern int  Tk=2;    // 1..3  (1)  ��������� ���������: 1-�������, 2-������, 3-����
extern int  TM=2;    // 1..4  (1)  ��� ����������� �����: 0-��� �����������,  1-������ �� �����=������ ����,  2-������ �� �����=������ ����,  3-����������� � �������� �����,  4-����������� ����������� ����� � ������ ��������
extern int  Tm=4;    // 1..4  (1)  ������� ����������� �����
 
extern int  Otr=0;   // -1..1 (1)  ��������� �������� ������ 1-��� ����������, 0-������������� ������, -1-������
extern int  Op= 2;   // -1..4 (1)  ������ � �������� ����������� ���� ������� ������ Op*Op*0.1*ATR, ��� Op<0 ����������� ��������. �������� ��� ��������� ������ � ������ �� �������
extern int  OUT=6;   // 1..6  (1)  ���� �������� �������� 
extern int  Ok=2;    // 1..9  (1)  ���������� ��� ������� ������ 
extern int  Orev=1;  // -1..1 (2)  ��������� �������� ������  
extern int  Oprice=1;// -1..1 (1)  ���� ������ -1- ���� �� ��������� ��������, 0-ask/bid, 1-������ �� ����������� ����������� � ������ ����

extern int  A=15;    // 7..28 (7)  ���-�� �����  ��� ������������ ATR (49,196,441,784 �����) 
extern int  a=5;     // 3..6  (1)  ���-�� ����� ��� ������������� atr

extern int  tk=0;    // 0..3  (1)  (0..6 ��� 30�������) 0-��� ���������� �������,  >0-��������� �������� � Tin=(tk-1)*8+T0 �� Tin+T1, ����� ��� ���� �������. ������ ������� ���������� 8 ����� � ������� �0  
extern int  T0=7;    // 1..8  (1)  ��� tk=0 ���������� GTC: 1,2,3,5,8,13,21 ����������. ��� tk>0 ����� ����� Tin=((8*(tk-1)+T0-1). ��� � �����
extern int  T1=8;    // 1..8  (1)  ��� tk=0 ���������� ����� ����� ������� �������� ����: 1,3,5,8,16,24,36,����������. ��� tk>0 ���������� ����� � ������� ������� ��������� ������  � ������� T0. ��� T1=0 || T1=8 ����������� �� ������� �� ��������  
extern int  X=6;     // 2..6  (1)  ��. Signal 6 � ������ ATR -���������� ��� ���������� ������ ����� ����

datetime Bar;
bool     UpTr, DnTr, Up, Dn, FineTime, Stock;
int      Magic, OrdersHistory,  Order, sig, iHL, DailyConfirmation[100000], day, Today, LastYear, Per, 
         ExpirHours, Expiration, Trades,  TestEndTime, BuyTime, SellTime, BuyStopTime, BuyLimitTime, SellStopTime, SellLimitTime, 
         HourIn, MinuteIn, HourOut, MinuteOut, RandomTime,  LastDay, file, TesterFile, DIGITS,  CanTrade, ExpMemory;
double   InitDeposit, Equity, DayMinEquity, MaxEquity, MinEquity, DrawDown,  HistDD, CurDD, LastTestDD, FullDD, Aggress,
         BUY, SELL, BUYSTOP, SELLSTOP, BUYLIMIT, SELLLIMIT, STOP_BUY, PROFIT_BUY, STOP_SELL, PROFIT_SELL, PS[30],  
         SetBUY, SetSELL, SetSTOP_BUY, SetPROFIT_BUY, SetSTOP_SELL, SetPROFIT_SELL,  
         MaxFromBuy, MinFromBuy, MaxFromSell, MinFromSell, RevBUY, RevSELL, MaxRisk=5,  MaxMargin=0.7, // ������������ ��������� ���� ���� ������� � ���� ������� (��� ����� ��� ��� �����), ������������ �������� �����
         StopLevel, Spred, Present, ASK, BID, ATR, atr, H, L, Mid1, Mid2, temp,
          Lot, BuyLot, SellLot, LotDigits, Tout, Tin, Tper; 
int      aPer[100], aHistDD[100], aLastTestDD[100], aMagic[100], aTestEndTime[100], aExpMemory[100], aExpParams[100][50], aBar[100], SessionEnd, SessionStart; // [����� ��������] [������� ���������]
string   aSym[100], aName[100];
double   aRisk[100],aOrdRem[2][10], aRevBUY[100], aRevSELL[100];  // [����� ��������] [��������� ������]  
string   history, str, SYMBOL, Date, Hist, filename, ExpertName="$kc", TesterFileName,
         Prm1,Prm2,Prm3,Prm4,Prm5,Prm6,Prm7,Prm8,Prm9,Prm10,Prm11,Prm12,Prm13, OptPeriod,
         Str1,Str2,Str3,Str4,Str5,Str6,Str7,Str8,Str9,Str10,Str11,Str12,Str13; 

#include <Service.mqh>       // ����������/�������������� ����������, ������ � ��. ���������
#include <ErrorCheck.mqh>    // �������� ����������
#include <MoneyManagement.mqh> 
#include <OrdersProcessing.mqh>
#include <$_Input.mqh>
#include <$_Output.mqh>
#include <$_Trailing.mqh>
#include <$_Count.mqh>
#include <$_Signal.mqh>
#include <AlpariTime.mqh>

void OnTick(){
   if (Time[0]==Bar) {BalanceCheck(); return;}  // ���������� ����� �������� ��������(0) ����
   Statist(); // ������ ���������� DD, Trades, ������ � ������ ������
   for(;;){// ������������� �������� ���� ����� � �������� ����������� �� ���� ��� (������ ��� �����) 
      if (Before()) break; // ��������� �� ����� ����� � ����������� (��� �����)
      OrderCheck();  // ������ ����������� �������� � ���������� ���  Print("SELLSTOP=",SELLSTOP," BUYSTOP=",BUYSTOP);
      Count();       // ������ �������� ����������, ������ ������ ����� OrderCheck!
      if (ATR==0) return; // ���������� ���� ������������ ��� ������ (��������� �� ���, �.�. �� ����� �������)
      if (tk>0 && FineTime==false) StandBy();  // ���������� ����� � ������� ��������� ��������� 
      else{
         if (tk==0 && Tper>0) PositionTimer(); // ����������� �� ��������� ��������� "������� ����� �������"
         StopLimitDel(); // �������� ���������, ���� ������� ���� (��� Del=2)
         StopReverse();  // ���� � �����������
         if (BUY>0 || SELL>0){
            TrailingStop();
            TrailingProfit();
            Output();   // ��������� �������  
            }
         Input();
         //WeekEnd(); // ����������� � ����� ������, ���� �� ������� ���� �� �������� 
         Modify();  // �������, ������������ ������ ����� ������������ �����
         if (SetBUY!=0 || SetSELL!=0){ // ���� ������� ����������� ����������� ������ ������ 
            if (!Real){// �� ������ ������ �����, �������� ���
               if (Risk>0) Lot=MoneyManagement(MathMax(SetBUY-SetSTOP_BUY,SetSTOP_SELL-SetSELL)); else Lot=0.1;
               OrdersSet();
               }  
            else OrdersCollect();   // �� ����� �������� � ����, ����� ����� ����� ���������, �������� ����� ������� � ������ ���������
         }  }
      if (Check) ValueCheck();   // ��������� �������� ����������� Real/Test
      if (!Real) break; // ����� �� ������������ ����� ����������� ������ �� ����� ��� ��������� ����� � �������� ����������� � ����� ExpertName.csv, ������� �� ������ ������� ���
      After();
      }
   TheEnd(); // Print("After Bar=",Bar);  // ����� � ����������� ���������, ���������� ������� ����������       
   Bar=Time[0];   //Print("New Bar=",Bar);     
   }// �������������������������������������������������������������������������������������������������������������������������������������������������������������

void WeekEnd(){   // ����������� � ����� ������ /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////   
   if (TimeDayOfWeek(Time[1])==5 && TimeHour(AlpariTime(0))>21){  // && TimeMinute(Time[0])>=60-Period()
      BUY=0; SELL=0; SetBUY=0; SetSELL=0; SetBUY=0; SetSELL=0;
   }  }// �������������������������������������������������������������������������������������������������������������������������������������������������������������
   
void StopLimitDel(){// �������� ���������, ���� ������� ����  /////////////////////////////////////////////////////////////////////////////////////////////////
   if (Del!=2)  return;
   if (BUY>0){ 
      if (SELLSTOP!=0 && SELLSTOP!=RevSELL)  SELLSTOP=0;   
      if (SELLLIMIT!=0)                      SELLLIMIT=0;  
      }
   if (SELL>0){
      if (BUYSTOP!=0  && BUYSTOP!=RevBUY)    BUYSTOP=0;    
      if (BUYLIMIT!=0)                       BUYLIMIT=0;   
   }  }// �������������������������������������������������������������������������������������������������������������������������������������������������������������

void StopReverse(){ // ������ �������� ���  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   switch(Rev){// ������ ������� ��������� ���������� (��������� ��� tk=0) 
      case 1: temp=-0.3;  break; 
      case 2: temp=0;     break;     
      case 3: temp=0.3;   break;
      default: return;    break;
      } 
   if (BUY>0 && STOP_BUY<BUY && BUY!=RevBUY && SELL==0 && SELLSTOP!=STOP_BUY){ // ���� ���� �������� ����, �� ������������ ������, � ��� �� ������������ �� ����� � ��� ����, � ������������ ��� �� ���������
      if (SELLSTOP!=0 || SELLLIMIT!=0) {SELLSTOP=0; SELLLIMIT=0;} // ����� ���������� �������� ����
      RevSELL=STOP_BUY; // �������� ���� ���������, ���� �� ��������� �� ���� ������ ��������������  
      SetSELL=STOP_BUY; 
      SetSTOP_SELL=BUY;
      SetPROFIT_SELL=SetSELL-(SetSTOP_SELL-SetSELL)-temp*(BUY-STOP_BUY); //  Print(" ��� �������� ��������� �� ��������� BUY setSELL=",SetSELL," STOP_SELL=",STOP_SELL," PROFIT_SELL=",PROFIT_SELL," RevSELL=",RevSELL);
      }
   if (SELL>0 && STOP_SELL>SELL && SELL!=RevSELL && BUY==0 && BUYSTOP!=STOP_SELL){           //Print("BUYSTOP=",BUYSTOP," STOP_SELL=",STOP_SELL," RevBUY=",RevBUY);
      if (BUYSTOP!=0 || BUYLIMIT!=0) {BUYSTOP=0; BUYLIMIT=0;} 
      RevBUY=STOP_SELL; // �������� ���� ���������, ���� �� ��������� �� ���� ������ �������������� 
      SetBUY=STOP_SELL; 
      SetSTOP_BUY=SELL; //Print("  ��� �������� ��������� �� ��������� SELL 
      SetPROFIT_BUY=SetBUY+(SetBUY-SetSTOP_BUY)+temp*(STOP_SELL-SELL);
      }
   if (SELLSTOP==RevSELL && (BUY==0  || STOP_BUY>BUY))   SELLSTOP=0; // ���� ����� � ��������� ��� ����� ���������, ������� ������������
   if (BUYSTOP==RevBUY   && (SELL==0 || STOP_SELL<SELL)) BUYSTOP=0;  // ���� �� ������� ��� � ��������� �������, ��������� �� ���� RevBUY/RevSELL
   }// ������������������������������������������������������������������������������������������������������������������������������������������������������������� 

void PositionTimer(){   // ����� �������� �������� ��� (� �����) /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////   
   if (BUY>0 && (AlpariTime(0)-BuyTime)/60/Period()>=Tper-1){ //Print("dTime=",(Time[0]-BuyTime)/3600.0);
      if (Bid-BUY>Present) BUY=0; // ���� ���� �������� �������, ���������
      else if (BUY+Present<PROFIT_BUY || PROFIT_BUY==0)     PROFIT_BUY=BUY+Present;     // ��������� ���� ���������� ����,
      } 
   if (SELL>0 && (AlpariTime(0)-SellTime)/60/Period()>=Tper-1){
      if (SELL-Ask>Present) SELL=0; // ���� ���� �������� �������, ���������
      else if (SELL-Present>PROFIT_SELL || PROFIT_SELL==0)  PROFIT_SELL=SELL-Present;
   }  }// �������������������������������������������������������������������������������������������������������������������������������������������������������������

void StandBy(){ // �p��� � ������� ��������� ��������� //////////////////////////////////////////////////////////////////////////////////////////////////////
   if (BUY>0){//Print("Buy=",BUY);
      if (Bid-BUY>Present)  BUY=0;  // ���������� �������, ���� ����� ���������
      else  if (PROFIT_BUY==0 || PROFIT_BUY>BUY+Present)  PROFIT_BUY=BUY+Present; // ��������� ������ �� ������� ��������
      }
   if (SELL>0){//Print("Sell=",SELL);
      if (SELL-Ask>Present) SELL=0;  
      else  if (PROFIT_SELL==0 || PROFIT_SELL<SELL-Present)  PROFIT_SELL=SELL-Present;
      }
   BUYSTOP=0; BUYLIMIT=0; SELLSTOP=0; SELLLIMIT=0; // ���� �������� ���������, ����� ���
   Modify();// ��� ���������, �������, ������������
   }// �������������������������������������������������������������������������������������������������������������������������������������������������������������     
         
   
   