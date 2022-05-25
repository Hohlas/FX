void Signal (int SigMode, int SigType, int K, int bar){  // Сигналы и направления тренда  SigMode=1-расчет тренда,                                                    //                              SigMode=2-расчет сигнала
   double x0,x1,x2,x3,C1,C2,H1,H2,L1,L2; 
   Up=0; Dn=0;            
   bool TREND=0, SIGNAL=0; int indper;
   if (SigMode==1) TREND=1; else  SIGNAL=1;
   switch (SigType){ 
      case 1:// сигналы по 0Layers при N>3 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
         if (K<6){
            H1=iCustom(SYMBOL,0,"0Layers",(K*4)*60/Period(),1,bar); // H2
            L1=iCustom(SYMBOL,0,"0Layers",(K*4)*60/Period(),5,bar); // L2
            }
         else{
            H1=iCustom(SYMBOL,0,"0Layers",((K-2)*3)*60/Period(),2,bar); // H3
            L1=iCustom(SYMBOL,0,"0Layers",((K-2)*3)*60/Period(),6,bar); // L3
            }
         C1=Close[bar];
         C2=Close[bar+1];
         if (C1>H1)  {if (TREND) Up=1; if (SIGNAL && C2<H1) Up=1;}
         if (C1<L1)  {if (TREND) Dn=1; if (SIGNAL && C2>L1) Dn=1;}    
         x0=C1; x1=C2; x2=H1; x3=L1;  // эт для файла печати в файл отчета             
      break; ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      
      case 2:// сигналы по 0Layers N<3 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
         switch(K){
            case 1:  //  0Layers (N=0)
               H1=iCustom(SYMBOL,0,"0Layers",0,0,bar); // при N=0 H1 of Camarilla Equation ORIGINAL
               L1=iCustom(SYMBOL,0,"0Layers",0,4,bar); // при N=0 L1 of Camarilla Equation ORIGINAL
            break;
            case 2: // опять 0Layers(N=1) с теми же уровнями 1 и 5
               H1=iCustom(SYMBOL,0,"0Layers",1,0,bar); // H1
               L1=iCustom(SYMBOL,0,"0Layers",1,4,bar); // L1
            break;
            case 3:  //  0Layers (N=0)
               H1=iCustom(SYMBOL,0,"0Layers",0,2,bar); // при N=0 H3 of Camarilla Equation ORIGINAL
               L1=iCustom(SYMBOL,0,"0Layers",0,6,bar); // при N=0 L3 of Camarilla Equation ORIGINAL
            break;
            case 4: // опять 0Layers(N=1) с теми же уровнями 1 и 5
               H1=iCustom(SYMBOL,0,"0Layers",1,1,bar); // H2
               L1=iCustom(SYMBOL,0,"0Layers",1,5,bar); // L2
            break;
            case 5:  //  0Layers (N=0)
               H1=iCustom(SYMBOL,0,"0Layers",0,3,bar); // при N=0 H4 of Camarilla Equation ORIGINAL
               L1=iCustom(SYMBOL,0,"0Layers",0,7,bar); // при N=0 L4 of Camarilla Equation ORIGINAL
            break;
            case 6: //  0Layers(N=2) , тока с более дальними уровнями 1 и 5
               H1=iCustom(SYMBOL,0,"0Layers",2,1,bar); // H2
               L1=iCustom(SYMBOL,0,"0Layers",2,5,bar); // L2
            break;
            case 7: // перебор уровней 2-6 для индюка 0Layers (N=1)
               H1=iCustom(SYMBOL,0,"0Layers",1,2,bar); // H3
               L1=iCustom(SYMBOL,0,"0Layers",1,6,bar); // L3
            break;
            case 8: // самые дальние уровни 3-7, они есть тока у 0Layers при (N=1)
               H1=iCustom(SYMBOL,0,"0Layers",1,3,bar); // H4
               L1=iCustom(SYMBOL,0,"0Layers",1,7,bar); // L4 
            break;
            case 9: //  0Layers(N=2) , тока с более дальними уровнями 1 и 5
               H1=iCustom(SYMBOL,0,"0Layers",2,2,bar); // H3
               L1=iCustom(SYMBOL,0,"0Layers",2,6,bar); // L3
            break;         
            }
         C1=Close[bar];
         C2=Close[bar+1];
         if (C1>H1)  {if (TREND) Up=1; if (SIGNAL && C2<H1) Up=1;}
         if (C1<L1)  {if (TREND) Dn=1; if (SIGNAL && C2>L1) Dn=1;}    
         x0=C1; x1=C2; x2=H1; x3=L1;  // эт для файла печати в файл отчета            
      break; ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      
      case 3: // отскоки/приближения к экстремумам HiLo //////////////////////////////////////////////////////////////////////////////////////////////////////
         x0=(5-K)*0.1;   // 0.4  0.3  0.2  0.1  0  -0.1  -0.2  -0.3  -0.4     
         x1=iCustom(SYMBOL,0,"0OSC",2,HL,iHL,PerCnt,0,bar);  // Теперь он рисует положение HLC/3 в канале HL, в
         x2=iCustom(SYMBOL,0,"0OSC",2,HL,iHL,PerCnt,0,bar+1);// диапазоне от -0.5 до 0.5
         if (x1> x0) {if (TREND) Up=1; if (SIGNAL && x2<= x0) Up=1;}
         if (x1<-x0) {if (TREND) Dn=1; if (SIGNAL && x2>=-x0) Dn=1;}
      break; ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

      case 4: // Сигнал / Шум /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
         indper=NormalizeDouble(MathPow(1.5,K+5),0)*PerAdapter; // 11  17  26  38  58  86  130  195  291
         x0=iCustom(SYMBOL,0,"0DM",1,indper,PerCnt,0,bar);
         if (TREND){
            if (x0> 0) Up=1;
            if (x0<-0) Dn=1;
            }
         if (SIGNAL){
            x1=iCustom(SYMBOL,0,"0DM",1,indper,PerCnt,0,bar+1);
            x2=iCustom(SYMBOL,0,"0DM",1,indper,PerCnt,2,bar); // max
            x3=iCustom(SYMBOL,0,"0DM",1,indper,PerCnt,3,bar); // min
            if (x3<0 && x0-x3>0.1 && x1-x3<=0.1) Up=1; // отскок от минимума 
            if (x2>0 && x2-x0>0.1 && x2-x1<=0.1) Dn=1;
            }
      break; ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
      case 5:// DM приоритетное направление движения цены/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
         indper=NormalizeDouble(MathPow(1.5,K+6),0)*PerAdapter; // 17  26  38  58  86  130  195  291  438  
         if (TREND){ // положение индюка относительно нулевой линии (ATR для гистерезиса)
            x0=iCustom(SYMBOL,0,"0DM",0,indper,PerCnt,0,bar);
            if (x0> ATR) Up=1; 
            if (x0<-ATR) Dn=1; 
            }
         if (SIGNAL){ // отскоки DM от максимального / минимального значений на ATR
            temp=ATR;
            if (K==1 || K==3 || K==5 || K== 7 || K==9){
               x0=iCustom(SYMBOL,0,"0DM",0,indper,PerCnt,0,bar);
               x1=iCustom(SYMBOL,0,"0DM",0,indper,PerCnt,0,bar+1);
               x2=iCustom(SYMBOL,0,"0DM",0,indper,PerCnt,2,bar); // max
               x3=iCustom(SYMBOL,0,"0DM",0,indper,PerCnt,3,bar); // min
               if (x3<-temp*2 && x0-x3>temp && x1-x3<=temp) Up=1; // отскок от минимума 
               if (x2> temp*2 && x2-x0>temp && x2-x1<=temp) Dn=1;
               }
            else{  // отскоки Momentum от максимального / минимального значений на ATR
               x0=iCustom(SYMBOL,0,"0DM",3,indper,PerCnt,0,bar);
               x1=iCustom(SYMBOL,0,"0DM",3,indper,PerCnt,0,bar+1);
               x2=iCustom(SYMBOL,0,"0DM",3,indper,PerCnt,2,bar); // max
               x3=iCustom(SYMBOL,0,"0DM",3,indper,PerCnt,3,bar); // min
               if (x3<-temp*2 && x0-x3>temp && x1-x3<=temp) Up=1; // отскок от минимума 
               if (x2> temp*2 && x2-x0>temp && x2-x1<=temp) Dn=1;
            }  }
      break; ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  
      case 6: // Фракталы ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////   
         if (TREND){// Тренд фракталу на базе HL
            x0=iCustom(SYMBOL,0,"0OSC",5,HL,PeriodCount(K),PerCnt,0,bar);    // если последняя сформированная вершина Lo, то тренд ВВЕРХ...
            if (x0>0) Up=1; else Dn=1;           
            }    
         if (SIGNAL){// сигнал = фрактал
            x3=ATR*K*0.2; // постоянная удаления вершины от краев (отсеиваем плоские фракталы)
            K++;
            x0=High[K+1]; // вершина
            x1=High[iHighest(SYMBOL,0,MODE_HIGH,K,1)];  // правая половина фрактала
            x2=High[iHighest(SYMBOL,0,MODE_HIGH,K,K+2)];// левая половина
            if (x0>x1  && x0>x2 && Close[1]<x0-x3 && Open[K*2+1]<x0-x3) Dn=1; // "чистый фрактал" (одна вершина, достаточно удаленная от краев)
            x0=Low [K+1];
            x1=Low [iLowest (SYMBOL,0,MODE_LOW, K,1)];
            x2=Low [iLowest (SYMBOL,0,MODE_LOW, K,K+2)];
            if (x0<x1 && x0<x2 && Close[1]>x0+x3 && Open[K*2+1]>x0+x3) Up=1;
            }     
      break; /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 

      case 7:// Тренд Momentum. Сигнал на разрыве, или оч длинном баре, а так же по моментуму //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////     
         if (TREND){ // Классический моментум
            indper=NormalizeDouble(MathPow(1.5,K+6),0)*PerAdapter; // 17  26  38  58  86  130  195  291  438
            x0=iCustom(SYMBOL,0,"0DM",3,indper,PerCnt,0,bar); 
            if (x0>0) Up=1; else Dn=1;
            }
         if (SIGNAL){//сигнал на разрыве, или оч длинном баре 
            if (K==2 || K==4 || K==6 || K==8){
               x0=ATR*(0.5+K*0.3); // 1.1  1.4  2.3  2.9
               x1=Open[bar-1]; // открытие нулевого бара
               x2=Open[bar]; 
               if (x1-x2>x0) Up=1; // наличие разрыва, или оч длинного бара
               if (x2-x1>x0) Dn=1;
               }
            else{
               indper=NormalizeDouble(MathPow(1.5,K+6),0)*PerAdapter; // 17  26  38  58  86  130  195  291  438
               x0=iCustom(SYMBOL,0,"0DM",3,indper,PerCnt,2,bar); // max
               x1=iCustom(SYMBOL,0,"0DM",3,indper,PerCnt,3,bar); // min
               x2=iCustom(SYMBOL,0,"0DM",3,indper,PerCnt,2,bar+1); // max
               x3=iCustom(SYMBOL,0,"0DM",3,indper,PerCnt,3,bar+1); // min
               if (x0> ATR*(2+K*0.5) && x0>x2) Up=1; 
               if (x1<-ATR*(2+K*0.5) && x1<x3) Dn=1;
            }  } 
      break; ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////       

      case 8: // сужение/расширение канала HL относительно предыдущих значений ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
         if (K<6) x0=(K+3)*0.1; // x0= 0.4  0.5  0.6  0.7  0.8
         else x0=(14-K)*0.1;    // x0= 0.8  0.7  0.6  0.5  
         if (TREND){     
            x1=iCustom(SYMBOL,0,"0OSC",1,HL,iHL,PerCnt,1,bar);    // Последний диапазон HL
            x2=iCustom(SYMBOL,0,"0OSC",1,HL,iHL,PerCnt,0,bar);    // Cреднее значение N диапазонов HL (N=30 - задается внутри индюка от балды). Tренд при сужении/расширении канала HL относительно среднестатистического значения  
            }
         if (SIGNAL){ 
            x1=iCustom(SYMBOL,0,"0OSC",1,HL,iHL,PerCnt,1,bar);    // Последний диапазон HL
            x2=iCustom(SYMBOL,0,"0OSC",1,HL,iHL,PerCnt,1,bar+1);  // ПредПоследний диапазон HL. сигнал при сужении/расширении канала HL относительно предыдущего значения, 
            }
         if (x1<=0) x1=1*Point; // для избежания
         if (x2<=0) x2=1*Point;  // деления на ноль   
         if (K<6) {if (x1/x2<x0)  {Up=1; Dn=1;}} // при сужении  диапазона   HL в  x0  раз    
         else     {if (x2/x1<x0)  {Up=1; Dn=1;}} // при расширении диапазона HL в  x0  раз
      break; /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 

      case 9: // тренд при сужении/расширенни зафиксированного диапазона HL относительно ATR, Сигналы при образовании новых экстремумов,        
         if (TREND){ // в отличии от п.5 HL считается по другой формуле
            H1=iCustom(SYMBOL,0,"0OSC",3,HL,iHL,PerCnt,1,bar); // Значение последнего максимума 
            L1=iCustom(SYMBOL,0,"0OSC",3,HL,iHL,PerCnt,0,bar); // Значение последнего минимума
            if (K<6) {x0=(K+3)*(K+3)*0.1; if ((H1-L1)/ATR<x0) {Up=1; Dn=1;}} // при сужении  диапазона HL до значения=ATR*  1.6  2.5  3.6  4.9  6.4
            else     {x0=(K+1)*(K+1)*0.1; if ((H1-L1)/ATR>x0) {Up=1; Dn=1;}} // при расширении диапазона HL до значения=ATR* 4.9  6.4  8.1  10  
            }
         if (SIGNAL){
            H1=iCustom(SYMBOL,0,"0OSC",4,HL,iHL,PerCnt,1,bar); // Значение последнего максимума
            L1=iCustom(SYMBOL,0,"0OSC",4,HL,iHL,PerCnt,0,bar); // Значение последнего минимума
            H2=iCustom(SYMBOL,0,"0OSC",4,HL,iHL,PerCnt,1,bar+1);
            L2=iCustom(SYMBOL,0,"0OSC",4,HL,iHL,PerCnt,0,bar+1);
            if (K<6){ // x0= 0.75  0.6  0.45  0.3  0.15 
               x0=(H2-L2)*(6-K)*0.15;
               if (L1>L2+x0) Up=1; // сформировался очередной минимум выше предыдущего 
               if (H1<H2-x0) Dn=1; // сформировался очередной максимум ниже предыдущего 
               }
            else{ // x0= 0.15  0.3  0.45  0.6 
               x0=(H2-L2)*(K-5)*0.15;
               if (L1<L2-x0) Up=1; // сформировался очередной минимум ниже предыдущего  
               if (H1>H2+x0) Dn=1; // сформировался очередной максимум выше предыдущего
               }
            x1=H1; x2=L1;   
            }   
      break;/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
 
      case 10:// Тренд на сужении/расширении HL, измеренном в ATR, сигнал по VolumeCluster       
         if (TREND){ 
            if (K<6) {x0=ATR*(K+2)*0.5; if ((H-L)<x0) {Up=1; Dn=1;}} // при сужении  диапазона HL до значения=ATR*  1.5  2  2.5  3  3.5
            else     {x0=ATR*(K-4)*1.5; if ((H-L)>x0) {Up=1; Dn=1;}} // при расширении диапазона HL до значения=ATR* 3  4,5  6  7.5
            x1=H1; x2=L1;
            }  
         if (SIGNAL){  // Свечные фигуры "Повешаннй" и "Надгробие". Тактика определения - VolumeCluster http://gproxyru.appspot.com/http/forex-vc.ru/index.html
            indper=(PerCnt+1)*2-1; // indper=1 3 5
            H1 =iCustom(SYMBOL,0,"0HL",8,K,indper,0,bar); // 
            L1 =iCustom(SYMBOL,0,"0HL",8,K,indper,1,bar);
            x0 =iCustom(SYMBOL,0,"0HL",8,K,indper,2,bar); // Сигнал (точка на графике)
            if (x0==L1) Up=1;
            if (x0==H1) Dn=1; 
            x1=H1; x2=L1; 
            }    
      break;////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      
      case 11: // сигнал, тренд по сужению/расширению ATR /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  
         x1=atr;  x2=ATR;
         if (x1<=0 || x2<=0) break;
         if (K<6) {x0=(K+4)*0.1;  if (x1/x2<x0) {Up=1; Dn=1;}}  // при уменьшении atr в   0.5  0.6  0.7  0.8  0.9
         else     {x0=(15-K)*0.1; if (x2/x1<x0) {Up=1; Dn=1;}}  // при увеличении atr в   0.9  0.8  0.7  0.6      
      break; ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  
      default: //  без всяких фильтров  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
         Up=1; Dn=1; 
      break; ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      }
      
   if (Check){  // сохраним значения индюков для сравнения Real / Test ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      switch(SigMode){
         case 1:
            PS[0]=x0; // Tr0 
            PS[1]=x1; // Tr1
            PS[2]=x2; // Tr2
            PS[3]=x3; // Tr3
         break;   
         case 2:
            PS[4]=x0; // In0
            PS[5]=x1; // In1
            PS[6]=x2; // In2
            PS[7]=x3; // In3
         break;   
         case 3:
            PS[8] =x0; // Out0
            PS[9] =x1; // Out1
            PS[10]=x2; // Out2
            PS[11]=x3; // Out3
         break;     
   }  }  }

