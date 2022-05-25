#define  cSIG1     0x009000  // цвет основной сигнальной линии индикатора
#define  cSIG2     0x004000  // цвет вспомогательной сигнальной линии индикатора 
#define  cIND1     0x000090  // цвет основной сигнальной линии индикатора
#define  cIND2     0x000070  // цвет вспомогательной сигнальной линии индикатора 
#define  cIND3     0x000050  // цвет основной сигнальной линии индикатора
#define  cIND4     0x000030  // цвет вспомогательной сигнальной линии индикатора 
void ARROW(string name, double price, int clr){// —“–≈Ћ ј          
   if (!Real) return;
   int Arrow=0, Anchor=0;
   if (name=="UP")   {Arrow=OBJ_ARROW_UP;       Anchor=ANCHOR_TOP;}     // —трелка верх,  ѕрив€зка сверху    
   if (name=="DN")   {Arrow=OBJ_ARROW_DOWN;     Anchor=ANCHOR_BOTTOM;}  // —трелка вниз,  ѕрив€зка снизу     
   name="Arrow"+name+" "+TimeToString(Time[bar],TIME_DATE | TIME_MINUTES);     // им€ знака    
   ObjectCreate    (0,name,Arrow,0,Time[bar],price);   
   ObjectSetInteger(0,name,OBJPROP_ANCHOR,Anchor);    // прив€зка  
   ObjectSetInteger(0,name,OBJPROP_COLOR,clr);        // цвет 
   ObjectSetInteger(0,name,OBJPROP_STYLE,STYLE_SOLID);   // сплошна€ лини€. STYLE_DASH-Ўтрихова€, STYLE_DOT-пунктир 
   ObjectSetInteger(0,name,OBJPROP_WIDTH,0);             // размер  
   ObjectSetInteger(0,name,OBJPROP_BACK,false);          // на переднем (false) или заднем (true) плане 
   ObjectSetInteger(0,name,OBJPROP_SELECTABLE,true);     // возможность выделить и перемещать
   }
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆   
int xUP, xDN, xTime;
void X_LINES(int up, int dn, int clr){// отмена крестиками сиглалов UP и DN: (сигналы, смещение от H/L, цвет)
   if (!Real) return;
   if (xTime!=Time[bar]){// новый бар
      xTime=int(Time[bar]);
      xUP=100; // рассто€ние ближней линии 
      xDN=100; // к текущей цене (в пунктах).
      }
   if (up<=0) {xUP+=40; X("UP",Low [bar]-xUP*Point,clr);}
   if (dn<=0) {xDN+=40; X("DN",High[bar]+xDN*Point,clr);} 
   }    
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆ 
void X(string txt, double price, int clr){// «јѕ–≈“ Ўќ–“ј (крестик сверху)          
   if (!Real) return;
   string name=txt+" "+DoubleToString(price,Digits)+" "+TimeToString(Time[bar-1],TIME_DATE | TIME_MINUTES);     // им€ знака    
   ObjectCreate    (0,name,OBJ_ARROW_STOP,0,Time[bar-1],price);   
   ObjectSetInteger(0,name,OBJPROP_ANCHOR,0);         // прив€зка
   ObjectSetInteger(0,name,OBJPROP_COLOR,clr);        // цвет 
   ObjectSetInteger(0,name,OBJPROP_BACK,false);       // на переднем (false) или заднем (true) плане 
   ObjectSetInteger(0,name,OBJPROP_WIDTH,0);          // размер
   ObjectSetInteger(0,name,OBJPROP_SELECTABLE,true);  // возможность выделить и перемещать
   }
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆   
int LineUP, LineDN; 
datetime LineTime;
void SIG_LINES(double up, string txtUP, double dn, string txtDN, int clr){// линии сиглалов UP и DN: (сигналы, цвет)
   if (!Real) return;
   if (LineTime!=Time[bar]){// новый бар
      LineTime=Time[bar];
      LineUP=100; // рассто€ние ближней линии к текущей цене
      LineDN=100; // к текущей цене (в пунктах).
      }
   if (up>0) {LineUP+=50; LINE(txtUP, bar,Low [bar]-LineUP*Point, bar+1,Low [bar+1]-LineUP*Point,clr);} //  аждую следующую линию отодвигаем от предыдущей на 4 пункта,
   if (dn>0) {LineDN+=50; LINE(txtDN, bar,High[bar]+LineDN*Point, bar+1,High[bar+1]+LineDN*Point,clr);} // чтобы они рисовались одрна над другой. 
   }   
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆ 
void LINE(string txt, int bar0, double price0, int bar1, double price1, int clr){// —»√ЌјЋ Ўќ–“ (лини€ сверху)
   if (!Real) return;  
   if (price1==0) price1=price0; // если один из параметров не указан, 
   if (price0==0) price0=price1; // присваиваем ему значение другого 
   if (bar0==0) bar0=bar; 
   if (bar1==0) bar1=bar+1;
   string name=txt+" "+DoubleToString(price0,Digits-1)+"/"+TimeToString(Time[bar0],TIME_DATE|TIME_MINUTES); // »м€ графического объекта не должно превышать 63 символа
   ObjectCreate(0,name,OBJ_TREND,0, Time[bar0],price0, Time[bar1],price1); // потом от прошлого значени€ к новому
   ObjectSetInteger(0,name,OBJPROP_COLOR,clr);      // цвет 
   ObjectSetInteger(0,name,OBJPROP_STYLE,STYLE_SOLID);   // сплошна€ лини€. STYLE_DASH-Ўтрихова€, STYLE_DOT-пунктир 
   ObjectSetInteger(0,name,OBJPROP_WIDTH,0);             // размер  
   ObjectSetInteger(0,name,OBJPROP_BACK,true);           // на переднем (false) или заднем (true) плане 
   ObjectSetInteger(0,name,OBJPROP_RAY_RIGHT,false);     // Ћуч не продолжаетс€ вправо 
   ObjectSetInteger(0,name,OBJPROP_SELECTABLE,true);     // возможность выделить и перемещать
   }
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆ 
void PRICE_TXT(double price){// «Ќј„≈Ќ»≈ ÷≈Ќџ
   if (!Real) return;
   string   name="Price "+TimeToString(Time[bar],TIME_DATE | TIME_MINUTES);     // им€ знака 
   ObjectCreate(0,name,OBJ_ARROW_RIGHT_PRICE,0,Time[bar],price);   
   }
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆   
void TEXT(string name, string text, double price){// “≈ —“    
   if (!Real) return;
   int Angle=0, Anchor=0;
   if (name=="UP")   {Angle=270;  Anchor=ANCHOR_TOP;}    //  ”гол (над ценой); ѕрив€зка сверху
   if (name=="DN")   {Angle=90;   Anchor=ANCHOR_BOTTOM;} //  ”гол (под ценой); ѕрив€зка снизу  
   
   name="Text"+name+" "+TimeToString(Time[bar-1],TIME_DATE | TIME_MINUTES);     // им€ знака  
   ObjectCreate(0,name,OBJ_TEXT,0,Time[bar-1],price);
   // свойства текста
   ObjectSetString (0,name,OBJPROP_TEXT,text);    // текст  
   ObjectSetString (0,name,OBJPROP_FONT,"Arial"); // шрифт 
   ObjectSetInteger(0,name,OBJPROP_FONTSIZE,8);   // размер шрифта 
   ObjectSetDouble (0,name,OBJPROP_ANGLE,Angle);  // угол наклона текста 
   // свойства графического объекта
   ObjectSetInteger(0,name,OBJPROP_ANCHOR,Anchor);    // прив€зка 
   ObjectSetInteger(0,name,OBJPROP_COLOR,clrWhite);   // цвет 
   ObjectSetInteger(0,name,OBJPROP_STYLE,STYLE_SOLID);// сплошна€ лини€. STYLE_DASH-Ўтрихова€, STYLE_DOT-пунктир 
   ObjectSetInteger(0,name,OBJPROP_WIDTH,0);          // размер  
   ObjectSetInteger(0,name,OBJPROP_BACK,false);        // на переднем (false) или заднем (true) плане 
   }   
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆   
int LabelCnt=0;
void LABEL(string text){// ћ≈“ ј на графике
   if (!Real) return;
   string  name="Label "+DoubleToStr(LabelCnt,0);
   LabelCnt+=8;
   ObjectCreate(0,name,OBJ_LABEL,0,0,0);
   // расположение графического объекта
   ObjectSetInteger(0,name,OBJPROP_CORNER,CORNER_LEFT_UPPER);// расположение относительно левого верхнего угла графика. CORNER_LEFT_LOWER-лев.нижн, CORNER_RIGHT_LOWER-прав.нижн, CORNER_RIGHT_UPPER-прав.верхн
   ObjectSetInteger(0,name,OBJPROP_XDISTANCE,5);           // координаты на
   ObjectSetInteger(0,name,OBJPROP_YDISTANCE,5+LabelCnt);  // графике
   // свойства текста
   ObjectSetString (0,name,OBJPROP_TEXT,text);  // текст  
   ObjectSetString (0,name,OBJPROP_FONT,"Arial");  // шрифт 
   ObjectSetInteger(0,name,OBJPROP_FONTSIZE,7); // размер шрифта 
   ObjectSetDouble (0,name,OBJPROP_ANGLE,0.0); // угол наклона текста 
   // свойства графического объекта
   ObjectSetInteger(0,name,OBJPROP_ANCHOR,ANCHOR_BOTTOM);// способ прив€зки
   ObjectSetInteger(0,name,OBJPROP_COLOR,clrWhite);      // цвет 
   ObjectSetInteger(0,name,OBJPROP_STYLE,STYLE_SOLID);   // сплошна€ лини€. STYLE_DASH-Ўтрихова€, STYLE_DOT-пунктир 
   ObjectSetInteger(0,name,OBJPROP_WIDTH,3);             // размер  
   ObjectSetInteger(0,name,OBJPROP_BACK,false);          // на переднем (false) или заднем (true) плане 
   
   
   }     
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆   
void CHART_SETTINGS(){
   if (!Real) return;
   // Ёлементы
   ChartSetInteger(0,CHART_MODE,CHART_BARS);       // способ отображени€ ценового графика (CHART_BARS, CHART_CANDLES, CHART_LINE)
   ChartSetInteger(0,CHART_SHOW_GRID, false);      // ќтображение сетки на графике
   ChartSetInteger(0,CHART_SHOW_PERIOD_SEP, true); // ќтображение вертикальных разделителей между соседними периодами
   ChartSetInteger(0,CHART_SHOW_OHLC, false);      // –ежим отображени€ значений OHLC в левом верхнем углу графика
   ChartSetInteger(0,CHART_FOREGROUND, true);      // ÷еновой график на переднем плане
   ChartSetInteger(0,CHART_SHOW_OBJECT_DESCR,true);// ¬сплывающие описани€ графических объектов
   ChartSetInteger(0,CHART_SHOW_VOLUMES,false);    // ќтображение объемов не нужно
   ChartSetInteger(0,CHART_SHOW_BID_LINE,true);
   ChartSetInteger(0,CHART_SHOW_ASK_LINE,true);
   // цвета
   ChartSetInteger(0,CHART_COLOR_BACKGROUND,clrBlack);   // ÷вет фона графика
   ChartSetInteger(0,CHART_COLOR_FOREGROUND,clrDimGray); // ÷вет осей, шкалы и строки OHLC
   ChartSetInteger(0,CHART_COLOR_GRID,clrDimGray);       // ÷вет сетки
   ChartSetInteger(0,CHART_COLOR_CHART_UP,clrLime);      // Ѕар вверх
   ChartSetInteger(0,CHART_COLOR_CHART_DOWN,clrLime);    // Ѕар вниз
   ChartSetInteger(0,CHART_COLOR_CHART_LINE,clrLime);    // Ћини€
   ChartSetInteger(0,CHART_COLOR_BID,clrDimGray);
   ChartSetInteger(0,CHART_COLOR_ASK,clrDimGray);
   }
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆      
