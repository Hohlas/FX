// Вот теперь может и сбудется...
#property copyright "Hohla"
#property link      "hohla@mail.ru"
#property strict // Указание компилятору на применение особого строгого режима проверки ошибок
#property description "Встроена функция R/W для ускорения оптимизации. При первом вызове создается файл со значениями индикатора, при последующих вызовах из него считываются посчитанные значения. Не дает никакого преимущества в скорости"

#property indicator_chart_window
#property indicator_buffers 6
#property indicator_color1 clrBlue // iHI
#property indicator_color2 clrBlue // iLO
#property indicator_color3 clrGainsboro // MaxHI
#property indicator_color4 clrGainsboro // MinLO
#property indicator_color5 clrGreen // StpHi
#property indicator_color6 clrGreen // StpLo

extern int HL=1; // 1..9 Type
extern int HLk=8;// 1..8 Period
double iHI[], iLO[], iMaxHI[], iMinLO[], iStpHi[], iStpLo[]; 

#define MAX_EXPERTS_AMOUNT 10
float Real, atr,ATR, Lim, Present, S=1;

#include <i$$_Indicators.mqh>
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ 
int OnInit(void){
   
   //if (!IND_INIT(Name)) return (INIT_FAILED);
   IndicatorBuffers(6);
   SetIndexStyle(0,DRAW_LINE);   SetIndexBuffer(0,iHI);     SetIndexLabel(0,"iHI");
   SetIndexStyle(1,DRAW_LINE);   SetIndexBuffer(1,iLO);     SetIndexLabel(1,"iLO");
   SetIndexStyle(2,DRAW_LINE);   SetIndexBuffer(2,iMaxHI);  SetIndexLabel(2,"MaxHI");
   SetIndexStyle(3,DRAW_LINE);   SetIndexBuffer(3,iMinLO);  SetIndexLabel(3,"MinLO");
   SetIndexStyle(4,DRAW_LINE);   SetIndexBuffer(4,iStpHi);  SetIndexLabel(4,"StpHi");
   SetIndexStyle(5,DRAW_LINE);   SetIndexBuffer(5,iStpLo);  SetIndexLabel(5,"StpLo");
   if (HL<1 || HL>9){//--- check for input parameter
      Print("Wrong input parameter HL=",HL);
      return(INIT_FAILED);
      }
   HL_init();
   string Name="$HLfast."+DoubleToStr(HL,0)+"."+DoubleToStr(HLk,0)+" HLper="+DoubleToStr(HLper,0)+" HLwid="+DoubleToStr(HLwid,0);
   IndicatorShortName(Name);
   return (INIT_SUCCEEDED); // "0"-Успешная инициализация.
   }
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ 
int bar;         
int start(){ 
   int CountBars=Bars-IndicatorCounted()-1; // IndicatorCounted() меньше на 1 чем prev_calculated в новом типе индикаторов  
   for (bar=CountBars; bar>0; bar--){    // Print("bar=",bar,"  ",TimeToStr(Time[bar],TIME_DATE | TIME_MINUTES));
      ATR=float(iATR(NULL,0,100,bar));
      iHILO();
      iHI[bar]=HI;  
      iLO[bar]=LO;  
      iMaxHI[bar]=MaxHI;
      iMinLO[bar]=MinLO;
      iStpHi[bar]=StpHi; //  HI+ATR*HLwid
      iStpLo[bar]=StpLo; // LO-ATR*HLwid
      }    
   return(0);
   }
