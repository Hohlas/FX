double   NewHi, NewLo, LastHi, LastLo, HH, LL, HHH, LLL,
         FirstUp, FirstDn, // ѕервый уровень на продажу/покупку
         FirstUpCenter, FirstDnCenter, // серединки первых уровней на продажу/покупку
         FirstUpPic, FirstDnPic, // трендовые уровни первых уровней
         FlatHi, FlatLo, // флэтовые уровни (при двойном касании)
         MostVisited, // наиболее посещаемый уровень между первыми уровн€ми
         MovUp[5], MovDn[5], // массивы движений, инициализируюст€ в init() на Movements членов
         TargetUp, TargetDn, // цели движени€
         MidMovUp, MidMovDn, // среднее значение нескольких пследних подобных движений
         HighestLo, // сама€ высока€ впадина на пробой
         LowestHi,  // сама€ низка€ вершина на пробой
         UP1, DN1, // ближайшие уровни
         UP2, DN2, // флэтовые уровни с PowerCheck отскоками
         UP3, DN3, DN3Pic, UP3Pic, UpCenter, DnCenter; // трендовые уровни, их пики и серединки
int   LevelsAmount=50, Trend=0, HiTime, LoTime;
int   Tup1,Tdn1,Tup2,Tdn2; // врем€ формировани€ уровней UP1,...DN2  
int   TrendLevels[5], TrLevCnt; // массив с последними п€тью трендовыми уровн€ми дл€ вычислени€ стопа       
int   LEV[1][10], Impulse, 
      u1, u2, u3, d1, d2, d3, um, dm, // индексы массива уровней UP1..DN3
      intH, intL,  // HH и LL текущего бара дл€ сравнени€
      Movements=3,  // кол-во последних движений дл€ определени€ измеренного движени€
      LastDir, FrDir, // направление пика дл€ крупных фракталов с периодом LevPer
      LastUp=0, LastDn=0, // номера уровней в массиве, близкий к HH(LL) при прошлом подсчете. „тобы не перебирать весь массив с одного до другого кра€, а начинать с этой €чейки. 
      TrendLevBreakUp=0, TrendLevBreakDn=0, // факт пробо€ трендового уровн€ на продажу/покупку дл€ смены тренда. ѕри пробое уровн€ на продажу TrendLevBreakUp увеличиваетс€ на 1, а TrendLevBreakDn обнул€етс€. » наоборот
      GlobalTrend, // тренд определ€емый пробоем первых (сильных) уровней на покупку/продажу 
      FirstUpTime, FirstDnTime, // врем€ образовани€ первых уровней
      FlatHiTime,  FlatLoTime,   // врем€ формировани€ последнего пика флэта
      FlatTime;
struct PicLevels{  //  C “ – ”   “ ” – ј   P I C
   int   Dir;  // направление пика дл€ мелких фракталов с периодом PicPer: 1-вершина, -1-впадина
   int   Free; // освободившийс€ член 
   double New; // последний из сформировавшихс€
   double Atr; // используемый при расчетах 
   int    intAtr; // целый ј“–
   double Avg; // средн€€ толщина последних п€ти трендовых дл€ расстановки стопов
   double MirUp;  // зеркальный уровень сверху
   double MirDn;  // зеркальный уровень снизу
   int MirUpTime; // врем€ возникновени€ зеркального уровн€ сверху
   int MirDnTime; // врем€ возникновени€ зеркального уровн€ снизу
   double Lim;    // точность совпадени€ уровней
   } Pic;    

            
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆
void LEVELS_MAIN(){// ќ—Ќќ¬Ќќ… ÷» Ћ ѕќ»— ј ”–ќ¬Ќ≈…
   Pic.New=0;
   HH =High[iHighest(NULL,0,MODE_HIGH,PicPer*2+1,bar)];   //  ороткие фракталы дл€ 
   LL =Low [iLowest (NULL,0,MODE_LOW ,PicPer*2+1,bar)];   // формировани€ уровней в NEW_LEVEL().
   HHH=High[iHighest(NULL,0,MODE_HIGH,LevPer*2+1,bar)];   // ѕолноценные фракталы дл€
   LLL=Low [iLowest (NULL,0,MODE_LOW ,LevPer*2+1,bar)];   // определени€ ложн€ков, тренда, ближайших и целевых уровней...
   intH  =int(High[bar]/Point);
   intL  =int(Low [bar]/Point);
   Pic.Atr=iATR(NULL,0,SlowAtrPer,bar); if (Pic.Atr==0) return;
   Pic.intAtr=int(Pic.Atr/Point);
   if (High[bar+PicPer]==HH){ // Ќовый мелкий фрактал  ///////////////////////////////////////////////////////
      Pic.New=HH; Pic.Dir=1;
      Impulse=int(((HH-Low[bar+PicPer-1])+(HH-Low[bar+PicPer+1]))*0.5*PowerPlus/Pic.Atr); // сила импульса, с которой цена отскакивает от уровн€, будет добавл€тьс€ в живучесть
      NEW_LEVEL();
      }
   if (Low[bar+PicPer]==LL){ // Ќовый мелкий фрактал  /////////////////////////////////////////////////////////
      Pic.New=LL; Pic.Dir=-1;  
      Impulse=int(((High[bar+PicPer-1]-LL)+(High[bar+PicPer+1]-LL))*0.5*PowerPlus/Pic.Atr); // сила импульса, с которой цена отскакивает от уровн€, будет добавл€тьс€ в живучесть
      NEW_LEVEL();
      }
   if (High[bar+LevPer]==HHH){// // Ќовый крупный фрактал
      LastHi=NewHi;  NewHi=HHH; LastDir=FrDir; FrDir=1; HiTime=int(Time[bar+PicPer]); // 
      TARGET_COUNT();// расчет целевых уровней окончани€ движени€ на основании измерени€ предыдущих безоткатных движений 
      LIM_DETECT(); // определение Pic.Lim допуск совпадени€ уровней
      }  
  if (Low[bar+LevPer]==LLL){// Ќовый крупный фрактал
      LastLo=NewLo; NewLo=LLL;  LastDir=FrDir; FrDir=-1; LoTime=int(Time[bar+PicPer]);//
      TARGET_COUNT();// расчет целевых уровней окончани€ движени€ на основании измерени€ предыдущих безоткатных движений
      LIM_DETECT(); // определение Pic.Lim допуск совпадени€ уровней
      }  
   if (TimeHour(Time[bar])<TimeHour(Time[bar+1])){ // Ќ ќ ¬ џ …   ƒ ≈ Ќ №       
      // if (Prn) Print(ttt,"NewDay ","  ",TimeToString(Time[bar],TIME_DATE | TIME_MINUTES)," LastHi=",LastHi);
      }  
   LEVELS_FIND_AROUND(); // ѕ ќ » —     Ѕ Ћ » « Ћ ≈ ∆ ј ў » ’   ” – ќ ¬ Ќ ≈ …      
   TREND_DETECT();   // ќ ѕ – ≈ ƒ ≈ Ћ ≈ Ќ » ≈   “ – ≈ Ќ ƒ ј 
   switch (FlsLev){// – ј — „ ≈ “   Ћ ќ ∆ Ќ я   ќ ¬ , т.е. ложн€к формируетс€ при пробитии:    
      case 1: FALSE_LEVELS (NewHi,HiTime,NewLo,LoTime); break;  // последнего пика
      case 2: FALSE_LEVELS (UP1,Tup1,DN1,Tdn1); break;  // ближайшего уровн€ c одним и более отскоком
      case 3: FALSE_LEVELS (UP2,Tup2,DN2,Tdn2); break;  // сильного флэтового уровн€ с двум€ и более отскоками
      case 4: if (Trend==0) FALSE_LEVELS (FlatHi,FlatHiTime,FlatLo,FlatLoTime); break;  // флэтового уровн€ образовавшегос€ канала
   }  }
   
     
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆      
void NEW_LEVEL(){
   int NEW =int(Pic.New/Point);   // целочисленное Pic.New
   int LIM=int(Pic.Lim/Point);  // ƒопуск совпадени€ уровней
   int f,j=0, Shift, center=0, pwr, From=bar, FrPeriod=2, BreakBars; 
   int ExPicTime=0; // врем€ ближайшшего превосход€щего пика перед новым (дл€ вершины - предыдущей вершины, дл€ впадины - предыдущей впадины)
   int OppositeTop; // номер бара противоположна€ вершина, лежаща€ между новым и превосход€щим его пиками (дл€ определени€ движени€, остановленного пиком при поиске первых уровней)
   int Concur=1;   // кол-во совпадений пиков
   int Visits=0; // кол-во посещений дл€ наиболее посещаемого уровн€
   int FlatBegin=0;// врем€ начала флэта
   double PowerLevel=Pic.New; // средний уровень совпавших пиков
   double lev; // lev=LEV[f][0]*Point
   int PicCnt=1; // счетчик вершин, сформировавших флэт
   Pic.Free=-1; // свободна€ €чейка
   int OldestCell=0,  OldestTime=int(Time[bar]);  // номер и врем€ самой старой €чейки
   int DeletedCell=-1, DeletedTime=int(Time[bar]); // номер и врем€ самой старой удаленной €чейки
   bool  FirstDnFind=false; // факт обнаружени€ уровн€, чтоб не искать ниже 
   //if (Prn) Print(ttt,"              NEW=",NEW," intH=",intH," intL=",intL);
   for (f=0; f<LevelsAmount; f++){// перебираем весь массив фракталов от большего к меньшему
      if (LEV[f][0]==0) {Pic.Free=f; break;} // добрались до нулевых значений, фракталы в массиве закончились
      if (LEV[f][1]<OldestTime) {OldestTime=LEV[f][1]; OldestCell=f;} // самый старый фрактал из действующих уровней на случай, если не найдетс€ свободных €чеек массива
      if (LEV[f][9]==0 && LEV[f][1]<DeletedTime) {DeletedTime=LEV[f][1]; DeletedCell=f;}// самый старый из псевдоудаленных, в первую очередь писать лучше туда
      Shift=iBarShift(NULL,0,LEV[f][1],false); // сдвиг фрактала из массива относительно текущего (нулевого) бара
      lev=LEV[f][0]*Point;
      // ќ ѕ – ≈ ƒ ≈ Ћ ≈ Ќ » ≈   ‘ Ћ Ё “ ј
      if (MathAbs(NEW-LEV[f][0])<LIM){// сравниваемые фракталы в пределах LIM
         LEV[f][2]++; Concur++;// поиск совпадающих уровней, увеличиваем кол-во совпадений
         if (Pic.Dir==LEV[f][5] && //  поиск среди вершин, если впадина - среди впадин
            Time[bar+PicPer]-LEV[f][1]>FlatTime && // сформирован достаточно давно от нового пика
          ((Pic.Dir>0 && int(High[iHighest(NULL,0,MODE_HIGH,Shift-bar+1,bar)]/Point)<NEW+LIM) || // между отобранным и новым пиками ничего не выступает
           (Pic.Dir<0 && int(Low [iLowest (NULL,0,MODE_LOW ,Shift-bar+1,bar)]/Point)>NEW-LIM))){ // между отобранным и новым пиками ничего не выступает  
            PicCnt++; // количество совпавших вершин
            PowerLevel+=lev; // и их сумма дл€ усреднени€ 
            if (LEV[f][1]>FlatBegin) FlatBegin=LEV[f][1];  // самый свежий пик, совпадающий с новым, чтобы провести между ними противоположную границу флэта    
         }  }//if (PicCnt>2) Print(TimeToString(Time[bar],TIME_DATE | TIME_MINUTES),":  NEW=",NEW,"  PicCnt=",PicCnt," FlatBegin=",TimeToString(LEV[f][1],TIME_DATE | TIME_MINUTES)," Htop=",High[iHighest(NULL,0,MODE_HIGH,Shift-bar+1,bar)]," Ltop=",Low [iLowest (NULL,0,MODE_LOW ,Shift-bar+1,bar)]);
      pwr=LEV[f][2]+LEV[f][4]; // "∆ивучесть" уровн€ = кол-во отскоков + скорость отскока. ќпредел€ет, во сколько уменьшаетс€ период фрактала при проверке         
      if (LEV[f][2]>PowerCheck && LEV[f][2]>Visits && lev<=FirstUp && lev>=FirstDn) {Visits=LEV[f][2]; MostVisited=lev;}// поиск самого посещаемого уровн€
      // » « ћ ≈ – ≈ Ќ » ≈    Ў » – » Ќ џ    ‘ – ј   “ ј Ћ ќ ¬
      if (LEV[f][5]>0 && LEV[f][0]+LIM>=int(High[iHighest(NULL,0,MODE_HIGH,(Shift-bar)*2,bar)]/Point)) LEV[f][7]=Shift-bar; // пока фрактал фракталит,
      if (LEV[f][5]<0 && LEV[f][0]-LIM<=int(Low [iLowest (NULL,0,MODE_LOW ,(Shift-bar)*2,bar)]/Point)) LEV[f][7]=Shift-bar; // мер€ем его ширину
      // ” ƒ ј Ћ ≈ Ќ » ≈   Ќ ≈ ‘ – ј   “ ј Ћ я ў » ’   ” – ќ ¬ Ќ ≈ …                  //if (LEV[f][3]==112906) Print(ttt," LEV[",f,"] ",LEV[f][0],"  ",TimeToString(LEV[f][1],TIME_DATE | TIME_MINUTES)," [2]=",LEV[f][2]," 4=",LEV[f][4]," [3]=",LEV[f][3]);   
      if (PowerPlus<0){// удаление уровн€, если после него по€вились более сильные (развернувшие большее движение)
         for (j=f; j<LevelsAmount; j++){// сравним текущий фрактал с оставшимис€ ниже по списку, 
            if (LEV[j][0]==0) continue;
            if (LEV[j][5]!=LEV[f][5]) continue; // вершину сравниваем только с вершинами, впадину толко с впадинами
            if (LEV[f][1]<LEV[j][1] && LEV[f][8]<LEV[j][8]){  // текущий фрактал старше и слабее найденного  //if (Prn) Print(ttt,"DEL fLEV[",f,"] ",LEV[f][0],"  ",TimeToString(LEV[f][1],TIME_DATE | TIME_MINUTES)," [8]=",LEV[f][8]," jLEV[",j,"] ",LEV[j][0],"  ",TimeToString(LEV[j][1],TIME_DATE | TIME_MINUTES)," [8]=",LEV[j][8]);
               LEVEL_DELETE(f,DelSmall); break; // удал€ем текущий уровень, сравнивать больше нечего
               }
            if (LEV[f][1]>LEV[j][1] && LEV[f][8]>LEV[j][8]){  // текущий фрактал моложе и сильнее сравниваемого //if (Prn) Print(ttt,"DEL jLEV[",j,"] ",LEV[j][0],"  ",TimeToString(LEV[j][1],TIME_DATE | TIME_MINUTES)," [8]=",LEV[j][8]," fLEV[",f,"] ",LEV[f][0],"  ",TimeToString(LEV[f][1],TIME_DATE | TIME_MINUTES)," [8]=",LEV[f][8]);
               LEVEL_DELETE(j,DelSmall);  // удал€ем свер€емый уровень  
         }  }  }
      else if (LEV[f][7]*pwr<Shift-bar) {LEVEL_DELETE(f,DelSmall); continue;} // фрактал не фракталит с учетом "коэффициента = кол.во совпадений + дальность отскока"
      // ѕ – ќ Ѕ » “ » ≈   — ќ Ќ ќ ѕ – ј ¬ Ћ ≈ Ќ Ќ џ ћ   ‘ – ј   “ ј Ћ ќ ћ
      if (LEV[f][6]==0){// еще не пробитый уровень (1-пробит превосход€щим пиком, 2-пробит обратным пиком)
         if (LEV[f][5]>0 && Pic.Dir>0 && NEW>LEV[f][0]+LIM) LEV[f][6]=1;// маркировка пробитого уровн€ если нова€ вершина сонаправлена с провер€емой и превосходит ее
         if (LEV[f][5]<0 && Pic.Dir<0 && NEW<LEV[f][0]-LIM) LEV[f][6]=1;// маркировка пробитого уровн€ если нова€ впадина сонаправлена с провер€емой и ниже ее
         }
      else{// ѕ – ќ Ѕ » “ » ≈   ѕ – ќ “ » ¬ ќ ѕ ќ Ћ ќ ∆ Ќ џ ћ   ‘ – ј   “ ј Ћ ќ ћ
         if (LEV[f][5]>0 && Pic.Dir<0 && NEW<LEV[f][0]-LIM) {LEV[f][6]=2; LEVEL_DELETE(f,DelBroken); continue;} // пробита€ вверх вершина пробиваетс€ вниз (и наборот) зеркальной впадиной,
         if (LEV[f][5]<0 && Pic.Dir>0 && NEW>LEV[f][0]+LIM) {LEV[f][6]=2; LEVEL_DELETE(f,DelBroken); continue;} // либо от зеркальной вершины происходит отскок в пределах допуска (т.е. она отработана и не нужна)
         } 
      //  ” ƒ ј Ћ ≈ Ќ » ≈   ѕ ≈ – ≈ ѕ » Ћ ≈ Ќ Ќ ќ √ ќ   ” – ќ ¬ Ќ я 
      if (LEV[f][9]>0 && LEV[f][6]>0 && LEV[f][5]==Pic.Dir){// пока не псевдоудаленный, пробитый, совпадает с текущим пиком
         BreakBars=0;  for (j=bar; j<Shift; j++) if (High[j]>=lev && Low[j]<=lev) BreakBars++;// от текущего бара до пробитой вершины считаем кол-во бар, перепиливших уровень 
         if (LevBreak>0 && BreakBars>LevBreak) {LEVEL_DELETE(f,0); continue;} // псевдо удаление пробитого уровн€   if (Prn) Print(ttt,"LEV[",f,"] ",LEV[f][0],"  ",TimeToString(LEV[f][1],TIME_DATE | TIME_MINUTES)," BreakBars=",BreakBars);   
         }     
      // ѕ–ќЅ»“»≈ ”–ќ¬Ќ≈… ѕќ ”ѕ »/ѕ–ќƒј∆», смена тренда при пробитии трендовых уровней    //if (Prn && LEV[f][0]==112827) Print(ttt," NEW=",NEW," LIM=",LIM," LEV-LIM=",LEV[f][0]-LIM,"  LEV[",f,"]=",LEV[f][0],"  ",TimeToString(LEV[f][1],TIME_DATE | TIME_MINUTES), " LEV6=",LEV[f][6]," LEV9=",LEV[f][9]); 
      if (LEV[f][3]>0){// уровень продажи пока не пробит
         center=(LEV[f][0]+LEV[f][3])/2; // основной объем вершины (серединка)
         if (Prn && LEV[f][3]==1277430) Print(ttt,"  LEV[",f,"]=",LEV[f][0]," [3]=",LEV[f][3],"  ",TimeToString(LEV[f][1],TIME_DATE | TIME_MINUTES)); 
         if (LEV[f][5]>0 && NEW>center && int(High[iLowest (NULL,0,MODE_HIGH,Shift-(bar+PicPer),bar+PicPer)]/Point)<LEV[f][3]) {// уровень продажи пробит и на рассто€нии от нового пика до данного уровн€ продажи хоть один хай опускалс€ ниже него.  
            LEV[f][3]=0; // удаление уровн€ продажи
            if (LEV[f][7]>=LevPer) {TrendLevBreakUp++; TrendLevBreakDn=0;}} // если это был достаточно широкий уровень, увеличиваем кол-во пробоев вверх, обнул€ем пробои вниз  
         if (LEV[f][5]<0 && NEW<center && int(Low [iHighest(NULL,0,MODE_LOW ,Shift-(bar+PicPer),bar+PicPer)]/Point)>LEV[f][3]) {// уровень покупки пробит и на рассто€нии от нового пика до данного уровн€ покупки хоть один лоу поднималс€ над ним. 
            if (Prn) Print(ttt,"  DEL LEV[",f,"]=",LEV[f][0]," [3]=",LEV[f][3],"  ",TimeToString(LEV[f][1],TIME_DATE | TIME_MINUTES)); 
            LEV[f][3]=0;  // удаление уровн€ покупки
            if (LEV[f][7]>=LevPer) {TrendLevBreakDn++; TrendLevBreakUp=0;}} // если это был достаточно широкий уровень, увеличиваем кол-во пробоев вниз, обнул€ем пробои вверх.       
      }  }
   if (Pic.Free<0){// если пустых €чеек уже нет,  
      if (DeletedCell>-1)  Pic.Free=DeletedCell; // если есть псевдоудаленные, берем самую старую из них (отработанные уровни, оставл€емые дл€ сравнени€, по которым не строитс€ график)  Print(TimeToString(Time[bar],TIME_DATE | TIME_MINUTES)," DeletedCell[",DeletedCell,"] ",LEV[DeletedCell][0],"  ",TimeToString(LEV[DeletedCell][1],TIME_DATE | TIME_MINUTES));} 
      else                 Pic.Free=OldestCell; // берем просто самую старую
      } 
   if (Impulse<0) Impulse=0; // при PowerPlus<0 Impulse не нужен, т.к. удаление происходит по ширине фрактала
   // ЅЋ»∆ј…Ў»… ѕ–≈¬ќ—’ќƒяў»… ѕ»   (дл€ нахождени€ между ним и Pic.New противолежащего пика. ѕо нему находитс€ движение, которое развернул данный пик и повышающиес€/понижающиес€ пики
   if (Pic.Dir>0) {for (f=bar+PicPer+1; f<Bars; f++) {if (High[f]>=High[bar+PicPer]) {ExPicTime=int(Time[f]); break;}}} // совпадающий по направлению, ближайший по времени к новому пику
   else           {for (f=bar+PicPer+1; f<Bars; f++) {if (Low [f]<=Low [bar+PicPer]) {ExPicTime=int(Time[f]); break;}}} // пик должен быть выше (или равен) нового, впадина должна быть ниже (или равна) новой
   Shift=iBarShift(NULL,0,ExPicTime,false);// сдвиг  превосход€щего пика
   LEV[Pic.Free][0]=NEW;            // пишем в свободную €чейку значение фрактала
   LEV[Pic.Free][1]=int(Time[bar+PicPer]);    // врем€ фрактала
   LEV[Pic.Free][2]=Concur; // живучесть = кол-во совпадений с предыдущими уровн€ми 
   if (Pic.Dir>0){// вершина  
      LEV[Pic.Free][3]=int(Low [iHighest(NULL,0,MODE_LOW ,PicPer*2+1,bar)]/Point); // дл€ вершины трендовый уровень не продажу
      OppositeTop=int(Low [iLowest (NULL,0,MODE_LOW ,Shift-(bar+PicPer)+1,bar+PicPer)]/Point); // противоположна€ впадина, лежаща€ между новым и превосход€щим его пиками (дл€ определени€ движени€, которое развернул данный пик) 
      }
   else{          // впадина      
      LEV[Pic.Free][3]=int(High[iLowest (NULL,0,MODE_HIGH,PicPer*2+1,bar)]/Point); // дл€ впадины трендовый уровень на покупку
      OppositeTop=int(High[iHighest(NULL,0,MODE_HIGH,Shift-(bar+PicPer)+1,bar+PicPer)]/Point);  // противоположна€ вершина, лежаща€ между новой и превосход€щей его впадинами (дл€ определени€ движени€, которое развернула данна€ впадина)
      }//if (Prn) Print(ttt," NEW=",NEW," OppositeTop=",OppositeTop," ExPicTime=",TimeToString(ExPicTime,TIME_DATE | TIME_MINUTES));
   LEV[Pic.Free][4]=Impulse;  // доп живучесть - скорость отскока     if (Prn) Print(ttt," Impulse=",Impulse); 
   LEV[Pic.Free][5]=Pic.Dir;  // направление фрактала: 1=¬≈–Ў»Ќј, -1=¬ѕјƒ»Ќј
   LEV[Pic.Free][6]=0;        // пробитость уровн€: 1-пробит пиком того же направлени€, 2-пробит пиком противоположного направлени€
   LEV[Pic.Free][7]=PicPer;   // сила фрактала - период, на котором он фракталит
   LEV[Pic.Free][8]=MathAbs(NEW-OppositeTop); // движение, которое развернул уровень, т.е. его сила. –азность между его пиком и противолежащей вершиной, из которой началось движение.
   LEV[Pic.Free][9]=1;        // 1-активный уровень (отображаетс€ на графике), 0-был псевдо удален, т.е. не отображаетс€ на графике, а остаетс€ в массиве лишь дл€ сравнени€ с новыми дл€ построени€ флэтовых уровней.
   AVG_TREND_LEV(NEW,LEV[Pic.Free][3]);// среднеей занчение последних п€ти трендовых дл€ стопа
   //FIRST_LEVELS(uf,df);     //if (Prn) Print(ttt," LEV[",d1,"] "," 3=",DN3);
   Shift=iBarShift(NULL,0,LEV[Pic.Free][1],false);// точка отсчета      
   FrPeriod=int(iBarShift(NULL,0,LEV[Pic.Free][8],false) - Shift); // ƒл€ Up пика: период от нового пика до предыдущего (выше или равного данному). “.е. если впоследствии сформируетс€ флэтовый уровень, можно будет проверить наличие повышающихс€ минимумов дл€ возможности продажи от него
   ArraySort (LEV,WHOLE_ARRAY,0,MODE_DESCEND); // отсортируем массив по убыванию (34, 23, 17, 8, 3, 0, 0, 0) 
   if (PicCnt<2) return; // не набралось совпавших вершин дл€ формировани€ флэта
   Shift=iBarShift(NULL,0,FlatBegin,false); // сдвиг дальней вершины флэта   
   Trend=0; // ‘ Ћ Ё “
   FlsDel(Pic.Dir);// удаление уровней покупки/продажи от прошлых ложн€ков
   TrendLevBreakUp=0;   TrendLevBreakDn=0; // сброс кол-ва пробоев трендовых уровней дл€ формировани€ тренда
   if (Pic.Dir>0){// сформирована вершина
      OppositeTop=iLowest (NULL,0,MODE_LOW ,Shift-(bar+PicPer)+1,bar+PicPer); // номер бара противоположной вершины флэта
      FlatHi=PowerLevel/PicCnt; // верхн€€ граница флэта
      FlatLo=Low [OppositeTop]; // минимум между крайними вершинами флэта
      FlatHiTime=int(Time[bar+PicPer]);  // врем€ формировани€ последней вершины флэта дл€ проверки ложн€ка
      FlatLoTime=int(Time[OppositeTop]); // врем€ формировани€ противоположной вершины
   }else{ // сформирована впадина
      OppositeTop=iHighest(NULL,0,MODE_HIGH,Shift-(bar+PicPer)+1,bar+PicPer); // номер бара противоположной вершины флэта
      FlatLo=PowerLevel/PicCnt; // нижн€€ граница флэта - поддержка
      FlatHi=High[iHighest(NULL,0,MODE_HIGH,Shift-(bar+PicPer)+1,bar+PicPer)]; // максимум между двум€ впадинами
      FlatHiTime=int(Time[OppositeTop]); // врем€ формировани€ противоположной вершины
      FlatLoTime=int(Time[bar+PicPer]);  // врем€ формировани€ последней вершины флэта дл€ проверки ложн€ка
   }  }
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆   
void LEVEL_DELETE(int LevToDel, int DelFactor){ // параметры: ”ровень дл€ удалени€, ѕричина 1-фрактал обмельчал, 2-пробит противоположной вершиной 
   //if (LEV[LevToDel][0]==110574) Print(ttt," LEV[",LevToDel,"][0]=",LEV[LevToDel][0],"  ",TimeToString(Time[bar],TIME_DATE | TIME_MINUTES));
   if (DelFactor==0){ // «адано псевдо удаление "0",  
      LEV[LevToDel][9]=0; // ставим метку, т.е. оставл€ем уровень в массиве, но не отображаем его на графике 
      LEV[LevToDel][3]=0; // за одно удал€ем его трендовый
   }else{// «адано реальное удаление "1" 
      LEV[LevToDel][0]=0; // удал€ем само значение цены
      LEV[LevToDel][3]=0; // за одно удал€ем его трендовый
      Pic.Free=LevToDel; // номер освободившейс€ €чейки дл€ новых значений
   }  }
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆   
void AVG_TREND_LEV(int L1, int L2){ // среднее занчение последних п€ти трендовых дл€ стопа
   TrendLevels[TrLevCnt]=MathAbs(L1-L2); // разность пика и его трендового уровн€ (ширина трендового уровн€)
   TrLevCnt++; if (TrLevCnt>4) TrLevCnt=0;
   int i,Max=0,Min=TrendLevels[0],Sum=0;
   for (i=0; i<5; i++){
      if (TrendLevels[i]>Max) Max=TrendLevels[i];
      if (TrendLevels[i]<Min) Min=TrendLevels[i];
      Sum+=TrendLevels[i];
      }
   Pic.Avg=(Sum-Max-Min)/3*Point; // Print(" Pic.Avg=",Pic.Avg," Atr=",Pic.Atr);
   }   
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆   
void LIM_DETECT(){   // ƒопуск совпадений уровней. –асчитываетс€ как меньшее (при LimType<0), среднее (LimType=0) или большее (при LimType>0) из процентов от значений ATR, рассто€нием между двум€ последними пиками, и целевых движений.
   double LastMovLimit, TargetLimit, FastAtr, SlowAtr;
   int d; // коэффициент проверки: при поиске максимального значени€ он >1 и наоборот. “.е. ищетс€ всегда максимальное из двух значений, умноженных на d. ƒл€ того, чтобы не писать два разных алгоритма
   int n=0; // кол-во суммируемых значений дл€ нахождени€ среднего
   if (LimType>=0) {Pic.Lim=0; d=1;} // максимальное из заданных значений
   else {Pic.Lim=-9999999999;d=-1;} // минимальное из заданных значений 
   if (LimATR>0){// %^2 ATR
      FastAtr=iATR(NULL,0,FastAtrPer,bar)*LimATR*LimATR*0.01; 
      SlowAtr=iATR(NULL,0,SlowAtrPer,bar)*LimATR*LimATR*0.01; 
      if (LimType==0) {Pic.Lim+=(FastAtr+SlowAtr)*0.5; n++;} // усредненное значение, либо
      else Pic.Lim=MathMax(FastAtr*d,SlowAtr*d); // большее из двух ј“–
      }
   if (LimMov>0){ // %^2 от рассто€ни€ между двум€ последними пиками
      LastMovLimit=(NewHi-NewLo)*LimMov*LimMov*0.01; // диапазон между последними пиками вверх и вниз 
      if (LimType==0) {Pic.Lim+=LastMovLimit; n++;}      // усредненное значение с предыдущими, либо
      else {if (LastMovLimit*d>Pic.Lim) Pic.Lim=LastMovLimit*d;}// большее из ј“–ного и флэтного 
      }
   if (LimTarget>0){ // %^2 от целевого движени€ (вверх+вниз) 
      TargetLimit=(MidMovUp+MidMovDn)*0.5*LimTarget*LimTarget*0.01; // усредненное значение целевых движений
      if (LimType==0) {Pic.Lim+=TargetLimit; n++;} // усредненное значение с предыдущими, либо 
      else {if (TargetLimit*d>Pic.Lim) Pic.Lim=TargetLimit*d;}  // большее из ј“–ного, флэтного и целевого 
      } 
   if (d<0) Pic.Lim*=d; // сравнивались отрицательные величины, преобразуем в положительное значение 
   if (n>0) Pic.Lim/=n; // при усреднении делим на кол-во слагаемых
   //if (Prn) Print(ttt," Pic.Lim=",NormalizeDouble(Pic.Lim,Digits-1)," FastAtr=",NormalizeDouble(FastAtr,Digits-1)," SlowAtr=",NormalizeDouble(SlowAtr,Digits-1)," LastMovLimit=",NormalizeDouble(LastMovLimit,Digits-1)," TargetLimit=",NormalizeDouble(TargetLimit,Digits-1)," MidMovUp=",NormalizeDouble(MidMovUp,Digits-1)," MidMovDn=",NormalizeDouble(MidMovDn,Digits-1)," n=",n);   
   }
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆   
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆   
void LEVELS_FIND_AROUND(){ // ѕ ќ » —     Ѕ Ћ » « Ћ ≈ ∆ ј ў » ’   ” – ќ ¬ Ќ ≈ … 
   u1=-1; u2=-1; u3=-1; d1=-1; d2=-1; d3=-1; um=-1; dm=-1; UP2=0; DN2=0; UP3=0; DN3=0; UpCenter=0; DnCenter=0; 
   int f, uf=-1, df=-1; // номера в массиве крупнейших первых уровней
   int mirUp=Pic.intAtr*5, mirDn=Pic.intAtr*5, FirstLevForce=Pic.intAtr*FirstLev; // первичное рассто€ние до зеркальных флэтовых
   for (f=0; f<LevelsAmount; f++){// предварительный поиск начала   
      if (LEV[f][0]==0) break; // пошли 00
      if (LEV[f][7]<LevPer || LEV[f][9]==0) continue; // узкие фракталы и псевдо удаленые уровни пропускаем. ќни оставлены в массиве дл€ сравнени€, но не отображаютс€ на графике
      if (LEV[f][0]>intH && ((LEV[f][5]>0 && LEV[f][6]==0) || LEV[f][5]<0)) u1=f;  //  остановка поиска при первом найденном уровне выше ха€. Ёто должен быть непробитый пик, либо пробита€ зеркальна€ впадина
      if (LEV[f][0]<intL && ((LEV[f][5]<0 && LEV[f][6]==0) || LEV[f][5]>0)) {d1=f; break;}//  остановка поиска при первом найденном уровне ниже лоу. Ёто должна быть непробита€ впадина, либо пробитый зеркальный пик
      } //if (Prn) Print(ttt," LEV[",f,"]=",LEV[f][0]," intH=",intH," u1=",u1);
   if (u1>-1){ // если был найден ближайший фрактал, ищем выше более сильные, трендовые и флэтовые уровни 
      UP1=LEV[u1][0]; // предварительное значение (может быть р€дом окажетс€ уровень посильней)
      for (f=u1; f>=0; f--){ // поиск выше найденного UP1
         if (u3>-1 && u2>-1 && uf>-1 && LEV[f][0]-UP1>Pic.intAtr) break; // все уровни найдены
         if (LEV[f][7]<LevPer || LEV[f][9]==0) continue; // узкие фракталы и псевдо удаленые уровни пропускаем. ќни оставлены в массиве дл€ сравнени€, но не отображаютс€ на графике
         if (LEV[f][0]-UP1<Pic.intAtr && (LEV[f][7]>LEV[u1][7] || LEV[f][2]>LEV[u1][2])) u1=f; // ищем поблизости более широкие[7] фракталы и с большим кол-вом отскоков[2]  && (LEV[f][7]>LEV[u1][7] || LEV[f][2]>LEV[u1][2])
         if (u2<0 && LEV[f][2]>=PowerCheck) u2=f; // поиск сильного уровн€ с достаточным кол-вом отскоков
         if (LEV[f][5]<0){ // впадина
            if (LEV[f][6]==1 && MathAbs(LEV[f][0]-intH)<mirUp) {um=f; mirUp=MathAbs(LEV[f][0]-intH);} // среди пробитых уровней ищем, от которой может произойти зеркальный отскок
         }else{            // вершина
            if (LEV[f][3]>0 && LEV[f][0]>intH){ // среди вершин, непробитых уровней на продажу   (LEV[f][3]+LEV[f][0])*0.5>intH
               if (u3<0) u3=f; // ближайший уровень на продажу
               if (uf<0 && LEV[f][8]>FirstLevForce) uf=f; // первый уровень на продажу
         }  }  }
      UP1=LEV[u1][0]*Point;   Tup1=LEV[u1][1]; // ближайший уровень над хаем с хот€бы одним отскоком  
      TargetUp=LEV[u1][8]*Point;
      if (u3>-1) {UP3=LEV[u3][3]*Point;   UP3Pic=LEV[u3][0]*Point;  UpCenter=(UP3+UP3Pic)*0.5*Point;} // “рендовый уровень на продажу, его пик и его серединка
      if (u2>-1) {UP2=LEV[u2][0]*Point;   Tup2=LEV[u2][1];}// сильный флэтовый уровень с достаточным кол-вом отскоков 
      if (um>-1) {Pic.MirUp=LEV[um][0]*Point; Pic.MirUpTime=LEV[um][1];}  // зеркальный уровень сверху
      //if (MathAbs(High[bar]-Pic.MirUp)>Pic.Atr) Pic.MirUp=0; // пробитие зекрального уровн€ сверху
      }//if (Prn && uf>=0) Print(ttt," LEV[",uf,"]=",LEV[uf][0],"  ",TimeToString(LEV[uf][1],TIME_DATE | TIME_MINUTES)," 3=",LEV[uf][3]); 
   if (d1>-1){// если был найден ближайший фрактал, ищем ниже более сильные, трендовые и флэтовые уровни 
      DN1=LEV[d1][0]; // предварительное значение (может быть р€дом окажетс€ уровень посильней)
      for (f=d1; f<LevelsAmount; f++){ // поиск ниже найденного DN1
         if (LEV[f][0]==0) break; // пошли 000
         if (d3>-1 && d2>-1 && df>-1 && DN1-LEV[f][0]>Pic.intAtr) break; // все уровни найдены
         if (LEV[f][7]<LevPer || LEV[f][9]==0) continue; // узкие фракталы и псевдо удаленые уровни пропускаем. ќни оставлены в массиве дл€ сравнени€, но не отображаютс€ на графике
         if (LEV[f][6]==1 && LEV[f][5]>0 && MathAbs(LEV[f][0]-intL)<mirDn) {dm=f; mirDn=MathAbs(LEV[f][0]-intL);}// среди пробитых уровней ищем снизу вершинку, от которой может произойти зеркальный отскок
         if (DN1-LEV[f][0]<Pic.intAtr && (LEV[f][7]>LEV[d1][7] || LEV[f][2]>LEV[d1][2])) d1=f; // ищем поблизости более широкие[7] фракталы и с большим кол-вом отскоков[2]   && (LEV[f][7]>LEV[d1][7] || LEV[f][2]>LEV[d1][2])
         if (d2<0 && LEV[f][2]>=PowerCheck) d2=f; // поиск сильного уровн€ с достаточным кол-вом отскоков 
         if (LEV[f][5]<0 && LEV[f][3]>0 && LEV[f][0]<intL){// среди впадин, непробитых уровней на покупку    (LEV[f][3]+LEV[f][0])*0.5<intL
            if (d3<0)  d3=f; // ближайший уровень на покупку 
            if (df<0 && LEV[f][8]>FirstLevForce) df=f;  // первый уровень на покупку
         }  }
      DN1=LEV[d1][0]*Point;   Tdn1=LEV[d1][1]; // if (Prn) Print(ttt,"  LEV[",d1,"]=",LEV[d1][0],"  ",TimeToString(LEV[d1][1],TIME_DATE | TIME_MINUTES)," L[6]=",LEV[d1][6]," L[5]=",LEV[d1][5]);   
      TargetDn=LEV[d1][8]*Point;
      if (d3>-1) {DN3=LEV[d3][3]*Point;   DN3Pic=LEV[d3][0]*Point;   DnCenter=(DN3+DN3Pic)*0.5;} // “рендовый уровень на покупkу, его пик и его серединка
      if (d2>-1) {DN2=LEV[d2][0]*Point;   Tdn2=LEV[d2][1];}// сильный уровень с достаточным кол-вом отскоков
      if (dm>-1) {Pic.MirDn=LEV[dm][0]*Point;  Pic.MirDnTime=LEV[dm][1];}   // зеркальный   уровень снизу
      //if (MathAbs(Pic.MirDn-Low[bar])>Pic.Atr) {Pic.MirDn=0;}// пробитие зекрального уровн€ снизу
      //if (Prn) Print(ttt," Pic.MirDn=",Pic.MirDn," fff=",fff,"  ",TimeToString(Pic.MirDnTime,TIME_DATE | TIME_MINUTES), " Pic.Atr=",Pic.Atr);//
      }
   if (Pic.New>0){
      if (Pic.Dir<0 && Pic.New<Pic.MirDn) Pic.MirDn=0; // нова€ впадина пробила зеркальный уровень снизу, удал€ем его
      if (Pic.Dir>0 && Pic.New>Pic.MirUp) Pic.MirUp=0; // нова€ вершина пробила зеркальный уровень сверху, удал€ем его  
      }
   FIRST_LEVELS(uf,df);   //  if (Prn && u2>0) Print(ttt," LEV[",u2,"]=",LEV[u2][0]," Power=",LEV[u2][2]," Pic.Lim=",Pic.Lim);   
   }     //if (Prn) Print(ttt,"d1=",d1," DN1=",DN1," LEV[2]=",LEV[d1][2]," LEV[4]=",LEV[d1][4] );  
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆
void FIRST_LEVELS(int FirstUpNum, int FirstDnNum){// построение первых уровней по найденным фракталам   
   // сперва просто берутс€ найденные значени€ уровней
   if (FirstUpNum>-1){//if (Prn) Print(ttt," FIRST UP LEVEL[",FirstUpNum,"]=",LEV[FirstUpNum][0]*Point," Pic=",LEV[FirstUpNum][5]);
      FirstUp=LEV[FirstUpNum][3]*Point;     // ѕервый “рендовый на продажу
      FirstUpPic=LEV[FirstUpNum][0]*Point;  // пиковый первого уровн€ на продажу
      FirstUpCenter=(FirstUp+FirstUpPic)/2; // —ерединка с объемом первого трендового 
      FirstUpTime=LEV[FirstUpNum][1];       // врем€ его формировани€
      }
   if (FirstDnNum>-1){// if (Prn) Print(ttt," FIRST DN LEVEL[",FirstDnNum,"]=",LEV[FirstDnNum][0]*Point," Pic=",LEV[FirstDnNum][5]);
      FirstDn=LEV[FirstDnNum][3]*Point;     // ѕервый “рендовый на продажу
      FirstDnPic=LEV[FirstDnNum][0]*Point;  // пиковый первого уровн€ на продажу
      FirstDnCenter=(FirstDn+FirstDnPic)/2; // —ерединка с объемом первого трендового 
      FirstDnTime=LEV[FirstDnNum][1];       // врем€ его формировани€
      }
   // доп. проверка на правильность построени€. Ќапример, найденный FirstUp левее FirstDn (тренд вниз), но между ними есть более низкий Low<FirstDn    
   //int OldestPic=MathMin(FirstUpTime,FirstDnTime);    // врем€ самого удаленного от текущего бара пика
   //int Shift=iBarShift(NULL,0,OldestPic,false);       // сдвиг самого удаленного пика от текущего бара
   //int LowestBar=iLowest (NULL,0,MODE_LOW ,Shift-bar,bar); // номер бара минимума на периоде до самого удаленного пика
   //int HighestBar=iHighest(NULL,0,MODE_HIGH,Shift-bar,bar); // номер бара максимума на периоде до самого удаленного пика
   //if (FirstDnPic>Low [LowestBar]+Pic.Lim){// отобранный из массива FirstDn оказалс€ не самым низким на промежутке от FirstUp до текущего бара
   //   FirstDn=High[iLowest (NULL,0,MODE_HIGH,PicPer*2+1,LowestBar-PicPer)]; // дл€ впадины трендовый уровень на покупку
   //   FirstDnPic=Low [LowestBar];
   //   FirstDnTime=OldestPic; // Print(TimeToString(Time[bar],TIME_DATE | TIME_MINUTES),":   FirstDnPic=",FirstDnPic," ",TimeToString(FirstDnTime,TIME_DATE | TIME_MINUTES),"   FirstDnPic=",Low [LowestBar]," OldestPicTime=",TimeToString(OldestPic,TIME_DATE | TIME_MINUTES), " FirstDn=",FirstDn);
   //   FirstDnCenter=(FirstDn+FirstDnPic)/2;
   //   }
   //if (FirstUpPic<High[HighestBar]-Pic.Lim){// отобранный из массива FirstUp оказалс€ не самым высоким на промежутке от FirstDn до текущего бара
   //   FirstUp=Low[iHighest(NULL,0,MODE_LOW,PicPer*2+1,HighestBar-PicPer)]; 
   //   FirstUpPic=High[HighestBar];
   //   FirstUpTime=OldestPic; // if (Prn) Print(ttt," FirstUpPic=",FirstUpPic,"  ",TimeToString(FirstUpTime,TIME_DATE | TIME_MINUTES)," High[HighestBar]",High[HighestBar]);
   //   FirstUpCenter=(FirstUp+FirstUpPic)/2; // —ерединка с объемом первого трендового        
   //   }  
   } 
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆   
void TREND_DETECT(){ // ќ ѕ – ≈ ƒ ≈ Ћ ≈ Ќ » ≈   “ – ≈ Ќ ƒ ј 
   if (GlobalTrend< 1 && High[bar]>FirstUpCenter)  GlobalTrend= 1;  // Print(TimeToString(Time[bar],TIME_DATE | TIME_MINUTES)," GlobalTrend=",GlobalTrend);}  
   if (GlobalTrend>-1 && Low[bar]<FirstDnCenter)   GlobalTrend=-1;  // Print(TimeToString(Time[bar],TIME_DATE | TIME_MINUTES)," GlobalTrend=",GlobalTrend);}   
   if (TrNewPic>0){ // —мена тренда при пробитии экстремума новым экстремумом
      if (Trend==0){
         if (NewHi-FlatHi>Pic.Lim) Trend= 1; // пик над границей флэта
         if (FlatLo-NewLo>Pic.Lim) Trend=-1;} // пик под границей флэта
      else{   
         if (NewHi-LastHi>Pic.Lim && NewLo-LastLo>Pic.Lim) Trend= 1; // пик над прошлым пиком
         if (LastLo-NewLo>Pic.Lim && LastHi-NewHi>Pic.Lim) Trend=-1; // пик под прошлым пиком
      }  }
   if (TrOppPic>0){ // —мена тренда при пробитии экстремума противоположным экстремумoм 
      if (Trend==0){
         if (NewLo>FlatHi) Trend= 1;   // над верхней границей флэта сформировалас€ впадина 
         if (NewHi<FlatLo) Trend=-1;}  // под нижней границей флэта сформировалась вершина
      else{   
         if (NewLo>LastHi) Trend= 1; // над сопротивлением сформировалас€ впадина 
         if (NewHi<LastLo) Trend=-1; // под поддержкой сформировалась вершина
      }  }
   if (TrLoOnHi>0){ // —мена тренда при пробитии самого низкого максимума минимумом
      if (UP1<LowestHi) LowestHi=UP1; // ищем самый низкий максимум на пробитие среди сильных уровней сопротивлени€
      if (NewLo>LowestHi) {// пробой сопротивлени€ с пулбэком (нижним фракталом)
         Trend=1; HighestLo=DN1;} //NewHi=HighestLo; фиксируем новую поддержку
      if (DN1>HighestLo) HighestLo=DN1; // ищем самый высокий минимум дл€ пробити€ среди сильных уровней поддержки
      if (NewHi<HighestLo) { // пробой поддержки с пулбэком (верхним фракталом)
         Trend=-1; LowestHi=UP1; //NewLo=LowestHi; фиксируем новое сопротивление
      }  }
   if (TrLevBrk>0){ // —мена тренда при пробитии трендовых уровней
      if (TrendLevBreakUp>TrLevBrk) Trend= 1; // пробитие подр€д TrLevBrk трендовых уровней на продажу
      if (TrendLevBreakDn>TrLevBrk) Trend=-1; // пробитие подр€д TrLevBrk трендовых уровней на покупку
   }  }
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆
void TARGET_COUNT(){// расчет целевых уровней окончани€ движени€ на основании измерени€ предыдущих безоткатных движений
   double max=0, min=1000000;
   int i;// if (Pic.Dir==LastPic) Print(TimeToString(Time[bar],TIME_DATE | TIME_MINUTES)+"    Pic.Dir==LastPic=",Pic.Dir);
   if (FrDir>0){// при верхнем пике
      TargetDn=NewHi-MidMovDn;// отмер€ем цель движени€ внизу
      if (NewHi-NewLo<Pic.Atr) return; // неправильные пики пропускаем
      if (LastDir!=FrDir) for (i=Movements-1; i>0; i--) MovUp[i]=MovUp[i-1];//пересортировка массива движений лишь в случае чередовани€ пиков, в противном случае просто обновл€ем последнее значение движени€ вверх
      MovUp[0]=NewHi-NewLo; // последнее движение вверх
      MidMovUp=0; // определение среднего значени€ движени€ вверх
      for (i=0; i<Movements; i++){// среди всех движений вверх
         MidMovUp+=MovUp[i];// суммируем все
         if (MovUp[i]>max) max=MovUp[i]; // ищем максимальное 
         if (MovUp[i]<min) min=MovUp[i]; // и минимальное движени€
         }
      MidMovUp=(MidMovUp-max-min)/(Movements-2); // находим среднее движение без аномальных максимального и минимального
      //if (Prn) Print(ttt," NewHi=",NormalizeDouble(NewHi,Digits-1)," Hi-Lo-",NormalizeDouble(NewHi-NewLo,Digits-1)," TargetDn=",NormalizeDouble(TargetDn,Digits-1),"  max=",NormalizeDouble(max,Digits-1)," min=",NormalizeDouble(min,Digits-1)," MidMovUp=",NormalizeDouble(MidMovUp,Digits-1)," MidMovDn=",NormalizeDouble(MidMovDn,Digits-1));
      }    
   else{ // при нижнем пике
      TargetUp=NewLo+MidMovUp;   // отмер€ем цель движени€ вверху
      if (NewHi-NewLo<Pic.Atr) return; // неправильные пики пропускаем Pic.Atr
      if (LastDir!=FrDir) for (i=Movements-1; i>0; i--) MovDn[i]=MovDn[i-1];//пересортировка массива движений лишь в случае чередовани€ пиков, в противном случае просто обновл€ем последнее значение движени€ вниз
      MovDn[0]=NewHi-NewLo; // последнее движение вверх
      MidMovDn=0; // определение среднего значени€ движени€ вниз
      for (i=0; i<Movements; i++){// среди всех движений вниз
         MidMovDn+=MovDn[i];// суммируем все
         if (MovDn[i]>max) max=MovDn[i]; // ищем максимальное 
         if (MovDn[i]<min) min=MovDn[i]; // и минимальное движени€
         }
      MidMovDn=(MidMovDn-max-min)/(Movements-2); // находим среднее движение без аномальных максимального и минимального     
      //if (Prn) Print(ttt," NewLo=",NormalizeDouble(NewLo,Digits-1)," Hi-Lo-",NormalizeDouble(NewHi-NewLo,Digits-1)," TargetUp=",NormalizeDouble(TargetUp,Digits-1),"  max=",NormalizeDouble(max,Digits-1)," min=",NormalizeDouble(min,Digits-1)," MidMovUp=",NormalizeDouble(MidMovUp,Digits-1)," MidMovDn=",NormalizeDouble(MidMovDn,Digits-1));
   }  }
   
   
     
   
    
   
           