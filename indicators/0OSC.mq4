// ��� ������ ����� � ��������...
#property copyright "Hohla"
#property link      "hohla@mail.ru"

#property indicator_separate_window
#property indicator_buffers 4
#property indicator_color1 SpringGreen
#property indicator_color2 Green
#property indicator_color3 Gray
#property indicator_color4 Gray

extern int OSC=5;
extern int HL=1;  // ������ ������� HL
extern int iHL=9; // ����. ������� HL
extern int PerCnt=0;   // ������ ������� ������� HL (������������ ���� ��� HL=1);

double H,L,H1,L1,H2,L2,H3,L3,Buffer0[],Buffer1[],Buffer2[],Buffer3[],porog,lo,hi,lo1,hi1,temp, hl[1000];
int i,j;

int init(){//����������������������������������������������������������������������������������������������������������������������������������������
   string short_name;
   IndicatorBuffers(4);
   SetIndexStyle(0,DRAW_LINE); 
   SetIndexBuffer(0,Buffer0);
   SetIndexStyle(1,DRAW_LINE); 
   SetIndexBuffer(1,Buffer1);
   SetIndexStyle(2,DRAW_LINE); 
   SetIndexBuffer(2,Buffer2);
   SetIndexStyle(3,DRAW_LINE); 
   SetIndexBuffer(3,Buffer3);
   switch (OSC){
         case 1:  short_name="1: HL/sHL (HL="+HL+", iHL="+iHL+", PerCnt="+PerCnt+") ";break; // ��������� ��������� HL � ������� HL, ����������� �� per ���
         case 2:  short_name="2: Canal  (HL="+HL+", iHL="+iHL+", PerCnt="+PerCnt+") ";break; // ���� HLC/3 � ������ 
         case 3:  short_name="3: LastHL (HL="+HL+", iHL="+iHL+", PerCnt="+PerCnt+") ";break; // ����������� ���������� HL �� ������������ ���������
         case 4:  short_name="4: LastHL (HL="+HL+", iHL="+iHL+", PerCnt="+PerCnt+") ";break; // ����������� ������� ����������� HL �� ������������ ���������
         case 5:  short_name="5: Fractal (HL="+HL+", iHL="+iHL+", PerCnt="+PerCnt+") ";break; // �������� �� HiLo
         }
   IndicatorShortName(short_name);
   SetIndexLabel(0,short_name);
   }//����������������������������������������������������������������������������������������������������������������������������������������

int start(){//����������������������������������������������������������������������������������������������������������������������������������������
   // ��� ������������� � ������� ���������� �������� ���������� ���������� ��������� "���������" �������� ����. ���� ��� ������� �� ����������� ����� ��������� �������� ����������,          
   // �������� ��� ������ �������� � ������ (�.1), �� ����� ������������ ������� ���, �.�. � �������� ������������ ��� �������� �� ������������, � � ����� ������ ������ �������� ��������.
   // ���� �� ������� ��� �����������, �� ����� �������������� ������������ ��� ��������, ��� �������� ����� �� � ����...  
   int N,CountBars=Bars-IndicatorCounted()-1;
   for (i=CountBars; i>0; i--){
      H =iCustom(NULL,0,"0HL",HL,iHL,PerCnt,0,i);   
      L =iCustom(NULL,0,"0HL",HL,iHL,PerCnt,1,i);
      H1=iCustom(NULL,0,"0HL",HL,iHL,PerCnt,0,i+1);   // ������� ������� hi / lo
      L1=iCustom(NULL,0,"0HL",HL,iHL,PerCnt,1,i+1);
      H2=iCustom(NULL,0,"0HL",HL,iHL,PerCnt,0,i+2);   // ������� ����������� hi / lo
      L2=iCustom(NULL,0,"0HL",HL,iHL,PerCnt,1,i+2);
      H3=iCustom(NULL,0,"0HL",HL,iHL,PerCnt,0,i+3);   // ������� ����������� hi / lo
      L3=iCustom(NULL,0,"0HL",HL,iHL,PerCnt,1,i+3);
      switch (OSC){
         case 1: // ��������� ��������� HL � ������� HL, ����������� �� per ���  ////////////////////////////////////////////////////////////////////////////////////////////////////
            N=30; // ���������� ���������� HL ��� ����������
            // !!!! ���� ������������ ��� ������� ������� (�������) ��� H(i), �� ������� ������ ������ �������, �.�. ��� ������������ ���� ����� ����������� �������� hl[0], � hl[0] ����� ����������� � ���������� ��������� ��� ����������� ������ ����, ��� � ������ �����������, �� ������������ ������ ���������� ��� ���������� 
            if (hl[0]!=H-L){// ������������� ����� �������� HL
               temp=0;
               hl[0]=H-L;   // ������� ��������� ��������
               for (j=N; j>0; j--){
                  hl[j]=hl[j-1]; // ������������� ������, �� ���, ���� ����� �������� ���� � �������� 1 
                  temp+=hl[j];   // �� ���� ��������� ����� ���� ��������
                  }
               temp/=N; // ��������� ������� N ���������� ��� ����� ���������� ���������
               }
            Buffer0[i]=temp;  // ������� �������� N ���������� HL
            Buffer1[i]=hl[0]; // ��������� �������� HL
         break;
         case 2: // ���� HLC/3 � ������ //////////////////////////////////////////////////////////////////////////////////////////////////////////
            double M=(iHigh(NULL,0,i)+iLow(NULL,0,i)+iClose(NULL,0,i))/3;
            if (H-L>0) temp=(M-L)/(H-L)-0.5; // ������������ � �������� ��������
            if (H>H1) porog=0.5; // ����� ��������
            if (L<L1) porog=-0.5; // ����� �������
            Buffer0[i]=temp;
            Buffer1[i]=porog; 
         break;
         case 3: // ����������� ���������� HL �� ������������ ���������
            if (L1>L)  lo=L; // ������������� ��������� ������� 
            if (H1<H)  hi=H; // ������������� ��������� ��������
            Buffer0[i]=lo;
            Buffer1[i]=hi; 
            Buffer2[i]=H;
            Buffer3[i]=L;  
         break;
         case 4: // ����������� ������� ����������� HL �� ������������ ���������
            if (L3>L2 && L2<=L1)  lo=L2; // ������������� ��������� ������� 
            if (H3<H2 && H2>=H1)  hi=H2; // ������������� ��������� ��������
            Buffer0[i]=lo;
            Buffer1[i]=hi; 
            Buffer2[i]=H1;
            Buffer3[i]=L1;  
         break;
         case 5: // �������� �� Hi Lo
            if (L3>L2 && L2<=L1)  temp=1; // ������������� ��������� �������, ����� ����� 
            if (H3<H2 && H2>=H1)  temp=-1; // ������������� ��������� ��������, ����� ����
            Buffer0[i]=temp;
            Buffer1[i]=0; 
            Buffer2[i]=0;
            Buffer3[i]=0;  
         break;
   }  }  }//����������������������������������������������������������������������������������������������������������������������������������������
  
   

