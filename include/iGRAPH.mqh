#define  cSIG1     0x009000  // ���� �������� ���������� ����� ����������
#define  cSIG2     0x004000  // ���� ��������������� ���������� ����� ���������� 
#define  cIND1     0x000090  // ���� �������� ���������� ����� ����������
#define  cIND2     0x000070  // ���� ��������������� ���������� ����� ���������� 
#define  cIND3     0x000050  // ���� �������� ���������� ����� ����������
#define  cIND4     0x000030  // ���� ��������������� ���������� ����� ���������� 
void ARROW(string name, double price, int clr){// �������          
   if (!Real) return;
   int Arrow=0, Anchor=0;
   if (name=="UP")   {Arrow=OBJ_ARROW_UP;       Anchor=ANCHOR_TOP;}     // ������� ����,  �������� ������    
   if (name=="DN")   {Arrow=OBJ_ARROW_DOWN;     Anchor=ANCHOR_BOTTOM;}  // ������� ����,  �������� �����     
   name="Arrow"+name+" "+TimeToString(Time[bar],TIME_DATE | TIME_MINUTES);     // ��� �����    
   ObjectCreate    (0,name,Arrow,0,Time[bar],price);   
   ObjectSetInteger(0,name,OBJPROP_ANCHOR,Anchor);    // ��������  
   ObjectSetInteger(0,name,OBJPROP_COLOR,clr);        // ���� 
   ObjectSetInteger(0,name,OBJPROP_STYLE,STYLE_SOLID);   // �������� �����. STYLE_DASH-���������, STYLE_DOT-������� 
   ObjectSetInteger(0,name,OBJPROP_WIDTH,0);             // ������  
   ObjectSetInteger(0,name,OBJPROP_BACK,false);          // �� �������� (false) ��� ������ (true) ����� 
   ObjectSetInteger(0,name,OBJPROP_SELECTABLE,true);     // ����������� �������� � ����������
   }
// ����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������
// ����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������   
int xUP, xDN, xTime;
void X_LINES(int up, int dn, int clr){// ������ ���������� �������� UP � DN: (�������, �������� �� H/L, ����)
   if (!Real) return;
   if (xTime!=Time[bar]){// ����� ���
      xTime=int(Time[bar]);
      xUP=100; // ���������� ������� ����� 
      xDN=100; // � ������� ���� (� �������).
      }
   if (up<=0) {xUP+=40; X("UP",Low [bar]-xUP*Point,clr);}
   if (dn<=0) {xDN+=40; X("DN",High[bar]+xDN*Point,clr);} 
   }    
// ����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������
// ���������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������� 
void X(string txt, double price, int clr){// ������ ����� (������� ������)          
   if (!Real) return;
   string name=txt+" "+DoubleToString(price,Digits)+" "+TimeToString(Time[bar-1],TIME_DATE | TIME_MINUTES);     // ��� �����    
   ObjectCreate    (0,name,OBJ_ARROW_STOP,0,Time[bar-1],price);   
   ObjectSetInteger(0,name,OBJPROP_ANCHOR,0);         // ��������
   ObjectSetInteger(0,name,OBJPROP_COLOR,clr);        // ���� 
   ObjectSetInteger(0,name,OBJPROP_BACK,false);       // �� �������� (false) ��� ������ (true) ����� 
   ObjectSetInteger(0,name,OBJPROP_WIDTH,0);          // ������
   ObjectSetInteger(0,name,OBJPROP_SELECTABLE,true);  // ����������� �������� � ����������
   }
// ����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������
// ����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������   
int LineUP, LineDN; 
datetime LineTime;
void SIG_LINES(double up, string txtUP, double dn, string txtDN, int clr){// ����� �������� UP � DN: (�������, ����)
   if (!Real) return;
   if (LineTime!=Time[bar]){// ����� ���
      LineTime=Time[bar];
      LineUP=100; // ���������� ������� ����� � ������� ����
      LineDN=100; // � ������� ���� (� �������).
      }
   if (up>0) {LineUP+=50; LINE(txtUP, bar,Low [bar]-LineUP*Point, bar+1,Low [bar+1]-LineUP*Point,clr);} // ������ ��������� ����� ���������� �� ���������� �� 4 ������,
   if (dn>0) {LineDN+=50; LINE(txtDN, bar,High[bar]+LineDN*Point, bar+1,High[bar+1]+LineDN*Point,clr);} // ����� ��� ���������� ����� ��� ������. 
   }   
// ����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������
// ���������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������� 
void LINE(string txt, int bar0, double price0, int bar1, double price1, int clr){// ������ ���� (����� ������)
   if (!Real) return;  
   if (price1==0) price1=price0; // ���� ���� �� ���������� �� ������, 
   if (price0==0) price0=price1; // ����������� ��� �������� ������� 
   if (bar0==0) bar0=bar; 
   if (bar1==0) bar1=bar+1;
   string name=txt+" "+DoubleToString(price0,Digits-1)+"/"+TimeToString(Time[bar0],TIME_DATE|TIME_MINUTES); // ��� ������������ ������� �� ������ ��������� 63 �������
   ObjectCreate(0,name,OBJ_TREND,0, Time[bar0],price0, Time[bar1],price1); // ����� �� �������� �������� � ������
   ObjectSetInteger(0,name,OBJPROP_COLOR,clr);      // ���� 
   ObjectSetInteger(0,name,OBJPROP_STYLE,STYLE_SOLID);   // �������� �����. STYLE_DASH-���������, STYLE_DOT-������� 
   ObjectSetInteger(0,name,OBJPROP_WIDTH,0);             // ������  
   ObjectSetInteger(0,name,OBJPROP_BACK,true);           // �� �������� (false) ��� ������ (true) ����� 
   ObjectSetInteger(0,name,OBJPROP_RAY_RIGHT,false);     // ��� �� ������������ ������ 
   ObjectSetInteger(0,name,OBJPROP_SELECTABLE,true);     // ����������� �������� � ����������
   }
// ����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������
// ���������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������� 
void PRICE_TXT(double price){// �������� ����
   if (!Real) return;
   string   name="Price "+TimeToString(Time[bar],TIME_DATE | TIME_MINUTES);     // ��� ����� 
   ObjectCreate(0,name,OBJ_ARROW_RIGHT_PRICE,0,Time[bar],price);   
   }
// ����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������
// ����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������   
void TEXT(string name, string text, double price){// �����    
   if (!Real) return;
   int Angle=0, Anchor=0;
   if (name=="UP")   {Angle=270;  Anchor=ANCHOR_TOP;}    //  ���� (��� �����); �������� ������
   if (name=="DN")   {Angle=90;   Anchor=ANCHOR_BOTTOM;} //  ���� (��� �����); �������� �����  
   
   name="Text"+name+" "+TimeToString(Time[bar-1],TIME_DATE | TIME_MINUTES);     // ��� �����  
   ObjectCreate(0,name,OBJ_TEXT,0,Time[bar-1],price);
   // �������� ������
   ObjectSetString (0,name,OBJPROP_TEXT,text);    // �����  
   ObjectSetString (0,name,OBJPROP_FONT,"Arial"); // ����� 
   ObjectSetInteger(0,name,OBJPROP_FONTSIZE,8);   // ������ ������ 
   ObjectSetDouble (0,name,OBJPROP_ANGLE,Angle);  // ���� ������� ������ 
   // �������� ������������ �������
   ObjectSetInteger(0,name,OBJPROP_ANCHOR,Anchor);    // �������� 
   ObjectSetInteger(0,name,OBJPROP_COLOR,clrWhite);   // ���� 
   ObjectSetInteger(0,name,OBJPROP_STYLE,STYLE_SOLID);// �������� �����. STYLE_DASH-���������, STYLE_DOT-������� 
   ObjectSetInteger(0,name,OBJPROP_WIDTH,0);          // ������  
   ObjectSetInteger(0,name,OBJPROP_BACK,false);        // �� �������� (false) ��� ������ (true) ����� 
   }   
// ����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������
// ����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������   
int LabelCnt=0;
void LABEL(string text){// ����� �� �������
   if (!Real) return;
   string  name="Label "+DoubleToStr(LabelCnt,0);
   LabelCnt+=8;
   ObjectCreate(0,name,OBJ_LABEL,0,0,0);
   // ������������ ������������ �������
   ObjectSetInteger(0,name,OBJPROP_CORNER,CORNER_LEFT_UPPER);// ������������ ������������ ������ �������� ���� �������. CORNER_LEFT_LOWER-���.����, CORNER_RIGHT_LOWER-����.����, CORNER_RIGHT_UPPER-����.�����
   ObjectSetInteger(0,name,OBJPROP_XDISTANCE,5);           // ���������� ��
   ObjectSetInteger(0,name,OBJPROP_YDISTANCE,5+LabelCnt);  // �������
   // �������� ������
   ObjectSetString (0,name,OBJPROP_TEXT,text);  // �����  
   ObjectSetString (0,name,OBJPROP_FONT,"Arial");  // ����� 
   ObjectSetInteger(0,name,OBJPROP_FONTSIZE,7); // ������ ������ 
   ObjectSetDouble (0,name,OBJPROP_ANGLE,0.0); // ���� ������� ������ 
   // �������� ������������ �������
   ObjectSetInteger(0,name,OBJPROP_ANCHOR,ANCHOR_BOTTOM);// ������ ��������
   ObjectSetInteger(0,name,OBJPROP_COLOR,clrWhite);      // ���� 
   ObjectSetInteger(0,name,OBJPROP_STYLE,STYLE_SOLID);   // �������� �����. STYLE_DASH-���������, STYLE_DOT-������� 
   ObjectSetInteger(0,name,OBJPROP_WIDTH,3);             // ������  
   ObjectSetInteger(0,name,OBJPROP_BACK,false);          // �� �������� (false) ��� ������ (true) ����� 
   
   
   }     
// ����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������
// ����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������   
void CHART_SETTINGS(){
   if (!Real) return;
   // ��������
   ChartSetInteger(0,CHART_MODE,CHART_BARS);       // ������ ����������� �������� ������� (CHART_BARS, CHART_CANDLES, CHART_LINE)
   ChartSetInteger(0,CHART_SHOW_GRID, false);      // ����������� ����� �� �������
   ChartSetInteger(0,CHART_SHOW_PERIOD_SEP, true); // ����������� ������������ ������������ ����� ��������� ���������
   ChartSetInteger(0,CHART_SHOW_OHLC, false);      // ����� ����������� �������� OHLC � ����� ������� ���� �������
   ChartSetInteger(0,CHART_FOREGROUND, true);      // ������� ������ �� �������� �����
   ChartSetInteger(0,CHART_SHOW_OBJECT_DESCR,true);// ����������� �������� ����������� ��������
   ChartSetInteger(0,CHART_SHOW_VOLUMES,false);    // ����������� ������� �� �����
   ChartSetInteger(0,CHART_SHOW_BID_LINE,true);
   ChartSetInteger(0,CHART_SHOW_ASK_LINE,true);
   // �����
   ChartSetInteger(0,CHART_COLOR_BACKGROUND,clrBlack);   // ���� ���� �������
   ChartSetInteger(0,CHART_COLOR_FOREGROUND,clrDimGray); // ���� ����, ����� � ������ OHLC
   ChartSetInteger(0,CHART_COLOR_GRID,clrDimGray);       // ���� �����
   ChartSetInteger(0,CHART_COLOR_CHART_UP,clrLime);      // ��� �����
   ChartSetInteger(0,CHART_COLOR_CHART_DOWN,clrLime);    // ��� ����
   ChartSetInteger(0,CHART_COLOR_CHART_LINE,clrLime);    // �����
   ChartSetInteger(0,CHART_COLOR_BID,clrDimGray);
   ChartSetInteger(0,CHART_COLOR_ASK,clrDimGray);
   }
// ����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������
// ����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������      
