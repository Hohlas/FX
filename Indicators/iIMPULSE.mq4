#property copyright "Hohla"
#property link      "mail@hohla.ru"
#property version    "160.818" // yym.mdd
#property strict // �������� ����������� �� ���������� ������� �������� ������ �������� ������ 
#property indicator_separate_window 
#property indicator_buffers 2
#property indicator_color1 clrGray           //  
#property indicator_color2 clrBlack           // 
// �������� ����������� �� ������ ��������� (��������). ������������ � ��������� �������� �������� ����� ������ ���� �� �������� �������� � ������� ��������. 
extern int Impulse =200;  // 150..400(50) ����� ������������ ATR%, ������� ������ ��������� ������� � ���� ��� ��������� �������
extern int ImpBack=100;  // 80..140 (20)����� �� ������� ���� ATR% ����� ������������� �������� ��� ������ �������

extern int  A=5;     // A=1..6  ���-�� ���� ��� ���������� ���
extern int  a=5;     // a=2..6  ���-�� ���^2 ��� �������� atr

int   bar, MinBarsToCount, BarsInDay, SlowAtrPer, FastAtrPer;
double    FastAtr, SlowAtr, I0[],I1[]; 
#include <lib_ATR.mqh>
#include <lib_Impulse.mqh>      // �������

int OnInit(){//�����������������������������������������������������������������������������������������������������������������
   string iName="Impulse";
   IndicatorBuffers(2);  IndicatorDigits(Digits);
   SetIndexStyle(0,DRAW_LINE);   SetIndexBuffer(0,I0);   // 
   SetIndexStyle(1,DRAW_LINE);   SetIndexBuffer(1,I1);   //
   iName=iName+"("+DoubleToStr(Impulse,0)+","+DoubleToStr(ImpBack,0)+") ";  //  
   IndicatorShortName(iName);
   SetIndexLabel(0,iName);
   BarsInDay=60*24/Period(); // ���-�� ��� � ���
   SlowAtrPer=BarsInDay*A;  
   FastAtrPer=a*a;
   MinBarsToCount=SlowAtrPer+1; 
   if (Bars>MinBarsToCount) return(INIT_SUCCEEDED); // �������� �������������. ��������� ���������� ������� OnInit() ������������� ���������� ������ ���� ��������� �������������� � �������������� #property strict.  
   else {Print(" Not enough Bars: Bars=",Bars," MinBars=",MinBarsToCount);  return(INIT_FAILED);} // ��������� ��� �������� �������� ��������� ������������� � ���������� ������� Deinit � ����� ������� ��������������� REASON_INITFAILED     
   //Print("OnInit(): Bars=",Bars," IndicatorCounted()=",IndicatorCounted());
   
   }//�����������������������������������������������������������������������������������������������������������������

void start(){
   int CountBars=Bars-1; 
   if (IndicatorCounted()>0) CountBars=Bars-IndicatorCounted()-1;
   //Print("start(): Bars=",Bars," IndicatorCounted()=",IndicatorCounted()," CountBars=",CountBars);
   for (bar=CountBars; bar>0; bar--){ // Print(" Bars=",Bars," IndicatorCounted=",IndicatorCounted()," CountBars=",CountBars, " bar=",bar);
      //if (bar>Bars-10 || bar<5) Print("start(): Bars=",Bars," IndicatorCounted()=",IndicatorCounted()," CountBars=",CountBars," bar=",bar);
      ATR(); // ���������� FastAtr & SlowAtr 
      IMPULSE();// ������������ ������ ���������. ���� ������ ��� �>>O ���� ��� �������� ���� ����� ������ �� L. ���� ������ ��� �<<O, ���� �������� ���� ������ �� �.
      I1[bar]=Imp.Sig;
      I0[bar]=Imp.Cur;   
   }  }