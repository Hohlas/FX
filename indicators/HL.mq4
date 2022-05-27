#property copyright   "Hohla"
#property link        "http://www.Hohla.ru"
#property description "HL"
#property strict

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 clrRed
#property indicator_color2 clrRed
//#property indicator_label1  "Line" 
//#property indicator_type1   DRAW_LINE 
//#property indicator_color1 DodgerBlue
//#property indicator_style1  STYLE_SOLID 
//#property indicator_width1  1 
//--- input parameter
input int HL=1;  // 1..9 Type
extern int iHL=8;// 1..8 Period
double HI[], LO[], max, min; 
int Per=1, SessionBars, BarsInDay, f=1;
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ 
int OnInit(void){
   string Name="$HL."+DoubleToStr(HL,0)+"."+DoubleToStr(iHL,0);
   IndicatorBuffers(2);
   SetIndexStyle(0,DRAW_LINE);   SetIndexBuffer(0,HI);   SetIndexLabel(0,"HI");
   SetIndexStyle(1,DRAW_LINE);   SetIndexBuffer(1,LO);   SetIndexLabel(1,"LO");
   if (HL<1 || HL>9){//--- check for input parameter
      Print("Wrong input parameter HL=",HL);
      return(INIT_FAILED);
      }
   double Adpt=60/Period(); // адаптация периода индикатора к таймфрейму
   switch (HL){
         case 1:  Per=int(MathPow(iHL,1.7)*Adpt);  Name=Name+"Nearest F ("          +DoubleToStr(Per,0)+")"; break; //  При пробитии одного из уровней ищутся ближайшие фракталы шириной Per бар. 
         case 2:  Per=int((iHL+1)*Adpt);           Name=Name+"Distant F(1) ATR*"    +DoubleToStr(Per,0)+")"; break; // При пробитии одного из уровней ищутся фракталы шириной f=1 далее ATR*Per от текущей цены
         case 3:  Per=int((iHL+1)*Adpt);           Name=Name+"Tr Distant F(1) ATR*" +DoubleToStr(Per,0)+")"; break; // Формирование хая на ближайшем фрактале(1) при удалении на ATR*Per от последнего лоу
         case 4:  Per=int((iHL+1)*Adpt);           Name=Name+"Trailing ATR*"        +DoubleToStr(Per,0)+")"; break; // При пробое Н ищется L далее Per*ATR от текущей цены 
         case 5:  Per=int(MathPow(iHL,1.7)*Adpt);  Name=Name+"Classic F("           +DoubleToStr(Per,0)+")"; break; // Фракталы шириной Per бар. 
         case 6:  Per=int((iHL+1)*Adpt);           Name=Name+"Strong F(1)ATR*"      +DoubleToStr(Per,0)+")"; break; // При пробое одного из уровней ищутся фракталы шириной f=1 с отскоком (силой) более ATR*Per
         case 7:  Per=int(MathPow(iHL+1,1.7)*Adpt);Name=Name+"Classic ("            +DoubleToStr(Per,0)+")"; break; // экстремумы на заданном периоде
         case 8:  Per=int((iHL-1)*3*Adpt);         Name=Name+"DayBegin ("           +DoubleToStr(Per,0)+")"; break; // Hi/Lo за 24+N часов
         case 9:  Per=int(iHL*Adpt);               Name=Name+"VolumeCluster ("      +DoubleToStr(Per,0)+")"; break; //  
         default: Per=int((iHL+1)*Adpt);           Name=Name+"no ("                 +DoubleToStr(Per,0)+")"; break;
         }
   BarsInDay=int(24*60/Period());         // кол-во бар в сессии
   SessionBars=int(Per*Adpt)+BarsInDay;   // кол-во бар с начала текущей сессии для (2)
   if (Bars<Per) {Print("Not enough Bars");  return(INIT_FAILED);}   
   IndicatorShortName(Name);   
   return(INIT_SUCCEEDED);
   }
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ 
double SigHL,  H, L;
int TrendHL=0, DayBar=0;
int OnCalculate(const int rates_total,    // количество баров, доступных индикатору для расчета (баров на графике)
                const int prev_calculated,// значение, которое вернула функция OnCalculate() на предыдущем вызове
                const datetime &time[],   //
                const double &open[],     // Если с момента последнего вызова функции OnCalculate() ценовые данные были изменены (подкачана более глубокая история или были заполнены пропуски истории), 
                const double &high[],     // то значение входного параметра prev_calculated будет установлено в нулевое значение самим терминалом. 
                const double &low[],      // 
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
   {  //Print("Bars = ",Bars(Symbol(),0),", rates_total = ",rates_total,", prev_calculated = ",prev_calculated," time[0] = ",time[0]," time[rates_total-1] = ",time[rates_total-1]); 
   int limit, b=0;
   double D=0, h=0, l=0, c=0, o=0;
   //if (rates_total<=Per) return(0);//--- check for bars count and input parameter
   if (prev_calculated<=0){//--- initial zero
      max=high[rates_total-1]; min=low[rates_total-1]; //Print("max=",max, " min=",min);
      for (int bar=rates_total-1; bar>rates_total-Per; bar--){
         if (high[bar]>max)   max=high[bar]+(high[bar]-low[bar]); // 
         if (low [bar]<min)   min=low [bar]-(high[bar]-low[bar]); // 
         HI[bar]=max; H=max;
         LO[bar]=min; L=min;
         }
      limit=rates_total-Per;
   }else{
      limit=rates_total-prev_calculated; // prev_calculated больше на 1 чем IndicatorCounted() в старом типе индикаторов
      }//   Print(" limit=",limit," rates_total=",rates_total," prev_calculated=",prev_calculated);      
   for (int bar=limit; bar>0; bar--){//     --- the main loop of calculations
      if (high[bar]>max)   max=high[bar]+(high[bar]-low[bar]);
      if (low [bar]<min)   min=low [bar]-(high[bar]-low[bar]);
      //Print("bar=",bar,"  ",TimeToStr(Time[bar],TIME_DATE | TIME_MINUTES)," limit=",limit," rates_total=",rates_total," prev_calculated=",prev_calculated);
      switch (HL){
         case 1: // Nearest F(Per). При пробое одного из уровней ищутся ближайшие фракталы шириной Per бар. 
            if (high[bar]>H || low[bar]<L){   // пробитие одной из границ канала
               H=0; L=0; b=bar;
               f=Per;
               while (!H || !L){ // обе границы находим заново
                  b++; if (b>Bars-Per*2) break; // счетчик бар                
                  if (!H && high[b+f]>high[bar] && high[b+f]==high[iHighest(NULL,0,MODE_HIGH,f*2+1,b)]) H=high[b+f]; // пока не найдется новый фрактал выше текущего бара заданной ширины
                  if (!L && low [b+f]<low [bar] && low [b+f]==low [iLowest (NULL,0,MODE_LOW ,f*2+1,b)]) L=low [b+f];
               }  }
         break; 
         case 2: // Distant F(1). При пробое одного из уровней ищутся фракталы шириной f=1 далее ATR*Per от текущей цены 
            if (high[bar]>H || low[bar]<L){   // пробитие одной из границ канала
               H=0; L=0; b=bar; 
               D=iATR(NULL,0,100,bar)*Per;
               while (!H || !L){ // обе границы находим заново
                  b++; if (b>Bars-f*2) break; // счетчик бар
                  if (!H && high[b+f]>high[bar] && high[b+f]==high[iHighest(NULL,0,MODE_HIGH,f*2+1,b)] && high[b+f]-low[bar]>D) H=high[b+f]; // пока не найдется новый фрактал выше текущего бара, 
                  if (!L && low [b+f]<low [bar] && low [b+f]==low [iLowest (NULL,0,MODE_LOW ,f*2+1,b)] && high[bar]-low[b+f]>D) L=low [b+f]; // давший движение более ATR*Per
               }  }
         break;       
         case 3: // Trend Distant F(1). Формирование хая на ближайшем фрактале(1) при удалении на ATR*Per от последнего лоу
            D=iATR(NULL,0,100,bar)*Per;
            if (TrendHL<=0){ // при нисходящем тренде
               if (low[bar]<L) FIND_LO(bar,f); // при пробитии L ищем ниже ближайший фрактал шириной f=1
               if (high[bar]>L+D){// отдаление от нижней границы
                  TrendHL=1; 
                  FIND_HI(bar,f); // ближайший фрактал сверху шириной f=1
               }  }        
            if (TrendHL>=0){ // Тренд вверх
               if (high[bar]>H) FIND_HI(bar,f); // при пробитии H ищем выше ближайший фрактал шириной f=1
               if (low[bar]<H-D){
                  TrendHL=-1;
                  FIND_LO(bar,f);
               }  }  
         break;             
         case 4: // Trailing - При пробое Н ищется L далее Per*ATR от текущей цены 
            if (low[bar]<L){  // пробой нижней границы 
               H=0; L=0; b=bar; 
               D=Per*iATR(NULL,0,100,bar);
               while (!H || !L){ // обе границы находим заново
                  b++; if (b>Bars-f*2) break; // счетчик бар
                  if (!H && high[b+f]>high[bar] && high[b+f]==high[iHighest(NULL,0,MODE_HIGH,f*2+1,b)] && high[b+f]-low[bar]>D)   H=high[b+f]; // любой фрактал выше текущей цены на Per*ATR 
                  if (!L && low [b+f]<low [bar] && low [b+f]==low [iLowest (NULL,0,MODE_LOW ,f*2+1,b)])                           L=low [b+f]; // любой ближайший фрактал снизу
               }  }
            if (high[bar]>H ){   // 
               H=0; L=0; b=bar; 
               D=iATR(NULL,0,100,bar)*Per;
               while (!H || !L){ // обе границы находим заново
                  b++; if (b>Bars-f*2) break; // счетчик бар
                  if (!H && high[b+f]>high[bar] && high[b+f]==high[iHighest(NULL,0,MODE_HIGH,f*2+1,b)])                           H=high[b+f]; // любой ближайший фрактал сверху 
                  if (!L && low [b+f]<low [bar] && low [b+f]==low [iLowest (NULL,0,MODE_LOW ,f*2+1,b)] && high[bar]-low[b+f]>D)   L=low [b+f]; // любой фрактал ниже текущей цены на Per*ATR 
               }  }
         break;
         case 5: // Classic F(Per). Фракталы шириной Per бар. 
            if (bar>Bars-Per-1) break;
            if (high[bar]>H)  FIND_HI(bar,Per); // при пробое верхней границы ищем ближайший фрактал шириной Per
            else              if (high[bar+Per]==high[iHighest(NULL,0,MODE_HIGH,Per*2+1,bar)])  H=high[bar+Per]; // сформировался фрактал шириной Per
            if (low[bar]<L)   FIND_LO(bar,Per); 
            else              if (low[bar+Per] ==low [iLowest (NULL,0,MODE_LOW ,Per*2+1,bar)])  L= low[bar+Per];
         break;
         case 6:  // Strong F(1) При пробое одного из уровней ищутся фракталы шириной f=1 с отскоком (силой) более ATR*Per
            if (high[bar]>H || low[bar]<L){   // пробитие одной из границ канала
               H=0; L=0; b=bar; 
               D=iATR(NULL,0,100,bar)*Per;
               double BackH=low[bar], BackL=high[bar];   // уровни заднего фронта для H и L (величина отскока от пика)
               while (!H || !L){ // обе границы находим заново
                  b++; if (b>Bars-f*2) break; // счетчик бар
                  if (low [b]<BackH)   BackH=low[b]; // фиксируем максимальну и минимальную цены от текущего бара до искомых пиков, это будут
                  if (high[b]>BackL)   BackL=high[b];// их Back уровни - движения, которые дал пик.
                  if (!H && high[b+f]>high[bar] && high[b+f]==high[iHighest(NULL,0,MODE_HIGH,f*2+1,b)] && high[b+f]-BackH>D) H=high[b+f]; // пока не найдется новый фрактал выше текущего бара, 
                  if (!L && low [b+f]<low [bar] && low [b+f]==low [iLowest (NULL,0,MODE_LOW ,f*2+1,b)] && BackL-low [b+f]>D) L=low [b+f]; // давший движение более ATR*Per
               }  }
         break;       
         case 7: // HL_Classic 
            if (bar>Bars-Per-1) break;
            b=bar+1; H=high[bar]; L=low[bar];
            //while(!BarCounter(b,bar,Per)){
            for (b=bar+1; b<=bar+Per; b++){
               if (high[b]>H) H=high[b];
               if (low[b]<L)  L=low[b];} 
                
         break;
         case 8: // DayBegin Hi/Lo за 24+N часов
            if (bar>Bars-2) break;
            DayBar++;// номер бара с начала дня
            if (TimeHour(Time[bar])<TimeHour(Time[bar+1])) DayBar=0; // новый день = обнуляем номер бара с начала дня
            if (DayBar==Per){// номер бара с начала дня совпал с заданным значением
               H=high[iHighest(NULL,0,MODE_HIGH,SessionBars,bar)]; // максимум с начала прошлой сессии до текущего бара
               L=low [iLowest (NULL,0,MODE_LOW ,SessionBars,bar)];
               } 
            if (H<high[bar]) H=high[bar];
            if (L>low[bar])  L=low[bar];      
         break;
         case 9: // VolumeCluster
            if (bar>Bars-Per-f-1) break; 
            D=(13-Per)*0.03; // при Per=1..9, D=36%-12%, (25% у автора) 
            c=close[bar+1];
            h=high[bar+1];
            l=low [bar+1];
            for (b=bar+1; b<=bar+f+1; b++){
               if (high[b]>h) h=high[b];
               if (low [b]<l) l=low [b];
               o=open[b];
               if (h-l>iATR(NULL,0,100,bar)*1.5){//  Не работаем в узком диапазоне
                  if ((h-o)/(h-l)<D && (h-c)/(h-l)<D) {L=l; H=h;  SigHL=L;} // Нижний "Фрактал" (открытие и закрытие в верхней части Bar баров)
                  if ((o-l)/(h-l)<D && (c-l)/(h-l)<D) {L=l; H=h;  SigHL=H;} // верхний "фрактал"
               }  }  
            if (H<high[bar]) H=high[bar];
            if (L>low[bar])  L=low[bar];      
         break;
         default://
            H=high[bar]; L=low[bar];
         break;   
         }
      
      if (H>0) HI[bar]=H; 
      else HI[bar]=max;// попался исторический максимум, присваиваем максимальное значение графика 
      if (L>0) LO[bar]=L; //Print("HL: H=",H," L=",L);
      else LO[bar]=min;     
     
      }
   return(rates_total); // количество баров при текущем вызове функции
   }
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
void FIND_HI(int bar, int width){
   H=0; int b=bar;
   while (!H){
      b++; if (b>Bars-width*2) break; // счетчик бар
      if (High[b+width]>High[bar] && High[b+width]==High[iHighest(NULL,0,MODE_HIGH,width*2+1,b)]) H=High[b+width];
   }  }   
void FIND_LO(int bar, int width){   
   L=0; int b=bar;
   while (!L){
      b++; if (b>Bars-width*2) break; // счетчик бар
      if (Low [b+width]<Low [bar] && Low [b+width]==Low [iLowest (NULL,0,MODE_LOW ,width*2+1,b)]) L=Low [b+width];
   }  } 
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ  
