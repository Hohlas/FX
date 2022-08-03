#define  clrSIG1     clrSilver              // цвет основной сигнальной линии индикатора
#define  clrSIG2     clrSIG1 //-0x151515     // цвет вспомогательной сигнальной линии индикатора 
#define  clrSIG3     clrSIG1 //-0x303030
#define  clrSIG4     clrSIG1 //-0x454545
//#define  cIND1     0x000090  // цвет основной сигнальной линии индикатора
//#define  cIND2     0x000070  // цвет вспомогательной сигнальной линии индикатора 
//#define  cIND3     0x000050  // цвет основной сигнальной линии индикатора
//#define  cIND4     0x000030  // цвет вспомогательной сигнальной линии индикатора
uint TextCnt=0; // счетчик текстовых объектов
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ  
string S5(double Data)  {return(DoubleToString(Data,int(MarketInfo(SYMBOL,MODE_DIGITS))));}
string S4(double Data)  {return(DoubleToString(Data,int(MarketInfo(SYMBOL,MODE_DIGITS))-1));}
string S2(double Data)  {return(DoubleToString(Data,2));}
string S1(double Data)  {return(DoubleToString(Data,1));}
string S0(double Data)  {return(DoubleToString(Data,0));}
float  N5(double Data)  {return(float(NormalizeDouble(Data,int(MarketInfo(SYMBOL,MODE_DIGITS)))));}
float  N4(double Data)  {return(float(NormalizeDouble(Data,int(MarketInfo(SYMBOL,MODE_DIGITS))-1)));}
int    N0(double Data)  {return(  int(NormalizeDouble(Data,0)));}
string BTIME(int      Shift)  {if (Shift>=Bars || Shift<=0)  return("ShiftErr"); return(TimeToString(Time[Shift],TIME_DATE | TIME_MINUTES));}  // 
string DTIME(datetime time)   {return(TimeToString(time,TIME_DATE | TIME_MINUTES));}
int    SHIFT(datetime time)   {return(iBarShift(NULL,0,time,false));}
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ 
string TIME (datetime ServerSeconds){// Серверное время в виде  День.Месяц/Час:Минута 
   string ServTime;
   int time;
   time=TimeDay(ServerSeconds);     if (time<10) ServTime=ServTime+"0"; ServTime=ServTime+DoubleToStr(time,0)+"."; // День.Месяц/Час:Минута
   time=TimeMonth(ServerSeconds);   if (time<10) ServTime=ServTime+"0"; ServTime=ServTime+DoubleToStr(time,0)+"/"; // 
   time=TimeHour(ServerSeconds);    if (time<10) ServTime=ServTime+"0"; ServTime=ServTime+DoubleToStr(time,0)+":"; // 
   time=TimeMinute(ServerSeconds);  if (time<10) ServTime=ServTime+"0"; ServTime=ServTime+DoubleToStr(time,0);     // 
   return (ServTime);
   }
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ 
bool CAN_PRINT(){
   if (IsOptimization() || Real) return(false);
   //if (Time[bar]<StringToTime("2010.02.17 05:00")) return(false);
   //if (Time[bar]>StringToTime("2010.02.17 15:00")) return(false); 
   return(true);
   }
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ 
void PRN(string text){  
   if (!Real){
      if (CAN_PRINT()) Print(TIME(TimeCurrent())," PRN: ",text);
   }else{
      string FileName=Company+"_"+AccountCurrency()+"_"+DoubleToStr(Magic,0)+".csv";
      int File=FileOpen(FileName, FILE_READ|FILE_WRITE);  
      if (File<0) {REPORT("PRN(): Can't open file "+FileName+" for Print!"); return;}
      FileSeek    (File,0,SEEK_END); 
      FileWrite   (File, TIME(TimeCurrent())+";"+text);      
      FileClose(File);  
   }  }
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ 
void CLEAR_CHART(){// Очистить график от своих объектов. ID-идентификатор линий, чтобы удалять с графика только их и не трогать остальные объекты 
	if (!CAN_PRINT()) return; 
	Print("CLEAR CHART: удалено ",TextCnt," графических объектов.  Предельное количество ",4294967295);
	for (int i=ObjectsTotal()-1; i>=0; i--){
		if (StringFind(ObjectName(i),"\n",0) >-1) ObjectDelete(ObjectName(i)); // удаляются только свои объекты с символом переноса строки "\n"
	}  }  
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ  	
string GRAPH_NAME(string txt, uint& Cnt){
   Cnt++; if (Cnt>4294967294) Print("GRAPH_NAME(): CNT>4294967295");
   string id="\n"+CODE(Cnt); //CODE(Cnt) идентификатор графического объекта с кодированием порядкового номера "CODE(Cnt)" для сокращения записи
   short MaxLen=63-(short)StringLen(id); // имя не должно превышать 63 символа
   if (StringLen(txt)>MaxLen) txt=StringSubstr(txt,0,MaxLen); // обрезаем по необходимости
   return (txt+id);  //
	}
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ 
void A(string txt, double price, int bar0, color clr){// ГАЛОЧКА          
   if (!CAN_PRINT()) return;
   string name=GRAPH_NAME(txt, TextCnt);
   ObjectCreate(0,name,OBJ_TEXT,0,Time[bar0],price-0*Point);
   ObjectSetString (0,name,OBJPROP_TEXT,txt+" > ");// текст
   ObjectSetString (0,name,OBJPROP_TOOLTIP,txt);   // текст всплывающей подсказки
   ObjectSetString (0,name,OBJPROP_FONT,"Arial"); // шрифт 
   ObjectSetInteger(0,name,OBJPROP_FONTSIZE,7);   // размер шрифта 
   ObjectSetDouble (0,name,OBJPROP_ANGLE,90);      // угол наклона текста 
   ObjectSetInteger(0,name,OBJPROP_ANCHOR,ANCHOR_RIGHT);    //  привязка справа
   ObjectSetInteger(0,name,OBJPROP_COLOR,clr);     // цвет 
   ObjectSetInteger(0,name,OBJPROP_BACK,false);    // на переднем (false) или заднем (true) плане 
   ObjectSetInteger(0,name,OBJPROP_SELECTABLE,true); // возможность выделить и перемещать
   } 
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ 
void V(string txt, double price, int bar0, color clr){// ГАЛОЧКА          
   if (!CAN_PRINT()) return;
   string name=GRAPH_NAME(txt, TextCnt);
   ObjectCreate(0,name,OBJ_TEXT,0,Time[bar0],price+0*Point);
   ObjectSetString (0,name,OBJPROP_TEXT," < "+txt);// текст
   ObjectSetString (0,name,OBJPROP_TOOLTIP,txt);   // текст всплывающей подсказки 
   ObjectSetString (0,name,OBJPROP_FONT,"Arial");  // шрифт 
   ObjectSetInteger(0,name,OBJPROP_FONTSIZE,7);    // размер шрифта 
   ObjectSetDouble (0,name,OBJPROP_ANGLE,90);      // угол наклона текста 
   ObjectSetInteger(0,name,OBJPROP_ANCHOR,ANCHOR_LEFT);    //  привязка справа
   ObjectSetInteger(0,name,OBJPROP_COLOR,clr);     // цвет   
   ObjectSetInteger(0,name,OBJPROP_BACK,false);    // на переднем (false) или заднем (true) плане 
   ObjectSetInteger(0,name,OBJPROP_SELECTABLE,true); // возможность выделить и перемещать
   }           
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ 
void X(string txt, double price, int bar0, color clr){// КРЕСТИК        
   if (!CAN_PRINT()) return;
   static uint ArrowCnt; // счетчик крестиков
   string name=GRAPH_NAME(txt, ArrowCnt);
   ObjectCreate    (0,name,OBJ_ARROW_STOP,0,Time[bar0],price+20*Point);  // 15*Point - поправка, т.к. крестик рисуется низковато 
   ObjectSetString (0,name,OBJPROP_TOOLTIP,txt);      // текст всплывающей подсказки
   ObjectSetInteger(0,name,OBJPROP_ANCHOR,0);         // привязка
   ObjectSetInteger(0,name,OBJPROP_COLOR,clr);        // цвет 
   ObjectSetInteger(0,name,OBJPROP_BACK,false);       // на переднем (false) или заднем (true) плане 
   ObjectSetInteger(0,name,OBJPROP_WIDTH,2);          // размер
   ObjectSetInteger(0,name,OBJPROP_SELECTABLE,true); // возможность выделить и перемещать
   } 
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ 
void LINE(string txt, int bar0, double price0, int bar1, double price1, color clr, uchar Width){// СИГНАЛ ШОРТ (линия сверху)
   if (!CAN_PRINT()) return;
   static uint LineCnt; // счетчик линий
   string name=GRAPH_NAME(txt, LineCnt);
   ObjectCreate(0,name,OBJ_TREND,0, Time[bar0],price0, Time[bar1],price1); // потом от прошлого значения к новому
   ObjectSetString (0,name,OBJPROP_TOOLTIP,txt);         // текст всплывающей подсказки
   ObjectSetInteger(0,name,OBJPROP_COLOR,clr);           // цвет 
   ObjectSetInteger(0,name,OBJPROP_STYLE,STYLE_SOLID);   // сплошная линия. STYLE_DASH-Штриховая, STYLE_DOT-пунктир 
   ObjectSetInteger(0,name,OBJPROP_WIDTH,Width);         // размер  
   ObjectSetInteger(0,name,OBJPROP_BACK,true);           // на переднем (false) или заднем (true) плане 
   ObjectSetInteger(0,name,OBJPROP_RAY_RIGHT,false);     // Луч не продолжается вправо 
   ObjectSetInteger(0,name,OBJPROP_SELECTABLE,true);     // возможность выделить и перемещать 
   }
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ   
int xUP, xDN, xTime;
void X_LINES(int up, int dn, int clr){// отмена крестиками сиглалов UP и DN: (сигналы, смещение от H/L, цвет)
   if (!CAN_PRINT()) return;
   if (xTime!=Time[bar]){// новый бар
      xTime=int(Time[bar]);
      xUP=100; // расстояние ближней линии 
      xDN=100; // к текущей цене (в пунктах).
      }
   if (up<=0) {xUP+=40; X("UP",Low [bar]-xUP*Point,bar,clr);}
   if (dn<=0) {xDN+=40; X("DN",High[bar]+xDN*Point,bar,clr);} 
   }
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ   
int LineUP, LineDN; 
datetime LineTime;
void SIG_LINES(double up, string txtUP, double dn, string txtDN, color clr){// линии сиглалов UP и DN: (сигналы, цвет)
   if (!CAN_PRINT()) return; 
   if (LineTime!=Time[bar]){// новый бар
      LineTime=Time[bar];
      LineUP=100; // расстояние ближней линии к текущей цене
      LineDN=100; // к текущей цене (в пунктах).
      }
   if (up>0) {LineUP+=100; LINE(txtUP, bar,Low [bar]-LineUP*Point, bar+1,Low [bar+1]-LineUP*Point, clr,0);} // Каждую следующую линию отодвигаем от предыдущей на 4 пункта,
   if (dn>0) {LineDN+=100; LINE(txtDN, bar,High[bar]+LineDN*Point, bar+1,High[bar+1]+LineDN*Point, clr,0);} // чтобы они рисовались одрна над другой. 
   }         
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ   
void LABEL(int X_shift, string txt){// МЕТКА на графике
   if (IsOptimization()) return;
   static uint LabelPos, LabelCnt; // счетчик меток
   string  name=GRAPH_NAME(txt, LabelCnt);  // Print("LABEL: name=",name);
   ObjectCreate(0,name,OBJ_LABEL,0,0,0);
   // расположение графического объекта
   ObjectSetInteger(0,name,OBJPROP_CORNER,CORNER_LEFT_UPPER);// расположение относительно левого верхнего угла графика. CORNER_LEFT_LOWER-лев.нижн, CORNER_RIGHT_LOWER-прав.нижн, CORNER_RIGHT_UPPER-прав.верхн
   ObjectSetInteger(0,name,OBJPROP_XDISTANCE,X_shift);            // координаты на
   ObjectSetInteger(0,name,OBJPROP_YDISTANCE,5+LabelPos);   // графике
   // свойства текста
   ObjectSetString (0,name,OBJPROP_TEXT,txt);     // текст  
   ObjectSetString (0,name,OBJPROP_FONT,"Arial");  // шрифт 
   ObjectSetInteger(0,name,OBJPROP_FONTSIZE,7);    // размер шрифта 
   ObjectSetDouble (0,name,OBJPROP_ANGLE,0.0);     // угол наклона текста 
   // свойства графического объекта
   ObjectSetInteger(0,name,OBJPROP_ANCHOR,ANCHOR_BOTTOM);// способ привязки
   ObjectSetInteger(0,name,OBJPROP_COLOR,clrBlack);      // цвет 
   ObjectSetInteger(0,name,OBJPROP_STYLE,STYLE_SOLID);   // сплошная линия. STYLE_DASH-Штриховая, STYLE_DOT-пунктир 
   ObjectSetInteger(0,name,OBJPROP_WIDTH,0);             // размер  
   ObjectSetInteger(0,name,OBJPROP_BACK,false);          // на переднем (false) или заднем (true) плане 
   ObjectSetInteger(0,name,OBJPROP_SELECTABLE,false);    // возможность выделить и перемещать
   LabelPos+=9; 
   }  
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ   
void CHART_SETTINGS(){// НАСТРОЙКИ ВНЕНШЕГО ВИДА ГРАФИКА
   //if (!Real) return;
   // Элементы
   ChartSetInteger(0,CHART_MODE,CHART_BARS);       // способ отображения ценового графика (CHART_BARS, CHART_CANDLES, CHART_LINE)
   ChartSetInteger(0,CHART_SHOW_GRID, false);      // Отображение сетки на графике
   ChartSetInteger(0,CHART_SHOW_PERIOD_SEP, false); // Отображение вертикальных разделителей между соседними периодами
   ChartSetInteger(0,CHART_SHOW_OHLC, false);      // Режим отображения значений OHLC в левом верхнем углу графика
   ChartSetInteger(0,CHART_FOREGROUND, true);      // Ценовой график на переднем плане
   ChartSetInteger(0,CHART_SHOW_OBJECT_DESCR,true);// Всплывающие описания графических объектов
   ChartSetInteger(0,CHART_SHOW_VOLUMES,false);    // Отображение объемов не нужно
   ChartSetInteger(0,CHART_SHOW_BID_LINE,true);
   ChartSetInteger(0,CHART_SHOW_ASK_LINE,true);
   //  BLACK on WHITE
   color BARS_COLOR=clrDarkGray;  //   clrBlack
   ChartSetInteger(0,CHART_COLOR_BACKGROUND,clrWhite);   // Цвет фона графика
   ChartSetInteger(0,CHART_COLOR_FOREGROUND,clrDimGray); // Цвет осей, шкалы и строки OHLC
   ChartSetInteger(0,CHART_COLOR_GRID,clrDimGray);       // Цвет сетки
   ChartSetInteger(0,CHART_COLOR_CHART_UP,BARS_COLOR);      // Бар вверх
   ChartSetInteger(0,CHART_COLOR_CHART_DOWN,BARS_COLOR);    // Бар вниз
   ChartSetInteger(0,CHART_COLOR_CHART_LINE,BARS_COLOR);    // Линия
   ChartSetInteger(0,CHART_COLOR_BID,clrDimGray);
   ChartSetInteger(0,CHART_COLOR_ASK,clrDimGray);
   // GREEN on BLACK 
   //ChartSetInteger(0,CHART_COLOR_BACKGROUND,clrBlack);   // Цвет фона графика
   //ChartSetInteger(0,CHART_COLOR_FOREGROUND,clrDimGray); // Цвет осей, шкалы и строки OHLC
   //ChartSetInteger(0,CHART_COLOR_GRID,clrDimGray);       // Цвет сетки
   //ChartSetInteger(0,CHART_COLOR_CHART_UP,clrLime);      // Бар вверх
   //ChartSetInteger(0,CHART_COLOR_CHART_DOWN,clrLime);    // Бар вниз
   //ChartSetInteger(0,CHART_COLOR_CHART_LINE,clrLime);    // Линия
   //ChartSetInteger(0,CHART_COLOR_BID,clrDimGray);
   //ChartSetInteger(0,CHART_COLOR_ASK,clrDimGray);
   // WHITE on GRAY
   //color BARS_COLOR=clrWhite;
   //ChartSetInteger(0,CHART_COLOR_BACKGROUND,clrSilver);   // Цвет фона графика
   //ChartSetInteger(0,CHART_COLOR_FOREGROUND,clrBlack);      // Цвет осей, шкалы и строки OHLC
   //ChartSetInteger(0,CHART_COLOR_GRID,clrSilver);           // Цвет сетки
   //ChartSetInteger(0,CHART_COLOR_CHART_UP,BARS_COLOR);      // Бар вверх
   //ChartSetInteger(0,CHART_COLOR_CHART_DOWN,BARS_COLOR);    // Бар вниз
   //ChartSetInteger(0,CHART_COLOR_CHART_LINE,BARS_COLOR);    // Линия
   //ChartSetInteger(0,CHART_COLOR_BID,clrSilver);
   //ChartSetInteger(0,CHART_COLOR_ASK,clrSilver);
   }
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ      
#define BITS  71 // разрядность "новой" системы исчисления
string CODE(ulong Data){  // КОДИРОВАНИЕ ОЧ ДЛИННОГО ЧИСЛА В ГРАФИЧЕСКИЕ СИМВОЛЫ вида "f@j6[w2" для сокращения записи
   string Result="", Sym;
   ulong Integer;
   char Part=0;
   while (Part>0 || Data>0){
      Integer=Data/BITS;      // целая часть от деления на разрядность
      Part=char(Data-Integer*BITS);// остаток от деления
      Data=Integer;
      if (Data==0 && Part==0) break;
      Sym=StringSetChar(" ", 0, ushort(Part+48)); // декодирование цифр 0..92 в символы, эквивалентные ASCII кодам с 48 до 122 
      Sym=ASCII(Part);
      Result=Sym+Result; //    
      }  
   return (Result); // на выходе получаем аброкадабру вида "f@j6[w2"
   }
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ      
ulong DECODE(string SymCode){ // ВОССТАНОВЛЕНИЕ ЧИСЛА ИЗ ГРАФИЧЕСКИХ СИМВОЛОВ
   int Lengh=StringLen(SymCode); 
   char Char=0;
   ulong cnt=1, Result=0;
   for (int i=Lengh-1; i>=0; i--){  
      Char=DE_ASCII(StringSubstr(SymCode,i,1));
      Result+=Char*cnt; // Print(cnt," Sym=",StringSubstr(SymCode,i, 1)," Char=",Char," Result=", Result);
      cnt*=(BITS);
      }  
   return(Result);
   }
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ      
char DE_ASCII(string Sym){
   for (char Code=0; Code<BITS; Code++) if (ASCII(Code)==Sym) return (Code); 
   return (-1);
   }
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ      
string ASCII(char Code){// ФОРМИРОВАНИЕ СОБСТВЕННОЙ ТАБЛИЦЫ БЕЗ ЗАПРЕЩЕННЫХ СИМВОЛОВ \/?...
   switch (Code){ 
      case  0: return("0");     
      case  1: return("1");     
      case  2: return("2");     
      case  3: return("3");     
      case  4: return("4");     
      case  5: return("5");     
      case  6: return("6");     
      case  7: return("7");     
      case  8: return("8");     
      case  9: return("9");     
      
      case  10: return("a");     
      case  11: return("b");     
      case  12: return("c");     
      case  13: return("d");     
      case  14: return("e");     
      case  15: return("f");     
      case  16: return("g");     
      case  17: return("h");     
      case  18: return("i");     
      case  19: return("j");     
      
      case  20: return("k");     
      case  21: return("l");     
      case  22: return("m");     
      case  23: return("n");     
      case  24: return("o");     
      case  25: return("p");     
      case  26: return("q");     
      case  27: return("r");     
      case  28: return("s");     
      case  29: return("t");     
      
      case  30: return("u");     
      case  31: return("v");     
      case  32: return("w");     
      case  33: return("x");     
      case  34: return("y");     
      case  35: return("z");     
      case  36: return("A");     
      case  37: return("B");     
      case  38: return("C");     
      case  39: return("D");     
      
      case  40: return("E");     
      case  41: return("F");     
      case  42: return("G");     
      case  43: return("H");     
      case  44: return("I");     
      case  45: return("J");     
      case  46: return("K");     
      case  47: return("L");     
      case  48: return("M");     
      case  49: return("N");     
      
      case  50: return("O");     
      case  51: return("P");     
      case  52: return("Q");     
      case  53: return("R");     
      case  54: return("S");     
      case  55: return("T");     
      case  56: return("U");     
      case  57: return("V");     
      case  58: return("W");     
      case  59: return("X");     
      
      case  60: return("Y");     
      case  61: return("Z");     
      case  62: return("_");     
      case  63: return("-");     
      case  64: return("+");     
      case  65: return("@");     
      case  66: return("#");     
      case  67: return("$");     
      case  68: return("~");   // терминал не любит символ "%"  
      case  69: return("^");     
      case  70: return("&");     
      case  71: return("№");     
      default : return ("?"); 
   }  }  
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ      
  