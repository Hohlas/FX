// Вот теперь может и сбудется...
#property copyright "Hohla"
#property link      "hohla@mail.ru"
#property strict // Указание компилятору на применение особого строгого режима проверки ошибок
#property indicator_separate_window
#property indicator_buffers 4
#property indicator_color1 Green
#property indicator_color2 Gray
#property indicator_color3 clrRed
#property indicator_color4 clrBlue

extern int Mode=0; // Mode=0..3
extern int Per=10; // Per=1..10
double iDM[],iBuf[],iMAX[],iMIN[];
int HL,HLk;
float ATR;
#include <i$$_Indicators.mqh>
//ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
//ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
int OnInit(void){
   string Name="DMfast."+DoubleToStr(Mode,0)+"."+DoubleToStr(Per,0);
   IndicatorBuffers(4);
   SetIndexStyle(0,DRAW_LINE);   SetIndexBuffer(0,iDM);   SetIndexLabel(0,"DM");
   SetIndexStyle(1,DRAW_LINE);   SetIndexBuffer(1,iBuf);  SetIndexLabel(1,"0");
   SetIndexStyle(2,DRAW_LINE);   SetIndexBuffer(2,iMAX);  SetIndexLabel(2,"MAX");
   SetIndexStyle(3,DRAW_LINE);   SetIndexBuffer(3,iMIN);  SetIndexLabel(3,"MIN");
   switch (Mode){
         case 0:  Name=Name+"DM_Classic ("   +DoubleToStr(Per,0)+")"; break;
         case 1:  Name=Name+"Signal/Noise (" +DoubleToStr(Per,0)+")"; break; 
         case 2:  Name=Name+"Delta_S ("      +DoubleToStr(Per,0)+")"; break; 
         case 3:  Name=Name+"Momentum ("     +DoubleToStr(Per,0)+")"; break;
         }
   IndicatorShortName(Name);
   SetIndexLabel(0,Name);
   if (Per<1 || Mode<0 || Mode>3){
      Print("Wrong input parameters"); return(INIT_FAILED);}
   return (INIT_SUCCEEDED); // "0"-Успешная инициализация.
   }
//ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
//ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ 
int bar;
void start(){
   int CountBars=Bars-IndicatorCounted()-1;
   for (bar=CountBars; bar>0; bar--){
      if (bar>Bars-Per-1) continue;
      iDM(Mode, Per);
      iDM[bar]=DM;
      iMAX[bar]=DMmax;
      iMIN[bar]=DMmin;   
      iBuf[bar]=0;
   }  }
