#property copyright "Hohla"
#property link      "mail@hohla.ru"
#property version   "181.212" // yym.mdd
#property description "ATR_Dual"
#property strict // Указание компилятору на применение особого строгого режима проверки ошибок 
#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 clrBlack
#property indicator_color2 clrRoyalBlue


extern int a=4;
extern int A=200; 
double atr[],ATR[];


int OnInit(void){//ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
   string Name="ATR."+DoubleToStr(a,0)+"."+DoubleToStr(A,0); 
   if (!IND_INIT(Name)) return (INIT_FAILED);
   IndicatorBuffers(2); // т.к. temp[] тоже считается
   IndicatorDigits(Digits);
   SetIndexStyle(0,DRAW_LINE);   SetIndexBuffer(0,atr);  SetIndexLabel(0,"atr"); //SetIndexDrawBegin(0,a);
   SetIndexStyle(1,DRAW_LINE);   SetIndexBuffer(1,ATR);  SetIndexLabel(1,"ATR"); //SetIndexDrawBegin(1,A);
   IndicatorShortName(Name);
   if (a<1 || A<1 ){ //  Bars<=
      Print("ATR: Wrong input parameter, a=",a," A=",A," Bars=",Bars," Time[Bars]=",TimeToStr(Time[Bars-1],TIME_DATE | TIME_MINUTES));
      return(INIT_FAILED);
      }
   return (INIT_SUCCEEDED); // "0"-Успешная инициализация.
   }
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
void start(){
   int CountBars=Bars-IndicatorCounted()-1;  //Print("Start ATR(",a,",",A,") Bars=",Bars," IndicatorCounted=",IndicatorCounted()," CountBars=",CountBars);
   for (int bar=CountBars; bar>0; bar--){    
      if (READ_DATA(bar, atr[bar], ATR[bar])) continue; // если данные закончились, переходим в режим записи. Либо, индикатор уже посчитан, и пересчитывать его не стоит.
      atr[bar]=iATR(NULL,0,a,bar); // Быстрый
      ATR[bar]=iATR(NULL,0,A,bar); // Мэдлэнный
      WRITE_DATA(bar, atr[bar], ATR[bar]);
   }  } 
     
   
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ   
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
bool READ_DATA(int bar, double& I0, double& I1){
   if (Mode!=READ) return(false); // флаг необходимости пересчета индюка
   string ReadTime=FileReadString(File);
   I0=StrToDouble(FileReadString(File)); 
   I1=StrToDouble(FileReadString(File));
   if (ReadTime!=TimeToStr(Time[bar],TIME_DATE | TIME_MINUTES)){// несоответвствие времени, считанного из массива со временем текущего бара
      Mode=WRITE; // переходим в режим записи.
      Print("ReadTime!=BarTime, go to WRITE MODE. ReadTime=",ReadTime," BarTime=",TimeToStr(Time[bar],TIME_DATE | TIME_MINUTES)); 
      return(false);}
   //Print("ReadTime=",ReadTime," I0=",I0," I1=",I1);  // line++; if (line<5) 
   return(true); // индикатор уже посчитан, считан из файла, и пересчитывать его не стоит.   
   }
void WRITE_DATA(int bar, double I0, double I1){
   if (Mode!=WRITE) return;
   FileWrite(File, TimeToStr(Time[bar],TIME_DATE | TIME_MINUTES), I0, I1); 
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