#property copyright "Hohla"
#property link      "mail@hohla.ru"
#property strict // �������� ����������� �� ���������� ������� �������� ������ �������� ������ 
#property indicator_chart_window  // indicator_separate_window
#property indicator_buffers 4
#property indicator_color1 clrGreen   // ���������� ������
#property indicator_color2 clrRed      // ��������� ������
#property indicator_color3 clrRed         // ����
#property indicator_color4 clrGreen       // ����
#property indicator_width1 3
#property indicator_width2 3
//#property indicator_width3 2
//#property indicator_width4 2
//#property indicator_style3 2
//#property indicator_style4 2
extern int A=0; // ��������� ������� �� �������: �������-���������, �������-����������.
double   I0[],I1[],I2[],I3[];
int bar;

void init(){//�����������������������������������������������������������������������������������������������������������������
   string iName="MyTrades";
   IndicatorBuffers(4);
   IndicatorDigits(Digits);
   SetIndexStyle(0,DRAW_LINE); SetIndexBuffer(0,I0); 
   SetIndexStyle(1,DRAW_LINE); SetIndexBuffer(1,I1); 
   SetIndexStyle(2,DRAW_ARROW); SetIndexBuffer(2,I2); 
   SetIndexStyle(3,DRAW_ARROW); SetIndexBuffer(3,I3); 
   //SetLevelStyle(STYLE_DASH,1,clrRed);
   IndicatorShortName(iName);
   SetIndexLabel(0,iName);
   
   }//�����������������������������������������������������������������������������������������������������������������

void start(){
   int Ord, BarOpen, BarClose, win=0, b;
   double delta, price;
   if (bar==Bars) return; bar=Bars;
   
   for (Ord=0; Ord<OrdersHistoryTotal(); Ord++){// ���������� ������� ������ ��������
      if (OrderSelect(Ord,SELECT_BY_POS,MODE_HISTORY)==true && OrderMagicNumber()==0 && OrderCloseTime()>0 && OrderSymbol()==Symbol() && (OrderType()==OP_BUY || OrderType()==OP_SELL)){
         BarOpen =iBarShift(NULL,0,OrderOpenTime(),false);  // �������� ���� �������� ������� ������������ ������ �������
         BarClose=iBarShift(NULL,0,OrderCloseTime(),false); // �������� ���� �������� ������� ������������ ����� �������
         if (BarOpen<=BarClose) continue; // �������� ������� �� ����
         price=OrderOpenPrice(); // ������ ��������� ������
         delta=(OrderOpenPrice()-OrderClosePrice())/(BarOpen-BarClose); // ���� ��������� ������ 
         if (OrderType()==OP_BUY ){ if (delta<0) win=1; else win=-1;} // ���������� ������ ������ �������
         if (OrderType()==OP_SELL){ if (delta>0) win=1; else win=-1;} // ����������� �������
         for (b=BarOpen; b>=BarClose; b--){
            //SetLevelStyle(STYLE_DASH,1,clrRed);
            if (win>0)  I0[b]=price; else I1[b]=price;
            if (OrderStopLoss()>0)     I2[b]=OrderStopLoss();
            if (OrderTakeProfit()>0)   I3[b]=OrderTakeProfit();
            price-=delta;
            }
        // Print("win=",win," PriceOpen=",OrderOpenPrice()," PriceClose=",OrderClosePrice()," Profit=",OrderTakeProfit()," Time=",TimeToString(OrderOpenTime(),TIME_DATE | TIME_MINUTES)," - ",TimeToString(OrderCloseTime(),TIME_DATE | TIME_MINUTES));  
   }  }  }  
      
   

        
         
