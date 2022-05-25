// ¬от теперь может и сбудетс€...
#property copyright "Hohla"
#property link      "hohla@mail.ru"

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
double   H1[],H2[],H3[],H4[],
         L1[],L2[],L3[],L4[], 
         H, L, C, P;
#include <AlpariTime.mqh>         
         
int init(){//∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆
   IndicatorBuffers(8);
   SetIndexStyle(0,DRAW_LINE);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexStyle(2,DRAW_LINE);
   SetIndexStyle(3,DRAW_LINE);
   SetIndexStyle(4,DRAW_LINE);
   SetIndexStyle(5,DRAW_LINE);
   SetIndexStyle(6,DRAW_LINE);
   SetIndexStyle(7,DRAW_LINE);
   SetIndexBuffer(0,H1);
   SetIndexBuffer(1,H2);
   SetIndexBuffer(2,H3);
   SetIndexBuffer(3,H4);
   SetIndexBuffer(4,L1);
   SetIndexBuffer(5,L2);
   SetIndexBuffer(6,L3);
   SetIndexBuffer(7,L4);
   IndicatorShortName("Extremums ");
   SetIndexLabel(0,"H1");
   SetIndexLabel(1,"H2");
   SetIndexLabel(2,"H3");
   SetIndexLabel(3,"H4");
   SetIndexLabel(4,"L1");
   SetIndexLabel(5,"L2");
   SetIndexLabel(6,"L3");
   SetIndexLabel(7,"L4");
   }//∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆

int start(){//∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆ 
   int i,j,CountBars=Bars-IndicatorCounted()-1;
   double time, time1;
   for (i=CountBars; i>0; i--){
      if (N<3){
         j=1440/Period(); // щитаем, скока баров в дне
         if (TimeHour(AlpariTime(i))<TimeHour(AlpariTime(i+1))){  // ищем конец прошлого дн€
            H=High[iHighest(NULL,0,MODE_HIGH,j,i)];   // щитаем экстремумы
            L=Low [iLowest (NULL,0,MODE_LOW,j,i)];    // прошлого дн€
            C=Close[i+1];                             // и его цену закрыти€
            P=(H+L+C)/3;
            }
         if (N==0){// Camarilla Equation ORIGINAL
            H4[i]=C+(H-L)*1.1/2;    
            H3[i]=C+(H-L)*1.1/4;    
            H2[i]=C+(H-L)*1.1/6;  
            H1[i]=C+(H-L)*1.1/12;
            L4[i]=C-(H-L)*1.1/2;    
            L3[i]=C-(H-L)*1.1/4;    
            L2[i]=C-(H-L)*1.1/6;  
            L1[i]=C-(H-L)*1.1/12;  
            }
         if (N==1){ // Camarilla Equation My Edition
            H4[i]=C+(H-L)*4/4;    
            H3[i]=C+(H-L)*3/4;    
            H2[i]=C+(H-L)*2/4;  
            H1[i]=C+(H-L)*1/4;
            L4[i]=C-(H-L)*4/4;    
            L3[i]=C-(H-L)*3/4;    
            L2[i]=C-(H-L)*2/4;  
            L1[i]=C-(H-L)*1/4;  
            }
         if (N==2){// ћетод √нинспена (¬алютный спекул€нт-48, с.62)
            H1[i]=P; L1[i]=P;  
            H2[i]=2*P-L;    
            L2[i]=2*P-H;    
            H3[i]=P+(H-L);  
            L3[i]=P-(H-L);
            H4[i]=H3[i]; L4[i]=L3[i];  
         }  }
      else{ // if (N>=3) ћетод √нинспена (¬алютный спекул€нт-48, с.62), экстремум ищетс€ не на прошлом дне, а на барах с 0 часов до N бара текущего дн€
         int bar=N;
         if (Period()>60) bar=MathFloor(N*60/Period())+1; // дл€ “‘>часа делаем N кратно “‘. ƒл€ Ќ4:  при N=3 bar=0;  при N=6 bar=1;  при N=10 bar=2;
         if (bar>1440/Period()-1) bar=1440/Period()-1; // 1440/Period()- число бар в дне дл€ “‘ с периодом Period()   
         time =(TimeHour(AlpariTime(i  ))*60+TimeMinute(AlpariTime(i  ))) / Period(); // приводим текущее врем€ в количество бар с начала дн€
         time1=(TimeHour(AlpariTime(i+1))*60+TimeMinute(AlpariTime(i+1))) / Period(); 
         if (time>=bar && time1<bar){ // текущее врем€ соответствует заданному количеству бар
            for (j=bar; j>0; j--) if (TimeDay(AlpariTime(i+j))!=TimeDay(AlpariTime(i+j+1))) break; // вычисл€ем, скока бар назад был 0 час. ¬ идиале j=N, но это если в истории нет пропусков  
            H=High[iHighest(NULL,0,MODE_HIGH,j,i)];
            L=Low [iLowest (NULL,0,MODE_LOW,j,i)];
            C=Close[i];
            P=(H+L+C)/3;
            } 
         H1[i]=P; L1[i]=P;  
         H2[i]=2*P-L;    
         L2[i]=2*P-H;    
         H3[i]=P+(H-L);  
         L3[i]=P-(H-L);
         H4[i]=H3[i]; L4[i]=L3[i];  
   }  }  }//∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆
 
   

