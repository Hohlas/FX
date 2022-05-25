// ¬от теперь может и сбудетс€...
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

int init(){//∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆
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
   }//∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆
   
int BarCounter(int per){// способы вычислени€ периода инидикатора //∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆
   if (j>=Bars-1) return(1);// чтоб не добратьс€ до конца графика :) 
   switch (PerCnt){
      case 0: // простой счетчик бар
         j++;
         if (j>=i+per) return(1);   // отсчитали нужное кол-во бар  for (j=i; j<i+Per; j++){
      break;      
      case 1: // складываем тела свечей, пока сумма не достигнет эталонного значени€
         if (j<i){
            Etalon=per*iATR(NULL,0,100,i)*0.5; // величина, к которой с каждым баром приближаетс€ длина кривой цены
            Counter=0; // вначале обнул€ем кривую цены
            }
         Counter+=MathAbs(Close[j]-Close[j+1]); // с каждым баром увеличиваем длину кривой цены
         j++; 
         if (Counter>=Etalon) return(1); // отмерили нужную длину
      break;
      case 2: // период эквивалентен количеству смены цветов свечей (равномерности тренда) 
         if (j<i){Etalon=0; Counter=0;} // обнул€ем направление тренда и счетчик изменений этого направлени€
         if (Etalon==0 && Close[j]-Open[j]>0){Etalon=1; Counter++;} //мен€ем направление тренда, фиксируем разворот
         if (Etalon==1 && Close[j]-Open[j]<0){Etalon=0; Counter++;} //мен€ем направление тренда, фиксируем разворот
         j++; 
         if (Counter*2>per) return(1); // превысили нужное число изменений тренда       
      break;     
      }    
   return(0);             
   }//∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆
   
int start(){//∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆
   int CountBars=Bars-IndicatorCounted()-1;
   for (i=CountBars; i>0; i--){
      switch (DM){
         case 0: //  лассическа€ формула индюка
            j=i-1; temp=0;
            while(!BarCounter(Per)){
               if (High[j]>High[j+1]) temp+=(High[j]-High[j+1]);
               if (Low[j]<Low[j+1])   temp+=(Low[j]-Low[j+1]); 
               }
            if ((temp>=0 && Buffer0[i+1]<0) || (temp<=0 && Buffer0[i+1]>0)) {max=0; min=0;}
            if (temp>max) max=temp;
            if (temp<min) min=temp;   
         break;
         case 1: // сигнал / шум
            double Noise=0; 
            j=i-1; 
            while(!BarCounter(Per)) Noise+=MathAbs((High[j]+Low[j]+Close[j])/3 - (High[j+1]+Low[j+1]+Close[j+1])/3); 
            if (Noise>0) temp = ((High[i]+Low[i]+Close[i])/3 - (High[j]+Low[j]+Close[j])/3) / Noise;
            if ((temp>=0 && Buffer0[i+1]<0) || (temp<=0 && Buffer0[i+1]>0)) {max=0; min=0;}
            if (temp>max) max=temp;
            if (temp<min) min=temp; 
         break;
         case 2: // площадь над медианой моментума - площадь под медианой моментума
            double Line, Delta=0, Up=0,Dn=0, MO; 
            j=i-1; 
            MO=(Close[i]-Close[i+Per])/Per;
            while(!BarCounter(Per)){
               Line=Close[i]-MO*(j-i); // расчетное значение цены на пр€мой i..(i+Per) знак "-", т.к. считаем с зада на перед
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
            while(!BarCounter(Per)) // считаем j, т.е. i+per
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
   }  }//∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆
   