// ��� ������ ����� � ��������...
#property copyright "Hohla"
#property link      "hohla@mail.ru"

#property indicator_separate_window
#property indicator_buffers 4
#property indicator_color1 Red
#property indicator_color2 Gray
#property indicator_color3 Gray
#property indicator_color4 Gray

extern int DM=0;
extern int Per=10; 
extern int PerCnt=0; 
double Buffer0[],Buffer1[],Max[],Min[],max,min,temp, Counter, Etalon;
int i,j;

int init(){//����������������������������������������������������������������������������������������������������������������������������������������
   string short_name;
   IndicatorBuffers(4);
   SetIndexStyle(0,DRAW_LINE); 
   SetIndexBuffer(0,Buffer0);
   SetIndexStyle(1,DRAW_LINE); 
   SetIndexBuffer(1,Buffer1); 
   SetIndexStyle(2,DRAW_LINE); 
   SetIndexBuffer(2,Max);
   SetIndexStyle(3,DRAW_LINE); 
   SetIndexBuffer(3,Min); 
   switch (DM){
         case 0:  short_name="0- DM_Classic ("+Per+"), PerCnt="+PerCnt;   break;
         case 1:  short_name="1- Signal/Noise ("+Per+"), PerCnt="+PerCnt; break; 
         case 2:  short_name="2- Delta_S ("+Per+"), PerCnt="+PerCnt; break; 
         case 3:  short_name="3- Momentum ("+Per+"), PerCnt="+PerCnt;     break;
         }
   IndicatorShortName(short_name);
   SetIndexLabel(0,short_name);
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
      switch (DM){
         case 0: // ������������ ������� ������
            j=i-1; temp=0;
            while(!BarCounter(Per)){
               if (High[j]>High[j+1]) temp+=(High[j]-High[j+1]);
               if (Low[j]<Low[j+1])   temp+=(Low[j]-Low[j+1]); 
               }
            if ((temp>=0 && Buffer0[i+1]<0) || (temp<=0 && Buffer0[i+1]>0)) {max=0; min=0;}
            if (temp>max) max=temp;
            if (temp<min) min=temp;   
         break;
         case 1: // ������ / ���
            double Noise=0; 
            j=i-1; 
            while(!BarCounter(Per)) Noise+=MathAbs((High[j]+Low[j]+Close[j])/3 - (High[j+1]+Low[j+1]+Close[j+1])/3); 
            if (Noise>0) temp = ((High[i]+Low[i]+Close[i])/3 - (High[j]+Low[j]+Close[j])/3) / Noise;
            if ((temp>=0 && Buffer0[i+1]<0) || (temp<=0 && Buffer0[i+1]>0)) {max=0; min=0;}
            if (temp>max) max=temp;
            if (temp<min) min=temp; 
         break;
         case 2: // ������� ��� �������� ��������� - ������� ��� �������� ���������
            double Line, Delta=0, Up=0,Dn=0, MO; 
            j=i-1; 
            MO=(Close[i]-Close[i+Per])/Per;
            while(!BarCounter(Per)){
               Line=Close[i]-MO*(j-i); // ��������� �������� ���� �� ������ i..(i+Per) ���� "-", �.�. ������� � ���� �� �����
               Delta=Close[j]-Line;
               if (Delta>0) Dn+=Delta; else Up-=Delta;
               }
            temp=Up-Dn;
            if ((temp>=0 && Buffer0[i+1]<0) || (temp<=0 && Buffer0[i+1]>0)) {max=0; min=0;}
            if (temp>max) max=temp;
            if (temp<min) min=temp; 
         break;
         case 3: // Momentum
            j=i-1; 
            while(!BarCounter(Per)) // ������� j, �.�. i+per
            temp=Open[i]-Open[j];
            if ((temp>=0 && Buffer0[i+1]<0) || (temp<=0 && Buffer0[i+1]>0)) {max=0; min=0;}
            if (temp>max) max=temp;
            if (temp<min) min=temp; 
         break;
         }
      Buffer0[i]=temp;
      Buffer1[i]=0;
      Max[i]=max;
      Min[i]=min;
   }  }//����������������������������������������������������������������������������������������������������������������������������������������
   