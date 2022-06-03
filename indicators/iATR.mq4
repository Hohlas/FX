#property copyright "Hohla"
#property link      "mail@hohla.ru"
#property version    "160.924" // yym.mdd
#property strict // ”казание компил€тору на применение особого строгого режима проверки ошибок 
#property  indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 clrDarkGray  // быстрый
#property indicator_color2 clrDimGray   // медленный


// ATR текущий, циклический, средний. Ѕыстрый считаетс€ с отбросом случайных выбросов.
extern int a=4; // кол-во бар дл€ быстрого.
extern int A=5; // кол-во бар дл€  медленного
double   I0[], I1[]; 
int bar, SlowAtrPer, FastAtrPer; 
#include <lib_ATR.mqh>  // 
int OnInit(void){//∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆
   string iName="ATR";
   IndicatorBuffers(3); IndicatorDigits(Digits);
   SetIndexStyle(0,DRAW_LINE);   SetIndexBuffer(0,I0); 
   SetIndexStyle(1,DRAW_LINE);   SetIndexBuffer(1,I1);
   if (A<1 || a<1)    {Print("!!!!!!!!! Wrong input parameters a=",a,", A=",A);  return(INIT_FAILED);}
   SlowAtrPer=A; 
   FastAtrPer=a;
   iName=iName+"("+DoubleToStr(FastAtrPer,0)+","+DoubleToStr(SlowAtrPer,0)+")";  //  
   IndicatorShortName(iName);
   SetIndexLabel(0,iName);
   Print("iATR OnInit(): Bars=",Bars," IndicatorCounted=",IndicatorCounted());
   return(ATR_INIT());  // (0)=”спешна€ инициализаци€. –езультат выполнени€ функции OnInit() анализируетс€ терминалом только если программа скомпилирована с использованием #property strict      
   }                    // Ќ≈нулевой код возврата означает неудачную инициализацию и генерирует событие Deinit с кодом причины деинициализации REASON_INITFAILED

void start(){
   int CountBars=Bars-IndicatorCounted()-1;
   Print(" S T A R T  CntFst=",CntFst," fstBUF=",NormalizeDouble(fstBUF,Digits-1)," FastAtr=",NormalizeDouble(FastAtr,Digits-1)," CountBars=",CountBars," Bars=",Bars," IndicatorCounted()=",IndicatorCounted());
   for (bar=CountBars; bar>0; bar--){
       ATR();
       if (SlowAtr==0) continue; 
       I0[bar]=FastAtr; 
       I1[bar]=SlowAtr;     
   }  }
     