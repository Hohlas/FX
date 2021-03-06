// Вот теперь может и сбудется...
#property copyright "Hohla"
#property link      "hohla@mail.ru"
#property strict // Указание компилятору на применение особого строгого режима проверки ошибок
#property description "Встроена функция R/W для ускорения оптимизации. При первом вызове создается файл со значениями индикатора, при последующих вызовах из него считываются посчитанные значения. Не дает никакого преимущества в скорости"

#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 clrBlack // iHI
#property indicator_color2 clrBlack // iLO
#property indicator_color3 clrGainsboro // MaxHI
#property indicator_color4 clrGainsboro // MinLO

extern int HL=1; // 1..9 Type
extern int HLk=8;// 1..8 Period
double iHI[], iLO[], iMaxHI[], iMinLO[], HI, LO, MaxHI, MinLO; 
int N=1, SessionBars, BarsInDay;
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ 
int OnInit(void){
   string Name="$HL."+DoubleToStr(HL,0)+"."+DoubleToStr(HLk,0);
   //if (!IND_INIT(Name)) return (INIT_FAILED);
   IndicatorBuffers(2);
   SetIndexStyle(0,DRAW_LINE);   SetIndexBuffer(0,iHI);     SetIndexLabel(0,"iHI");
   SetIndexStyle(1,DRAW_LINE);   SetIndexBuffer(1,iLO);     SetIndexLabel(1,"iLO");
   SetIndexStyle(2,DRAW_LINE);   SetIndexBuffer(2,iMaxHI);  SetIndexLabel(2,"MaxHI");
   SetIndexStyle(3,DRAW_LINE);   SetIndexBuffer(3,iMinLO);  SetIndexLabel(3,"MinLO");
   if (HL<1 || HL>9){//--- check for input parameter
      Print("Wrong input parameter HL=",HL);
      return(INIT_FAILED);
      }
   double Adpt=60/Period(); // адаптация периода индикатора к таймфрейму
   switch (HL){
         case 1:  N=int(MathPow(HLk,1.7)*Adpt);  Name=Name+" Nearest F ("          +DoubleToStr(N,0)+")"; break; //  При пробитии одного из уровней ищутся ближайшие фракталы шириной N бар. 
         case 2:  N=int((HLk+1)*Adpt);           Name=Name+" Distant F(1) ATR*"    +DoubleToStr(N,0)+")"; break; // При пробитии одного из уровней ищутся фракталы шириной f=1 далее ATR*N от текущей цены
         case 3:  N=int((HLk+1)*Adpt);           Name=Name+" Tr Distant F(1) ATR*" +DoubleToStr(N,0)+")"; break; // Формирование хая на ближайшем фрактале(1) при удалении на ATR*N от последнего лоу
         case 4:  N=int((HLk+1)*Adpt);           Name=Name+" Trailing ATR*"        +DoubleToStr(N,0)+")"; break; // При пробое Н ищется LO далее N*ATR от текущей цены 
         case 5:  N=int(MathPow(HLk,1.7)*Adpt);  Name=Name+" Classic F("           +DoubleToStr(N,0)+")"; break; // Фракталы шириной N бар. 
         case 6:  N=int((HLk+1)*Adpt);           Name=Name+" Strong F(1)ATR*"      +DoubleToStr(N,0)+")"; break; // При пробое одного из уровней ищутся фракталы шириной f=1 с отскоком (силой) более ATR*N
         case 7:  N=int(MathPow(HLk+1,1.7)*Adpt);Name=Name+" Classic ("            +DoubleToStr(N,0)+")"; break; // экстремумы на заданном периоде
         case 8:  N=int((HLk-1)*3*Adpt);         Name=Name+" DayBegin ("           +DoubleToStr(N,0)+")"; break; // Hi/Lo за 24+N часов
         case 9:  N=int(HLk*Adpt);               Name=Name+" VolumeCluster ("      +DoubleToStr(N,0)+")"; break; //  
         default: N=int((HLk+1)*Adpt);           Name=Name+" no ("                 +DoubleToStr(N,0)+")"; break;
         }
   BarsInDay=int(24*60/Period());         // кол-во бар в сессии
   SessionBars=int(N*Adpt)+BarsInDay;   // кол-во бар с начала текущей сессии для (2)
   Print("init $HL: ",TimeToStr(Time[1],TIME_DATE | TIME_MINUTES)," HLper=",N," Bars=",Bars," Time[bars]=",TimeToStr(Time[Bars-1],TIME_DATE | TIME_MINUTES));  
   MaxHI=High[Bars-1]; MinLO=Low[Bars-1]; 
   IndicatorShortName(Name);
   return (INIT_SUCCEEDED); // "0"-Успешная инициализация.
   }
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ 
int Trend=0, DayBar=0;
int start(){ 
   int CountBars, f=1;
   double ATR, h=0, l=0, c=0, o=0;
   double D=(13-N)*0.03; // при N=1..9, D=36%-12%, (25% у автора) 
   if (IndicatorCounted()<=0){//--- initial zero
      MaxHI=High[Bars-1]; MinLO=Low[Bars-1]; //Print("MaxHI=",MaxHI, " MinLO=",MinLO);
      for (int bar=Bars-1; bar>Bars-N; bar--){
         if (High[bar]>MaxHI)   MaxHI=High[bar]; // 
         if (Low [bar]<MinLO)   MinLO=Low [bar]; // 
         iHI[bar]=MaxHI; HI=MaxHI;
         iLO[bar]=MinLO; LO=MinLO;
         }
      CountBars=Bars-N-1;
   }else{
      CountBars=Bars-IndicatorCounted()-1; // IndicatorCounted() меньше на 1 чем prev_calculated в новом типе индикаторов
      }//  
   for (int bar=CountBars; bar>0; bar--){    // Print("bar=",bar,"  ",TimeToStr(Time[bar],TIME_DATE | TIME_MINUTES));
      //if (READ_DATA(bar, iHI[bar], iLO[bar])) continue; // если данные закончились, переходим в режим записи. Либо, индикатор уже посчитан, и пересчитывать его не стоит.
      if (High[bar]>=MaxHI)   {MaxHI=High[bar]; HI=MaxHI;}// обновление абсолютного  пика
      if (Low [bar]<=MinLO)   {MinLO=Low [bar]; LO=MinLO;}  
      switch (HL){
         case 1: // Nearest F(N). При пробое одного из уровней ищутся ближайшие фракталы шириной N бар. 
            if (High[bar]>=HI || Low[bar]<=LO){   // пробитие одной из границ канала
               for (int b=bar; b<Bars-N; b++)   if (FIND_HI(b,bar,N,true)) break; // поиск ближайшего фрактала шириной N
               for (int b=bar; b<Bars-N; b++)   if (FIND_LO(b,bar,N,true)) break; // поиск ближайшего фрактала шириной N
               }
         break; 
         case 2: // Distant F(1). При пробое одного из уровней ищутся фракталы шириной f=1 далее ATR*N от текущей цены 
            ATR=iATR(NULL,0,100,bar)*N;
            if (High[bar]>=HI || Low[bar]<=LO){   // пробитие одной из границ канала
               for (int b=bar; b<Bars-f; b++)   if (FIND_HI(b,bar,f, High[b]-Low[bar]>ATR)) break; // поиск ближайшего фрактала шириной f=1 при условии, что он будет удален на ATR*N
               for (int b=bar; b<Bars-f; b++)   if (FIND_LO(b,bar,f, High[bar]-Low[b]>ATR)) break; //
               }      
         break;       
         case 3: // Trend Distant F(1). Формирование хая на ближайшем фрактале(1) при удалении на ATR*N от последнего лоу
            ATR=iATR(NULL,0,100,bar)*N;
            if (Trend<=0){ // при нисходящем тренде
               if (Low[bar]<=LO)  // при пробитии LO
                  for (int b=bar; b<Bars-f; b++)   if (FIND_LO(b,bar,f,true)) break; // ищем ниже ближайший фрактал шириной f=1
               if (High[bar]>LO+ATR){// отдаление от нижней границы
                  Trend=1; 
                  for (int b=bar; b<Bars-f; b++)   if (FIND_HI(b,bar,f,true)) break; // ближайший фрактал сверху шириной f=1
               }  }        
            if (Trend>=0){ // Тренд вверх
               if (High[bar]>=HI) // при пробитии HI
                  for (int b=bar; b<Bars-f; b++)   if (FIND_HI(b,bar,f,true)) break; // ищем выше ближайший фрактал шириной f=1
               if (Low[bar]<HI-ATR){ // при отдалении от верхней границы
                  Trend=-1;
                  for (int b=bar; b<Bars-f; b++)   if (FIND_LO(b,bar,f,true)) break; // ближайший снизу фрактал шириной f=1
               }  }    
         break;             
         case 4: // Trailing - При пробое Н ищется LO далее N*ATR от текущей цены 
            ATR=iATR(NULL,0,100,bar)*N;
            if (Low[bar]<=LO){  // пробой нижней границы 
               for (int b=bar; b<Bars-f; b++)   if (FIND_HI(b,bar,f, High[b]-Low[bar]>ATR)) break; // ближайший фрактал сверху шириной f=1 удаленный на ATR*N
               for (int b=bar; b<Bars-f; b++)   if (FIND_LO(b,bar,f,true)) break;// ближайший фрактал снизу  шириной f=1
               } 
            if (High[bar]>=HI ){   // пробой верхней границы
               for (int b=bar; b<Bars-f; b++)   if (FIND_HI(b,bar,f,true)) break;// любой ближайший фрактал сверху
               for (int b=bar; b<Bars-f; b++)   if (FIND_LO(b,bar,f, High[bar]-Low[b]>ATR)) break;// любой фрактал ниже текущей цены на N*ATR 
               } 
         break;
         case 5: // Classic F(N). Фракталы шириной N бар. 
            if (bar+N>=Bars) break;
            if (High[bar]>=HI){   for (int b=bar; b<Bars-N; b++)   if (FIND_HI(b,bar,N,true)) break;} // при пробое верхней границы ищем ближайший фрактал шириной N
            else{                 if (High[bar+N]==High[iHighest(NULL,0,MODE_HIGH,N*2+1,bar)])  HI=High[bar+N];} // сформировался фрактал шириной N
            if (Low[bar]<=LO){    for (int b=bar; b<Bars-N; b++)   if (FIND_LO(b,bar,N,true)) break;} 
            else{                 if (Low[bar+N] ==Low [iLowest (NULL,0,MODE_LOW ,N*2+1,bar)])  LO= Low[bar+N];}
         break;
         case 6:  // Strong F(1) При пробое одного из уровней ищутся фракталы шириной f=1 с отскоком (силой) более ATR*N
            ATR=iATR(NULL,0,100,bar)*N;
            if (High[bar]>=HI || Low[bar]<=LO){   // пробитие одной из границ канала
               double max=High[bar], min=Low[bar];
               for (int b=bar; b<Bars-f; b++){
                  if (Low [b]<min) min=Low [b]; // минимум от искомого пика до текущего бара - величина отскока
                  if (FIND_HI(b,bar,f, High[b]-min>ATR)) break; // ближайший фрактал шириной f=1 с величиной отскока более ATR*N
                  }
               for (int b=bar; b<Bars-f; b++){
                  if (High[b]>max) max=High[b];
                  if (FIND_LO(b,bar,f, max-Low[b]>ATR)) break;// любой фрактал ниже текущей цены на N*ATR 
               }   }
         break;       
         case 7: // HL_Classic 
            if (bar+N+1>Bars) break;
            HI=High[bar]; LO=Low[bar];
            for (int b=bar+1; b<=bar+N; b++){
               if (High[b]>HI) HI=High[b];
               if (Low[b]<LO)  LO=Low[b];} 
         break;
         case 8: // DayBegin Hi/Lo за 24+N часов
            if (bar+2>Bars) break;
            DayBar++;// номер бара с начала дня
            if (TimeHour(Time[bar])<TimeHour(Time[bar+1])) DayBar=0; // новый день = обнуляем номер бара с начала дня
            if (DayBar==N){// номер бара с начала дня совпал с заданным значением
               HI=High[iHighest(NULL,0,MODE_HIGH,SessionBars,bar)]; // максимум с начала прошлой сессии до текущего бара
               LO=Low [iLowest (NULL,0,MODE_LOW ,SessionBars,bar)];
               } 
            if (HI<High[bar]) HI=High[bar];
            if (LO>Low[bar])  LO=Low[bar];      
         break;
         case 9: // VolumeCluster  D=(13-N)*0.03; // при N=1..9, D=36%-12%, (25% у автора)
            if (bar+N+f+1>Bars) break;  
            c=Close[bar+1];
            h=High[bar+1];
            l=Low [bar+1];
            for (int b=bar+1; b<=bar+f+1; b++){
               if (High[b]>h) h=High[b];
               if (Low [b]<l) l=Low [b];
               o=Open[b];
               if (h-l>iATR(NULL,0,100,bar)*1.5){//  Не работаем в узком диапазоне
                  if ((h-o)/(h-l)<D && (h-c)/(h-l)<D) {LO=l; HI=h;} // Нижний "Фрактал" (открытие и закрытие в верхней части Bar баров)
                  if ((o-l)/(h-l)<D && (c-l)/(h-l)<D) {LO=l; HI=h;} // верхний "фрактал"
               }  }  
            if (HI<High[bar]) HI=High[bar];
            if (LO>Low[bar])  LO=Low[bar];      
         break;
         default://
            HI=High[bar]; LO=Low[bar];
         break;   
         }  
      iHI[bar]=HI; iMaxHI[bar]=MaxHI; //   HI+ATR
      iLO[bar]=LO; iMinLO[bar]=MinLO;  //  LO-ATR 
      //WRITE_DATA(bar, iHI[bar], iLO[bar]);
      }    
   return(0);
   }
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
double LocalMax, LocalMin;
bool FIND_HI(int b, int bar, int width, bool Condition){ // Поиск фрактала шириной width. Condition - доп. внешнее условие
   if (High[b]==MaxHI){ // добрались до абсолютного максимума Print(" HI=MaxHI ",TimeToStr(Time[bar],TIME_DATE | TIME_MINUTES),"      bar=",bar,"  ", " HI=",HI," High[bar]=",High[bar]," MaxHI=",MaxHI);
      HI=High[b];  return(true);}     // это будет искомый пик, дальше искать нет смысла 
   if (b==bar) {LocalMax=High[b];   return(false);} // первый бар поиска, фиксируем максимальное значение на периоде поиска
   if (High[b]>LocalMax) LocalMax=High[b]; // цена должна быть максимальной на всем участке поиска
   if (High[b]==LocalMax && High[b]==High[iHighest(NULL,0,MODE_HIGH,width+1,b)]){// максимальный пик и фрактал периодом width
      HI=High[b]; return(true && Condition);}   // пик найден Print(TimeToStr(Time[bar],TIME_DATE | TIME_MINUTES),"      bar=",bar,"  ", " HI=",HI," High[bar]=",High[bar]);
   return (false); // пока не найдется новый фрактал выше текущего бара заданной ширины   
   } 
bool FIND_LO(int b, int bar, int width, bool Condition){
   if (Low [b]==MinLO){
      LO=Low[b]; return(true);}
   if (b==bar) {LocalMin=Low[b];    return(false);}
   if (Low[b]<LocalMin) LocalMin=Low[b];
   if (Low[b]==LocalMin && Low[b]==Low[iLowest (NULL,0,MODE_LOW ,width+1,b)]){
      LO=Low[b]; return(true && Condition);} // пока не найдется новый фрактал выше текущего бара заданной ширины
   return (false);    
   }            
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ  
#define WRITE 0
#define READ 1
int Mode, File;
bool IND_INIT(string Name){
   string FileName="x"+Name+"_"+Symbol()+DoubleToStr(Period(),0)+".csv";
   if (FileIsExist(FileName,0)){// файл уже готов, переходим в
      Mode=READ;  Print("Open ", FileName," in READ mode");  // режим чтения    
   }else{//  файла не было
      Mode=WRITE; Print("Open ", FileName," in WRITE mode"); // переходим в режим записи файла 
      }
   File=FileOpen(FileName, FILE_READ | FILE_WRITE | FILE_SHARE_READ | FILE_SHARE_WRITE, ';'); // проверка наличия файла - попытка открыть в режиме чтения   
   if (File<0) Print("Can't open ", FileName);
   if (Mode==READ){
      if (!SEARCH_DATA(Bars-1)){ // строка не найдена, на этапе инициализации проще перезаписать  все заново
         FileClose(File); FileDelete(FileName); // удаляем некчемный файл
         File=FileOpen(FileName, FILE_READ | FILE_WRITE | FILE_SHARE_READ | FILE_SHARE_WRITE, ';'); // и заводим новый
         Print("Delete and ReOpen ", FileName," in Write Mode");
         Mode=WRITE; // переход в режим записи
      }  }
   return(true);   
   } 
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ   
// функция R/W для ускорения оптимизации. 
// При первом вызове создается файл со значениями индикатора, при последующих вызовах из него считываются посчитанные значения. 
// Не дает никакого преимущества в скорости"


bool SEARCH_DATA(int bar){
   string BarTime=TimeToStr(Time[bar],TIME_DATE | TIME_MINUTES); // будем искать строку с временем текущего бара, от которого продолжится считывание данных
   FileSeek (File,0,SEEK_SET);
   while (FileReadString(File)!=BarTime){ // ищем строку с датой начала тестирования
      if (FileIsEnding(File)){// добрались до конца файла, строка так и не нашлась
         Print("Can't find string with time ",BarTime);
         return(false);
      }  }
   FileSeek (File,-17,SEEK_CUR);   // нашли нужную строку, отмотаем назад, чтобы потом читать с самого начала этой строки     
   Print("Find string ",BarTime);
   return (true);
   } 
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ    
bool READ_DATA(int bar, double& I0, double& I1){
   if (Mode!=READ) return(false); // флаг необходимости пересчета индюка
   string ReadTime, // время бара записанных в файле данных для сравнения с 
   BarTime=TimeToStr(Time[bar],TIME_DATE | TIME_MINUTES); // временем текущего бара
   for (;;){
      ReadTime=FileReadString(File);
      I0=StrToDouble(FileReadString(File)); 
      I1=StrToDouble(FileReadString(File));
      //Print("READ: ",ReadTime," I0=",I0," I1=",I1);  // line++; if (line<5) 
      if (ReadTime==BarTime)   return(true); // из файла cчитаны данные для текущего бара, выходим с флагом успешного выполнения
      if (!SEARCH_DATA(bar)) break; // считанные данные не совпали и в файле не найдено нужной строки, переходим в режим записи
      }
   Mode=WRITE; // переходим в режим записи.
   FileSeek(File,0,SEEK_END); // перемещаемся в конец файла для продолжения записи
   //Print("ReadTime!=BarTime, switch to WRITE MODE. ReadTime=",ReadTime," BarTime=",TimeToStr(Time[bar],TIME_DATE | TIME_MINUTES)); 
   return(false);
   }
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ   
void WRITE_DATA(int bar, double I0, double I1){
   if (Mode!=WRITE) return;
   FileWrite(File, TimeToStr(Time[bar],TIME_DATE | TIME_MINUTES), I0, I1); 
   //Print("WRITE: bar",bar," ",TimeToStr(Time[bar],TIME_DATE | TIME_MINUTES)," I0=", I0," I1=", I1);
   }       
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
void OnDeinit(const int reason){
   FileClose(File);
    switch (reason){ // вместо reason можно использовать UninitializeReason()
      //case 0: str="Эксперт самостоятельно завершил свою работу"; break;
      case 1: Print("Indicator DEINIT: Program "+" removed from chart"); break;
      case 2: Print("Indicator DEINIT: Program "+" recompile"); break;
      case 3: Print("Indicator DEINIT: Symbol or Period was CHANGED!"); break;
      case 4: Print("Indicator DEINIT: Chart closed!"); break;
      case 5: Print("Indicator DEINIT: Input Parameters Changed!"); break;
      case 6: Print("Indicator DEINIT: Another Account Activate!"); break; 
      case 9: Print("Indicator DEINIT: Terminal closed!"); break;   
   }  }
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ      
   
