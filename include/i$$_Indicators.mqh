


// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ 
//                                        D I R E C T     M O V E N T 
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ                             
float DM, DM1, DMmax,DMmin, DMmax1, DMmin1;
int BarDM=1;
void iDM(int DmMode, int per){//      MODE=0..3, per=1..10
   for (int B=Bars-BarDM; B>=bar; B--){ // чтобы функция не была чусвстительна к пропуску бар в следствии нерегулярного подключеия к графику 
      BarDM=Bars-bar+1;   //     Print
      if (B+per>=Bars) return;
      float Noise=0, Line=0, Delta=0, UP=0, DN=0, MO=0; 
      DM1=DM; 
      switch (DmMode){
         case 0: // Classic
            DM=0;
            for (int b=B; b<B+per; b++){ 
               if (High[b]>High[b+1]) DM+=float(High[b]-High[b+1]);
               if (Low[b] <Low [b+1]) DM+=float(Low [b]-Low [b+1]); 
               }
         break;
         case 1: // Signal / Noise
            for (int b=B; b<B+per; b++)  Noise+=MathAbs(float(High[b]+Low[b]+Close[b])/3 - float(High[b+1]+Low[b+1]+Close[b+1])/3); 
            if (Noise>0) DM = (float(High[B]+Low[B]+Close[B])/3 - float(High[B+per]+Low[B+per]+Close[B+per])/3) / Noise;  
         break;
         case 2: // UpIntegral - DnIntegral
            MO=float(Close[B]-Close[B+per])/per; // Momentum
            for (int b=B; b<B+per; b++){ 
               Line=float(Close[B])-MO*(b-B); // расчетное значение цены на прямой B..(B+per) знак "-", т.к. считаем с зада на перед
               Delta=float(Close[b])-Line;
               if (Delta>0) DN+=Delta; else UP-=Delta;
               }
            DM=UP-DN;
         break;
         case 3: // Momentum
            DM=float(Open[B]-Open[B+per]);
         break;
         }
      if ((DM>=0 && DM1<0) || (DM<=0 && DM1>0)) {DMmax=0; DMmin=0;}
      if (DM>DMmax) DMmax=DM;
      if (DM<DMmin) DMmin=DM; 
   //Print(TimeToStr(Time[bar],TIME_DATE | TIME_MINUTES)," DM=",DM," Min=", DMmin," Max=",DMmax);   
   }  }  
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ 
//                                        H I  /  L O 
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ                              
short BarsInDay, SessionBars, HLper, HLwid, HLtrend, daybar, DayBar=0; 
int   BarHL=1; // счетчик посчитанных бар
float H,H1,L,L1,C,C1, MaxHI=(float)High[Bars-1], MinLO=(float)Low [Bars-1], 
      HI, LO, HI1, LO1, HI2, LO2, HI3, LO3, VolClaster, StpHi, StpLo;
void HL_init(){
   double Adpt=60/Period(); // адаптация периода индикатора к таймфрейму
   HLper=1; HLwid=1;
   switch (HL){ // в зависимости от случая, меняются либо HLper, либо HLwid. По умолчанию они равны 1. 
      case 1:  HLper=short(MathPow(HLk,1.7)*Adpt);    break; // При пробитии одного из уровней ищутся ближайшие фракталы шириной HLper бар. 
      case 2:  HLwid=short(HLk*Adpt);                 break; // При пробитии одного из уровней ищутся фракталы шириной HLper=1 далее ATR*HLwid от текущей цены
      case 3:  HLwid=short((HLk+1)*Adpt);             break; // Формирование хая на ближайшем фрактале(1) при удалении на ATR*HLwid от последнего лоу
      case 4:  HLwid=short((HLk)*Adpt);               break; // При пробое Н ищется LO далее HLwid*ATR от текущей цены 
      case 5:  HLper=short(MathPow(HLk,1.7)*Adpt);    break; // Фракталы шириной HLper бар. 
      case 6:  HLper=short(MathPow(HLk,1.7)*Adpt);    break; // При пробое, либо после формирования фрактала ищутся фракталы шириной HLwid не ближе чем ATR от текущей цены.
      case 7:  HLper=short(MathPow(HLk+1,1.7)*Adpt);  break; // экстремумы на заданном периоде
      case 8:  HLper=short((HLk-1)*3*Adpt);           break; // Hi/Lo за 24+HLper часов
      case 9:  HLper=1; 
               VolClaster=float((13-HLk)*0.03);       break; // при N=1..9, Delta=36%-12%, (25% у автора)int(HLk*Adpt);                //  
      default: HLper=short((HLk+1)*Adpt);             break;
      }
   //Print("init iHILO: ",TimeToStr(Time[1],TIME_DATE | TIME_MINUTES)," HLper=",HLper," HLwid=",HLwid," Bars=",Bars," Time[bars]=",TimeToStr(Time[Bars-1],TIME_DATE | TIME_MINUTES)," VolClaster=",VolClaster);  
   BarsInDay=short(24*60/Period());
   SessionBars=short(HLper*Adpt)+BarsInDay;   // кол-во бар с начала текущей сессии для (2)
   }
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ                             
void iHILO(){      
   for (int B=Bars-BarHL; B>=bar; B--){ // чтобы функция не была чусвстительна к пропуску бар в следствии нерегулярного подключеия к графику 
      BarHL=Bars-bar+1;   //     Print("bar=",bar," B=",B," BarHL=",BarHL," ATR=",ATR," Bars=",Bars," Time[B]=",TimeToStr(Time[B],TIME_DATE | TIME_MINUTES));
      HI3=HI2; HI2=HI1; HI1=HI; LO3=LO2; LO2=LO1; LO1=LO;  H1=H; L1=L; C1=C; 
      H=float(High[B]); 
      L=float(Low [B]);
      C=float(Close[B]);
      if (H>=MaxHI)   {MaxHI=H; HI=H;}// обновление абсолютного  пика
      if (L<=MinLO)   {MinLO=L; LO=L;}  
      if (B+HLper>=Bars) continue;
      float o,h,l,c;
      float Delta=ATR*HLwid; 
      //if (Magic==141020590) Print("time[",B,"]=",BTIME(B)," BarHL=",BarHL," Delta=",Delta," H=",H," HI=",HI," LO=",LO," HLwid=",HLwid," HLper=",HLper);
      // STOP / TRAILING count
      if (H>=StpHi || L<=StpLo){  // пробой одной из границ
         float maxHi=float(High[B]), minLo=float(Low[B]), STOP=float(ATR*S);
         for (int b=B; b<Bars-HLper; b++){
            if (Low[b]<minLo) minLo=float(Low[b]); // максимальная величина движения вниз из High[b] 
            if (FIND_HI(B,b,1,StpHi,High[b]-minLo>STOP))   break; // ближайший фрактал сверху шириной 1 удаленный на STOP
            }
         for (int b=B; b<Bars-HLper; b++){
            if (High[b]>maxHi) maxHi=float(High[b]);// минимальная величина движения вверх из Low[b] 
            if (FIND_LO(B,b,1,StpLo,maxHi-Low[b]>STOP))    break; // любой фрактал ниже текущей цены на STOP
         }  }
      // HI / LO  count   
      switch (HL){
         case 1: // Nearest F(HLper). При пробое одного из уровней ищутся ближайшие фракталы шириной HLper бар. 
            if (H>=HI || L<=LO){   // пробитие одной из границ канала
               for (int b=B; b<Bars-HLper; b++)   if (FIND_HI(B,b,HLper,HI,true)) break; // поиск ближайшего фрактала шириной HLper
               for (int b=B; b<Bars-HLper; b++)   if (FIND_LO(B,b,HLper,LO,true)) break; //
               }
         break; 
         case 2: // Distant F(1). При пробое одного из уровней ищутся фракталы шириной per=2 далее ATR*HLper от текущей цены 
            if (H>=HI || L<=LO){   // пробитие одной из границ канала
               for (int b=B; b<Bars-HLper; b++)   if (FIND_HI(B,b,HLper,HI,High[b]-L>Delta)) break; // поиск ближайшего фрактала шириной per=1 при условии, что он будет удален на ATR*HLper
               for (int b=B; b<Bars-HLper; b++)   if (FIND_LO(B,b,HLper,LO,H-Low [b]>Delta)) break; //
               }      
         break;       
         case 3: // HLtrend Distance F(1). Формирование хая на ближайшем фрактале(1) при удалении на ATR*HLwid от последнего лоу
            if (HLtrend<=0){ // при нисходящем тренде
               if (L<=LO)  // при пробитии LO
                  for (int b=B; b<Bars-HLper; b++)   if (FIND_LO(B,b,HLper,LO,true)) break; // ищем ниже ближайший фрактал шириной HLper=1
               if (H>LO+Delta){// отдаление от нижней границы
                  HLtrend=1; 
                  for (int b=B; b<Bars-HLper; b++)   if (FIND_HI(B,b,HLper,HI,true)) break; // ближайший фрактал сверху шириной HLper=1
               }  }        
            if (HLtrend>=0){ // Тренд вверх
               if (H>=HI) // при пробитии HI
                  for (int b=B; b<Bars-HLper; b++)   if (FIND_HI(B,b,HLper,HI,true)) break; // ищем выше ближайший фрактал шириной HLper=1
               if (L<HI-Delta){ // при отдалении от верхней границы
                  HLtrend=-1;
                  for (int b=B; b<Bars-HLper; b++)   if (FIND_LO(B,b,HLper,LO,true)) break; // ближайший снизу фрактал шириной HLper=1
               }  }    
         break;             
         case 4: // Power HiLo - При пробое Н ищется LO далее HLper*ATR от текущей цены 
            if (H>=HI || L<=LO){  // пробой одной из границ
               float maxHi=float(High[B]), minLo=float(Low[B]);
               for (int b=B; b<Bars-HLper; b++){
                  if (Low[b]<minLo) minLo=float(Low[b]); // максимальная величина движения вниз из High[b] 
                  if (FIND_HI(B,b,HLper,HI,High[b]-minLo>Delta))   break; // ближайший фрактал сверху шириной 1 удаленный на Delta
                  }
               for (int b=B; b<Bars-HLper; b++){
                  if (High[b]>maxHi) maxHi=float(High[b]);// минимальная величина движения вверх из Low[b] 
                  if (FIND_LO(B,b,HLper,LO,maxHi-Low[b]>Delta))    break; // любой фрактал ниже текущей цены на Delta
               }  }
         break;
         case 5: // Classic F(HLper). Фракталы шириной HLper бар. 
            if (B+HLper>=Bars) break;
            if (H>=HI){ for (int b=B; b<Bars-HLper; b++)   if (FIND_HI(B,b,HLper,HI,true)) break;} // при пробое верхней границы ищем ближайший фрактал шириной HLper
            else{       if (High[B+HLper]==High[iHighest(NULL,0,MODE_HIGH,HLper*2+1,B)])  HI=float(High[B+HLper]);} // сформировался фрактал шириной HLper
            if (L<=LO){ for (int b=B; b<Bars-HLper; b++)   if (FIND_LO(B,b,HLper,LO,true)) break;} 
            else{       if (Low[B+HLper] ==Low [iLowest (NULL,0,MODE_LOW ,HLper*2+1,B)])  LO=float(Low [B+HLper]);}
         break;
         case 6:  // 
            if (H>=HI || High[B+HLper]==High[iHighest(NULL,0,MODE_HIGH,HLper*2+1,B)]){ // пробой границы канала, либо новый фрактал шириной HLper 
               for (int b=B; b<Bars-HLper; b++)  if (FIND_HI(B,b,HLper,HI,High[b]-H>Delta)) break; // поиск фрактала шириной HLper не ближе чем ATR
               }
            if (L<=LO || Low [B+HLper]==Low [iLowest (NULL,0,MODE_LOW ,HLper*2+1,B)]){ // пробой границы канала, либо новый фрактал шириной HLper   
               for (int b=B; b<Bars-HLper; b++)  if (FIND_LO(B,b,HLper,LO,L-Low[b]>Delta)) break; // поиск фрактала шириной HLper не ближе чем ATR
               }
         break;       
         case 7: // HL_Classic 
            if (B+HLper+1>Bars) break;
            HI=H; LO=L;
            for (int b=B+1; b<=B+HLper; b++){
               if (High[b]>HI) HI=float(High[b]);
               if (Low[b]<LO)  LO=float(Low [b]);} 
         break;
         case 8: // DayBegin Hi/Lo за 24+HLper часов
            if (B+2>Bars) break;
            DayBar++;// номер бара с начала дня
            if (TimeHour(Time[B])<TimeHour(Time[B+1])) DayBar=0; // новый день = обнуляем номер бара с начала дня
            if (DayBar==HLper){// номер бара с начала дня совпал с заданным значением
               HI=float(High[iHighest(NULL,0,MODE_HIGH,SessionBars,B)]); // максимум с начала прошлой сессии до текущего бара
               LO=float(Low [iLowest (NULL,0,MODE_LOW ,SessionBars,B)]);
               } 
            if (HI<H) HI=H;
            if (LO>L) LO=L;      
         break;
         case 9: // VolumeCluster  Delta=(13-HLper)*0.03; // при HLper=1..9, Delta=36%-12%, (25% у автора)
            if (B+HLper+1>=Bars) break;  // 
            c=float(Close[B+1]);
            h=float(High [B+1]);
            l=float(Low  [B+1]);
            for (int b=B+1; b<=B+HLper+1; b++){
               if (High[b]>h) h=float(High[b]);
               if (Low [b]<l) l=float(Low [b]);
               o=float(Open[b]);
               if (h-l>ATR*1.5){//  Не работаем в узком диапазоне
                  if ((h-o)/(h-l)<VolClaster && (h-c)/(h-l)<VolClaster) {LO=l; HI=h;} // Нижний "Фрактал" (открытие и закрытие в верхней части Bar баров)
                  if ((o-l)/(h-l)<VolClaster && (c-l)/(h-l)<VolClaster) {LO=l; HI=h;} // верхний "фрактал"
               }  }  
            if (HI<H) HI=H;
            if (LO>L) LO=L;      
         break;
         default://
            HI=H; LO=L;
         break;   
         }
      iOSC();   
   }  }      
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ                             
float LocalMax, LocalMin;
bool FIND_HI(int B, int b, int width, float& NewHi, bool Condition){ // Поиск фрактала шириной width. Condition - доп. внешнее условие
   float h=float(High[b]);
   if (h==MaxHI){ // добрались до абсолютного максимума Print(" NewHi=MaxHI ",TimeToStr(Time[B],TIME_DATE | TIME_MINUTES),"      B=",B,"  ", " NewHi=",NewHi," High[B]=",High[B]," MaxHI=",MaxHI);
      NewHi=h;  return(true);}     // это будет искомый пик, дальше искать нет смысла 
   if (b==B) {LocalMax=h;   return(false);} // первый бар поиска, фиксируем максимальное значение на периоде поиска
   if (h>LocalMax){ LocalMax=h;} // цена должна быть максимальной на всем участке поиска
   if (h==LocalMax && High[b]==High[iHighest(NULL,0,MODE_HIGH,width+1,b)]){// максимальный пик и фрактал периодом width
      NewHi=h;  return(true && Condition);}   // пик найден Print(TimeToStr(Time[B],TIME_DATE | TIME_MINUTES),"      B=",B,"  ", " NewHi=",NewHi," High[B]=",High[B]);
   return (false); // пока не найдется новый фрактал выше текущего бара заданной ширины   
   } 
bool FIND_LO(int B, int b, int width, float& NewLo, bool Condition){
   float l=float(Low[b]);
   if (l==MinLO){
      NewLo=l; return(true);}
   if (b==B) {LocalMin=l;    return(false);}
   if (l<LocalMin) LocalMin=l;
   if (l==LocalMin && Low[b]==Low[iLowest (NULL,0,MODE_LOW ,width+1,b)]){
      NewLo=l; return(true && Condition);} // пока не найдется новый фрактал выше текущего бара заданной ширины
   return (false);    
   }            
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ  
//                                 L A Y E R S
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ  
float LayH4,LayH3,LayH2,LayH1,LayL4,LayL3,LayL2,LayL1,
      _HLC, _H, _L, _C;
int BarLayers=1; // счетчик посчитанных бар
void LAYERS(int Layer){
   int BarsToCount;
   for (int B=Bars-BarLayers; B>=bar; B--){ // чтобы функция не была чусвстительна к пропуску бар в следствии нерегулярного подключеия к графику 
      BarLayers=Bars-bar+1; // Print("bar=",bar," B=",B," BarLayers=",BarLayers," Bars=",Bars," Time[B]=",TimeToStr(Time[B],TIME_DATE | TIME_MINUTES));
      if (B+BarsInDay>=Bars) continue;
      if (Layer<3){
         if (TimeHour(Time[B])<TimeHour(Time[B+1])){  // ищем конец прошлого дня
            _H=float(High[iHighest(NULL,0,MODE_HIGH,BarsInDay,B)]);   // щитаем экстремумы
            _L=float(Low [iLowest (NULL,0,MODE_LOW ,BarsInDay,B)]);    // прошлого дня
            _C=float(Close[B+1]);                             // и его цену закрытия
            _HLC=(_H+_L+_C)/3;
            }
         if (Layer==0){// Camarilla Equation ORIGINAL
            LayH4=_C+(_H-_L)*float(1.1/2);    
            LayH3=_C+(_H-_L)*float(1.1/4);    
            LayH2=_C+(_H-_L)*float(1.1/6);  
            LayH1=_C+(_H-_L)*float(1.1/12);
            LayL4=_C-(_H-_L)*float(1.1/2);    
            LayL3=_C-(_H-_L)*float(1.1/4);    
            LayL2=_C-(_H-_L)*float(1.1/6);  
            LayL1=_C-(_H-_L)*float(1.1/12);  
            }
         if (Layer==1){ // Camarilla Equation My Edition
            LayH4=_C+(_H-_L)*4/4;    
            LayH3=_C+(_H-_L)*3/4;    
            LayH2=_C+(_H-_L)*2/4;  
            LayH1=_C+(_H-_L)*1/4;
            LayL4=_C-(_H-_L)*4/4;    
            LayL3=_C-(_H-_L)*3/4;    
            LayL2=_C-(_H-_L)*2/4;  
            LayL1=_C-(_H-_L)*1/4;  
            }
         if (Layer==2){// Метод Гнинспена (Валютный спекулянт-48, с.62)
            LayH1=_HLC; LayL1=_HLC;  
            LayH2=2*_HLC-_L;    
            LayL2=2*_HLC-_H;    
            LayH3=_HLC+(_H-_L);  
            LayL3=_HLC-(_H-_L);
            LayH4=LayH3; LayL4=LayL3;  
            }
      }else{ // if (Layer>=3) Метод Гнинспена (Валютный спекулянт-48, с.62), экстремум ищется не на прошлом дне, а на барах с 0 часов до Layer бара текущего дня
         if (Layer<24)  BarsToCount=Layer*60/Period();
         else           BarsToCount=  23 *60/Period();
         //if (B+BarsToCount+1>Bars) continue;
         daybar++;// номер бара с начала дня
         if (TimeHour(Time[B])<TimeHour(Time[B+1])) daybar=0; // новый день = обнуляем номер бара с начала дня
         if (daybar==BarsToCount){// номер бара с начала дня совпал с заданным значением
            _H=float(High[iHighest(NULL,0,MODE_HIGH,BarsToCount,B)]);
            _L=float(Low [iLowest (NULL,0,MODE_LOW,BarsToCount,B)]);
            _C=float(Close[B]);
            _HLC=(_H+_L+_C)/3;
            }   
         LayH1=_HLC; LayL1=_HLC;  
         LayH2=2*_HLC-_L;    
         LayL2=2*_HLC-_H;    
         LayH3=_HLC+(_H-_L);  
         LayL3=_HLC-(_H-_L);
         LayH4=LayH3; 
         LayL4=LayL3; //   Print("Layer=",Layer," LayH1=",LayH1," LayL1=",LayL1," LayH2=",LayH2," LayL2=",LayL2," LayH3=",LayH3," LayL3=",LayL3); 
   }  }  }
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ  
//                                           O S C
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ 
#define OscN  30 // количество диапазонов HL для усреднения
float hl[OscN+1],Osc0=0, Osc1=0, Osc2=0;
void iOSC(){
   float hlc=0;
   Osc2=Osc1; // предыдущий диапазон HL 
   if (hl[0]!=HI-LO){// сформировался новый диапазон HL
      Osc0=0;
      hl[0]=HI-LO;   // обновим последний диапазон
      for (int b=OscN; b>0; b--){
         hl[b]=hl[b-1]; // пересортируем массив, чтобы новое значение было с индексом 1 
         Osc0+=hl[b];   // за одно посчитаем сумму всех значений
         }
      Osc0=Osc0/OscN; // посчитаем среднее N диапазонов без учета последнего диапазона
      }
   Osc1=hl[0]; // Последний диапазон HL
   }    
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ  
//                                           O S C
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ    
struct INDIVIDUAL_VARIABLES{// данные эксперта
   float atr, ATR, Lim, Present;
   float DM, DMmax, DMmin;             // for iDM()
   float  HI, HI1, HI2, LO, LO1, LO2;  // for iHILO()
   float  H, L, C;                     // for iHILO()
   float _HLC, _H, _L, _C;             // for LAYERS()
   float StpHi, StpLo;                 // for Input(),Trailing(), Output()
   float Osc0,Osc1,hl[OscN+1];         // for iOSC()
   short HLtrend, DayBar, daybar;
   int BarDM, BarHL, BarLayers;
   } v[MAX_EXPERTS_AMOUNT];      

void LOAD_VARIABLES(ushort e){// восстановление индивидуальных переменных для эксперта "e" (HI,LO,DM,DayBar) на каждом баре в режиме последовательного запуска на реале
   if (!Real) return;
   atr=v[e].atr;           ATR=v[e].ATR;        Lim=v[e].Lim;        Present=v[e].Present;
   DM=v[e].DM;             DMmax=v[e].DMmax;    DMmin=v[e].DMmin; 
   HI=v[e].HI;             HI1=v[e].HI1;        HI2=v[e].HI2;        LO=v[e].LO;  LO1=v[e].LO1;  LO2=v[e].LO2; 
   H=v[e].H;               L=v[e].L;            C=v[e].C;
   _HLC=v[e]._HLC;         _H=v[e]._H;          _L=v[e]._L;          _C=v[e]._C;
   StpHi=v[e].StpHi;       StpLo=v[e].StpLo;
   Osc0=v[e].Osc0;         Osc1=v[e].Osc1;      for (int i=0; i<=OscN; i++)  hl[i]=v[e].hl[i];
   HLtrend=v[e].HLtrend;   DayBar=v[e].DayBar;  daybar=v[e].daybar;
   BarDM=v[e].BarDM;       BarHL=v[e].BarHL;    BarLayers=v[e].BarLayers; 
   if (BarHL==0) BarHL=1; // при инициализации значение должно быть >0    
   }

void SAVE_VARIABLES(ushort e){// сохранение индивидуальных переменных для эксперта "e" (HI,LO,DM,DayBar) на каждом баре в режиме последовательного запуска на реале
   if (!Real) return;
   v[e].atr=atr;           v[e].ATR=ATR;        v[e].Lim=Lim;        v[e].Present=Present;
   v[e].DM=DM;             v[e].DMmax=DMmax;    v[e].DMmin=DMmin;
   v[e].HI=HI;             v[e].HI1=HI1;        v[e].HI2=HI2;        v[e].LO=LO;  v[e].LO1=LO1;  v[e].LO2=LO2;
   v[e].H=H;               v[e].L=L;            v[e].C=C;
   v[e]._HLC=_HLC;         v[e]._H=_H;          v[e]._L=_L;          v[e]._C=_C; 
   v[e].StpHi=StpHi;       v[e].StpLo=StpLo;
   v[e].Osc0=Osc0;         v[e].Osc1=Osc1;      for (int i=0; i<=OscN; i++) v[e].hl[i]=hl[i];
   v[e].HLtrend=HLtrend;   v[e].DayBar=DayBar;  v[e].daybar=daybar;
   v[e].BarDM=BarDM;       v[e].BarHL=BarHL;    v[e].BarLayers=BarLayers;     
   }
     