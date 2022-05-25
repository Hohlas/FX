struct ImpulseStruct{  
   double Val;    // величина зафиксированного импульса
   double Highest,Lowest;  // максимальная и минимальная цены с момента возникновения импульса
   double UpLim,DnLim;  // значения верхнего и нижнего порогов срабатывания, при превышении которых фиксируется импульс
   double Sig;          // значение сигнала (приравнивается просто к текущему порогу срабатывания)
   double HCO, CO;      // 
   double Cur;          // значение импульса на данном баре
   } Imp; 
   
void IMPULSE(){ // ОТСЛЕЖИВАНИЕ РЕЗКИХ КОЛЕБАНИЙ. Лонг сигнал при С>>O либо при закрытии бара очень далеко от L. Шорт сигнал при С<<O, либо закрытии бара далеко от Н.
   Imp.HCO=Close[bar]-Low[bar] - (High[bar]-Close[bar]);   // импульс = разница плеч в баре: от закрытия до минимума - от максимума до закрытия
   Imp.CO=Close[bar]-Open[bar];
   if (MathAbs(Imp.HCO)>MathAbs(Imp.CO))  Imp.Cur=Imp.HCO; else Imp.Cur=Imp.CO;
   
   Imp.UpLim= SlowAtr*Impulse*0.01;  // границы для определения
   Imp.DnLim=-Imp.UpLim;    // превышения пика
   if (Imp.Sig>0){   // цена начала импульса вверх
      if (High[bar]>Imp.Highest) Imp.Highest=High[bar]; // максимальная цена с момента сигнала
      if (Imp.Highest-Low[bar]>Imp.Val*ImpBack*0.01)  Imp.Sig=0; // цена просела от максимальной цены на величину пропорциональную величине импульса, обнуляем сигнал
      }
   if (Imp.Sig<0){  // цена начала импульса вниз
      if (Low[bar]<Imp.Lowest) Imp.Lowest=Low[bar]; // миниимальная цена с момента сигнала
      if (High[bar]-Imp.Lowest>Imp.Val*ImpBack*0.01)  Imp.Sig=0;
      }
   if (Imp.Cur>Imp.UpLim){       // резкое импульс вверх, превышающее SlowAtr*N*0.01
      Imp.Val=High[bar]-Low[bar];// величина импульса
      Imp.Highest=High[bar];     // максимум с момента начала импульса
      Imp.Sig=Imp.UpLim;         // активация сигнала
      }                   
   if (Imp.Cur<Imp.DnLim){
      Imp.Val=High[bar]-Low[bar];
      Imp.Lowest=Low[bar]; 
      Imp.Sig=Imp.DnLim; 
   }  }