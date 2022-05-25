// ��� ������ ����� � ��������...
#property copyright "Hohla"
#property link      "hohla@mail.ru"

#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 Green
#property indicator_color2 Green
#property indicator_color3 Yellow

extern int HL=1;
extern int iHL=8;
extern int PerCnt=2; // ������������ ������ ��� 1(������ ������� �������) � 8-�� ������
double HiBuf[], LoBuf[], SigBuf[], temp, hi, lo, Counter, Etalon;
int i,j,Trend=0;
#include <AlpariTime.mqh>  

int init(){//����������������������������������������������������������������������������������������������������������������������������������������
   string short_name;
   IndicatorBuffers(3);
   SetIndexStyle(0,DRAW_LINE);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexStyle(2,DRAW_ARROW); SetIndexArrow(2,163);
   SetIndexBuffer(0,HiBuf);
   SetIndexBuffer(1,LoBuf);
   SetIndexBuffer(2,SigBuf);
   switch (HL){
         case 1:  short_name="1- HL_Classic ("+iHL+") ";break;
         case 2:  short_name="2- HL_DayBegin ("+iHL+") ";break; // ����� ������� Hi/Lo  ������� � N ���� �������� ���
         case 3:  short_name="3- HL_N ("+iHL+") ";break;  //  HL_N - ����������� N ����������, ������������� ������� ���
         case 4:  short_name="4- HL_Delta ("+iHL+") ";break; // ������������ ������ ��� ��� �������� �� �������� �������� �� ���������� ���
         case 5:  short_name="5- HL_ATR ("+iHL+") ";break;  // HL_ATR - L ������������� �� H �� ���������� x*ATR
         case 6:  short_name="6- HL_Fractal ("+iHL+") ";break; // ���������� �� ���������
         case 7:  short_name="7- HL_Layers  ("+iHL+") ";break; // ������  ������������� ������� (����� #Layers)
         case 8:  short_name="8- VolClaster ("+iHL+"%) ";break;
         }
   IndicatorShortName(short_name);
   SetIndexLabel(1,short_name);
   hi=High[Bars-IndicatorCounted()-1];
   lo=Low[Bars-IndicatorCounted()-1];
   }//����������������������������������������������������������������������������������������������������������������������������������������

int BarCounter(int per){// ������� ���������� ������� ����������� //����������������������������������������������������������������������������������������������������������������������������������������
   if (j>=Bars-1) return(1);// ���� �� ��������� �� ����� ������� :) 
   switch (PerCnt){
      case 0: // ������� ������� ���
         j++;
         if (j>=i+per) return(1);   // ��������� ������ ���-�� ���  for (j=i; j<i+Per; j++){
      break;      
      case 1: // ���������� ���� ������, ���� ����� �� ��������� ���������� ��������
         if (j<i){
            Etalon=per*iATR(NULL,0,100,i)*0.5; // ��������, � ������� � ������ ����� ������������ ����� ������ ����
            Counter=0; // ������� �������� ������ ����
            }
         Counter+=MathAbs(Close[j]-Close[j+1]); // � ������ ����� ����������� ����� ������ ����
         j++; 
         if (Counter>=Etalon) return(1); // �������� ������ �����
      break;
      case 2: // ������ ������������ ���������� ����� ������ ������ (������������� ������) 
         if (j<i){Etalon=0; Counter=0;} // �������� ����������� ������ � ������� ��������� ����� �����������
         if (Etalon==0 && Close[j]-Open[j]>0){Etalon=1; Counter++;} //������ ����������� ������, ��������� ��������
         if (Etalon==1 && Close[j]-Open[j]<0){Etalon=0; Counter++;} //������ ����������� ������, ��������� ��������
         j++; 
         if (Counter*2>per) return(1); // ��������� ������ ����� ��������� ������       
      break;     
      }    
   return(0);             
   }//����������������������������������������������������������������������������������������������������������������������������������������

int start(){//���������������������������������������������������������������������������������������������������������������������������������������� 
   int CountBars=Bars-IndicatorCounted()-1;
   for (i=CountBars; i>0; i--){
      switch (HL){
         case 1: // HL_Classic 
            j=i-1; hi=High[i]; lo=Low[i];
            while(!BarCounter(iHL)){
               if (High[j]>hi) hi=High[j];
               if (Low[j]<lo)  lo=Low[j];
               }   
         break;
         case 2: // HL_DayBegin ����� ������� Hi/Lo ������� � N ����
            int time=iHL;
            if (Period()>60) time=MathFloor((iHL*60)/Period())*Period()/60; // ��� ��>���� ������ ������ ������� ��. ��� �4:  ��� iHL=3 time=0;  ��� iHL=6 time=4;  ��� iHL=10 time=8;
            if (TimeHour(AlpariTime(i))==time) {hi=High[i]; lo=Low[i];}
            if (High[i]>hi) hi=High[i];
            if (Low[i]<lo) lo=Low[i];   
         break;
         case 3: // HL_N - ����������� N ����������, ������������� ������� ���
            int k=0; j=i+1; hi=High[i];
            while (k<iHL){      // ����������� N ����������, ������������� ������� ���
               if (High[j]>hi){hi=High[j];k++;}
               j++; if (j>=Bars-10) break;
               }
            k=0; j=i+1; lo=Low[i]; 
            while (k<iHL){   
               if (Low[j]<lo){lo=Low[j];k++;}
               j++; if (j>=Bars-10) break; 
               }
         break;
         case 4: // HL_Delta-2 ������������ ������ ��� ��� �������� �� �������� �������� �� ���������� ���
            temp=iHL*iATR(NULL,0,100,i);
            if (temp<=0) break;
            if (High[i]>lo+temp){// ����� �� ���
               if (Trend<=0){ // ��� ����� ����
                  Trend=1;  
                  hi=High[i]; // ��������� �������� hi
               }  }      
            if (Low[i]<hi-temp){
               if (Trend>=0){
                  Trend=-1;
                  lo=Low[i];
               }  }
         break; ////////////////////////////      
         case 5: // HL_ATR - L ������������� �� H �� ���������� x*ATR
            temp=iHL*iATR(NULL,0,100,i)*0.5;
            if (High[i]>hi){hi=High[i]; if (lo<hi-temp) lo=hi-temp;}
            if (Low[i]<lo) {lo=Low[i];  if (hi>lo+temp) hi=lo+temp;}   
         break;
         case 6: // HL_Fractal 
            if (High[i+iHL]==High[iHighest(NULL,0,MODE_HIGH,iHL*2+1,i)])  hi=High[i+iHL];
            if (Low[i+iHL]== Low[iLowest(NULL,0,MODE_LOW,iHL*2+1,i)])     lo=Low[i+iHL];
         break;
         case 7: // ������  ������������� ������� (����� #Layers) 
            double H1,H2,H3,H4, L1,L2,L3,L4;
            H1=iCustom(NULL,0,"0Layers",iHL,0,i); 
            H2=iCustom(NULL,0,"0Layers",iHL,1,i);
            H3=iCustom(NULL,0,"0Layers",iHL,2,i); 
            H4=iCustom(NULL,0,"0Layers",iHL,3,i);
            L1=iCustom(NULL,0,"0Layers",iHL,4,i); 
            L2=iCustom(NULL,0,"0Layers",iHL,5,i);
            L3=iCustom(NULL,0,"0Layers",iHL,6,i);
            L4=iCustom(NULL,0,"0Layers",iHL,7,i);    
            // �� ���������� ������� ������ hi / lo � ����������� �� ��������� ���� ����� ����   
            if (High[i]>H4)  hi=High[i];else
            if (High[i]>H3)  hi=H4;    else
            if (High[i]>H2)  hi=H3;    else
            if (High[i]>H1)  hi=H2;    else
            if (High[i]>L1)  hi=H1;    else
            if (High[i]>L2)  hi=L1;    else
            if (High[i]>L3)  hi=L2;    else
            if (High[i]>L4)  hi=L3;    else                 
                             hi=L4; 
            if (Low[i]<L4)   lo=Low[i];else
            if (Low[i]<L3)   lo=L4;    else
            if (Low[i]<L2)   lo=L3;    else
            if (Low[i]<L1)   lo=L2;    else
            if (Low[i]<H1)   lo=L1;    else
            if (Low[i]<H2)   lo=H1;    else
            if (Low[i]<H3)   lo=H2;    else
            if (Low[i]<H4)   lo=H3;    else
                             lo=H4;
         break;                
         case 8: // VolumeCluster
            double O,H,L,C,ATR, porog; 
            int Trend, Bar=PerCnt;
            porog=(13-iHL)*0.03; // ��� iHL=1..9, porog=36%-12%, (25% � ������) 
            C=Close[i+1];
            H=High[i+1];
            L=Low [i+1];
            ATR=iATR(NULL,0,100,i)*1.5;
            for (j=i+1; j<=i+Bar+1; j++){
               if (High[j]>H) H=High[j];
               if (Low [j]<L) L=Low [j];
               O=Open[j];
               if (H-L>ATR){//  �� �������� � ����� ���������
                  if ((H-O)/(H-L)<porog && (H-C)/(H-L)<porog) {lo=L; hi=H;  SigBuf[i]=L;} // ������ "�������" (�������� � �������� � ������� ����� Bar �����)
                  if ((O-L)/(H-L)<porog && (C-L)/(H-L)<porog) {lo=L; hi=H;  SigBuf[i]=H;} // ������� "�������"
               }  }
         break;        
         }
      if (hi<High[i]) hi=High[i];
      if (lo>Low[i])  lo=Low[i];   
      HiBuf[i]=hi;
      LoBuf[i]=lo; 
   }  }
   
   /*
      case 44: // HL_N1   - ����� ���������� ������ ��� ����������� N ��������� ����� �� �������� ���
            if (Low[i]<lo){  
               k=0; j=i+1;
               hi=High[i]; lo=Low[i]; 
               while (k<iHL){
                  if (High[j]>hi){hi=High[j];k++;}
                  j++; if (j>=Bars-1) break;
               }  }
            if (High[i]>hi){    // ����� ���������� ������ ��� ����������� N ��������� ����� �� �������� ���
               k=0; j=i+1; 
               hi=High[i]; lo=Low[i];  
               while (k<iHL){   
                  if (Low[j]<lo){lo=Low[j];k++;}
                  j++; if (j>=Bars-1) break; 
               }  } 
         break;
         */