// Вот теперь может и сбудется...
#property copyright "Hohla"
#property link      "hohla@mail.ru"
#property strict // Указание компилятору на применение особого строгого режима проверки ошибок
#property indicator_separate_window
#property indicator_buffers 4
#property indicator_color1 SpringGreen
#property indicator_color2 Green
#property indicator_color3 Gray
#property indicator_color4 Gray

extern int MODE=1;// MODE=1..5
extern int HL=1;  // HL=1..9
extern int HLk=1; // iHL=1..8

#include <i$$_Indicators.mqh>
double Buffer0[],Buffer1[],Buffer2[],Buffer3[];

int OnInit(void){//ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
   string Name="OSCfast."+DoubleToStr(MODE,0)+"."+DoubleToStr(HL,0)+"."+DoubleToStr(HLk,0);
   IndicatorBuffers(4);
   SetIndexStyle(0,DRAW_LINE);   SetIndexBuffer(0,Buffer0);    SetIndexLabel(0,"Buf0");
   SetIndexStyle(1,DRAW_LINE);   SetIndexBuffer(1,Buffer1);    SetIndexLabel(1,"Buf1");
   SetIndexStyle(2,DRAW_LINE);   SetIndexBuffer(2,Buffer2);    SetIndexLabel(2,"Buf2");
   SetIndexStyle(3,DRAW_LINE);   SetIndexBuffer(3,Buffer3);    SetIndexLabel(3,"Buf3");
   switch (MODE){
         case 1:  Name=Name+"HL/sHL (HL="+DoubleToStr(HL,0)+", iHL="+DoubleToStr(HLk,0)+") ";break; // Отношение последней HL к средней HL, посчитанной за per раз
         case 2:  Name=Name+"Canal  (HL="+DoubleToStr(HL,0)+", iHL="+DoubleToStr(HLk,0)+") ";break; // Цена HLC/3 в канале 
         case 3:  Name=Name+"LastHL (HL="+DoubleToStr(HL,0)+", iHL="+DoubleToStr(HLk,0)+") ";break; // фиксируются экстремумы HL до формирования следующих
         case 4:  Name=Name+"LastHL (HL="+DoubleToStr(HL,0)+", iHL="+DoubleToStr(HLk,0)+") ";break; // фиксируются вершины экстремумов HL до формирования следующих
         case 5:  Name=Name+"Fractal (HL="+DoubleToStr(HL,0)+", iHL="+DoubleToStr(HLk,0)+") ";break; // фракталы по HiLo
         }
   IndicatorShortName(Name);
   HL_init();
   return (INIT_SUCCEEDED); // "0"-Успешная инициализация.
   }
//ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
//ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
int bar;         
float ATR;
void start(){
   int CountBars=Bars-IndicatorCounted()-1;
   if (CountBars>Bars-1) return;
   for (bar=CountBars; bar>0; bar--){ //Print("  OSC ",TimeToStr(Time[bar],TIME_DATE | TIME_MINUTES));
      ATR=iATR(NULL,0,100,bar);
      iHILO();
      iOSC(MODE);
      Buffer0[bar]=Osc0;
      Buffer1[bar]=Osc1; 
      Buffer2[bar]=Osc2;
      Buffer3[bar]=Osc3;     
   }  }  
