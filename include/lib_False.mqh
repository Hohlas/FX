#property version    "161.028" // yym.mdd

struct FalseLevels{  //  C Т Р У К Т У Р А   Л О Ж Н Ы Х   П Р О Б О Е В
   double Max; // максимум ложняка (для постановки стопа)
   double Min; // минимум ложняка (для стопа)
   double Buy; // уровень покупки, из которого выстрелил ложняк
   double Sel; // уровень продажи, из которого выстрелил ложняк 
   double DNuplev;// верхняя граница флэта ложняка вниз
   double DNdnlev;// нижняя граница флэта ложняка вниз
   double UPuplev;// верхняя граница флэта ложняка вверх
   double UPdnlev;// нижняя граница флэта ложняка вверх
   double Lim;    // погрешность формирования = процент от ширины пробиваемого канала или АТР
   int UP;     // флаг начала ложняка
   int DN;     // флаг начала ложняка
   int Tr;     // смена тренда при пробое ложняка
   } Fls;      // переменная ложняка
double UP1_1, UP1_2, DN1_1, DN1_2, UP2_1, UP2_2, DN2_1, DN2_2;
int Tup1_1, Tup1_2, Tup2_1, Tup2_2, Tdn1_1, Tdn1_2, Tdn2_1, Tdn2_2;

FalseLevels FALSE_LEVELS (double UpLevel,datetime TimeUp, double DnLevel,datetime TimeDn, int FalseLimit){ // Р А С Ч Е Т   Л О Ж Н Я К О В
   int f, h, l;
   if (FalseLimit>0) Fls.Lim=(UpLevel-DnLevel)*FalseLimit*0.1;   // погрешность формирования = процент от ширины пробиваемого канала 
   else              Fls.Lim=MathPow(FalseLimit-2,2)*0.1*ATR;  // или процент АТР (0.4 0.9)
   if (Fls.UP==0 &&                 // ложняка пока нет 
       High[bar]>UpLevel+Fls.Lim &&  // пробой уровня на достаточную величину FlatLim
      (High[bar+1]<=UpLevel+Fls.Lim || High[bar+2]<=UpLevel+Fls.Lim) && // фиксируется именно факт пробоя
       Time[bar]-TimeUp>FlatTime){   // ложняк сформирован на достаточном удалении от пробиваемой вершины
      Fls.UP=1;            // флаг начала ложняка
      h=bar+1; while(High[h]>=High[h+1]) h++; // ищем уровень покупки по максимумам баров
      l=bar;   while(Low [l]>=Low [l+1]) l++; // ищем уровень покупки по минимумам баров
      f=MathMin(h,l); // берем самый поздний
      Fls.Buy=(High[f]+Low[f])*0.5;   if (Fls.Buy-Low[f]>ATR*0.5) Fls.Buy=Low[f]+ATR*0.5; // уровень покупки - серединка трендового уровня, из которого выстрелил ложняк. С проверкой его ширины
      Fls.Max=High[bar];   // фиксируем максимум ложняка (для постановки стопа)
      Fls.UPuplev=UpLevel; // пробитая ложняком верхняя граница
      Fls.UPdnlev=DnLevel;   // противоположная граница флэта, для регистрации отработки ложняка 
      }//if (Prn) Print(ttt,"1.         Fls.UP=",Fls.UP);
   if (Fls.DN==0 &&                 // ложняка пока нет
      Low[bar]<DnLevel-Fls.Lim &&   // пробой уровня на достаточную величину FlatLim
      (Low[bar+1]>=DnLevel-Fls.Lim || Low[bar+2]>=DnLevel-Fls.Lim) && // фиксируется именно факт пробоя
      Time[bar]-TimeDn>FlatTime){   // ложняк сформирован на достаточном удалении от пробиваемой вершины
      Fls.DN=1;            // флаг начала ложняка
      h=bar;   while(High[h]<=High[h+1]) h++; // ищем уровень продажи по максимумам баров
      l=bar+1; while(Low [l]<=Low [l+1]) l++; // ищем уровень продажи по минимумам баров
      f=MathMin(h,l); // берем самый поздний
      Fls.Sel=(High[f]+Low[f])*0.5;   if (High[f]-Fls.Sel>ATR*0.5) Fls.Sel=High[f]-ATR*0.5; // уровень покупки - серединка трендового уровня, из которого выстрелил ложняк. С проверкой его ширины
      Fls.Min=Low[bar];    // фиксируем минимум ложняка (для стопа)  
      Fls.DNdnlev=DnLevel; // пробитая ложняком нижняя граница
      Fls.DNuplev=UpLevel;   // запоминаем противоположную границу флэта, для регистрации отработки ложняка 
      } 
   
   bool TrChFls=false; // смена тренда ложняком   
   if (Fls.UP>0){ // незавершенный ложняк ВВЕРХ (сопротивления)
      if (Fls.UP<3){
         if (High[bar]>Fls.Max) Fls.Max=High[bar]; // отслеживание максимума ложнянка (второй выход за уровень не считаем)
         if (High[bar]<Fls.Max) Fls.UP=3;}// ложняк стал уменьшаться  //X("3", Fls.Max, clrYellow);
      if (Fls.UP>1 && Low[bar]<Fls.Buy){ // пробит уровень покупки ложняка, (не первым баром ложняка) 
         if (TrChFls) Trend=-1; // меняем тренд
         Fls.UP=4;} // маркировка сигнала
      if (Fls.UP>2 && High[bar]>Fls.Max) {// cформированный ложняк повторно пробит,
         if (TrChFls) {Trend=1;} // значит и пробитый ложняком уровень неактуален
        Fls.UP=0;}  // УДАЛЕНИЕ ЛОЖНЯКА ВВЕРХ   X("UP", Fls.Max, clrWhite); 
      if (Fls.UP==1) Fls.UP++; // чтобы уровень покупки не пробивался первым же длинным баром ложняка  
      if (Low[bar]-Fls.UPdnlev<Fls.Lim) Fls.UP=0;; // дошли до нижней границы флэта, ложняк отработан
      if (High[bar]-Fls.UPuplev>Fls.UPuplev-Fls.UPdnlev) Fls.UP=0;;  // ложняк удалился от пробитой границы на ширину флэта (стал слишком большим)
      }  
   if (Fls.DN>0){// незавершенный ложняк ВНИЗ (поддержки)
      if (Fls.DN<3){
         if (Low[bar]<Fls.Min) Fls.Min=Low[bar]; // отслеживание минимума ложнянка (второй выход за уровень не считаем)
         if (Low[bar]>Fls.Min) Fls.DN=3;}  // ложняк стал уменьшаться
      if (Fls.DN>1 && High[bar]>Fls.Sel){   // пробит уровень продажи ложняка,
         if (TrChFls) Trend=1; //  меняем тренд
         Fls.DN=4;} // маркировка сигнала
      if (Fls.DN>2 && Low[bar]<Fls.Min) {// cформированный ложняк повторно пробит,
         if (TrChFls) {Trend=-1;}//значит и пробитый ложняком уровень неактуален
         Fls.DN=0;} // УДАЛЕНИЕ ЛОЖНЯКА ВНИЗ    
      if (Fls.DN==1) Fls.DN++;   
      if (Fls.DNuplev-High[bar]<Fls.Lim) Fls.DN=0;; // дошли до верхней границы флэта, ложняк отработан
      if (Fls.DNdnlev-Low[bar]>Fls.DNuplev-Fls.DNdnlev) Fls.DN=0;;  // ложняк удалился от пробитой границы на ширину флэта (стал слишком большим)
      } 
   //if (Prn) Print(ttt," Fls.UP=",Fls.UP," Fls.Lim=",NormalizeDouble(Fls.Lim,Digits-1)," UpLevel=",UpLevel," Fls.Max=",Fls.Max," Fls.Buy=",Fls.Buy);   // ," TimeUp=",TimeToString(TimeUp,TIME_DATE | TIME_MINUTES)," Time[bar]-TimeUp=",Time[bar]-TimeUp," FlatTime=",FlatTime
   UP1_2=UP1_1; UP1_1=UP1; Tup1_2=Tup1_1; Tup1_1=Tup1;  UP2_2=UP2_1; UP2_1=UP2; Tup2_2=Tup2_1; Tup2_1=Tup2; 
   DN1_2=DN1_1; DN1_1=DN1; Tdn1_2=Tdn1_1; Tdn1_1=Tdn1;  DN2_2=DN2_1; DN2_1=DN2; Tdn2_2=Tdn2_1; Tdn2_1=Tdn2;  
   //if (Trend==0)  FlsDel(Pic.dir);// удаление уровней покупки/продажи от прошлых ложняков   
   if (Fls.UP>0){ 
      LINE("FlsUPuplev",bar+1,Fls.UPuplev,bar,Fls.UPuplev,  clrRoyalBlue); 
      LINE("FlsUPdnlev",bar+1,Fls.UPdnlev,bar,Fls.UPdnlev,  clrRoyalBlue);  
      LINE("FlsMax",    bar+1,Fls.Max,    bar,Fls.Max,      clrCornflowerBlue); 
      LINE("FlsBuy",    bar+1,Fls.Buy,    bar,Fls.Buy,      clrCornflowerBlue); 
      }
   if (Fls.DN>0){ 
      LINE("FlsDNuplev",bar+1,Fls.DNuplev,bar,Fls.DNuplev,  clrIndigo); 
      LINE("FlsDNdnlev",bar+1,Fls.DNdnlev,bar,Fls.DNdnlev,  clrIndigo);  
      LINE("FlsMin",    bar+1,Fls.Min,    bar,Fls.Min,      clrOrchid);  
      LINE("FlsSel",    bar+1,Fls.Sel,    bar,Fls.Sel,      clrOrchid); 
      }  
   return Fls;  
   }  
