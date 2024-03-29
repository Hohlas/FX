#property copyright "Hohla"
#property link      "www.hohla.ru"
#property version   "191.113" // yym.mdd
#property strict // Указание компилятору на применение особого строгого режима проверки ошибок 
#property description "Определение консолидаций"
#property description "с общим ценовым диапазоном. "
#property indicator_chart_window 
#property indicator_buffers 3
//#property indicator_plots   1
#property indicator_type1   DRAW_LINE
#property indicator_color1 clrBlue  // 
#property indicator_color2 clrRed   // 
//--- input params
input int Per=3;        // Количество свечей в группе 
input int MaxWidth=600;  // Максимальная ширина диапазона в пунктах   
input int MinWidth=1;   // Минимальная ширина диапазона в пунктах
input bool Shadows=true;// Учитывать тени
input color RectColor=clrLightGreen; // Цвет прямоугольника
input string AlertText="Проторговка"; // текст оповещения
input bool  Mail=true;  // Mail уведомление
input bool  Push=false;  // Push уведомление
input bool  Alrt=true;  // Alert уведомление
input bool  SignalEveryBar=true; // Сигнал на каждом баре
//---- buffers
double Buffer[],UP[],DN[],Max,Min;

//#import "stdlib.ex5"
//string ErrorDescription(int error_code);   
//#import

string ObjID;
int OnInit(){
   if (Per<1)     {Alert("Количество свечей в группе должно быть больше 0");  return(INIT_FAILED);}
   if (MinWidth<1){Alert("Минимальная ширина диапазона должна быть больше 0");   return(INIT_FAILED);}
   if (MaxWidth<=MinWidth){Alert("Максимальная ширина диапазона должна быть больше его минимальной ширины");   return(INIT_FAILED);}
   Max=MaxWidth*_Point;
   Min=MinWidth*_Point;  
   SetIndexBuffer(0,Buffer,INDICATOR_DATA);
   SetIndexBuffer(1,UP,INDICATOR_CALCULATIONS);
   SetIndexBuffer(2,DN,INDICATOR_CALCULATIONS);
   IndicatorSetInteger(INDICATOR_DIGITS,_Digits);// indicator digits
   PlotIndexSetInteger(0,PLOT_DRAW_BEGIN,Per+1);  // set draw begin, first bar from what index will be drawn
   string short_name="POC("+string(Per)+")";    // name for DataWindow and indicator subwindow label
   IndicatorSetString(INDICATOR_SHORTNAME,short_name);
   PlotIndexSetString(0,PLOT_LABEL,short_name);
   ObjID=string(Per)+string(MaxWidth)+string(MinWidth)+string(Shadows);
   ERROR_CHECK(__FUNCTION__);
   if (Shadows) Missage=AlertText+" с тенями: "; else Missage=AlertText+" без теней: ";
   Missage=Missage+_Symbol+"/"+PER();
   Print("Init "+__FILE__+": "+Missage,",  ObjectsTotal=",ObjectsTotal(0));
   return(INIT_SUCCEEDED);
   }
int bar, PocSum, Coord;
double Hi,Hi1, Lo,Lo1;
string AlertTime, Missage, AlertMissage; 
datetime BarTime;
bool FirstInit=true;
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[]) 
   {
   if (rates_total<=Per) {Alert("Недостаточно бар в истории");  return(0);} // not enough bars for calculation
   if (iTime(NULL,0,0)==BarTime) return(rates_total);
   BarTime=iTime(NULL,0,0);   
   int BarsToCount; 
   //Print("Start OnCalculate: rates_total=",rates_total,", prev_calculated=",prev_calculated,", ServTime=",string(TimeCurrent()));
   if (prev_calculated<=0 || FirstInit){
      FirstInit=false;
      AlertMissage="";   
      Print("Start Indicator: prev_calculated=",prev_calculated," rates_total=",rates_total);
      for (bar=rates_total-1; bar>rates_total-Per && !IsStopped(); bar--){
         //Buffer[bar]=0; // Print("Buffer[",bar,"]=",Buffer[bar]);
         } 
      BarsToCount=rates_total-1; 
      }         
   else  BarsToCount=rates_total-prev_calculated; // -1
   
   for (bar=BarsToCount; bar>0 && !IsStopped(); bar--){ // 
      CHECK_RANGE(bar);
      //if (bar<10) Print("Time[",bar,"]=",T(bar));
      // X(S0(PocSum), Lo, bar, clrBlue);
      if (SignalEveryBar && PocSum>=Per && Hi-Lo>Min && Hi-Lo<Max){
         if (Coord==0) Coord=bar+PocSum-1; else Coord=bar+1;
         RECT(S0(PocSum)+" bars, "+S0((Hi1-Lo1)/_Point)+" points", bar, Lo, Coord, Hi,  RectColor,0);
         AlertMissage=T(bar)+" "+string(PocSum)+" bars, "+S0((Hi1-Lo1)/_Point)+" points";
         }
      if (Hi-Lo>Min && Hi-Lo<Max) continue;
      if (PocSum>Per && Hi1-Lo1>Min && Hi1-Lo1<Max){ //  && (Hi1-Lo1)<Max
         Coord=0;
         if (!SignalEveryBar){ 
            RECT(S0(PocSum-1)+" bars, "+S0((Hi1-Lo1)/_Point)+" points", bar+1, Lo1, bar+PocSum-1, Hi1,  RectColor,0);
            AlertMissage=T(bar)+" "+string(PocSum-1)+" bars, "+S0((Hi1-Lo1)/_Point)+" points";
         }  }
      PocSum=0;
      Hi=H(bar); 
      Lo=L(bar);
      for (int i=bar+1; i<rates_total && !IsStopped(); i++){// поиск начала диапазона 
         CHECK_RANGE(i);
         if (Hi-Lo<Min){
            Hi=Hi1; Lo=Lo1; 
            break; 
      }  }  }  
   ALERT();      
   //ERROR_CHECK(__FUNCTION__); //Print("EndCalculate"); 
   return(rates_total);
   }
void CHECK_RANGE(int i){
   Hi1=Hi; Lo1=Lo;
   Hi=MathMin(H(i),Hi);
   Lo=MathMax(L(i),Lo);
   PocSum++;
   }  
double H(int shift){
   if (Shadows)   return(iHigh(NULL,0,shift)); // хай свечи
   else           return(MathMax(iOpen(NULL,0,shift),iClose(NULL,0,shift))); // максимум тела свечи  
   }
double L(int shift){
   if (Shadows)   return(iLow (NULL,0,shift)); // лоу свечи
   else           return(MathMin(iOpen(NULL,0,shift),iClose(NULL,0,shift))); // максимум тела свечи  
   }
string T(int shift){return(string(iTime(NULL,0,shift)));}   
void ALERT(){ 
   if (AlertMissage=="") return; // if (bar>1) return; //
   ResetLastError();
   if (Mail) SendMail(Missage,Missage+"\n"+AlertMissage);
   if (Alrt) Alert(Missage+" "+AlertMissage);
   if (Push) SendNotification(Missage+"\n"+AlertMissage); //
   AlertMissage="";
   //ERROR_CHECK(__FUNCTION__);
   }
void OnDeinit(const int reason){
   string txt=" Деинициализация программы: ";
   switch(reason){
      case 0: Print(txt,"Эксперт прекратил свою работу"); break;
      case 1: Print(txt,"Программа удалена с графика"); break;
      case 2: Print(txt,"Программа перекомпилирована"); break;
      case 3: Print(txt,"Символ или период графика был изменен"); break;
      case 4: Print(txt,"График закрыт"); break;
      case 5: Print(txt,"Входные параметры были изменены пользователем"); break;
      case 6: Print(txt,"Активирован другой счет либо произошло переподключение к торговому серверу вследствие изменения настроек счета"); break;
      case 7: Print(txt,"Применен другой шаблон графика"); break;
      case 8: Print(txt,"Признак того, что обработчик OnInit() вернул ненулевое значение"); break;
      case 9: Print(txt,"Терминал был закрыт"); break;     
      default: Print(txt,"UnKnown reason ",reason); 
      }
   CLEAR_CHART(ObjID); 
   }
   
   
   
bool TIME_OK(){ // return(true);
   //Print("iTime=",iTime(NULL,0,bar)," StringTo Time=",StringToTime("2019.10.16 12:00"));
   if (iTime(NULL,0,bar)<StringToTime("2019.10.16 12:00")) return(false);
   if (iTime(NULL,0,bar)>StringToTime("2019.10.27 08:00")) return(false); 
   return(true);
   }
void PRN(string text) {if (TIME_OK()) Print(T(bar)," ",text);} 
string S5(double Data)  {return(DoubleToString(Data,_Digits));}
string S4(double Data)  {return(DoubleToString(Data,_Digits-1));}
string S2(double Data)  {return(DoubleToString(Data,2));}
string S1(double Data)  {return(DoubleToString(Data,1));}
string S0(double Data)  {return(DoubleToString(Data,0));}
void RECT(string txt, int bar0, double price0, int bar1, double price1, color clr, uchar width){// СИГНАЛ ШОРТ (линия сверху)
   string name="Rect"+string(iTime(NULL,0,bar1))+ObjID+string(price1); //GRAPH_NAME(txt, LineCnt);
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
void LINE(string txt, int bar0, double price0, int bar1, double price1, color clr, uchar width){// СИГНАЛ ШОРТ (линия сверху)
   string name="Line"+string(iTime(NULL,0,bar0))+ObjID+string(price0); //GRAPH_NAME(txt, LineCnt);
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
   string name="X"+string(iTime(NULL,0,bar0))+ObjID+string(price);
   ObjectCreate(0,name,OBJ_ARROW_STOP,0,iTime(NULL,0,bar0),price-0*_Point);
   ObjectSetString (0,name,OBJPROP_TOOLTIP,txt);      // текст всплывающей подсказки
   ObjectSetInteger(0,name,OBJPROP_ANCHOR,0);         // привязка
   ObjectSetInteger(0,name,OBJPROP_COLOR,clr);        // цвет 
   ObjectSetInteger(0,name,OBJPROP_BACK,false);       // на переднем (false) или заднем (true) плане 
   ObjectSetInteger(0,name,OBJPROP_WIDTH,2);          // размер
   ObjectSetInteger(0,name,OBJPROP_SELECTABLE,true); // возможность выделить и перемещать
   }    
void A(string txt, double price, int bar0, color clr){// ГАЛОЧКА          
   string name="A"+string(iTime(NULL,0,bar0))+ObjID+string(price);
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
   string name="V"+string(iTime(NULL,0,bar0))+ObjID+string(price);
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
void CLEAR_CHART(string str){// Очистить график от своих объектов. ObjID-идентификатор линий, чтобы удалять с графика только их и не трогать остальные объекты 
	int before=ObjectsTotal(0) ;
	for (int i=ObjectsTotal(0,0,-1)-1; i>=0; i--) // мой старый метод
		if (StringFind(ObjectName(0,i,0,-1),str,0) >-1) 
		   ObjectDelete(0,ObjectName(0,i,0,-1)); // удаляются только свои объекты с символом переноса строки "\n"
	    
   Print("CLEAR_CHART: Objects before=",before," Objects after=",ObjectsTotal(0));
	}
string PER(){ 
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
void ERROR_CHECK(string ErrTxt){ // Проверка проведения операций с ордерами. Возвращает необходимость повтора торговой операции
   int err=GetLastError(); //
   ResetLastError();
   if (err==0) return; // Ошибок нет. Повтор не нужен
   string ErrDescription;
   switch(err){
      case ERR_SUCCESS:                   ErrDescription="Операция выполнена успешно"; break;
      case ERR_INTERNAL_ERROR:            ErrDescription="Неожиданная внутренняя ошибка"; break;
      case ERR_WRONG_INTERNAL_PARAMETER:  ErrDescription="Ошибочный параметр при внутреннем вызове функции клиентского терминала"; break;
      case ERR_INVALID_PARAMETER:         ErrDescription="Ошибочный параметр при вызове системной функции"; break;
      case ERR_NOT_ENOUGH_MEMORY:         ErrDescription="Недостаточно памяти для выполнения системной функции"; break;
      case ERR_STRUCT_WITHOBJECTS_ORCLASS:ErrDescription="Структура содержит объекты строк и/или динамических массивов и/или структуры с такими объектами и/или классы"; break;
      case ERR_INVALID_ARRAY:             ErrDescription="Массив неподходящего типа, неподходящего размера или испорченный объект динамического массива"; break;
      case ERR_ARRAY_RESIZE_ERROR:        ErrDescription="Недостаточно памяти для перераспределения массива либо попытка изменения размера статического массива"; break;
      case ERR_STRING_RESIZE_ERROR:       ErrDescription="Недостаточно памяти для перераспределения строки"; break;
      case ERR_NOTINITIALIZED_STRING:     ErrDescription="Неинициализированная строка"; break;
      case ERR_INVALID_DATETIME:          ErrDescription="Неправильное значение даты и/или времени"; break;
      case ERR_ARRAY_BAD_SIZE:            ErrDescription="Общее число элементов в массиве не может превышать 2147483647"; break;
      case ERR_INVALID_POINTER:           ErrDescription="Ошибочный указатель"; break;
      case ERR_INVALID_POINTER_TYPE:      ErrDescription="Ошибочный тип указателя"; break;
      case ERR_FUNCTION_NOT_ALLOWED:      ErrDescription="Системная функция не разрешена для вызова"; break;
      case ERR_RESOURCE_NAME_DUPLICATED:  ErrDescription="Совпадение имени динамического и статического ресурсов"; break;
      case ERR_RESOURCE_NOT_FOUND:        ErrDescription="Ресурс с таким именем в EX5 не найден"; break;
      case ERR_RESOURCE_UNSUPPOTED_TYPE:  ErrDescription="Неподдерживаемый тип ресурса или размер более 16 MB"; break;
      case ERR_RESOURCE_NAME_IS_TOO_LONG: ErrDescription="Имя ресурса превышает 63 символа"; break;
      case ERR_MATH_OVERFLOW:             ErrDescription="При вычислении математической функции произошло переполнение "; break;
      // Графики
      case ERR_CHART_WRONG_ID:            ErrDescription="Ошибочный идентификатор графика"; break;
      case ERR_CHART_NO_REPLY:            ErrDescription="График не отвечает"; break;
      case ERR_CHART_NOT_FOUND:           ErrDescription="График не найден"; break;
      case ERR_CHART_NO_EXPERT:           ErrDescription="У графика нет эксперта, который мог бы обработать событие"; break;
      case ERR_CHART_CANNOT_OPEN:         ErrDescription="Ошибка открытия графика"; break;
      case ERR_CHART_CANNOT_CHANGE:       ErrDescription="Ошибка при изменении для графика символа и периода"; break;
      case ERR_CHART_WRONG_PARAMETER:     ErrDescription="Ошибочное значение параметра для функции по работе с графиком"; break;
      case ERR_CHART_CANNOT_CREATE_TIMER: ErrDescription="Ошибка при создании таймера"; break;
      case ERR_CHART_WRONG_PROPERTY:      ErrDescription="Ошибочный идентификатор свойства графика"; break;
      case ERR_CHART_SCREENSHOT_FAILED:   ErrDescription="Ошибка при создании скриншота"; break;
      case ERR_CHART_NAVIGATE_FAILED:     ErrDescription="Ошибка навигации по графику"; break;
      case ERR_CHART_TEMPLATE_FAILED:     ErrDescription="Ошибка при применении шаблона"; break;
      case ERR_CHART_WINDOW_NOT_FOUND:    ErrDescription="Подокно, содержащее указанный индикатор, не найдено"; break;
      case ERR_CHART_INDICATOR_CANNOT_ADD:ErrDescription="Ошибка при добавлении индикатора на график"; break;
      case ERR_CHART_INDICATOR_CANNOT_DEL:ErrDescription="Ошибка при удалении индикатора с графика"; break;
      case ERR_CHART_INDICATOR_NOT_FOUND: ErrDescription="Индикатор не найден на указанном графике"; break;
      // Графические объекты
      case ERR_OBJECT_ERROR:              ErrDescription="Ошибка при работе с графическим объектом"; break;
      case ERR_OBJECT_NOT_FOUND:          ErrDescription="Графический объект не найден"; break;
      case ERR_OBJECT_WRONG_PROPERTY:     ErrDescription="Ошибочный идентификатор свойства графического объекта"; break;
      case ERR_OBJECT_GETDATE_FAILED:     ErrDescription="Невозможно получить дату, соответствующую значению"; break;
      case ERR_OBJECT_GETVALUE_FAILED:    ErrDescription="Невозможно получить значение, соответствующее дате"; break;
      // MarketInfo
      case ERR_MARKET_UNKNOWN_SYMBOL:     ErrDescription="Неизвестный символ"; break;
      case ERR_MARKET_NOT_SELECTED:       ErrDescription="Символ не выбран в MarketWatch"; break;
      case ERR_MARKET_WRONG_PROPERTY:     ErrDescription="Ошибочный идентификатор свойства символа"; break;
      case ERR_MARKET_LASTTIME_UNKNOWN:   ErrDescription="Время последнего тика неизвестно (тиков не было)"; break;
      case ERR_MARKET_SELECT_ERROR:       ErrDescription="Ошибка добавления или удаления символа в MarketWatch"; break;
      // Доступ к истории
      //case 4014:  ErrDescription="Системная функция не разрешена для вызова"; break;
      //case 4401:  ErrDescription="Запрашиваемая история не найдена"; break;
      //case 4515:  ErrDescription="Не удалось отправить уведомление"; break;
      //case 4516:  ErrDescription="Неверный параметр для отправки уведомления "; break;
      //case 4517:  ErrDescription="Неверные настройки уведомлений в терминале (не указан ID или не выставлено разрешение)"; break;
      //case 4518:  ErrDescription="Слишком частая отправка уведомлений"; break;
      default:    ErrDescription="Some Error"; break;
      }
   ErrTxt="Ошибка №"+string(err)+" в функции "+ErrTxt+": "+ErrDescription;
   Alert(ErrTxt);  
   }	
	    