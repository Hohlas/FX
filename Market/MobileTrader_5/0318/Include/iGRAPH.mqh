uint ArrowCnt=0, TextCnt=0, LineCnt=0, LabelCnt=0, LabelPos=0; // Индивидуальные счетчики для каждого типа объектов

bool TIME_OK(){ // return(true);
   //Print("iTime=",iTime(NULL,0,bar)," StringTo Time=",StringToTime("2019.10.16 12:00"));
   if (iTime(NULL,0,bar)<StringToTime("2019.10.16 12:00")) return(false);
   if (iTime(NULL,0,bar)>StringToTime("2019.10.27 08:00")) return(false); 
   return(true);
   }
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ    
void PRN(string text) {if (TIME_OK()) Print(BTIME(bar)," ",text);} 
string S5(double Data)  {return(DoubleToString(Data,int(SymbolInfoInteger(SYMBOL,SYMBOL_DIGITS))));}  
string S4(double Data)  {return(DoubleToString(Data,int(SymbolInfoInteger(SYMBOL,SYMBOL_DIGITS))-1));}
string S2(double Data)  {return(DoubleToString(Data,2));}
string S1(double Data)  {return(DoubleToString(Data,1));}
string S0(double Data)  {return(DoubleToString(Data,0));}
float  N5(double Data)  {return(float(NormalizeDouble(Data,int(SymbolInfoInteger(SYMBOL,SYMBOL_DIGITS)))));}
float  N4(double Data)  {return(float(NormalizeDouble(Data,int(SymbolInfoInteger(SYMBOL,SYMBOL_DIGITS))-1)));}
int    N0(double Data)  {return(  int(NormalizeDouble(Data,0)));} 
string BTIME(int      Shift)  {return(TimeToString(iTime(NULL,0,Shift),TIME_DATE | TIME_MINUTES));}  // if (Shift>=Bars || Shift<=0) Print("STIME() Error: Shift=",Shift); return("");
string DTIME(datetime time)   {return(TimeToString(time,TIME_DATE | TIME_MINUTES));}
int    SHIFT(datetime time)   {return(iBarShift(NULL,0,time,false));}
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ 
bool CAN_PRINT(){
   if (iTime(NULL,0,bar)<StringToTime("1970.06.30 00:00")) return(false);
   if (iTime(NULL,0,bar)>StringToTime("2999.07.02 00:00")) return(false); 
   return(true);
   }
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ 
void RECT(string txt, int bar0, double price0, int bar1, double price1, color clr, uchar width){// СИГНАЛ ШОРТ (линия сверху)
   string name=GRAPH_NAME(txt, LineCnt);
   ObjectCreate(0,name,OBJ_RECTANGLE,0, iTime(NULL,0,bar0),price0, iTime(NULL,0,bar1),price1); 
   ObjectSetString (0,name,OBJPROP_TOOLTIP,txt);         // текст всплывающей подсказки
   ObjectSetInteger(0,name,OBJPROP_COLOR,clr);           // цвет 
   ObjectSetInteger(0,name,OBJPROP_STYLE,STYLE_SOLID);   // сплошная линия. STYLE_DASH-Штриховая, STYLE_DOT-пунктир 
   ObjectSetInteger(0,name,OBJPROP_WIDTH,width);         // размер 
   ObjectSetInteger(0,name,OBJPROP_FILL,true);           // заливка
   ObjectSetInteger(0,name,OBJPROP_BACK,true);           // на переднем (false) или заднем (true) плане 
   ObjectSetInteger(0,name,OBJPROP_RAY_RIGHT,false);     // Луч не продолжается вправо 
   ObjectSetInteger(0,name,OBJPROP_SELECTABLE,true);     // возможность выделить и перемещать 
   }
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ 
void LINE(string txt, int bar0, double price0, int bar1, double price1, color clr, uchar width){// СИГНАЛ ШОРТ (линия сверху)
   string name=GRAPH_NAME(txt, LineCnt);
   ObjectCreate(0,name,OBJ_TREND,0, iTime(NULL,0,bar0),price0, iTime(NULL,0,bar1),price1); 
   ObjectSetString (0,name,OBJPROP_TOOLTIP,txt);         // текст всплывающей подсказки
   ObjectSetInteger(0,name,OBJPROP_COLOR,clr);           // цвет 
   ObjectSetInteger(0,name,OBJPROP_STYLE,STYLE_SOLID);   // сплошная линия. STYLE_DASH-Штриховая, STYLE_DOT-пунктир 
   ObjectSetInteger(0,name,OBJPROP_WIDTH,width);         // размер  
   ObjectSetInteger(0,name,OBJPROP_BACK,true);           // на переднем (false) или заднем (true) плане 
   ObjectSetInteger(0,name,OBJPROP_RAY_RIGHT,false);     // Луч не продолжается вправо 
   ObjectSetInteger(0,name,OBJPROP_SELECTABLE,true);    // возможность выделить и перемещать 
   }
void X(string txt, double price, int bar0, color clr){// ГАЛОЧКА          
   string name=GRAPH_NAME(txt, LineCnt);
   ObjectCreate(0,name,OBJ_ARROW_STOP,0,iTime(NULL,0,bar0),price-0*_Point);
   ObjectSetString (0,name,OBJPROP_TOOLTIP,txt);      // текст всплывающей подсказки
   ObjectSetInteger(0,name,OBJPROP_ANCHOR,0);         // привязка
   ObjectSetInteger(0,name,OBJPROP_COLOR,clr);        // цвет 
   ObjectSetInteger(0,name,OBJPROP_BACK,false);       // на переднем (false) или заднем (true) плане 
   ObjectSetInteger(0,name,OBJPROP_WIDTH,2);          // размер
   ObjectSetInteger(0,name,OBJPROP_SELECTABLE,true); // возможность выделить и перемещать
   }    
void A(string txt, double price, int bar0, color clr){// ГАЛОЧКА          
   string name=GRAPH_NAME(txt, LineCnt);
   ObjectCreate(0,name,OBJ_TEXT,0,iTime(NULL,0,bar0),price-0*_Point);
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
   string name=GRAPH_NAME(txt, LineCnt);
   ObjectCreate(0,name,OBJ_TEXT,0,iTime(NULL,0,bar0),price+0*_Point);
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
void CLEAR_CHART_FROM(string str){// Очистить график от своих объектов. ObjID-идентификатор линий, чтобы удалять с графика только их и не трогать остальные объекты 
	int before=ObjectsTotal(0) ;
	for (int i=ObjectsTotal(0,0,-1)-1; i>=0; i--) // мой старый метод
		if (StringFind(ObjectName(0,i,0,-1),str,0) >-1) 
		   ObjectDelete(0,ObjectName(0,i,0,-1)); // удаляются только свои объекты с символом переноса строки "\n"   
   Print("CLEAR_CHART: Objects before=",before," Objects after=",ObjectsTotal(0));
	}
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ 
void CLEAR_CHART(){// Очистить график от своих объектов. ID-идентификатор линий, чтобы удалять с графика только их и не трогать остальные объекты 
	if (!CAN_PRINT()) return; // Print("CLEAR CHART: удалено ",TextCnt," графических объектов.  Предельное количество ",4294967295);
	for (int i=ObjectsTotal(0,0,-1)-1; i>=0; i--){
		if (StringFind(ObjectName(0,i,0,-1),"\n",0) >-1) 
		   ObjectDelete(0,ObjectName(0,i,0,-1)); // удаляются только свои объекты с символом переноса строки "\n"
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
	
	
string PER2STR(){ 
   switch(Period()){
      case PERIOD_M1:  return("M1");
      case PERIOD_M2:  return("M2");
      case PERIOD_M3:  return("M3");
      case PERIOD_M4:  return("M4");
      case PERIOD_M5:  return("M5");
      case PERIOD_M6:  return("M6");
      case PERIOD_M10: return("M10");
      case PERIOD_M12: return("M12");
      case PERIOD_M15: return("M15");
      case PERIOD_M20: return("M20");
      case PERIOD_M30: return("M30");
      case PERIOD_H1:  return("H1");
      case PERIOD_H2:  return("H2");
      case PERIOD_H3:  return("H3");
      case PERIOD_H4:  return("H4");
      case PERIOD_H6:  return("H6");
      case PERIOD_H8:  return("H8");
      case PERIOD_H12: return("H12");
      case PERIOD_D1:  return("Daily");
      case PERIOD_W1:  return("Weekly");
      case PERIOD_MN1: return("Monthly");    
      default: return("unknown period"); 
   }  } 
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
      Sym=ASCII(Part);
      Result=Sym+Result; //    
      }  
   return (Result); // на выходе получаем аброкадабру вида "f@j6[w2"
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
   
   
   
   
   
  