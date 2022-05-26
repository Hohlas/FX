// Вот теперь может и сбудется...
#property copyright "Hohla"
#property link      "hohla@mail.ru"
#property strict // Указание компилятору на применение особого строгого режима проверки ошибок
#property indicator_chart_window
#property indicator_buffers 8
#property indicator_color1 White    // H1
#property indicator_color2 Yellow    // H2
#property indicator_color3 Orange    // H3
#property indicator_color4 Red // H4
#property indicator_color5 White // L1
#property indicator_color6 Yellow // L2
#property indicator_color7 Orange // L3
#property indicator_color8 Red // L4

extern int N=5; 
double   H1[],H2[],H3[],H4[],L1[],L2[],L3[],L4[];
double H=0, L=0, C=0, HLC=0;
int BarsInDay, DayBar=0, BarsToCount; 
//ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
//ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ             
int OnInit(void){
   string Name="Layers."+DoubleToStr(N,0);
   if (!IND_INIT(Name)) return (INIT_FAILED);
   IndicatorBuffers(8);
   SetIndexStyle(0,DRAW_LINE);   SetIndexBuffer(0,H1);   SetIndexLabel(0,"H1");
   SetIndexStyle(1,DRAW_LINE);   SetIndexBuffer(1,H2);   SetIndexLabel(1,"H2");
   SetIndexStyle(2,DRAW_LINE);   SetIndexBuffer(2,H3);   SetIndexLabel(2,"H3");
   SetIndexStyle(3,DRAW_LINE);   SetIndexBuffer(3,H4);   SetIndexLabel(3,"H4");
   SetIndexStyle(4,DRAW_LINE);   SetIndexBuffer(4,L1);   SetIndexLabel(4,"L1");
   SetIndexStyle(5,DRAW_LINE);   SetIndexBuffer(5,L2);   SetIndexLabel(5,"L2");
   SetIndexStyle(6,DRAW_LINE);   SetIndexBuffer(6,L3);   SetIndexLabel(6,"L3");
   SetIndexStyle(7,DRAW_LINE);   SetIndexBuffer(7,L4);   SetIndexLabel(7,"L4");
   IndicatorShortName(Name);
   BarsInDay=int(24*60/Period());         // кол-во бар в сессии
   if (N<24) BarsToCount= N*60/Period();
   else      BarsToCount=23*60/Period();
   //Print("BarsToCount=",BarsToCount);
   return (INIT_SUCCEEDED); // "0"-Успешная инициализация.
   }
//ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
//ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ 
void start(){
   int CountBars=Bars-IndicatorCounted()-1;
   for (int bar=CountBars; bar>0; bar--){
      if (READ_DATA(bar, H1[bar], H2[bar], H3[bar], H4[bar], L1[bar], L2[bar], L3[bar], L4[bar])) continue; // если данные закончились, переходим в режим записи. Либо, индикатор уже посчитан, и пересчитывать его не стоит.
      if (bar>Bars-2) continue;
      if (N<3){
         if (TimeHour(Time[bar])<TimeHour(Time[bar+1])){  // ищем конец прошлого дня
            H=High[iHighest(NULL,0,MODE_HIGH,BarsInDay,bar)];   // щитаем экстремумы
            L=Low [iLowest (NULL,0,MODE_LOW ,BarsInDay,bar)];    // прошлого дня
            C=Close[bar+1];                             // и его цену закрытия
            HLC=(H+L+C)/3;
            }
         if (N==0){// Camarilla Equation ORIGINAL
            H4[bar]=C+(H-L)*1.1/2;    
            H3[bar]=C+(H-L)*1.1/4;    
            H2[bar]=C+(H-L)*1.1/6;  
            H1[bar]=C+(H-L)*1.1/12;
            L4[bar]=C-(H-L)*1.1/2;    
            L3[bar]=C-(H-L)*1.1/4;    
            L2[bar]=C-(H-L)*1.1/6;  
            L1[bar]=C-(H-L)*1.1/12;  
            }
         if (N==1){ // Camarilla Equation My Edition
            H4[bar]=C+(H-L)*4/4;    
            H3[bar]=C+(H-L)*3/4;    
            H2[bar]=C+(H-L)*2/4;  
            H1[bar]=C+(H-L)*1/4;
            L4[bar]=C-(H-L)*4/4;    
            L3[bar]=C-(H-L)*3/4;    
            L2[bar]=C-(H-L)*2/4;  
            L1[bar]=C-(H-L)*1/4;  
            }
         if (N==2){// Метод Гнинспена (Валютный спекулянт-48, с.62)
            H1[bar]=HLC; L1[bar]=HLC;  
            H2[bar]=2*HLC-L;    
            L2[bar]=2*HLC-H;    
            H3[bar]=HLC+(H-L);  
            L3[bar]=HLC-(H-L);
            H4[bar]=H3[bar]; L4[bar]=L3[bar];  
            }
      }else{ // if (N>=3) Метод Гнинспена (Валютный спекулянт-48, с.62), экстремум ищется не на прошлом дне, а на барах с 0 часов до N бара текущего дня
         if (bar>Bars-BarsToCount-1) continue;
         DayBar++;// номер бара с начала дня
         if (TimeHour(Time[bar])<TimeHour(Time[bar+1])) DayBar=0; // новый день = обнуляем номер бара с начала дня
         if (DayBar==BarsToCount){// номер бара с начала дня совпал с заданным значением
            H=High[iHighest(NULL,0,MODE_HIGH,BarsToCount,bar)];
            L=Low [iLowest (NULL,0,MODE_LOW,BarsToCount,bar)];
            C=Close[bar];
            HLC=(H+L+C)/3;
            }   
         H1[bar]=HLC; L1[bar]=HLC;  
         H2[bar]=2*HLC-L;    
         L2[bar]=2*HLC-H;    
         H3[bar]=HLC+(H-L);  
         L3[bar]=HLC-(H-L);
         H4[bar]=H3[bar]; 
         L4[bar]=L3[bar];  
         }
      WRITE_DATA(bar, H1[bar], H2[bar], H3[bar], H4[bar], L1[bar], L2[bar], L3[bar], L4[bar]);
   }  }
   
    
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ  
#define WRITE 0
#define READ 1
int Mode, File;
bool IND_INIT(string Name){
   string FileName="x"+Name+"_"+Symbol()+DoubleToStr(Period(),0)+".csv";
   File=FileOpen(FileName, FILE_READ, ';'); // проверка наличия файла - попытка открыть в режиме чтения
   if (File<0){// файла не было
      Mode=WRITE; // переходим в режим записи файла
      File=FileOpen(FileName, FILE_READ|FILE_WRITE, ';'); //  
   }else{// файл уже готов, переходим в 
      Mode=READ;  // режим чтения 
      }
   if (File<0)  {Print("Can't open ", FileName); return(false);}
   Print("Open ", FileName," in Mode=",Mode," Bars=",Bars," TimeBars=",TimeToStr(Time[Bars-1],TIME_DATE | TIME_MINUTES));
   if (Mode==READ){
      while (FileReadString(File)!=TimeToStr(Time[Bars-1],TIME_DATE | TIME_MINUTES)){ // ищем строку с датой начала тестирования
         if (FileIsEnding(File)){// добрались до конца файла, строка так и не нашлась
            Print("Can't find target line in file ", FileName,". Delete and ReWrite file");
            FileClose(File); FileDelete(FileName); // удаляем некчемный файл
            File=FileOpen(FileName, FILE_READ|FILE_WRITE, ';'); // и заводим новый, так проще
            Mode=WRITE; // переход в режим записи
            return(true);
         }  }
      FileSeek (File,-17,SEEK_CUR);   // отмотаем немного назад, чтобы потом снова начать читать с этой строки   
      }
   return(true);   
   }  
bool READ_DATA(int bar, double& I0, double& I1, double& I2, double& I3, double& I4, double& I5, double& I6, double& I7){
   if (Mode!=READ) return(false); // флаг необходимости пересчета индюка
   string ReadTime=FileReadString(File);
   I0=StrToDouble(FileReadString(File)); 
   I1=StrToDouble(FileReadString(File));
   I2=StrToDouble(FileReadString(File));
   I3=StrToDouble(FileReadString(File));
   I4=StrToDouble(FileReadString(File));
   I5=StrToDouble(FileReadString(File));
   I6=StrToDouble(FileReadString(File));
   I7=StrToDouble(FileReadString(File));
   if (ReadTime!=TimeToStr(Time[bar],TIME_DATE | TIME_MINUTES)){// несоответвствие времени, считанного из массива со временем текущего бара
      Mode=WRITE; // переходим в режим записи.
      Print("ReadTime!=BarTime, go to WRITE MODE. ReadTime=",ReadTime," BarTime=",TimeToStr(Time[bar],TIME_DATE | TIME_MINUTES)); 
      return(false);}
   //Print("ReadTime=",ReadTime," I0=",I0," I1=",I1);  // line++; if (line<5) 
   return(true); // индикатор уже посчитан, считан из файла, и пересчитывать его не стоит.   
   }
void WRITE_DATA(int bar, double I0, double I1, double I2, double I3, double I4, double I5, double I6, double I7){
   if (Mode!=WRITE) return;
   FileWrite(File, TimeToStr(Time[bar],TIME_DATE | TIME_MINUTES), I0, I1, I2, I3, I4, I5, I6, I7); 
   //Print("WRITE bar",bar," ",TimeToStr(Time[bar],TIME_DATE | TIME_MINUTES)," I0=", I0," I1=", I1);
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
   
 
   

