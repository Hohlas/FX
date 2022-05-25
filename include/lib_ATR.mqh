int CntFst=0, CntSlw=0;
double  fstBUF, slwBUF;
double   FastAtr,SlowAtr;

int ATR_INIT(){
   fstBUF=0; slwBUF=0; CntFst=0; CntSlw=0;
   if (a<1) {Print("ATR_INIT(): a<1"); return(INIT_FAILED);}
   if (A<1) {Print("ATR_INIT(): A<1"); return(INIT_FAILED);}
   if (A<a) {Print("ATR_INIT(): A<a"); return(INIT_FAILED);}
   Print("ATR_INIT(): FastAtrPer=",FastAtrPer," SlowAtrPer=",SlowAtrPer);
   return (INIT_SUCCEEDED); // Успешная инициализация. Результат выполнения функции OnInit() анализируется терминалом только если программа скомпилирована с использованием #property strict.
   } 
   
void ATR(){
   fstBUF+=High[bar]-Low[bar];   CntFst++; 
   slwBUF+=High[bar]-Low[bar];   CntSlw++;
   //Print(" Time[",bar,"]=",TimeToString(Time[bar],TIME_DATE | TIME_MINUTES)," Cnt=",CntFst," BUF + ",DoubleToStr(High[bar]-Low[bar],Digits)," =",DoubleToStr(fstBUF,Digits));
   if (CntFst>FastAtrPer){// набралось достаточно HL для усреднения
      fstBUF-=High[bar+FastAtrPer]-Low[bar+FastAtrPer];
      FastAtr=fstBUF/FastAtrPer; 
      //Print("                                   BUF - ",DoubleToStr(High[bar+FastAtrPer]-Low[bar+FastAtrPer],Digits)," (",TimeToString(Time[bar+FastAtrPer],TIME_DATE | TIME_MINUTES),") = ",DoubleToStr(fstBUF,Digits)," FastAtr=",DoubleToStr(FastAtr,Digits));
      }
   if (CntSlw>SlowAtrPer){
      slwBUF-=High[bar+SlowAtrPer]-Low[bar+SlowAtrPer];
      SlowAtr=slwBUF/SlowAtrPer;
      }
   }
      
   
  
      
    

    
   
           