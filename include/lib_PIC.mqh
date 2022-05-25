#define  P        0  // цена
#define  T        1  // Time[bar] врем€ возникновени€ нового пика
#define  CONCUR   2  // concur - совпадение уровней
#define  TRND     3  // трендовый уровень нового пика
#define  FRNT     4  // величина переднего фронта  уровн€ (развернутого им движени€)
#define  DIR      5  // направление фрактала: 1=¬≈–Ў»Ќј, -1=¬ѕјƒ»Ќј
#define  BACK     6  // величина заднего фронта уровн€ (инициированного им движени€)
#define  PER      7  // период фрактала (на котором он фракталит)
#define  ExTIME   8  // врем€ начала движени€, которое развернул уровень.
#define  LIVE     9  // 1-активный уровень (отображаетс€ на графике); 0-псевдо удаленный, остаетс€ в массиве лишь дл€ сравнени€ с новыми дл€ построени€ флэтовых уровней.
#define  SAW     10  //  ол-во перепиливающих бар; признак "пробитости" (!=0) и "зеркальности" (<0) уровн€.
//#define  ExPIC   11  // противоположный пик, из которого началось движение, развернутое новым пиком
 
double   HH, LL, HHH, LLL,
         FirstUp, FirstDn, FirstMiddle,// ѕервые уровни и уровень за серединкой
         FirstUpCenter, FirstDnCenter, // серединки первых уровней на продажу/покупку
         FirstUpPic, FirstDnPic,       // пиковые уровни первых уровней
         LastFirstUp, LastFirstDn, LastFirstUpPic, LastFirstDnPic, // прошлые значени€ первых уровней 
         MostVisited,                  // наиболее посещаемый уровень между первыми уровн€ми
         FlatHi, FlatLo,   // флэтовые уровни (при двойном касании)
         MovUp[5], MovDn[5],  // массивы движений, инициализируюст€ в init() на Movements членов
         TargetUp, TargetDn,  // цели движени€
         MidMovUp, MidMovDn,  // среднее значение нескольких пследних подобных движений
         HighestLo, // сама€ высока€ впадина на пробой
         LowestHi,  // сама€ низка€ вершина на пробой
         UP1, DN1, // ближайшие уровни
         UP2, DN2, // флэтовые уровни с FlatPwr отскоками
         UP3, DN3, DN3Pic, UP3Pic, UpCenter, DnCenter; // трендовые уровни, их пики и серединки       
int   Tup1,Tdn1,Tup2,Tdn2, // врем€ формировани€ уровней UP1,...DN2  
      LevelsAmount=50, TrendLevels[5], TrLevCnt=0, // массив с последними п€тью трендовыми уровн€ми дл€ вычислени€ стопа и счетчик перебора членов  
      LEV[1][11], u1, u2, u3, d1, d2, d3, um, dm, // индексы массива уровней UP1..DN3
      intH, intL,  // HH и LL текущего бара дл€ сравнени€
      Movements=3,  //  ол-во последних движений дл€ определени€ измеренного движени€ (должно быть не меньше 3)
      FirstLevPower, // сила первого уровн€ =  величина движени€, которую должен развернуть уровень, чтобы стать первым
      TrendLevBreakUp=0, TrendLevBreakDn=0, // факт пробо€ трендового уровн€ на продажу/покупку дл€ смены тренда. ѕри пробое уровн€ на продажу TrendLevBreakUp увеличиваетс€ на 1, а TrendLevBreakDn обнул€етс€. » наоборот
      TrLevPwr, BrokenLevels,  // ширина трендового на пробой и кол-во пробитых подр€д уровней дл€ определени€ тренда
      FlatTime, // минимальна€ продолжительность флэта в PIC(), либо врем€ от пробиваемой вершины до ложн€ка.  FlatTime=FltLen*Period()*60 (сек) 
      GlobalTrend; // тренд определ€емый пробоем первых (сильных) уровней на покупку/продажу 
datetime HiTime, LoTime, hiTime, loTime;
datetime FirstLevPer=0; // период поиска первых уровней. Ќа нем ищем пики, развернувшие самые большие движени€
datetime FirstUpTime, FirstDnTime,  // врем€ образовани€ первых уровней
         FlatHiTime,  FlatLoTime;   // врем€ формировани€ последнего пика флэта
datetime LastFlatBegin;             // врем€ начала последнего флэта          

struct PicLevels{  //  C “ – ”   “ ” – ј   P I C
   int   dir;  // направление дл€ мелких фракталов с периодом PicPer: 1-вершина, -1-впадина
   int   Dir;  // направление дл€ крупных фракталов с периодом LevPer: 1-вершина, -1-впадина
   int   Dir2;  // прошлое направление дл€ крупных фракталов с периодом LevPer: 1-вершина, -1-впадина
   int   Free; // освободившийс€ член 
   int   Pot;  // потенциал пика (например дл€ впадины): 0-понижающиес€ вершины (пик развернутого прошлой впадиной движени€ был выше), 1-повышающиес€ вершины,  2 -размах развернутого прошлым пиком движени€ был меньше.  
   double New; // последний из сформировавшихс€ мелких пиков
   double NEW; // последний из сформировавшихс€ крупных пиков
   double hi,lo,Hi,Lo;// верхние/нижние мелкие/крупные пики
   double hi2,lo2,Hi2,Lo2; // прошлые верхние/нижние мелкие/крупные пики
   double Atr;    // ATR дл€ вычислени€ уровней
   int    intAtr; // целый ј“–
   int    intLim; // целый допуск совпадени€ уровней
   int Impulse;   // сила импульса (скорость отскока) пика. >0 дл€ вершины и <0 дл€ впадины.
   double Lim;    // точность совпадени€ уровней
   } Pic; 
      
int PIC_INIT(){
   if (PicPer<1 || LevPer<1) {Print("PIC_INIT(): PicPer=",PicPer," LevPer=",LevPer,". Must be >0"); return(INIT_FAILED);}
   if (TrLevBrk>0) TrLevPwr=LevPer; else TrLevPwr=PicPer;  // ширина трендового на пробой дл€ определени€ тренда
   BrokenLevels=MathAbs(TrLevBrk); // кол-во пробитых подр€д трендовых уровней дл€ определени€ тренда
   ArrayResize(LEV,LevelsAmount);// массив с фракталами
   ArrayResize(MovDn,Movements); // массив с цел€ми безоткатных движений
   ArrayResize(MovUp,Movements); // массив с цел€ми безоткатных движений
   FlatTime=FltLen*Period()*60; // продолжительность флэта (сек), меньше которой он не защитываетс€ (сек)
   if (FirstLev<0) // в данном случае FirstLev - количество дней дл€ поиска первых уровней. ѕри FirstLev>=0 он обозначает кол-во дневных Atr=SlowAtr*2*(2+FirstLev) дл€ подсчета первых уровней.
      FirstLevPer=MathAbs(FirstLev)*BarsInDay; // кол-во бар в FirstLev дн€х дл€ поиска пиков, развернувших самые большие движени€
   Pic.Hi=High[bar]; 
   Pic.Lo=Low [bar];
   Print("PIC_INIT(): bar=",bar," Time[bar]=",TimeToString(Time[bar],TIME_DATE | TIME_MINUTES)," FirstLevBars=",MathAbs(FirstLev)*BarsInDay," FlatTime=",FlatTime/60,"min "); 
   return (INIT_SUCCEEDED); // "0"-”спешна€ инициализаци€. –езультат выполнени€ функции OnInit() анализируетс€ терминалом только если программа скомпилирована с использованием #property strict.
   } 
            
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆
void PIC(){// ќ—Ќќ¬Ќќ… ÷» Ћ ѕќ»— ј ”–ќ¬Ќ≈…
   Pic.New=0;
   HH =High[iHighest(NULL,0,MODE_HIGH,PicPer*2+1,bar)];   //  ороткие фракталы дл€ 
   LL =Low [iLowest (NULL,0,MODE_LOW ,PicPer*2+1,bar)];   // формировани€ уровней в NEW_LEVEL().
   HHH=High[iHighest(NULL,0,MODE_HIGH,LevPer*2+1,bar)];   // ѕолноценные фракталы дл€
   LLL=Low [iLowest (NULL,0,MODE_LOW ,LevPer*2+1,bar)];   // определени€ ложн€ков, тренда, ближайших и целевых уровней...
   intH  =int(High[bar]/Point);
   intL  =int(Low [bar]/Point);
   if (SlowAtr==0) return;
   // ћ ≈ Ћ   » ≈   ѕ »   »
   if (High[bar+PicPer]==HH){ // Ќовый мелкий hi  ///////////////////////////////////////////////////////
      Pic.New=HH; Pic.dir=1;     Pic.hi2=Pic.hi; Pic.hi=HH; hiTime=int(Time[bar+PicPer]);
      if (Target<0) TargetDn=Pic.hi-MidMovDn;// отмер€ем цель движени€ вниз от мелкого пика: Target=-2-крупнейшее движ. от мелкого пика; -1-среднее движ. от мелкого пика;
      NEW_LEVEL(); // ‘ќ–ћ»–ќ¬јЌ»≈ » ”ƒјЋ≈Ќ»≈ ”–ќ¬Ќ≈…
      }
   if (Low[bar+PicPer]==LL){ // Ќовый мелкий lo  /////////////////////////////////////////////////////////
      Pic.New=LL; Pic.dir=-1;    Pic.lo2=Pic.lo; Pic.lo=LL; loTime=int(Time[bar+PicPer]);
      if (Target<0) TargetUp=Pic.lo+MidMovUp;   // отмер€ем цель движени€ вверх от мелкого пика: Target=-2-крупнейшее движ. от мелкого пика; -1-среднее движ. от мелкого пика;
      NEW_LEVEL(); // ‘ќ–ћ»–ќ¬јЌ»≈ » ”ƒјЋ≈Ќ»≈ ”–ќ¬Ќ≈…
      }
   //   – ” ѕ Ќ џ ≈   ѕ »   »    // if (Prn) Print(ttt,"            Pic.Hi=",Pic.Hi," Pic.Hi2=",Pic.Hi2," intL=",intL, " HiTime=",TimeToString(HiTime,TIME_DATE | TIME_MINUTES));
   if (High[bar+LevPer]==HHH){// // Ќовый крупный Hi
      Pic.Hi2=Pic.Hi;  Pic.Hi=HHH; Pic.Dir2=Pic.Dir; Pic.Dir=1; HiTime=int(Time[bar+LevPer]); // 
      Pic.Impulse=int(((Pic.Hi-Low[bar+LevPer-1])+(Pic.Hi-Low[bar+LevPer+1]))/SlowAtr); // сила импульса, с которой цена отскакивает от уровн€
      TARGET_COUNT();// –ј—„≈“ ÷≈Ћ≈¬џ’ ”–ќ¬Ќ≈… ќ ќЌ„јЌ»я ƒ¬»∆≈Ќ»я Ќј ќ—Ќќ¬јЌ»» »«ћ≈–≈Ќ»я ѕ–≈ƒџƒ”ў»’ Ѕ≈«ќ“ ј“Ќџ’ ƒ¬»∆≈Ќ»… 
      if (Target>0) TargetDn=Pic.Hi-MidMovDn;// отмер€ем цель движени€ вниз от крупного пика:  Target=1-среднее от крупного пика; 2-крупнейшее от крупного пика
      } 
   if (Low[bar+LevPer]==LLL){// Ќовый крупный Lo
      Pic.Lo2=Pic.Lo; Pic.Lo=LLL;  Pic.Dir2=Pic.Dir; Pic.Dir=-1; LoTime=int(Time[bar+LevPer]);//
      Pic.Impulse=-int(((High[bar+LevPer-1]-Pic.Lo)+(High[bar+LevPer+1]-Pic.Lo))/SlowAtr); // сила импульса, с которой цена отскакивает от уровн€
      TARGET_COUNT();// –ј—„≈“ ÷≈Ћ≈¬џ’ ”–ќ¬Ќ≈… ќ ќЌ„јЌ»я ƒ¬»∆≈Ќ»я Ќј ќ—Ќќ¬јЌ»» »«ћ≈–≈Ќ»я ѕ–≈ƒџƒ”ў»’ Ѕ≈«ќ“ ј“Ќџ’ ƒ¬»∆≈Ќ»…
      if (Target>0) TargetUp=Pic.Lo+MidMovUp;   // отмер€ем цель движени€ вверх от крупного пика:  Target=1-среднее от крупного пика; 2-крупнейшее от крупного пика
      }
     
   if (Target==0) {TargetDn=High[bar]-MidMovDn; TargetUp=Low[bar]+MidMovUp;}// отмер€ем цели движени€ от текущего клоза вниз и вверх      
   LEVELS_FIND_AROUND(); // ѕ ќ » —     Ѕ Ћ » « Ћ ≈ ∆ ј ў » ’   ” – ќ ¬ Ќ ≈ …      
   TREND_DETECT();   // ќ ѕ – ≈ ƒ ≈ Ћ ≈ Ќ » ≈   “ – ≈ Ќ ƒ ј 
   // if (Prn) Print(TimeToString(Time[bar],TIME_DATE | TIME_MINUTES)," intH[",bar,"]=",intH," UP1=",UP1," DN1=",DN1);
   }
//void DAY_ATR(){// ƒ Ќ ≈ ¬ Ќ ќ …   ƒ » ј ѕ ј « ќ Ќ   « ј   ѕ ќ — Ћ ≈ ƒ Ќ » ≈   ѕ я “ №   ƒ Ќ ≈ … 
//   if (TimeHour(Time[bar])>TimeHour(Time[bar+1])) return; // новый день     
//   double DayHigh=High[iHighest(NULL,0,MODE_HIGH,BarsInDay,bar)], DayLow=Low[iLowest(NULL,0,MODE_LOW ,BarsInDay,bar)];
//   DayMov[DaysCnt]=DayHigh-DayLow; DaysCnt++; if (DaysCnt>=5) DaysCnt=0;
//   DayAtr=0; for (int i=0; i<5; i++) DayAtr+=DayMov[i]; DayAtr/=5; 
//   } //Print(ttt,"NewDay ","  ",TimeToString(Time[bar],TIME_DATE | TIME_MINUTES)," DayHigh-DayLow=",DayHigh-DayLow,"   ",NormalizeDouble(DayMov[0],Digits-1)," ",NormalizeDouble(DayMov[1],Digits-1)," ",NormalizeDouble(DayMov[2],Digits-1)," ",NormalizeDouble(DayMov[3],Digits-1)," ",NormalizeDouble(DayMov[4],Digits-1),"      DayAtr=",NormalizeDouble(DayAtr,Digits-1));    
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆      
void NEW_LEVEL(){// ‘ќ–ћ»–ќ¬јЌ»≈ » ”ƒјЋ≈Ќ»≈ ”–ќ¬Ќ≈…
   int New=int(Pic.New/Point);   // целочисленное Pic.New
   int f,j=0, Shift, From=bar, ppp; 
   datetime FrontTime=0;//¬рем€ начала переднего фронта - самого близкого из крупных противолежащих пиков к новому пику. Ќомер пи
   datetime ExBarTime=0;// врем€ ближайшшего превосход€щего бара перед новым (дл€ вершины - предыдущей вершины, дл€ впадины - предыдущей впадины)
   int ExPicTime=0;     // врем€ ближайшшего превосход€щего пика из массива...
   int ExPower=0;       // сила [FRNT] ближайшего превосход€щего пика. –азмах развернутого движени€.
   int ExPowerPic=0;    // дл€ впадины - противоположный пик развернутого прошлой впадиной движени€
   int OppositeTop;  // номер бара противоположна€ вершина, лежаща€ между новым и превосход€щим его пиками (дл€ определени€ движени€, остановленного пиком при поиске первых уровней)
   int Concur=1;     // кол-во совпадений пиков
   int Visits=FltPic; // минимальное кол-во посещений дл€ наиболее посещаемого уровн€
   datetime FlatBegin=Time[bar];// ¬рем€ начала флэта. ƒл€ начала берем врем€ нового пика
   bool ArrBreak; // флаг удалени€ из сортированного массива непроверенных членов, чтобы цикл "for" не "break" раньше времени
   double LevMiddle=Pic.New; // средний уровень совпавших пиков
   double lev; // lev=LEV[f][P]*Point
   int PicCnt=1; // счетчик вершин, сформировавших флэт
   Pic.Free=-1; // свободна€ €чейка
   MostVisited=0; // уровень с максимальным кол-вом посещений (>FlatPwr) в пределах первых уровней
   int LowestPowerCell=0, LowestPower=POWER(0); // номер €чейки и сила самого слабого уровн€ дл€ удалени€ на случай, если не найдетс€ свободной €чейки
   int OldestCell=0;    datetime OldestTime=Time[bar];  // номер и врем€ самой старой €чейки
   int DeletedCell=-1;  datetime DeletedTime=Time[bar]; // номер и врем€ самой старой удаленной €чейки
   bool  FirstDnFind=false; // факт обнаружени€ уровн€, чтоб не искать ниже 
   PIC_LIM(); // ќѕ–≈ƒ≈Ћ≈Ќ»≈ Pic.Atr, Pic.intAtr, Pic.Lim(допуск совпадени€ уровней)
   //if (Prn) Print(ttt,"              New=",New," intH=",intH," intL=",intL, " LowestPower=",LowestPower);
   for (f=0; f<LevelsAmount; f++){// перебираем весь массив фракталов от большего к меньшему
      if (LEV[f][P]==0) {Pic.Free=f; if (ArrBreak) continue; else break;} // break нельз€, т.к. на предыдущих f могут удал€тьс€ уровни ниже по списку
      if (LEV[f][T]<OldestTime) {OldestTime=LEV[f][T]; OldestCell=f;} // самый старый фрактал из действующих уровней на случай, если не найдетс€ свободных €чеек массива
      //if (POWER(f)<LowestPower) {LowestPower=POWER(f); LowestPowerCell=f;} // самый слабый уровень дл€ удалени€, если не найдетс€ свободных €чеек
      if (LEV[f][LIVE]==0 && LEV[f][T]<DeletedTime) {DeletedTime=LEV[f][T]; DeletedCell=f;}// самый старый из псевдоудаленных, в первую очередь писать лучше туда
      Shift=iBarShift(NULL,0,LEV[f][T],false); // сдвиг фрактала из массива относительно текущего (нулевого) бара
      lev=LEV[f][P]*Point; 
      // ќ ѕ – ≈ ƒ ≈ Ћ ≈ Ќ » ≈   ‘ Ћ Ё “ ј
      if (MathAbs(New-LEV[f][P])<Pic.intLim){// сравниваемые фракталы в пределах Lim
         LEV[f][CONCUR]++; Concur++;// поиск совпадающих уровней, увеличиваем кол-во совпадений
         if (Pic.dir==LEV[f][DIR] && //  поиск среди вершин, если впадина - среди впадин
            Time[bar+PicPer]-LEV[f][T]>FlatTime && // сформирован достаточно давно от нового пика
          ((Pic.dir>0 && int(High[iHighest(NULL,0,MODE_HIGH,Shift-bar+1,bar)]/Point)<New+Pic.intLim) || // между отобранным и новым пиками ничего не выступает
           (Pic.dir<0 && int(Low [iLowest (NULL,0,MODE_LOW ,Shift-bar+1,bar)]/Point)>New-Pic.intLim))){ // между отобранным и новым пиками ничего не выступает  
            PicCnt++; // количество совпавших вершин
            LevMiddle+=lev; // и их сумма дл€ усреднени€ 
            if (LEV[f][T]<FlatBegin) FlatBegin=LEV[f][T];  // самый старый пик, совпадающий с новым, чтобы провести между ними противоположную границу флэта    
         }  }//if (PicCnt>2) Print(TimeToString(Time[bar],TIME_DATE | TIME_MINUTES),":  New=",New,"  PicCnt=",PicCnt," FlatBegin=",TimeToString(LEV[f][T],TIME_DATE | TIME_MINUTES)," Htop=",High[iHighest(NULL,0,MODE_HIGH,Shift-bar+1,bar)]," Ltop=",Low [iLowest (NULL,0,MODE_LOW ,Shift-bar+1,bar)]);
      //if (Pic.dir==LEV[f][DIR] && MathAbs(New-LEV[f][TRND])<Pic.intLim) {LEV[f][CONCUR]++; Concur++;} // отскоки от трендовых уровней так же защитываютс€ за совпадени€
      // ѕќ»—  —јћќ√ќ ѕќ—≈ўј≈ћќ√ќ ”–ќ¬Ќя
      if (LEV[f][CONCUR]>Visits && lev<FirstUp && lev>FirstDn) {Visits=LEV[f][CONCUR]; MostVisited=lev;}
      // ѕќ»—  ЅЋ»∆ј…Ў≈√ќ ѕ–≈¬ќ—’ќƒяў≈√ќ ѕ» ј  
      if (Pic.dir==LEV[f][DIR] && LEV[f][T]>ExPicTime){// сравниваютс€ сонаправленные пики
         if (Pic.dir>0 && LEV[f][P]>New-Pic.intLim) {ExPicTime=LEV[f][T]; ExPower=LEV[f][FRNT]; ExPowerPic=LEV[f][P]-LEV[f][FRNT]; ppp=f;} // размеры развернутых движений, и
         if (Pic.dir<0 && LEV[f][P]<New+Pic.intLim) {ExPicTime=LEV[f][T]; ExPower=LEV[f][FRNT]; ExPowerPic=LEV[f][P]+LEV[f][FRNT]; ppp=f;} // их начала: дл€ впадины это вершина, дл€ вершины это дно. 
         }   
      // ”ƒјЋ≈Ќ»≈  —ЋјЅџ’  ”–ќ¬Ќ≈…, если после них по€вились более сильные (развернувшие большее движение)  
      if (MinPower==0){// удаление слабых уровней если если после них по€вились более сильные. ѕри MinPower>0 еще при создании удал€ютс€ уровни вел-на переднего фронта которых  меньше ј“–*MinPower
         for (j=f; j<LevelsAmount; j++){// сравним текущий фрактал с оставшимис€ ниже по списку, 
            if (LEV[j][DIR]!=LEV[f][DIR]) continue; // вершину сравниваем только с вершинами, впадину толко с впадинами
            if ((LEV[f][LIVE]>0 || DelSmall==true) && LEV[f][T]<LEV[j][T] && POWER(f)<POWER(j)){  // текущий фрактал не псевдоудаленный либо подлежит реальному удалению. ќн старше и слабее чем ниже по списку  //
               LEVEL_DELETE(f,DelSmall); break; // удал€ем текущий уровень, сравнивать больше нечего  if (Prn) Print(ttt,"DEL fLEV[",f,"] ",LEV[f][P],"  ",TimeToString(LEV[f][T],TIME_DATE | TIME_MINUTES)," fPOWER=",POWER(f),"    jLEV[",j,"] ",LEV[j][P],"  ",TimeToString(LEV[j][T],TIME_DATE | TIME_MINUTES)," jPOWER=",POWER(j)," ExBarTime=",TimeToString(LEV[j][ExTIME],TIME_DATE | TIME_MINUTES));
               }
            if ((LEV[j][LIVE]>0 || DelSmall==1) && LEV[f][T]>LEV[j][T] && POWER(f)>POWER(j)){  // фрактал ниже по списку не псевдоудаленный либо подлежит реальному удалению. ќн старше и слабее текущего  /
               LEVEL_DELETE(j,DelSmall); ArrBreak=1;  // удал€ем свер€емый уровень. —тавим флаг, чтобы цикл не прерывалс€ при первом попавшемс€ нулевом значении, т.к. после его удалени€ массив еще не отсортирован  if (Prn) Print(ttt,"DEL jLEV[",j,"] ",LEV[j][P],"  ",TimeToString(LEV[j][T],TIME_DATE | TIME_MINUTES)," jPOWER=",POWER(j),"    fLEV[",f,"] ",LEV[f][P],"  ",TimeToString(LEV[f][T],TIME_DATE | TIME_MINUTES)," fPOWER=",POWER(f)," ExBarTime=",TimeToString(LEV[j][ExTIME],TIME_DATE | TIME_MINUTES));
         }  }  } 
      if (LEV[f][SAW]==0){//  Ќ ≈   ѕ – ќ Ѕ » “ џ …  уровень (фронт>0)
         if (LEV[f][DIR]!=Pic.dir && MathAbs(New-LEV[f][P])>LEV[f][BACK]) LEV[f][BACK]=MathAbs(New-LEV[f][P]); // увеличение заднего фронта по мере удалени€ от пика 
      }else{            //  ѕ – ќ Ѕ » “ џ …   уровень   
         if (LEV[f][LIVE]==1 && ((DelSaw>0 && MathAbs(LEV[f][SAW])>DelSaw) || LEV[f][PER]<LevPer)){// неудаленный пик: кол-во перепиливших бар превысило допустимое или он слишком мелкий дл€ пробитого
            LEVEL_DELETE(f,0); continue;} // псевдо удаление перепиленного уровн€  X("DelSaw "+DoubleToStr(LEV[f][P],0)+"/"+DoubleToStr(LEV[f][SAW],0), LEV[f][P]*Point, clrGreen);  
         // ѕ–ќЅ»“»≈  ѕ–ќ“»¬ќѕќЋќ∆Ќџћ  ‘–ј “јЋќћ
         if (LEV[f][SAW]<0 && (LEV[f][LIVE]==1 || DelBroken>0) &&// уровень глубоко пробит и (не псевдоудален, либо подлежит реальному удалению)
            ((LEV[f][DIR]>0 && Pic.dir<0 && New<LEV[f][P]+Pic.intLim) || // пробита€ вверх вершина пробиваетс€ вниз 
             (LEV[f][DIR]<0 && Pic.dir>0 && New>LEV[f][P]-Pic.intLim))){ // зеркальной впадиной (и наборот), либо от зеркальной вершины происходит отскок в пределах допуска Lim (т.е. она отработана "с недолетом" и не нужна)
            LEVEL_DELETE(f,DelBroken); continue; // X("DelBroken "+DoubleToStr(LEV[f][P],0)+"/"+DoubleToStr(LEV[f][SAW],0), LEV[f][P]*Point, clrRed);
      }  }  }      
   if (Pic.Free<0){// если пустых €чеек уже нет,  
      if (DeletedCell>-1)  Pic.Free=DeletedCell; // если есть псевдоудаленные, берем самую старую из них (отработанные уровни, оставл€емые дл€ сравнени€, по которым не строитс€ график)  Print(TimeToString(Time[bar],TIME_DATE | TIME_MINUTES)," DeletedCell[",DeletedCell,"] ",LEV[DeletedCell][P],"  ",TimeToString(LEV[DeletedCell][T],TIME_DATE | TIME_MINUTES));} 
      else                 Pic.Free=OldestCell; // берем просто самую старую
      } 
   // ЅЋ»∆ј…Ў»… ѕ–≈¬ќ—’ќƒяў»… Ѕј–  (дл€ нахождени€ между ним и Pic.New противолежащего пика. ѕо нему находитс€ движение, которое развернул данный пик и повышающиес€/понижающиес€ пики
   if (Pic.dir>0){
      for (f=bar+PicPer+1; f<Bars; f++) {    // поиск на истории ближайшего по времени
         if (High[f]>High[bar+PicPer]) {ExBarTime=Time[f]; break;} // совпадающего по направлению (пик должен быть выше (или равен) нового)  if (Prn) Print(ttt,"1  ExBarTime=",TimeToString(ExBarTime,TIME_DATE | TIME_MINUTES));
   }}else{
      for (f=bar+PicPer+1; f<Bars; f++) {
         if (Low [f]<Low [bar+PicPer]) {ExBarTime=Time[f]; break;} // впадина должна быть ниже (или равна) новой
      }  }  
   Shift=iBarShift(NULL,0,ExBarTime,false);// сдвиг  превосход€щего пика
   LEV[Pic.Free][P]=New;            // пишем в свободную €чейку значение фрактала
   LEV[Pic.Free][T]=int(Time[bar+PicPer]);    // врем€ возникновени€ фрактала
   LEV[Pic.Free][CONCUR]=Concur; // живучесть = кол-во совпадений с предыдущими уровн€ми 
   if (Pic.dir>0){// вершина  
      LEV[Pic.Free][TRND]=int(Low [iHighest(NULL,0,MODE_LOW ,PicPer*2+1,bar)]/Point); // дл€ вершины трендовый уровень не продажу
      if (LEV[Pic.Free][P]-LEV[Pic.Free][TRND]>Pic.intAtr) LEV[Pic.Free][TRND]=LEV[Pic.Free][P]-Pic.intAtr;
      f=iLowest (NULL,0,MODE_LOW ,Shift-(bar+PicPer)+1,bar+PicPer);
      OppositeTop=int(Low [f]/Point); // противоположна€ впадина, лежаща€ между новым и превосход€щим его пиками (дл€ определени€ движени€, которое развернул данный пик) 
      LEV[Pic.Free][FRNT]=New-OppositeTop; // сила уровн€ (величина развернутого им движени€) = рассто€ние от нового пика до минимума, лежащего между новым пиком и превосход€щим его баром. 
      if (ExPowerPic<OppositeTop) Pic.Pot=0; else Pic.Pot=1; // Potential=0: повышающиес€ впадины (пик развернутого прошлой вершиной движени€ был ниже). Potential=1: понижающиес€ впадины 
      }
   else{          // впадина      
      LEV[Pic.Free][TRND]=int(High[iLowest (NULL,0,MODE_HIGH,PicPer*2+1,bar)]/Point); // дл€ впадины трендовый уровень на покупку
      if (LEV[Pic.Free][TRND]-LEV[Pic.Free][P]>Pic.intAtr) LEV[Pic.Free][TRND]=LEV[Pic.Free][P]+Pic.intAtr;
      f=iHighest(NULL,0,MODE_HIGH,Shift-(bar+PicPer)+1,bar+PicPer);
      OppositeTop=int(High[f]/Point);  // противоположна€ вершина, лежаща€ между новой и превосход€щей его впадинами (дл€ определени€ движени€, которое развернула данна€ впадина)
      LEV[Pic.Free][FRNT]=OppositeTop-New; // сила уровн€ (величина развернутого им движени€) = рассто€ние от нового пика до максимума, лежащего между новым пиком и превосход€щим его баром. 
      if (ExPowerPic>OppositeTop) Pic.Pot=0; else Pic.Pot=1; // Potential=0: понижающиес€ вершины (пик развернутого прошлой впадиной движени€ был выше).  Potential=1: повышающиес€ вершины 
      } 
   if (Pic.Pot>0 && LEV[Pic.Free][FRNT]>ExPower) Pic.Pot=2; // Potential=2 -размах развернутого прошлым пиком движени€ был меньше. Ќе гарантируетс€ пробитие предыдущего максимума
   
   int clr;
   switch(Pic.Pot){
      case 1: clr=clrRed; break;    // Potential=1 -размах развернутого прошлым пиком движени€ был больше. √арантируетс€ пробитие предыдущего максимума
      case 2: clr=clrGreen; break;  // Potential=2 -размах развернутого прошлым пиком движени€ был меньше. Ќе гарантируетс€ пробитие предыдущего максимума
      default: clr=clrGray;         // Potential=0: понижающиес€ вершины (пик развернутого прошлой впадиной движени€ был выше). 
      }
   //X("Pic.Pot="+DoubleToStr(Pic.Pot,0), Pic.New, clr);
   //if (Prn){ Print(ttt,"  ExTIME=",TimeToString(LEV[Pic.Free][ExTIME],TIME_DATE | TIME_MINUTES),"  OppositeTop=",OppositeTop*Point,"  [T]=",TimeToString(LEV[Pic.Free][T],TIME_DATE | TIME_MINUTES)," New=",New*Point," ppp=",ppp," ExPower=",ExPower," ExPicTime=",TimeToString(LEV[ppp][T],TIME_DATE | TIME_MINUTES)," ExPowerPic=",ExPowerPic*Point);
   //         LINE("Potential="+DoubleToString(Pic.Pot,0), int(iBarShift(NULL,0,LEV[ppp][T],false)), LEV[ppp][P]*Point, int(iBarShift(NULL,0,LEV[Pic.Free][T],false)), New*Point, clrRed);}     
   LEV[Pic.Free][DIR]=Pic.dir;  // направление фрактала: 1=¬≈–Ў»Ќј, -1=¬ѕјƒ»Ќј
   LEV[Pic.Free][BACK]=MathAbs(New-int(Close[bar]/Point));  // задний фронт (Fall) = кол-во пунктов от текущего до будущего крупного фрактала. Ѕудет постепенно увеличиватьс€ по мере удалени€ цены от уровн€
   LEV[Pic.Free][PER]=Shift-(bar+PicPer);   // период фрактала (на котором он фракталит). ¬ момент формировани€ равен кол-ву бар до превосход€щего пика. ¬ момент пробити€ может скорректироватьс€ в меньшую сторону.  if (Prn) Print(ttt," [PER]=",LEV[Pic.Free][PER],"  ExBarTime=",TimeToString(ExBarTime,TIME_DATE | TIME_MINUTES));
   LEV[Pic.Free][ExTIME]=int(Time[f]); // врем€ начала движени€, которое развернул уровень.
   LEV[Pic.Free][LIVE]=1;  // 1-активный уровень (отображаетс€ на графике), 0-был псевдо удален, т.е. не отображаетс€ на графике, а остаетс€ в массиве лишь дл€ сравнени€ с новыми дл€ построени€ флэтовых уровней.
   LEV[Pic.Free][SAW]=0;   //  ол-во перепиливающих бар; признак "пробитости" (!=0) и "зеркальности" (<0) уровн€. 
   Shift=iBarShift(NULL,0,LEV[Pic.Free][T],false);// точка отсчета      
   int FrPeriod=int(iBarShift(NULL,0,LEV[Pic.Free][ExTIME],false) - Shift); // ƒл€ Up пика: период от нового пика до предыдущего (выше или равного данному). “.е. если впоследствии сформируетс€ флэтовый уровень, можно будет проверить наличие повышающихс€ минимумов дл€ возможности продажи от него
   ArraySort (LEV,WHOLE_ARRAY,0,MODE_DESCEND); // отсортируем массив по убыванию (34, 23, 17, 8, 3, 0, 0, 0) 
   if (PicCnt<2) return; // не набралось совпавших вершин дл€ формировани€ флэта
    // ‘ Ћ Ё “
   Shift=iBarShift(NULL,0,FlatBegin,false); // сдвиг дальней вершины флэта   
   LastFlatBegin=FlatBegin;
   Trend=0;
   TrendLevBreakUp=0;   TrendLevBreakDn=0; // сброс кол-ва пробоев трендовых уровней дл€ формировани€ тренда
   if (Pic.dir>0){// сформирована вершина
      OppositeTop=iLowest (NULL,0,MODE_LOW ,Shift-(bar+PicPer)+1,bar+PicPer); // номер бара противоположной вершины флэта
      FlatHi=LevMiddle/PicCnt; // верхн€€ граница флэта
      FlatLo=Low [OppositeTop]; // минимум между крайними вершинами флэта
      FlatHiTime=Time[bar+PicPer];  // врем€ формировани€ последней вершины флэта дл€ проверки ложн€ка
      FlatLoTime=Time[OppositeTop]; // врем€ формировани€ противоположной вершины
   }else{ // сформирована впадина
      OppositeTop=iHighest(NULL,0,MODE_HIGH,Shift-(bar+PicPer)+1,bar+PicPer); // номер бара противоположной вершины флэта
      FlatLo=LevMiddle/PicCnt; // нижн€€ граница флэта - поддержка
      FlatHi=High[iHighest(NULL,0,MODE_HIGH,Shift-(bar+PicPer)+1,bar+PicPer)]; // максимум между двум€ впадинами
      FlatHiTime=Time[OppositeTop]; // врем€ формировани€ противоположной вершины
      FlatLoTime=Time[bar+PicPer];  // врем€ формировани€ последней вершины флэта дл€ проверки ложн€ка
   }  }//if (Prn) Print(ttt,"  Pic.dir=",Pic.dir," FlatHi=",FlatHi," ",TimeToString(FlatHiTime,TIME_DATE | TIME_MINUTES),"  FlatLo=",FlatLo," ",TimeToString(FlatLoTime,TIME_DATE | TIME_MINUTES)," OppositeTopTime=",TimeToString(Time[OppositeTop],TIME_DATE | TIME_MINUTES)," FlatBegin=",TimeToString(FlatBegin,TIME_DATE | TIME_MINUTES));     
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆   
void LEVEL_DELETE(int f, int DelFactor){ // параметры: ”ровень дл€ удалени€; ѕричина 0-ѕсевдо, 1-–еальное удаление
   if (DelFactor==0){ // ѕсевдо удаление   
      //if (LEV[f][LIVE]!=0) LINE("DEL LEV", iBarShift(NULL,0,LEV[f][T],false),LEV[f][P]*Point, bar,LEV[f][P]*Point, clrRosyBrown);
      LEV[f][LIVE]=0; // ставим метку, т.е. оставл€ем уровень в массиве, но не отображаем его на графике 
      LEV[f][TRND]=0; // за одно удал€ем его трендовый
   }else{// –еальное удаление  
      //if (LEV[f][P]!=0) LINE("DEL LEV", iBarShift(NULL,0,LEV[f][T],false),LEV[f][P]*Point, bar,LEV[f][P]*Point, clrDimGray);
      LEV[f][P]=0; // удал€ем само значение цены
      LEV[f][TRND]=0; // за одно удал€ем его трендовый
      LEV[f][LIVE]=0; // и метку псевдоудаленности на вс€кий
      Pic.Free=f; // номер освободившейс€ €чейки дл€ новых значений
   }  }
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆   
int POWER(int f){ // — » Ћ ј    ” – ќ ¬ Ќ я, исход€ из движений, которые он развернул, либо задал, т.е. величины переднего и заднего фронтов 
   if (LEV[f][BACK]==0) return (LEV[f][FRNT]); // задний фронт еще не сформировалс€, только передний (= величина развернутого движени€)
   switch (LevPower){// сила уровн€ определ€етс€ по величинам переднего и заднего фронтов. »з них беретс€: 1-передний, 0-средний, -1-задний, 2-больший из двух
      case -2: return (MathMin(LEV[f][FRNT],LEV[f][BACK])); break; // меньший из двух
      case -1: return (LEV[f][BACK]); break;          // задний фронт
      case  0: return ((LEV[f][FRNT]+LEV[f][BACK])/2); break;  // среднее значение
      case  1: return (LEV[f][FRNT]); break; // передний фронт = сила уровн€ (величина развернутого им движени€) = рассто€ние от нового пика до максимума, лежащего между новым пиком и превосход€щим его баром.
      default: return (MathMax(LEV[f][FRNT],LEV[f][BACK])); break; // больший из двух
   }  }     
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆   
void PIC_LIM(){   // ƒќѕ”—  —ќ¬ѕјƒ≈Ќ»… ”–ќ¬Ќ≈…
   switch (PicLim){// PicLimPerCent = PicLimVal * PicLimVal * 0.01
      case 1: Pic.Atr=(FastAtr+SlowAtr)/2; break; // среднее значение последних п€ти трендовых уровней
      case 2: Pic.Atr=MathMin(FastAtr,SlowAtr); break;
      case 3: Pic.Atr=MathMax(FastAtr,SlowAtr); break;
      }
   Pic.Lim=Pic.Atr*PicVal*0.01;   // допуск уровней в % ATR
   Pic.intAtr=int(Pic.Atr/Point);   
   Pic.intLim=int(Pic.Lim/Point);  // ƒопуск совпадени€ уровней
   FirstLevPower=Pic.intAtr*2*(2+FirstLev); // величина движени€, которую должен развернуть уровень, чтобы стать первым 
   }  //if (Prn) Print(ttt," Pic.Lim=",NormalizeDouble(Pic.Lim,Digits-1)," FastAtr=",NormalizeDouble(FastAtr,Digits-1)," SlowAtr=",NormalizeDouble(SlowAtr,Digits-1)," Pic.Avg=",NormalizeDouble(Pic.Avg,Digits-1)," MidMovUp=",NormalizeDouble(MidMovUp,Digits-1)," MidMovDn=",NormalizeDouble(MidMovDn,Digits-1));   
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆
void FIRST_LEVELS(int uf, int df){// ѕќ—“–ќ≈Ќ»≈ ѕ≈–¬џ’ ”–ќ¬Ќ≈… ѕќ Ќј…ƒ≈ЌЌџћ ‘–ј “јЋјћ   
   LastFirstUp=FirstUp; double tempUP=FirstUpPic;
   LastFirstDn=FirstDn; double tempDN=FirstDnPic;
   if (uf>-1){// номер уровн€ в составе массива 
      FirstUp=LEV[uf][TRND]*Point;     // ѕервый “рендовый на продажу
      FirstUpPic=LEV[uf][P]*Point;  // пиковый первого уровн€ на продажу
      FirstUpCenter=(FirstUp+FirstUpPic)/2; // —ерединка с объемом первого трендового 
      FirstUpTime=LEV[uf][T];       // врем€ его формировани€
      }//if (Prn) Print(ttt," FirstUp=",LEV[uf][P],"  ",TimeToString(LEV[uf][T],TIME_DATE | TIME_MINUTES));
   if (df>-1){// номер уровн€ в составе массива
      FirstDn=LEV[df][TRND]*Point;     // ѕервый “рендовый на продажу
      FirstDnPic=LEV[df][P]*Point;  // пиковый первого уровн€ на продажу
      FirstDnCenter=(FirstDn+FirstDnPic)/2; // —ерединка с объемом первого трендового 
      FirstDnTime=LEV[df][T];       // врем€ его формировани€
      }//if (Prn) Print(ttt," FirstDn=",LEV[df][P],"  ",TimeToString(LEV[df][T],TIME_DATE | TIME_MINUTES));
   if (LastFirstUp!=FirstUp) LastFirstUpPic=tempUP;
   if (LastFirstDn!=FirstDn) LastFirstDnPic=tempDN;
   // поиск уровн€ между первыми уровн€ми чуть дальше серединки
   if (LastFirstUp==FirstUp && LastFirstDn==FirstDn) return;// уровни не обновились
   if (uf<0 || df<0) return;
   FirstMiddle=0;
   int fConcur, Concur=0, fPwr=-1, Power=0, Mid=int((FirstUp+FirstDn)*0.5/Point); // арифметическа€ серединка, будем искать от нее до немного не доход€ противоположного кра€
   int UpZone, DnZone;
   int PowerCheck=MinPower*Pic.intAtr; // минимальный передний фронт, меньше которого уровни не отображаютс€ 
   datetime TimeStart=MathMin(FirstUpTime,FirstDnTime), TimeEnd=MathMax(FirstUpTime,FirstDnTime);
   double Zone=(FirstUp-FirstDn)/8; // ограничение зоны поиска серединки в 1/8 диапазона между уровн€ми
   UpZone=int((FirstUp-Zone)/Point); // ограничение зоны поиска выше серединки
   DnZone=int((FirstDn+Zone)/Point); // ограничение зоны поиска ниже серединки
   for (int f=uf; f<df; f++){// между первыми уровн€ми
      if (f==uf) continue;
      int pwr=POWER(f);
      if (LEV[f][LIVE]==0 || LEV[f][PER]<LevPer || pwr<PowerCheck) continue; // псевдо удаленые, узкие и слабые фракталыи сразу пропускаем. ќни оставлены в массиве дл€ сравнени€, но не отображаютс€ на графике
      if (LEV[f][T]<TimeStart || LEV[f][T]>TimeEnd) continue; // рассматриваем только уровни между пиками
      if (FirstUpTime>FirstDnTime && (LEV[f][P]>Mid || LEV[f][P]<DnZone)) continue; // пик позже впадины = (тренд восход€щий): ищем ниже серединки Mid но не доход€ 1/8 диапазона до нижнего уровн€
      if (FirstUpTime<FirstDnTime && (LEV[f][P]<Mid || LEV[f][P]>UpZone)) continue; // пик раньше впадины = (тренд вниз): ищем выше серединки Mid но не доход€ 1/8 диапазона до верхнего уровн€
      if (LEV[f][CONCUR]>Concur){Concur=LEV[f][CONCUR]; fConcur=f;} // уровень с максимальным кол-вом отскоков
      if (pwr>Power) {Power=pwr; fPwr=f;}// самый сильный уровень - непробитый и развернувший большее движение
      }
   if (Concur>=FltPic)  FirstMiddle=LEV[fConcur][P]*Point; // уровень с кол-вом отскоков, превышающим FlatPwr
   else {if (fPwr>=0)   FirstMiddle=LEV[fPwr][P]*Point;}   // самый сильный (развернувший большее движение)
   }    
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆   
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆   
void LEVELS_FIND_AROUND(){ // ѕ ќ » —     Ѕ Ћ » « Ћ ≈ ∆ ј ў » ’   ” – ќ ¬ Ќ ≈ … 
   int   uf=-1, df=-1; // номера первых уровней  
   int PowerCheck=MinPower*Pic.intAtr; // минимальный передний фронт, меньше которого уровни не отображаютс€ 
   u1=-1; u2=-1; u3=-1; d1=-1; d2=-1; d3=-1; um=-1; dm=-1; UP1=0; DN1=0; UP2=0; DN2=0; UP3=0; DN3=0; UpCenter=0; DnCenter=0; 
   int   mirUp=Pic.intAtr*15, mirDn=Pic.intAtr*15; // первичное рассто€ние до зеркальных флэтовых 
   for (int f=0; f<LevelsAmount; f++){// предварительный поиск начала   
      if (LEV[f][P]==0) break; // пошли пустые значени€
      if (LEV[f][LIVE]==0) continue;   // псевдо удаленые фракталыи пропускаем. ќни оставлены в массиве дл€ сравнени€, но не отображаютс€ на графике
      if (LEV[f][SAW]==0){// ≈ў≈ Ќ≈ ѕ–ќЅ»“џ… ѕ»  ѕ–ќ¬≈–я≈“—я Ќј ѕ–ќЅ»“»≈ Ѕј–ќћ
         if ((LEV[f][DIR]>0 && intH>LEV[f][P]+Pic.intLim) ||   // если бар пробивает 
             (LEV[f][DIR]<0 && intL<LEV[f][P]-Pic.intLim)){    // провер€емый пик
            LEV[f][SAW]=1;    // маркировка пробитого уровн€ - SAW!=0     X("break "+DoubleToStr(LEV[f][P],0)+"/"+DoubleToStr(LEV[f][SAW],0), LEV[f][P]*Point, clrBlue);
            LEV[f][TRND]=0;   // удал€ем трендовый уровнень
            int Shift=iBarShift(NULL,0,LEV[f][T],false); // сдвиг фрактала из массива относительно текущего (нулевого) бара
            if (Shift-bar<LEV[f][PER])  LEV[f][PER]=Shift-bar;} // корректировка ширины фрактала       
      }else{ // ѕ–ќЅ»“џ… ѕ»  ѕ–ќ¬≈–я≈“—я Ќј ѕ≈–≈ѕ»Ћ»¬јЌ»≈
         if (LEV[f][SAW]>0){// ѕ–ќ¬≈– ј Ќј «≈– јЋ№Ќќ—“№
            if (Pic.dir>0 && intL>LEV[f][P]) LEV[f][SAW]=-LEV[f][SAW];  // цена превзошла пробитый уровень, 
            if (Pic.dir<0 && intH<LEV[f][P]) LEV[f][SAW]=-LEV[f][SAW];  // макрируем его "зеркальным"
            }
         if (intH>LEV[f][P] && intL<LEV[f][P]){// пик пилитс€ баром
            if (LEV[f][SAW]>0) LEV[f][SAW]++; else LEV[f][SAW]--; // кол-во бар, перепиливших уровень
         }  }      
      if (LEV[f][PER]<LevPer || POWER(f)<PowerCheck) continue;  // узкие и слабые фракталыи  пропускаем. ќни оставлены в массиве дл€ сравнени€, но не отображаютс€ на графике
      //  ќЌ“–ќЋ№ «≈– јЋ№Ќџ’ ”–ќ¬Ќ≈…
      if (LEV[f][SAW]<0 && (LEV[f][SAW]>=-DelSaw || DelSaw==0)){ // SAW- кол-во бар, "перепиливших" уровень; <0 при полном пробое пика, после которого уровень может зеркалить
         if (LEV[f][DIR]>0){
            if (intL<LEV[f][P]) LEV[f][SAW]=-99; // обратный пробой, помечаем пока как запиленный, потом он удалитс€ в NEW_LEVEL() как пробитый противоположным фракталом
            if (MathAbs(LEV[f][P]-intL)<mirDn) {dm=f; mirDn=MathAbs(LEV[f][P]-intL);} // самый близкий зеркальный уровень к текущей цене
         }else{
            if (intH>LEV[f][P]) LEV[f][SAW]=-99; // обратный пробой, помечаем пока как запиленный, потом он удалитс€ в NEW_LEVEL() как пробитый противоположным фракталом
            if (MathAbs(LEV[f][P]-intH)<mirUp) {um=f; mirUp=MathAbs(LEV[f][P]-intH);} // самый близкий зеркальный уровень к текущей цене    
         }  } 
      // ‘ЋЁ“ќ¬џ≈ ”–ќ¬Ќ» — ЅќЋ≈≈ FltPwr ќ“— ќ јћ» (UP2,DN2)
      if (LEV[f][CONCUR]>=FltPic && MathAbs(LEV[f][SAW])<=DelSaw){
         if (LEV[f][DIR]>0 && LEV[f][P]>intH)         u2=f; // 
         if (LEV[f][DIR]<0 && LEV[f][P]<intL && d2<0) d2=f; //  
         }
      if (LEV[f][SAW]!=0) continue; // дальше анализируютс€ только непробитые уровни
      // Ќ≈ѕ–ќЅ»“џ≈ ѕ» » (UP1,DN1)
      if (LEV[f][P]>intH)           u1=f; //  Ѕлижайший непробитый пик ([DIR]>0)
      if (LEV[f][P]<intL && d1<0)   d1=f; //  ќстановка поиска на ближайшей непробитой впадине
      // ѕ–ќ¬≈– ј “–≈Ќƒќ¬џ’ ”–ќ¬Ќ≈… (смена тренда при их пробитии), ќѕ–≈ƒ≈Ћ≈Ќ»≈ ѕ≈–¬џ’ ”–ќ¬Ќ≈…     
      if (LEV[f][TRND]<=0) continue; // трендовый уже пробит
      int center=(LEV[f][P]+LEV[f][TRND])/2; // основной объем вершины (серединка)
      int Shift=iBarShift(NULL,0,LEV[f][T],false); // сдвиг фрактала из массива относительно текущего (нулевого) бара
      if (LEV[f][DIR]>0){ // вершина
         if (intH>center && int(High[iLowest (NULL,0,MODE_HIGH,Shift-bar,bar)]/Point)<LEV[f][TRND]) {// уровень продажи пробит и на рассто€нии от нового пика до данного уровн€ продажи хоть один хай опускалс€ ниже него.  
            LEV[f][TRND]=0; // удаление пробитого уровн€ продажи  //X("Del UpTrendLev", LEV[f][TRND]*Point, clrViolet);
            if (LEV[f][PER]>=TrLevPwr) {TrendLevBreakUp++;  TrendLevBreakDn=0;}  // если это был достаточно широкий уровень, увеличиваем кол-во пробоев вверх, обнул€ем пробои вниз    
         }else{// трендовый уровень на продажу еще не пробит 
            if (intH<center){// поиск первого уровн€ на продажу
               u3=f; // ближайший трендовый
               if (FirstLev>=0){ if (POWER(f)>FirstLevPower)   uf=f;} // ближайший пик к текущей цене, развернувший движение в ATR*2*(2+FirstLev)
               else            { if (LEV[f][PER]>FirstLevPer)  uf=f;} // пик, развернувший самое большое движение на периоде в FirstLev дней
         }  }  }    
      else{ // впадина
         if (intL<center && int(Low [iHighest(NULL,0,MODE_LOW ,Shift-(bar+PicPer),bar+PicPer)]/Point)>LEV[f][TRND]) {// уровень покупки пробит и на рассто€нии от нового пика до данного уровн€ покупки хоть один лоу поднималс€ над ним. 
            LEV[f][TRND]=0;  // удаление пробитого уровн€ покупки  //X("Del DnTrendLev", LEV[f][TRND]*Point, clrViolet);
            if (LEV[f][PER]>=TrLevPwr) {TrendLevBreakDn++;  TrendLevBreakUp=0;}  // если это был достаточно широкий уровень, увеличиваем кол-во пробоев вниз, обнул€ем пробои вверх.       
         }else{// трендовый уровень на покупку еще не пробит 
            if (intL>center){// поиск первого уровн€ на покупку
               if (d3<0) d3=f; // ближайший трендовый
               if (FirstLev>=0){ if (POWER(f)>FirstLevPower  && df<0) df=f;} // ближайший пик к текущей цене, развернувший движение в ATR*2*(2+FirstLev)
               else            { if (LEV[f][PER]>FirstLevPer && df<0) df=f;} // пик, развернувший самое большое движение на периоде в FirstLev дней
      }  }  }  }  
   if (u1>-1) {UP1=LEV[u1][P]*Point;      Tup1=LEV[u1][T];} // ближайший уровень над хаем с хот€бы одним отскоком  
   if (u2>-1) {UP2=LEV[u2][P]*Point;      Tup2=LEV[u2][T];}// сильный флэтовый уровень с достаточным кол-вом отскоков 
   if (u3>-1) {UP3=LEV[u3][TRND]*Point;   UP3Pic=LEV[u3][P]*Point;   UpCenter=(UP3+UP3Pic)*0.5;} // “рендовый уровень на продажу, его пик и его серединка
   if (d1>-1) {DN1=LEV[d1][P]*Point;      Tdn1=LEV[d1][T];} // if (Prn) Print(ttt,"  LEV[",d1,"]=",LEV[d1][P],"  ",TimeToString(LEV[d1][T],TIME_DATE | TIME_MINUTES)," L[6]=",LEV[d1][BACK]," L[5]=",LEV[d1][DIR]);   
   if (d2>-1) {DN2=LEV[d2][P]*Point;      Tdn2=LEV[d2][T];}// сильный уровень с достаточным кол-вом отскоков
   if (d3>-1) {DN3=LEV[d3][TRND]*Point;   DN3Pic=LEV[d3][P]*Point;   DnCenter=(DN3+DN3Pic)*0.5;} // “рендовый уровень на покупkу, его пик и его серединка
   FIRST_LEVELS(uf,df); // –ј—„≈“ ѕ≈–¬џ’ ”–ќ¬Ќ≈… » ”–ќ¬Ќя „”“№ ƒјЋ№Ў≈ —≈–≈ƒ»Ќ »  
   }  
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆   
void TREND_DETECT(){ // ќ ѕ – ≈ ƒ ≈ Ћ ≈ Ќ » ≈   “ – ≈ Ќ ƒ ј 
   double                  pH=Pic.hi, pH2=Pic.hi2, pL=Pic.lo, pL2=Pic.lo2; datetime pHt=hiTime, pLt=loTime;   // при TrPic=1 берутс€ мелкие пики
   if (MathAbs(TrPic)==2) {pH=Pic.Hi; pH2=Pic.Hi2; pL=Pic.Lo; pL2=Pic.Lo2;          pHt=HiTime; pLt=LoTime;}  // берутс€ крупные пики
   datetime FT=MathMax(FlatHiTime,FlatLoTime); // нужно учитиывть врем€ возникновени€ флэта, т.к. флэт может пробитьс€ старым пиком не успев сформироватьс€
   if (GlobalTrend<=0 && High[bar]>FirstUpCenter)  GlobalTrend= 1;  // смена глобального тренда при
   if (GlobalTrend>=0 && Low [bar]<FirstDnCenter)  GlobalTrend=-1;  // пробитии центров первых уровней   
   if (TrPic>0){  // пробитие сопротивлени€(прошлой вершинки) новой вершинкой
      if (Trend==0){ // ¬ыход из флэта
         if (pH-FlatHi>Pic.Lim && pHt>FT) Trend= 1;  // пик над границей флэта и возник позже
         if (FlatLo-pL>Pic.Lim && pLt>FT) Trend=-1;  // пик под границей флэта и возник позже
      }else{   
         if (pH-pH2>Pic.Lim && pL-pL2>Pic.Lim) Trend= 1; // пик над прошлым пиком
         if (pL2-pL>Pic.Lim && pH2-pH>Pic.Lim) Trend=-1; // пик под прошлым пиком
      }  }
   if (TrPic<0){  // ѕробитие сопротивлени€(прошлой вершинки) новой впадиной
      if (Trend==0){ // ¬ыход из флэта
         if (pL>FlatHi && pLt>FT) Trend= 1;  // над верхней границей флэта сформировалас€ впадина  ( позже )
         if (pH<FlatLo && pHt>FT) Trend=-1;  // под нижней границей флэта сформировалась вершина ( позже )
      }else{   
         if (pL>pH2) Trend= 1; // над вершиной сформировалас€ впадина 
         if (pH<pL2) Trend=-1; // под впадиной сформировалась вершина
      }  }
   if (TrLoOnHi>0){ // ѕробитие самого низкого максимума минимумом
      if (TrLoOnHi==1)  {pH=Pic.hi; pH2=Pic.hi2; pL=Pic.lo; pL2=Pic.lo2; pHt=hiTime; pLt=loTime;} // при TrLoOnHi==1 берутс€ мелкие пики
      else              {pH=Pic.Hi; pH2=Pic.Hi2; pL=Pic.Lo; pL2=Pic.Lo2; pHt=HiTime; pLt=LoTime;} // при TrLoOnHi==2 берутс€ крупные пики
      if (UP1<LowestHi) LowestHi=UP1; // самый низкий максимум на пробитие среди уровней сопротивлени€
      if (Trend!=1 && pL>LowestHi) {// пробой сопротивлени€ с пулбэком (нижним фракталом)
         Trend=1; HighestLo=DN1;} // фиксиаци€ нового уровн€ на пробой
      if (DN1>HighestLo) HighestLo=DN1; // самый высокий минимум дл€ пробити€ среди уровней поддержки
      if (Trend!=-1 && pH<HighestLo) { // пробой поддержки с пулбэком (верхним фракталом)
         Trend=-1; LowestHi=UP1; // фиксиаци€ нового уровн€ на пробой
      }  }
   if (TrLevBrk!=0){ // ѕробитие подр€д TrLevBrk трендовых уровней
      if (Trend==0){
         if (Pic.New>FlatHi && TrendLevBreakUp>0) Trend= 1; // пробой трендового уровн€ над верхней границей флэта
         if (Pic.New<FlatLo && TrendLevBreakDn>0) Trend=-1; // пробой трендового уровн€ под нижней границей флэта
      }else{
         if (TrendLevBreakUp>=BrokenLevels) Trend= 1; // пробитие подр€д TrLevBrk трендовых уровней на продажу
         if (TrendLevBreakDn>=BrokenLevels) Trend=-1; // пробитие подр€д TrLevBrk трендовых уровней на покупку
   }  }  }  // if (Prn) Print(ttt," pH=",pH," FlatHi=",FlatHi,"  HiTime=",TimeToString(HiTime,TIME_DATE | TIME_MINUTES));
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆
void TARGET_COUNT(){// расчет целевых уровней окончани€ движени€ на основании измерени€ предыдущих безоткатных движений
   double max=0;
   int i;// if (Pic.dir==LastPic) Print(TimeToString(Time[bar],TIME_DATE | TIME_MINUTES)+"    Pic.dir==LastPic=",Pic.dir);
   if (Pic.Dir>0){// при верхнем пике
      if (Pic.Hi-Pic.Lo<SlowAtr) return; // мелкие движени€ пропускаем
      if (Pic.Dir2!=Pic.Dir) for (i=Movements-1; i>0; i--) MovUp[i]=MovUp[i-1];//пересортировка массива движений лишь в случае чередовани€ пиков, в противном случае просто обновл€ем последнее значение движени€ вверх //  else if (Prn) Print(ttt," Pic.Hi=",NormalizeDouble(Pic.Hi,Digits-1)," Pic.Lo=",NormalizeDouble(Pic.Lo,Digits-1)," Hi-Lo-",NormalizeDouble(Pic.Hi-Pic.Lo,Digits-1)," SlowAtr=",NormalizeDouble(SlowAtr,Digits-1));
      MovUp[0]=Pic.Hi-Pic.Lo; // последнее движение вверх
      MidMovUp=0; // определение среднего значени€ движени€ вверх
      for (i=0; i<Movements; i++){// среди последних движений вверх
         MidMovUp+=MovUp[i];// суммируем все
         if (MovUp[i]>max) max=MovUp[i]; // ищем максимальное 
         }
      if (MathAbs(Target)<2) MidMovUp/=Movements; // при Target=-1..1 движение определ€етс€ как среднее движение
      else MidMovUp=max; // при Target=-2 или Target=2 ищем максимальное движение
      }//if (Prn) Print(ttt," Pic.Hi=",NormalizeDouble(Pic.Hi,Digits-1)," Hi-Lo-",NormalizeDouble(Pic.Hi-Pic.Lo,Digits-1)," TargetDn=",NormalizeDouble(TargetDn,Digits-1),"  max=",NormalizeDouble(max,Digits-1)," min=",NormalizeDouble(min,Digits-1)," MidMovUp=",NormalizeDouble(MidMovUp,Digits-1)," MidMovDn=",NormalizeDouble(MidMovDn,Digits-1));
   else{ // при нижнем пике
      if (Pic.Hi-Pic.Lo<SlowAtr) return; // мелкие движени€ пропускаем 
      if (Pic.Dir2!=Pic.Dir) for (i=Movements-1; i>0; i--) MovDn[i]=MovDn[i-1];//пересортировка массива движений лишь в случае чередовани€ пиков, в противном случае просто обновл€ем последнее значение движени€ вниз
      MovDn[0]=Pic.Hi-Pic.Lo; // последнее движение вверх
      MidMovDn=0; // определение среднего значени€ движени€ вниз
      for (i=0; i<Movements; i++){// среди последних движений вниз
         MidMovDn+=MovDn[i];// суммируем все
         if (MovDn[i]>max) max=MovDn[i]; // ищем максимальное 
         }
      if (MathAbs(Target)<2) MidMovDn/=Movements;  // при Target=-1..1 движение определ€етс€ как среднее движение     
      else MidMovDn=max; // при Target=-2 или Target=2 ищем максимальное движение
   }  }  //if (Prn) Print(ttt," Pic.Lo=",NormalizeDouble(Pic.Lo,Digits-1)," Hi-Lo-",NormalizeDouble(Pic.Hi-Pic.Lo,Digits-1)," TargetUp=",NormalizeDouble(TargetUp,Digits-1),"  max=",NormalizeDouble(max,Digits-1)," min=",NormalizeDouble(min,Digits-1)," MidMovUp=",NormalizeDouble(MidMovUp,Digits-1)," MidMovDn=",NormalizeDouble(MidMovDn,Digits-1));
   
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆   


//   DelBroken   не реализован
   
    
   
           