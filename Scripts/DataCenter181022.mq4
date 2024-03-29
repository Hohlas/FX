#define VERSION "181.022"
#property version    VERSION // yym.mdd
#property copyright  "Hohla"
#property link       "hohla.ru"
#property strict // Указание компилятору на применение особого строгого режима проверки ошибок 

         
datetime BarTime, LastBarTime, Expiration, LastDay, TestEndTime, ExpMemory, BuyTime, SellTime;
char     AtrPer=10;
int      bar=1;
double   Spred, P;
string   FileName="Data"+Symbol()+".csv", ExpertName="DataCenter"+VERSION;
         
int OnInit(){// при загрузке эксперта, смене инструмента/периода/счета/входных параметров, компиляции
   int File=FileOpen(FileName,  FILE_READ|FILE_WRITE | FILE_SHARE_READ | FILE_SHARE_WRITE, ';');
   if (File<0) {MessageBox("Can't open file "+FileName); return(INIT_FAILED);}
   FileWrite(File,"Time", "Spred","ATR","ATR/Spred");
   FileClose(File);
   P=MathPow(10,Digits);
   Alert("file ", FileName, " created");
   return(INIT_SUCCEEDED);  
   }
          
void OnTick(){ // 
   if (Ask-Bid>Spred)   Spred=Ask-Bid;
   if (Time[bar]==BarTime) return; // Сравниваем время открытия текущего(0) бара
   BarTime=Time[bar];
   double Atr=ATR();
   int File=FileOpen(FileName, FILE_READ | FILE_WRITE);
   if (File<0) {MessageBox("Can't open file "+FileName);}
   FileSeek (File,0,SEEK_END);     // перемещаемся в конец
   FileWrite(File, TimeToStr(Time[0]), DoubleToStr(Spred*P,0), DoubleToStr(Atr*P,0), DoubleToStr(Atr/Spred,1));
   FileClose(File);
   Spred=0;
   }  
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ 
double ATR(){  
   double Atr=0;   
   for (char i=0; i<AtrPer; i++)  Atr+=High[bar+i]-Low[bar+i];    // 
   return(Atr/AtrPer); 
   }
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ 
string CurrentTime (datetime ServerSeconds){// Серверное время в виде  День.Месяц/Час:Минута 
   string ServTime;
   int time;
   time=TimeDay(ServerSeconds);     if (time<10) ServTime=ServTime+"0"; ServTime=ServTime+DoubleToStr(time,0)+"."; // День.Месяц/Час:Минута
   time=TimeMonth(ServerSeconds);   if (time<10) ServTime=ServTime+"0"; ServTime=ServTime+DoubleToStr(time,0)+"/"; // 
   time=TimeHour(ServerSeconds);    if (time<10) ServTime=ServTime+"0"; ServTime=ServTime+DoubleToStr(time,0)+":"; // 
   time=TimeMinute(ServerSeconds);  if (time<10) ServTime=ServTime+"0"; ServTime=ServTime+DoubleToStr(time,0);     // 
   return (ServTime);
   }   