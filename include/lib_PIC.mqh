#define  P        0  // ����
#define  T        1  // Time[bar] ����� ������������� ������ ����
#define  CONCUR   2  // concur - ���������� �������
#define  TRND     3  // ��������� ������� ������ ����
#define  FRNT     4  // �������� ��������� ������  ������ (������������ �� ��������)
#define  DIR      5  // ����������� ��������: 1=�������, -1=�������
#define  BACK     6  // �������� ������� ������ ������ (��������������� �� ��������)
#define  PER      7  // ������ �������� (�� ������� �� ���������)
#define  ExTIME   8  // ����� ������ ��������, ������� ��������� �������.
#define  LIVE     9  // 1-�������� ������� (������������ �� �������); 0-������ ���������, �������� � ������� ���� ��� ��������� � ������ ��� ���������� �������� �������.
#define  SAW     10  // ���-�� �������������� ���; ������� "����������" (!=0) � "������������" (<0) ������.
//#define  ExPIC   11  // ��������������� ���, �� �������� �������� ��������, ����������� ����� �����
 
double   HH, LL, HHH, LLL,
         FirstUp, FirstDn, FirstMiddle,// ������ ������ � ������� �� ����������
         FirstUpCenter, FirstDnCenter, // ��������� ������ ������� �� �������/�������
         FirstUpPic, FirstDnPic,       // ������� ������ ������ �������
         LastFirstUp, LastFirstDn, LastFirstUpPic, LastFirstDnPic, // ������� �������� ������ ������� 
         MostVisited,                  // �������� ���������� ������� ����� ������� ��������
         FlatHi, FlatLo,   // �������� ������ (��� ������� �������)
         MovUp[5], MovDn[5],  // ������� ��������, ���������������� � init() �� Movements ������
         TargetUp, TargetDn,  // ���� ��������
         MidMovUp, MidMovDn,  // ������� �������� ���������� �������� �������� ��������
         HighestLo, // ����� ������� ������� �� ������
         LowestHi,  // ����� ������ ������� �� ������
         UP1, DN1, // ��������� ������
         UP2, DN2, // �������� ������ � FlatPwr ���������
         UP3, DN3, DN3Pic, UP3Pic, UpCenter, DnCenter; // ��������� ������, �� ���� � ���������       
int   Tup1,Tdn1,Tup2,Tdn2, // ����� ������������ ������� UP1,...DN2  
      LevelsAmount=50, TrendLevels[5], TrLevCnt=0, // ������ � ���������� ����� ���������� �������� ��� ���������� ����� � ������� �������� ������  
      LEV[1][11], u1, u2, u3, d1, d2, d3, um, dm, // ������� ������� ������� UP1..DN3
      intH, intL,  // HH � LL �������� ���� ��� ���������
      Movements=3,  // ���-�� ��������� �������� ��� ����������� ����������� �������� (������ ���� �� ������ 3)
      FirstLevPower, // ���� ������� ������ =  �������� ��������, ������� ������ ���������� �������, ����� ����� ������
      TrendLevBreakUp=0, TrendLevBreakDn=0, // ���� ������ ���������� ������ �� �������/������� ��� ����� ������. ��� ������ ������ �� ������� TrendLevBreakUp ������������� �� 1, � TrendLevBreakDn ����������. � ��������
      TrLevPwr, BrokenLevels,  // ������ ���������� �� ������ � ���-�� �������� ������ ������� ��� ����������� ������
      FlatTime, // ����������� ����������������� ����� � PIC(), ���� ����� �� ����������� ������� �� �������.  FlatTime=FltLen*Period()*60 (���) 
      GlobalTrend; // ����� ������������ ������� ������ (�������) ������� �� �������/������� 
datetime HiTime, LoTime, hiTime, loTime;
datetime FirstLevPer=0; // ������ ������ ������ �������. �� ��� ���� ����, ������������ ����� ������� ��������
datetime FirstUpTime, FirstDnTime,  // ����� ����������� ������ �������
         FlatHiTime,  FlatLoTime;   // ����� ������������ ���������� ���� �����
datetime LastFlatBegin;             // ����� ������ ���������� �����          

struct PicLevels{  //  C � � � � � � � �   P I C
   int   dir;  // ����������� ��� ������ ��������� � �������� PicPer: 1-�������, -1-�������
   int   Dir;  // ����������� ��� ������� ��������� � �������� LevPer: 1-�������, -1-�������
   int   Dir2;  // ������� ����������� ��� ������� ��������� � �������� LevPer: 1-�������, -1-�������
   int   Free; // �������������� ���� 
   int   Pot;  // ��������� ���� (�������� ��� �������): 0-������������ ������� (��� ������������ ������� �������� �������� ��� ����), 1-������������ �������,  2 -������ ������������ ������� ����� �������� ��� ������.  
   double New; // ��������� �� ���������������� ������ �����
   double NEW; // ��������� �� ���������������� ������� �����
   double hi,lo,Hi,Lo;// �������/������ ������/������� ����
   double hi2,lo2,Hi2,Lo2; // ������� �������/������ ������/������� ����
   double Atr;    // ATR ��� ���������� �������
   int    intAtr; // ����� ���
   int    intLim; // ����� ������ ���������� �������
   int Impulse;   // ���� �������� (�������� �������) ����. >0 ��� ������� � <0 ��� �������.
   double Lim;    // �������� ���������� �������
   } Pic; 
      
int PIC_INIT(){
   if (PicPer<1 || LevPer<1) {Print("PIC_INIT(): PicPer=",PicPer," LevPer=",LevPer,". Must be >0"); return(INIT_FAILED);}
   if (TrLevBrk>0) TrLevPwr=LevPer; else TrLevPwr=PicPer;  // ������ ���������� �� ������ ��� ����������� ������
   BrokenLevels=MathAbs(TrLevBrk); // ���-�� �������� ������ ��������� ������� ��� ����������� ������
   ArrayResize(LEV,LevelsAmount);// ������ � ����������
   ArrayResize(MovDn,Movements); // ������ � ������ ����������� ��������
   ArrayResize(MovUp,Movements); // ������ � ������ ����������� ��������
   FlatTime=FltLen*Period()*60; // ����������������� ����� (���), ������ ������� �� �� ������������ (���)
   if (FirstLev<0) // � ������ ������ FirstLev - ���������� ���� ��� ������ ������ �������. ��� FirstLev>=0 �� ���������� ���-�� ������� Atr=SlowAtr*2*(2+FirstLev) ��� �������� ������ �������.
      FirstLevPer=MathAbs(FirstLev)*BarsInDay; // ���-�� ��� � FirstLev ���� ��� ������ �����, ������������ ����� ������� ��������
   Pic.Hi=High[bar]; 
   Pic.Lo=Low [bar];
   Print("PIC_INIT(): bar=",bar," Time[bar]=",TimeToString(Time[bar],TIME_DATE | TIME_MINUTES)," FirstLevBars=",MathAbs(FirstLev)*BarsInDay," FlatTime=",FlatTime/60,"min "); 
   return (INIT_SUCCEEDED); // "0"-�������� �������������. ��������� ���������� ������� OnInit() ������������� ���������� ������ ���� ��������� �������������� � �������������� #property strict.
   } 
            
// ��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������
// ��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������
void PIC(){// �������� ���� ������ �������
   Pic.New=0;
   HH =High[iHighest(NULL,0,MODE_HIGH,PicPer*2+1,bar)];   // �������� �������� ��� 
   LL =Low [iLowest (NULL,0,MODE_LOW ,PicPer*2+1,bar)];   // ������������ ������� � NEW_LEVEL().
   HHH=High[iHighest(NULL,0,MODE_HIGH,LevPer*2+1,bar)];   // ����������� �������� ���
   LLL=Low [iLowest (NULL,0,MODE_LOW ,LevPer*2+1,bar)];   // ����������� ��������, ������, ��������� � ������� �������...
   intH  =int(High[bar]/Point);
   intL  =int(Low [bar]/Point);
   if (SlowAtr==0) return;
   // � � � � � �   � � � �
   if (High[bar+PicPer]==HH){ // ����� ������ hi  ///////////////////////////////////////////////////////
      Pic.New=HH; Pic.dir=1;     Pic.hi2=Pic.hi; Pic.hi=HH; hiTime=int(Time[bar+PicPer]);
      if (Target<0) TargetDn=Pic.hi-MidMovDn;// �������� ���� �������� ���� �� ������� ����: Target=-2-���������� ����. �� ������� ����; -1-������� ����. �� ������� ����;
      NEW_LEVEL(); // ������������ � �������� �������
      }
   if (Low[bar+PicPer]==LL){ // ����� ������ lo  /////////////////////////////////////////////////////////
      Pic.New=LL; Pic.dir=-1;    Pic.lo2=Pic.lo; Pic.lo=LL; loTime=int(Time[bar+PicPer]);
      if (Target<0) TargetUp=Pic.lo+MidMovUp;   // �������� ���� �������� ����� �� ������� ����: Target=-2-���������� ����. �� ������� ����; -1-������� ����. �� ������� ����;
      NEW_LEVEL(); // ������������ � �������� �������
      }
   // � � � � � � �   � � � �    // if (Prn) Print(ttt,"            Pic.Hi=",Pic.Hi," Pic.Hi2=",Pic.Hi2," intL=",intL, " HiTime=",TimeToString(HiTime,TIME_DATE | TIME_MINUTES));
   if (High[bar+LevPer]==HHH){// // ����� ������� Hi
      Pic.Hi2=Pic.Hi;  Pic.Hi=HHH; Pic.Dir2=Pic.Dir; Pic.Dir=1; HiTime=int(Time[bar+LevPer]); // 
      Pic.Impulse=int(((Pic.Hi-Low[bar+LevPer-1])+(Pic.Hi-Low[bar+LevPer+1]))/SlowAtr); // ���� ��������, � ������� ���� ����������� �� ������
      TARGET_COUNT();// ������ ������� ������� ��������� �������� �� ��������� ��������� ���������� ����������� �������� 
      if (Target>0) TargetDn=Pic.Hi-MidMovDn;// �������� ���� �������� ���� �� �������� ����:  Target=1-������� �� �������� ����; 2-���������� �� �������� ����
      } 
   if (Low[bar+LevPer]==LLL){// ����� ������� Lo
      Pic.Lo2=Pic.Lo; Pic.Lo=LLL;  Pic.Dir2=Pic.Dir; Pic.Dir=-1; LoTime=int(Time[bar+LevPer]);//
      Pic.Impulse=-int(((High[bar+LevPer-1]-Pic.Lo)+(High[bar+LevPer+1]-Pic.Lo))/SlowAtr); // ���� ��������, � ������� ���� ����������� �� ������
      TARGET_COUNT();// ������ ������� ������� ��������� �������� �� ��������� ��������� ���������� ����������� ��������
      if (Target>0) TargetUp=Pic.Lo+MidMovUp;   // �������� ���� �������� ����� �� �������� ����:  Target=1-������� �� �������� ����; 2-���������� �� �������� ����
      }
     
   if (Target==0) {TargetDn=High[bar]-MidMovDn; TargetUp=Low[bar]+MidMovUp;}// �������� ���� �������� �� �������� ����� ���� � �����      
   LEVELS_FIND_AROUND(); // � � � � �   � � � � � � � � � � �   � � � � � � �      
   TREND_DETECT();   // � � � � � � � � � � �   � � � � � � 
   // if (Prn) Print(TimeToString(Time[bar],TIME_DATE | TIME_MINUTES)," intH[",bar,"]=",intH," UP1=",UP1," DN1=",DN1);
   }
//void DAY_ATR(){// � � � � � � �   � � � � � � � �   � �   � � � � � � � � �   � � � �   � � � � 
//   if (TimeHour(Time[bar])>TimeHour(Time[bar+1])) return; // ����� ����     
//   double DayHigh=High[iHighest(NULL,0,MODE_HIGH,BarsInDay,bar)], DayLow=Low[iLowest(NULL,0,MODE_LOW ,BarsInDay,bar)];
//   DayMov[DaysCnt]=DayHigh-DayLow; DaysCnt++; if (DaysCnt>=5) DaysCnt=0;
//   DayAtr=0; for (int i=0; i<5; i++) DayAtr+=DayMov[i]; DayAtr/=5; 
//   } //Print(ttt,"NewDay ","  ",TimeToString(Time[bar],TIME_DATE | TIME_MINUTES)," DayHigh-DayLow=",DayHigh-DayLow,"   ",NormalizeDouble(DayMov[0],Digits-1)," ",NormalizeDouble(DayMov[1],Digits-1)," ",NormalizeDouble(DayMov[2],Digits-1)," ",NormalizeDouble(DayMov[3],Digits-1)," ",NormalizeDouble(DayMov[4],Digits-1),"      DayAtr=",NormalizeDouble(DayAtr,Digits-1));    
// ��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������
// ��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������      
void NEW_LEVEL(){// ������������ � �������� �������
   int New=int(Pic.New/Point);   // ������������� Pic.New
   int f,j=0, Shift, From=bar, ppp; 
   datetime FrontTime=0;//����� ������ ��������� ������ - ������ �������� �� ������� �������������� ����� � ������ ����. ����� ��
   datetime ExBarTime=0;// ����� ����������� �������������� ���� ����� ����� (��� ������� - ���������� �������, ��� ������� - ���������� �������)
   int ExPicTime=0;     // ����� ����������� �������������� ���� �� �������...
   int ExPower=0;       // ���� [FRNT] ���������� �������������� ����. ������ ������������ ��������.
   int ExPowerPic=0;    // ��� ������� - ��������������� ��� ������������ ������� �������� ��������
   int OppositeTop;  // ����� ���� ��������������� �������, ������� ����� ����� � ������������� ��� ������ (��� ����������� ��������, �������������� ����� ��� ������ ������ �������)
   int Concur=1;     // ���-�� ���������� �����
   int Visits=FltPic; // ����������� ���-�� ��������� ��� �������� ����������� ������
   datetime FlatBegin=Time[bar];// ����� ������ �����. ��� ������ ����� ����� ������ ����
   bool ArrBreak; // ���� �������� �� �������������� ������� ������������� ������, ����� ���� "for" �� "break" ������ �������
   double LevMiddle=Pic.New; // ������� ������� ��������� �����
   double lev; // lev=LEV[f][P]*Point
   int PicCnt=1; // ������� ������, �������������� ����
   Pic.Free=-1; // ��������� ������
   MostVisited=0; // ������� � ������������ ���-��� ��������� (>FlatPwr) � �������� ������ �������
   int LowestPowerCell=0, LowestPower=POWER(0); // ����� ������ � ���� ������ ������� ������ ��� �������� �� ������, ���� �� �������� ��������� ������
   int OldestCell=0;    datetime OldestTime=Time[bar];  // ����� � ����� ����� ������ ������
   int DeletedCell=-1;  datetime DeletedTime=Time[bar]; // ����� � ����� ����� ������ ��������� ������
   bool  FirstDnFind=false; // ���� ����������� ������, ���� �� ������ ���� 
   PIC_LIM(); // ����������� Pic.Atr, Pic.intAtr, Pic.Lim(������ ���������� �������)
   //if (Prn) Print(ttt,"              New=",New," intH=",intH," intL=",intL, " LowestPower=",LowestPower);
   for (f=0; f<LevelsAmount; f++){// ���������� ���� ������ ��������� �� �������� � ��������
      if (LEV[f][P]==0) {Pic.Free=f; if (ArrBreak) continue; else break;} // break ������, �.�. �� ���������� f ����� ��������� ������ ���� �� ������
      if (LEV[f][T]<OldestTime) {OldestTime=LEV[f][T]; OldestCell=f;} // ����� ������ ������� �� ����������� ������� �� ������, ���� �� �������� ��������� ����� �������
      //if (POWER(f)<LowestPower) {LowestPower=POWER(f); LowestPowerCell=f;} // ����� ������ ������� ��� ��������, ���� �� �������� ��������� �����
      if (LEV[f][LIVE]==0 && LEV[f][T]<DeletedTime) {DeletedTime=LEV[f][T]; DeletedCell=f;}// ����� ������ �� ���������������, � ������ ������� ������ ����� ����
      Shift=iBarShift(NULL,0,LEV[f][T],false); // ����� �������� �� ������� ������������ �������� (��������) ����
      lev=LEV[f][P]*Point; 
      // � � � � � � � � � � �   � � � � �
      if (MathAbs(New-LEV[f][P])<Pic.intLim){// ������������ �������� � �������� Lim
         LEV[f][CONCUR]++; Concur++;// ����� ����������� �������, ����������� ���-�� ����������
         if (Pic.dir==LEV[f][DIR] && //  ����� ����� ������, ���� ������� - ����� ������
            Time[bar+PicPer]-LEV[f][T]>FlatTime && // ����������� ���������� ����� �� ������ ����
          ((Pic.dir>0 && int(High[iHighest(NULL,0,MODE_HIGH,Shift-bar+1,bar)]/Point)<New+Pic.intLim) || // ����� ���������� � ����� ������ ������ �� ���������
           (Pic.dir<0 && int(Low [iLowest (NULL,0,MODE_LOW ,Shift-bar+1,bar)]/Point)>New-Pic.intLim))){ // ����� ���������� � ����� ������ ������ �� ���������  
            PicCnt++; // ���������� ��������� ������
            LevMiddle+=lev; // � �� ����� ��� ���������� 
            if (LEV[f][T]<FlatBegin) FlatBegin=LEV[f][T];  // ����� ������ ���, ����������� � �����, ����� �������� ����� ���� ��������������� ������� �����    
         }  }//if (PicCnt>2) Print(TimeToString(Time[bar],TIME_DATE | TIME_MINUTES),":  New=",New,"  PicCnt=",PicCnt," FlatBegin=",TimeToString(LEV[f][T],TIME_DATE | TIME_MINUTES)," Htop=",High[iHighest(NULL,0,MODE_HIGH,Shift-bar+1,bar)]," Ltop=",Low [iLowest (NULL,0,MODE_LOW ,Shift-bar+1,bar)]);
      //if (Pic.dir==LEV[f][DIR] && MathAbs(New-LEV[f][TRND])<Pic.intLim) {LEV[f][CONCUR]++; Concur++;} // ������� �� ��������� ������� ��� �� ������������ �� ����������
      // ����� ������ ����������� ������
      if (LEV[f][CONCUR]>Visits && lev<FirstUp && lev>FirstDn) {Visits=LEV[f][CONCUR]; MostVisited=lev;}
      // ����� ���������� �������������� ����  
      if (Pic.dir==LEV[f][DIR] && LEV[f][T]>ExPicTime){// ������������ �������������� ����
         if (Pic.dir>0 && LEV[f][P]>New-Pic.intLim) {ExPicTime=LEV[f][T]; ExPower=LEV[f][FRNT]; ExPowerPic=LEV[f][P]-LEV[f][FRNT]; ppp=f;} // ������� ����������� ��������, �
         if (Pic.dir<0 && LEV[f][P]<New+Pic.intLim) {ExPicTime=LEV[f][T]; ExPower=LEV[f][FRNT]; ExPowerPic=LEV[f][P]+LEV[f][FRNT]; ppp=f;} // �� ������: ��� ������� ��� �������, ��� ������� ��� ���. 
         }   
      // ��������  ������  �������, ���� ����� ��� ��������� ����� ������� (������������ ������� ��������)  
      if (MinPower==0){// �������� ������ ������� ���� ���� ����� ��� ��������� ����� �������. ��� MinPower>0 ��� ��� �������� ��������� ������ ���-�� ��������� ������ �������  ������ ���*MinPower
         for (j=f; j<LevelsAmount; j++){// ������� ������� ������� � ����������� ���� �� ������, 
            if (LEV[j][DIR]!=LEV[f][DIR]) continue; // ������� ���������� ������ � ���������, ������� ����� � ���������
            if ((LEV[f][LIVE]>0 || DelSmall==true) && LEV[f][T]<LEV[j][T] && POWER(f)<POWER(j)){  // ������� ������� �� ��������������� ���� �������� ��������� ��������. �� ������ � ������ ��� ���� �� ������  //
               LEVEL_DELETE(f,DelSmall); break; // ������� ������� �������, ���������� ������ ������  if (Prn) Print(ttt,"DEL fLEV[",f,"] ",LEV[f][P],"  ",TimeToString(LEV[f][T],TIME_DATE | TIME_MINUTES)," fPOWER=",POWER(f),"    jLEV[",j,"] ",LEV[j][P],"  ",TimeToString(LEV[j][T],TIME_DATE | TIME_MINUTES)," jPOWER=",POWER(j)," ExBarTime=",TimeToString(LEV[j][ExTIME],TIME_DATE | TIME_MINUTES));
               }
            if ((LEV[j][LIVE]>0 || DelSmall==1) && LEV[f][T]>LEV[j][T] && POWER(f)>POWER(j)){  // ������� ���� �� ������ �� ��������������� ���� �������� ��������� ��������. �� ������ � ������ ��������  /
               LEVEL_DELETE(j,DelSmall); ArrBreak=1;  // ������� ��������� �������. ������ ����, ����� ���� �� ���������� ��� ������ ���������� ������� ��������, �.�. ����� ��� �������� ������ ��� �� ������������  if (Prn) Print(ttt,"DEL jLEV[",j,"] ",LEV[j][P],"  ",TimeToString(LEV[j][T],TIME_DATE | TIME_MINUTES)," jPOWER=",POWER(j),"    fLEV[",f,"] ",LEV[f][P],"  ",TimeToString(LEV[f][T],TIME_DATE | TIME_MINUTES)," fPOWER=",POWER(f)," ExBarTime=",TimeToString(LEV[j][ExTIME],TIME_DATE | TIME_MINUTES));
         }  }  } 
      if (LEV[f][SAW]==0){//  � �   � � � � � � � �  ������� (�����>0)
         if (LEV[f][DIR]!=Pic.dir && MathAbs(New-LEV[f][P])>LEV[f][BACK]) LEV[f][BACK]=MathAbs(New-LEV[f][P]); // ���������� ������� ������ �� ���� �������� �� ���� 
      }else{            //  � � � � � � � �   �������   
         if (LEV[f][LIVE]==1 && ((DelSaw>0 && MathAbs(LEV[f][SAW])>DelSaw) || LEV[f][PER]<LevPer)){// ����������� ���: ���-�� ������������ ��� ��������� ���������� ��� �� ������� ������ ��� ���������
            LEVEL_DELETE(f,0); continue;} // ������ �������� ������������� ������  X("DelSaw "+DoubleToStr(LEV[f][P],0)+"/"+DoubleToStr(LEV[f][SAW],0), LEV[f][P]*Point, clrGreen);  
         // ��������  ���������������  ���������
         if (LEV[f][SAW]<0 && (LEV[f][LIVE]==1 || DelBroken>0) &&// ������� ������� ������ � (�� ������������, ���� �������� ��������� ��������)
            ((LEV[f][DIR]>0 && Pic.dir<0 && New<LEV[f][P]+Pic.intLim) || // �������� ����� ������� ����������� ���� 
             (LEV[f][DIR]<0 && Pic.dir>0 && New>LEV[f][P]-Pic.intLim))){ // ���������� �������� (� �������), ���� �� ���������� ������� ���������� ������ � �������� ������� Lim (�.�. ��� ���������� "� ���������" � �� �����)
            LEVEL_DELETE(f,DelBroken); continue; // X("DelBroken "+DoubleToStr(LEV[f][P],0)+"/"+DoubleToStr(LEV[f][SAW],0), LEV[f][P]*Point, clrRed);
      }  }  }      
   if (Pic.Free<0){// ���� ������ ����� ��� ���,  
      if (DeletedCell>-1)  Pic.Free=DeletedCell; // ���� ���� ���������������, ����� ����� ������ �� ��� (������������ ������, ����������� ��� ���������, �� ������� �� �������� ������)  Print(TimeToString(Time[bar],TIME_DATE | TIME_MINUTES)," DeletedCell[",DeletedCell,"] ",LEV[DeletedCell][P],"  ",TimeToString(LEV[DeletedCell][T],TIME_DATE | TIME_MINUTES));} 
      else                 Pic.Free=OldestCell; // ����� ������ ����� ������
      } 
   // ��������� ������������� ���  (��� ���������� ����� ��� � Pic.New ��������������� ����. �� ���� ��������� ��������, ������� ��������� ������ ��� � ������������/������������ ����
   if (Pic.dir>0){
      for (f=bar+PicPer+1; f<Bars; f++) {    // ����� �� ������� ���������� �� �������
         if (High[f]>High[bar+PicPer]) {ExBarTime=Time[f]; break;} // ������������ �� ����������� (��� ������ ���� ���� (��� �����) ������)  if (Prn) Print(ttt,"1  ExBarTime=",TimeToString(ExBarTime,TIME_DATE | TIME_MINUTES));
   }}else{
      for (f=bar+PicPer+1; f<Bars; f++) {
         if (Low [f]<Low [bar+PicPer]) {ExBarTime=Time[f]; break;} // ������� ������ ���� ���� (��� �����) �����
      }  }  
   Shift=iBarShift(NULL,0,ExBarTime,false);// �����  �������������� ����
   LEV[Pic.Free][P]=New;            // ����� � ��������� ������ �������� ��������
   LEV[Pic.Free][T]=int(Time[bar+PicPer]);    // ����� ������������� ��������
   LEV[Pic.Free][CONCUR]=Concur; // ��������� = ���-�� ���������� � ����������� �������� 
   if (Pic.dir>0){// �������  
      LEV[Pic.Free][TRND]=int(Low [iHighest(NULL,0,MODE_LOW ,PicPer*2+1,bar)]/Point); // ��� ������� ��������� ������� �� �������
      if (LEV[Pic.Free][P]-LEV[Pic.Free][TRND]>Pic.intAtr) LEV[Pic.Free][TRND]=LEV[Pic.Free][P]-Pic.intAtr;
      f=iLowest (NULL,0,MODE_LOW ,Shift-(bar+PicPer)+1,bar+PicPer);
      OppositeTop=int(Low [f]/Point); // ��������������� �������, ������� ����� ����� � ������������� ��� ������ (��� ����������� ��������, ������� ��������� ������ ���) 
      LEV[Pic.Free][FRNT]=New-OppositeTop; // ���� ������ (�������� ������������ �� ��������) = ���������� �� ������ ���� �� ��������, �������� ����� ����� ����� � ������������� ��� �����. 
      if (ExPowerPic<OppositeTop) Pic.Pot=0; else Pic.Pot=1; // Potential=0: ������������ ������� (��� ������������ ������� �������� �������� ��� ����). Potential=1: ������������ ������� 
      }
   else{          // �������      
      LEV[Pic.Free][TRND]=int(High[iLowest (NULL,0,MODE_HIGH,PicPer*2+1,bar)]/Point); // ��� ������� ��������� ������� �� �������
      if (LEV[Pic.Free][TRND]-LEV[Pic.Free][P]>Pic.intAtr) LEV[Pic.Free][TRND]=LEV[Pic.Free][P]+Pic.intAtr;
      f=iHighest(NULL,0,MODE_HIGH,Shift-(bar+PicPer)+1,bar+PicPer);
      OppositeTop=int(High[f]/Point);  // ��������������� �������, ������� ����� ����� � ������������� ��� ��������� (��� ����������� ��������, ������� ���������� ������ �������)
      LEV[Pic.Free][FRNT]=OppositeTop-New; // ���� ������ (�������� ������������ �� ��������) = ���������� �� ������ ���� �� ���������, �������� ����� ����� ����� � ������������� ��� �����. 
      if (ExPowerPic>OppositeTop) Pic.Pot=0; else Pic.Pot=1; // Potential=0: ������������ ������� (��� ������������ ������� �������� �������� ��� ����).  Potential=1: ������������ ������� 
      } 
   if (Pic.Pot>0 && LEV[Pic.Free][FRNT]>ExPower) Pic.Pot=2; // Potential=2 -������ ������������ ������� ����� �������� ��� ������. �� ������������� �������� ����������� ���������
   
   int clr;
   switch(Pic.Pot){
      case 1: clr=clrRed; break;    // Potential=1 -������ ������������ ������� ����� �������� ��� ������. ������������� �������� ����������� ���������
      case 2: clr=clrGreen; break;  // Potential=2 -������ ������������ ������� ����� �������� ��� ������. �� ������������� �������� ����������� ���������
      default: clr=clrGray;         // Potential=0: ������������ ������� (��� ������������ ������� �������� �������� ��� ����). 
      }
   //X("Pic.Pot="+DoubleToStr(Pic.Pot,0), Pic.New, clr);
   //if (Prn){ Print(ttt,"  ExTIME=",TimeToString(LEV[Pic.Free][ExTIME],TIME_DATE | TIME_MINUTES),"  OppositeTop=",OppositeTop*Point,"  [T]=",TimeToString(LEV[Pic.Free][T],TIME_DATE | TIME_MINUTES)," New=",New*Point," ppp=",ppp," ExPower=",ExPower," ExPicTime=",TimeToString(LEV[ppp][T],TIME_DATE | TIME_MINUTES)," ExPowerPic=",ExPowerPic*Point);
   //         LINE("Potential="+DoubleToString(Pic.Pot,0), int(iBarShift(NULL,0,LEV[ppp][T],false)), LEV[ppp][P]*Point, int(iBarShift(NULL,0,LEV[Pic.Free][T],false)), New*Point, clrRed);}     
   LEV[Pic.Free][DIR]=Pic.dir;  // ����������� ��������: 1=�������, -1=�������
   LEV[Pic.Free][BACK]=MathAbs(New-int(Close[bar]/Point));  // ������ ����� (Fall) = ���-�� ������� �� �������� �� �������� �������� ��������. ����� ���������� ������������� �� ���� �������� ���� �� ������
   LEV[Pic.Free][PER]=Shift-(bar+PicPer);   // ������ �������� (�� ������� �� ���������). � ������ ������������ ����� ���-�� ��� �� �������������� ����. � ������ �������� ����� ����������������� � ������� �������.  if (Prn) Print(ttt," [PER]=",LEV[Pic.Free][PER],"  ExBarTime=",TimeToString(ExBarTime,TIME_DATE | TIME_MINUTES));
   LEV[Pic.Free][ExTIME]=int(Time[f]); // ����� ������ ��������, ������� ��������� �������.
   LEV[Pic.Free][LIVE]=1;  // 1-�������� ������� (������������ �� �������), 0-��� ������ ������, �.�. �� ������������ �� �������, � �������� � ������� ���� ��� ��������� � ������ ��� ���������� �������� �������.
   LEV[Pic.Free][SAW]=0;   // ���-�� �������������� ���; ������� "����������" (!=0) � "������������" (<0) ������. 
   Shift=iBarShift(NULL,0,LEV[Pic.Free][T],false);// ����� �������      
   int FrPeriod=int(iBarShift(NULL,0,LEV[Pic.Free][ExTIME],false) - Shift); // ��� Up ����: ������ �� ������ ���� �� ����������� (���� ��� ������� �������). �.�. ���� ������������ ������������ �������� �������, ����� ����� ��������� ������� ������������ ��������� ��� ����������� ������� �� ����
   ArraySort (LEV,WHOLE_ARRAY,0,MODE_DESCEND); // ����������� ������ �� �������� (34, 23, 17, 8, 3, 0, 0, 0) 
   if (PicCnt<2) return; // �� ��������� ��������� ������ ��� ������������ �����
    // � � � �
   Shift=iBarShift(NULL,0,FlatBegin,false); // ����� ������� ������� �����   
   LastFlatBegin=FlatBegin;
   Trend=0;
   TrendLevBreakUp=0;   TrendLevBreakDn=0; // ����� ���-�� ������� ��������� ������� ��� ������������ ������
   if (Pic.dir>0){// ������������ �������
      OppositeTop=iLowest (NULL,0,MODE_LOW ,Shift-(bar+PicPer)+1,bar+PicPer); // ����� ���� ��������������� ������� �����
      FlatHi=LevMiddle/PicCnt; // ������� ������� �����
      FlatLo=Low [OppositeTop]; // ������� ����� �������� ��������� �����
      FlatHiTime=Time[bar+PicPer];  // ����� ������������ ��������� ������� ����� ��� �������� �������
      FlatLoTime=Time[OppositeTop]; // ����� ������������ ��������������� �������
   }else{ // ������������ �������
      OppositeTop=iHighest(NULL,0,MODE_HIGH,Shift-(bar+PicPer)+1,bar+PicPer); // ����� ���� ��������������� ������� �����
      FlatLo=LevMiddle/PicCnt; // ������ ������� ����� - ���������
      FlatHi=High[iHighest(NULL,0,MODE_HIGH,Shift-(bar+PicPer)+1,bar+PicPer)]; // �������� ����� ����� ���������
      FlatHiTime=Time[OppositeTop]; // ����� ������������ ��������������� �������
      FlatLoTime=Time[bar+PicPer];  // ����� ������������ ��������� ������� ����� ��� �������� �������
   }  }//if (Prn) Print(ttt,"  Pic.dir=",Pic.dir," FlatHi=",FlatHi," ",TimeToString(FlatHiTime,TIME_DATE | TIME_MINUTES),"  FlatLo=",FlatLo," ",TimeToString(FlatLoTime,TIME_DATE | TIME_MINUTES)," OppositeTopTime=",TimeToString(Time[OppositeTop],TIME_DATE | TIME_MINUTES)," FlatBegin=",TimeToString(FlatBegin,TIME_DATE | TIME_MINUTES));     
// ��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������
// ��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������   
void LEVEL_DELETE(int f, int DelFactor){ // ���������: ������� ��� ��������; ������� 0-������, 1-�������� ��������
   if (DelFactor==0){ // ������ ��������   
      //if (LEV[f][LIVE]!=0) LINE("DEL LEV", iBarShift(NULL,0,LEV[f][T],false),LEV[f][P]*Point, bar,LEV[f][P]*Point, clrRosyBrown);
      LEV[f][LIVE]=0; // ������ �����, �.�. ��������� ������� � �������, �� �� ���������� ��� �� ������� 
      LEV[f][TRND]=0; // �� ���� ������� ��� ���������
   }else{// �������� ��������  
      //if (LEV[f][P]!=0) LINE("DEL LEV", iBarShift(NULL,0,LEV[f][T],false),LEV[f][P]*Point, bar,LEV[f][P]*Point, clrDimGray);
      LEV[f][P]=0; // ������� ���� �������� ����
      LEV[f][TRND]=0; // �� ���� ������� ��� ���������
      LEV[f][LIVE]=0; // � ����� ����������������� �� ������
      Pic.Free=f; // ����� �������������� ������ ��� ����� ��������
   }  }
// ��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������
// ��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������   
int POWER(int f){ // � � � �    � � � � � �, ������ �� ��������, ������� �� ���������, ���� �����, �.�. �������� ��������� � ������� ������� 
   if (LEV[f][BACK]==0) return (LEV[f][FRNT]); // ������ ����� ��� �� �������������, ������ �������� (= �������� ������������ ��������)
   switch (LevPower){// ���� ������ ������������ �� ��������� ��������� � ������� �������. �� ��� �������: 1-��������, 0-�������, -1-������, 2-������� �� ����
      case -2: return (MathMin(LEV[f][FRNT],LEV[f][BACK])); break; // ������� �� ����
      case -1: return (LEV[f][BACK]); break;          // ������ �����
      case  0: return ((LEV[f][FRNT]+LEV[f][BACK])/2); break;  // ������� ��������
      case  1: return (LEV[f][FRNT]); break; // �������� ����� = ���� ������ (�������� ������������ �� ��������) = ���������� �� ������ ���� �� ���������, �������� ����� ����� ����� � ������������� ��� �����.
      default: return (MathMax(LEV[f][FRNT],LEV[f][BACK])); break; // ������� �� ����
   }  }     
// ��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������
// ��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������   
void PIC_LIM(){   // ������ ���������� �������
   switch (PicLim){// PicLimPerCent = PicLimVal * PicLimVal * 0.01
      case 1: Pic.Atr=(FastAtr+SlowAtr)/2; break; // ������� �������� ��������� ���� ��������� �������
      case 2: Pic.Atr=MathMin(FastAtr,SlowAtr); break;
      case 3: Pic.Atr=MathMax(FastAtr,SlowAtr); break;
      }
   Pic.Lim=Pic.Atr*PicVal*0.01;   // ������ ������� � % ATR
   Pic.intAtr=int(Pic.Atr/Point);   
   Pic.intLim=int(Pic.Lim/Point);  // ������ ���������� �������
   FirstLevPower=Pic.intAtr*2*(2+FirstLev); // �������� ��������, ������� ������ ���������� �������, ����� ����� ������ 
   }  //if (Prn) Print(ttt," Pic.Lim=",NormalizeDouble(Pic.Lim,Digits-1)," FastAtr=",NormalizeDouble(FastAtr,Digits-1)," SlowAtr=",NormalizeDouble(SlowAtr,Digits-1)," Pic.Avg=",NormalizeDouble(Pic.Avg,Digits-1)," MidMovUp=",NormalizeDouble(MidMovUp,Digits-1)," MidMovDn=",NormalizeDouble(MidMovDn,Digits-1));   
// ��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������
// ��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������
void FIRST_LEVELS(int uf, int df){// ���������� ������ ������� �� ��������� ���������   
   LastFirstUp=FirstUp; double tempUP=FirstUpPic;
   LastFirstDn=FirstDn; double tempDN=FirstDnPic;
   if (uf>-1){// ����� ������ � ������� ������� 
      FirstUp=LEV[uf][TRND]*Point;     // ������ ��������� �� �������
      FirstUpPic=LEV[uf][P]*Point;  // ������� ������� ������ �� �������
      FirstUpCenter=(FirstUp+FirstUpPic)/2; // ��������� � ������� ������� ���������� 
      FirstUpTime=LEV[uf][T];       // ����� ��� ������������
      }//if (Prn) Print(ttt," FirstUp=",LEV[uf][P],"  ",TimeToString(LEV[uf][T],TIME_DATE | TIME_MINUTES));
   if (df>-1){// ����� ������ � ������� �������
      FirstDn=LEV[df][TRND]*Point;     // ������ ��������� �� �������
      FirstDnPic=LEV[df][P]*Point;  // ������� ������� ������ �� �������
      FirstDnCenter=(FirstDn+FirstDnPic)/2; // ��������� � ������� ������� ���������� 
      FirstDnTime=LEV[df][T];       // ����� ��� ������������
      }//if (Prn) Print(ttt," FirstDn=",LEV[df][P],"  ",TimeToString(LEV[df][T],TIME_DATE | TIME_MINUTES));
   if (LastFirstUp!=FirstUp) LastFirstUpPic=tempUP;
   if (LastFirstDn!=FirstDn) LastFirstDnPic=tempDN;
   // ����� ������ ����� ������� �������� ���� ������ ���������
   if (LastFirstUp==FirstUp && LastFirstDn==FirstDn) return;// ������ �� ����������
   if (uf<0 || df<0) return;
   FirstMiddle=0;
   int fConcur, Concur=0, fPwr=-1, Power=0, Mid=int((FirstUp+FirstDn)*0.5/Point); // �������������� ���������, ����� ������ �� ��� �� ������� �� ������ ���������������� ����
   int UpZone, DnZone;
   int PowerCheck=MinPower*Pic.intAtr; // ����������� �������� �����, ������ �������� ������ �� ������������ 
   datetime TimeStart=MathMin(FirstUpTime,FirstDnTime), TimeEnd=MathMax(FirstUpTime,FirstDnTime);
   double Zone=(FirstUp-FirstDn)/8; // ����������� ���� ������ ��������� � 1/8 ��������� ����� ��������
   UpZone=int((FirstUp-Zone)/Point); // ����������� ���� ������ ���� ���������
   DnZone=int((FirstDn+Zone)/Point); // ����������� ���� ������ ���� ���������
   for (int f=uf; f<df; f++){// ����� ������� ��������
      if (f==uf) continue;
      int pwr=POWER(f);
      if (LEV[f][LIVE]==0 || LEV[f][PER]<LevPer || pwr<PowerCheck) continue; // ������ ��������, ����� � ������ ��������� ����� ����������. ��� ��������� � ������� ��� ���������, �� �� ������������ �� �������
      if (LEV[f][T]<TimeStart || LEV[f][T]>TimeEnd) continue; // ������������� ������ ������ ����� ������
      if (FirstUpTime>FirstDnTime && (LEV[f][P]>Mid || LEV[f][P]<DnZone)) continue; // ��� ����� ������� = (����� ����������): ���� ���� ��������� Mid �� �� ������ 1/8 ��������� �� ������� ������
      if (FirstUpTime<FirstDnTime && (LEV[f][P]<Mid || LEV[f][P]>UpZone)) continue; // ��� ������ ������� = (����� ����): ���� ���� ��������� Mid �� �� ������ 1/8 ��������� �� �������� ������
      if (LEV[f][CONCUR]>Concur){Concur=LEV[f][CONCUR]; fConcur=f;} // ������� � ������������ ���-��� ��������
      if (pwr>Power) {Power=pwr; fPwr=f;}// ����� ������� ������� - ���������� � ������������ ������� ��������
      }
   if (Concur>=FltPic)  FirstMiddle=LEV[fConcur][P]*Point; // ������� � ���-��� ��������, ����������� FlatPwr
   else {if (fPwr>=0)   FirstMiddle=LEV[fPwr][P]*Point;}   // ����� ������� (������������ ������� ��������)
   }    
// ��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������   
// ��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������   
void LEVELS_FIND_AROUND(){ // � � � � �   � � � � � � � � � � �   � � � � � � � 
   int   uf=-1, df=-1; // ������ ������ �������  
   int PowerCheck=MinPower*Pic.intAtr; // ����������� �������� �����, ������ �������� ������ �� ������������ 
   u1=-1; u2=-1; u3=-1; d1=-1; d2=-1; d3=-1; um=-1; dm=-1; UP1=0; DN1=0; UP2=0; DN2=0; UP3=0; DN3=0; UpCenter=0; DnCenter=0; 
   int   mirUp=Pic.intAtr*15, mirDn=Pic.intAtr*15; // ��������� ���������� �� ���������� �������� 
   for (int f=0; f<LevelsAmount; f++){// ��������������� ����� ������   
      if (LEV[f][P]==0) break; // ����� ������ ��������
      if (LEV[f][LIVE]==0) continue;   // ������ �������� ��������� ����������. ��� ��������� � ������� ��� ���������, �� �� ������������ �� �������
      if (LEV[f][SAW]==0){// ��� �� �������� ��� ����������� �� �������� �����
         if ((LEV[f][DIR]>0 && intH>LEV[f][P]+Pic.intLim) ||   // ���� ��� ��������� 
             (LEV[f][DIR]<0 && intL<LEV[f][P]-Pic.intLim)){    // ����������� ���
            LEV[f][SAW]=1;    // ���������� ��������� ������ - SAW!=0     X("break "+DoubleToStr(LEV[f][P],0)+"/"+DoubleToStr(LEV[f][SAW],0), LEV[f][P]*Point, clrBlue);
            LEV[f][TRND]=0;   // ������� ��������� ��������
            int Shift=iBarShift(NULL,0,LEV[f][T],false); // ����� �������� �� ������� ������������ �������� (��������) ����
            if (Shift-bar<LEV[f][PER])  LEV[f][PER]=Shift-bar;} // ������������� ������ ��������       
      }else{ // �������� ��� ����������� �� �������������
         if (LEV[f][SAW]>0){// �������� �� ������������
            if (Pic.dir>0 && intL>LEV[f][P]) LEV[f][SAW]=-LEV[f][SAW];  // ���� ��������� �������� �������, 
            if (Pic.dir<0 && intH<LEV[f][P]) LEV[f][SAW]=-LEV[f][SAW];  // ��������� ��� "����������"
            }
         if (intH>LEV[f][P] && intL<LEV[f][P]){// ��� ������� �����
            if (LEV[f][SAW]>0) LEV[f][SAW]++; else LEV[f][SAW]--; // ���-�� ���, ������������ �������
         }  }      
      if (LEV[f][PER]<LevPer || POWER(f)<PowerCheck) continue;  // ����� � ������ ���������  ����������. ��� ��������� � ������� ��� ���������, �� �� ������������ �� �������
      // �������� ���������� �������
      if (LEV[f][SAW]<0 && (LEV[f][SAW]>=-DelSaw || DelSaw==0)){ // SAW- ���-�� ���, "������������" �������; <0 ��� ������ ������ ����, ����� �������� ������� ����� ���������
         if (LEV[f][DIR]>0){
            if (intL<LEV[f][P]) LEV[f][SAW]=-99; // �������� ������, �������� ���� ��� ����������, ����� �� �������� � NEW_LEVEL() ��� �������� ��������������� ���������
            if (MathAbs(LEV[f][P]-intL)<mirDn) {dm=f; mirDn=MathAbs(LEV[f][P]-intL);} // ����� ������� ���������� ������� � ������� ����
         }else{
            if (intH>LEV[f][P]) LEV[f][SAW]=-99; // �������� ������, �������� ���� ��� ����������, ����� �� �������� � NEW_LEVEL() ��� �������� ��������������� ���������
            if (MathAbs(LEV[f][P]-intH)<mirUp) {um=f; mirUp=MathAbs(LEV[f][P]-intH);} // ����� ������� ���������� ������� � ������� ����    
         }  } 
      // �������� ������ � ����� FltPwr ��������� (UP2,DN2)
      if (LEV[f][CONCUR]>=FltPic && MathAbs(LEV[f][SAW])<=DelSaw){
         if (LEV[f][DIR]>0 && LEV[f][P]>intH)         u2=f; // 
         if (LEV[f][DIR]<0 && LEV[f][P]<intL && d2<0) d2=f; //  
         }
      if (LEV[f][SAW]!=0) continue; // ������ ������������� ������ ���������� ������
      // ���������� ���� (UP1,DN1)
      if (LEV[f][P]>intH)           u1=f; //  ��������� ���������� ��� ([DIR]>0)
      if (LEV[f][P]<intL && d1<0)   d1=f; //  ��������� ������ �� ��������� ���������� �������
      // �������� ��������� ������� (����� ������ ��� �� ��������), ����������� ������ �������     
      if (LEV[f][TRND]<=0) continue; // ��������� ��� ������
      int center=(LEV[f][P]+LEV[f][TRND])/2; // �������� ����� ������� (���������)
      int Shift=iBarShift(NULL,0,LEV[f][T],false); // ����� �������� �� ������� ������������ �������� (��������) ����
      if (LEV[f][DIR]>0){ // �������
         if (intH>center && int(High[iLowest (NULL,0,MODE_HIGH,Shift-bar,bar)]/Point)<LEV[f][TRND]) {// ������� ������� ������ � �� ���������� �� ������ ���� �� ������� ������ ������� ���� ���� ��� ��������� ���� ����.  
            LEV[f][TRND]=0; // �������� ��������� ������ �������  //X("Del UpTrendLev", LEV[f][TRND]*Point, clrViolet);
            if (LEV[f][PER]>=TrLevPwr) {TrendLevBreakUp++;  TrendLevBreakDn=0;}  // ���� ��� ��� ���������� ������� �������, ����������� ���-�� ������� �����, �������� ������ ����    
         }else{// ��������� ������� �� ������� ��� �� ������ 
            if (intH<center){// ����� ������� ������ �� �������
               u3=f; // ��������� ���������
               if (FirstLev>=0){ if (POWER(f)>FirstLevPower)   uf=f;} // ��������� ��� � ������� ����, ������������ �������� � ATR*2*(2+FirstLev)
               else            { if (LEV[f][PER]>FirstLevPer)  uf=f;} // ���, ������������ ����� ������� �������� �� ������� � FirstLev ����
         }  }  }    
      else{ // �������
         if (intL<center && int(Low [iHighest(NULL,0,MODE_LOW ,Shift-(bar+PicPer),bar+PicPer)]/Point)>LEV[f][TRND]) {// ������� ������� ������ � �� ���������� �� ������ ���� �� ������� ������ ������� ���� ���� ��� ���������� ��� ���. 
            LEV[f][TRND]=0;  // �������� ��������� ������ �������  //X("Del DnTrendLev", LEV[f][TRND]*Point, clrViolet);
            if (LEV[f][PER]>=TrLevPwr) {TrendLevBreakDn++;  TrendLevBreakUp=0;}  // ���� ��� ��� ���������� ������� �������, ����������� ���-�� ������� ����, �������� ������ �����.       
         }else{// ��������� ������� �� ������� ��� �� ������ 
            if (intL>center){// ����� ������� ������ �� �������
               if (d3<0) d3=f; // ��������� ���������
               if (FirstLev>=0){ if (POWER(f)>FirstLevPower  && df<0) df=f;} // ��������� ��� � ������� ����, ������������ �������� � ATR*2*(2+FirstLev)
               else            { if (LEV[f][PER]>FirstLevPer && df<0) df=f;} // ���, ������������ ����� ������� �������� �� ������� � FirstLev ����
      }  }  }  }  
   if (u1>-1) {UP1=LEV[u1][P]*Point;      Tup1=LEV[u1][T];} // ��������� ������� ��� ���� � ������ ����� ��������  
   if (u2>-1) {UP2=LEV[u2][P]*Point;      Tup2=LEV[u2][T];}// ������� �������� ������� � ����������� ���-��� �������� 
   if (u3>-1) {UP3=LEV[u3][TRND]*Point;   UP3Pic=LEV[u3][P]*Point;   UpCenter=(UP3+UP3Pic)*0.5;} // ��������� ������� �� �������, ��� ��� � ��� ���������
   if (d1>-1) {DN1=LEV[d1][P]*Point;      Tdn1=LEV[d1][T];} // if (Prn) Print(ttt,"  LEV[",d1,"]=",LEV[d1][P],"  ",TimeToString(LEV[d1][T],TIME_DATE | TIME_MINUTES)," L[6]=",LEV[d1][BACK]," L[5]=",LEV[d1][DIR]);   
   if (d2>-1) {DN2=LEV[d2][P]*Point;      Tdn2=LEV[d2][T];}// ������� ������� � ����������� ���-��� ��������
   if (d3>-1) {DN3=LEV[d3][TRND]*Point;   DN3Pic=LEV[d3][P]*Point;   DnCenter=(DN3+DN3Pic)*0.5;} // ��������� ������� �� �����k�, ��� ��� � ��� ���������
   FIRST_LEVELS(uf,df); // ������ ������ ������� � ������ ���� ������ ���������  
   }  
// ��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������
// ��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������
// ��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������
// ��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������   
void TREND_DETECT(){ // � � � � � � � � � � �   � � � � � � 
   double                  pH=Pic.hi, pH2=Pic.hi2, pL=Pic.lo, pL2=Pic.lo2; datetime pHt=hiTime, pLt=loTime;   // ��� TrPic=1 ������� ������ ����
   if (MathAbs(TrPic)==2) {pH=Pic.Hi; pH2=Pic.Hi2; pL=Pic.Lo; pL2=Pic.Lo2;          pHt=HiTime; pLt=LoTime;}  // ������� ������� ����
   datetime FT=MathMax(FlatHiTime,FlatLoTime); // ����� ��������� ����� ������������� �����, �.�. ���� ����� ��������� ������ ����� �� ����� ��������������
   if (GlobalTrend<=0 && High[bar]>FirstUpCenter)  GlobalTrend= 1;  // ����� ����������� ������ ���
   if (GlobalTrend>=0 && Low [bar]<FirstDnCenter)  GlobalTrend=-1;  // �������� ������� ������ �������   
   if (TrPic>0){  // �������� �������������(������� ��������) ����� ���������
      if (Trend==0){ // ����� �� �����
         if (pH-FlatHi>Pic.Lim && pHt>FT) Trend= 1;  // ��� ��� �������� ����� � ������ �����
         if (FlatLo-pL>Pic.Lim && pLt>FT) Trend=-1;  // ��� ��� �������� ����� � ������ �����
      }else{   
         if (pH-pH2>Pic.Lim && pL-pL2>Pic.Lim) Trend= 1; // ��� ��� ������� �����
         if (pL2-pL>Pic.Lim && pH2-pH>Pic.Lim) Trend=-1; // ��� ��� ������� �����
      }  }
   if (TrPic<0){  // �������� �������������(������� ��������) ����� ��������
      if (Trend==0){ // ����� �� �����
         if (pL>FlatHi && pLt>FT) Trend= 1;  // ��� ������� �������� ����� �������������� �������  ( ����� )
         if (pH<FlatLo && pHt>FT) Trend=-1;  // ��� ������ �������� ����� �������������� ������� ( ����� )
      }else{   
         if (pL>pH2) Trend= 1; // ��� �������� �������������� ������� 
         if (pH<pL2) Trend=-1; // ��� �������� �������������� �������
      }  }
   if (TrLoOnHi>0){ // �������� ������ ������� ��������� ���������
      if (TrLoOnHi==1)  {pH=Pic.hi; pH2=Pic.hi2; pL=Pic.lo; pL2=Pic.lo2; pHt=hiTime; pLt=loTime;} // ��� TrLoOnHi==1 ������� ������ ����
      else              {pH=Pic.Hi; pH2=Pic.Hi2; pL=Pic.Lo; pL2=Pic.Lo2; pHt=HiTime; pLt=LoTime;} // ��� TrLoOnHi==2 ������� ������� ����
      if (UP1<LowestHi) LowestHi=UP1; // ����� ������ �������� �� �������� ����� ������� �������������
      if (Trend!=1 && pL>LowestHi) {// ������ ������������� � �������� (������ ���������)
         Trend=1; HighestLo=DN1;} // ��������� ������ ������ �� ������
      if (DN1>HighestLo) HighestLo=DN1; // ����� ������� ������� ��� �������� ����� ������� ���������
      if (Trend!=-1 && pH<HighestLo) { // ������ ��������� � �������� (������� ���������)
         Trend=-1; LowestHi=UP1; // ��������� ������ ������ �� ������
      }  }
   if (TrLevBrk!=0){ // �������� ������ TrLevBrk ��������� �������
      if (Trend==0){
         if (Pic.New>FlatHi && TrendLevBreakUp>0) Trend= 1; // ������ ���������� ������ ��� ������� �������� �����
         if (Pic.New<FlatLo && TrendLevBreakDn>0) Trend=-1; // ������ ���������� ������ ��� ������ �������� �����
      }else{
         if (TrendLevBreakUp>=BrokenLevels) Trend= 1; // �������� ������ TrLevBrk ��������� ������� �� �������
         if (TrendLevBreakDn>=BrokenLevels) Trend=-1; // �������� ������ TrLevBrk ��������� ������� �� �������
   }  }  }  // if (Prn) Print(ttt," pH=",pH," FlatHi=",FlatHi,"  HiTime=",TimeToString(HiTime,TIME_DATE | TIME_MINUTES));
// ��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������
// ��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������
void TARGET_COUNT(){// ������ ������� ������� ��������� �������� �� ��������� ��������� ���������� ����������� ��������
   double max=0;
   int i;// if (Pic.dir==LastPic) Print(TimeToString(Time[bar],TIME_DATE | TIME_MINUTES)+"    Pic.dir==LastPic=",Pic.dir);
   if (Pic.Dir>0){// ��� ������� ����
      if (Pic.Hi-Pic.Lo<SlowAtr) return; // ������ �������� ����������
      if (Pic.Dir2!=Pic.Dir) for (i=Movements-1; i>0; i--) MovUp[i]=MovUp[i-1];//�������������� ������� �������� ���� � ������ ����������� �����, � ��������� ������ ������ ��������� ��������� �������� �������� ����� //  else if (Prn) Print(ttt," Pic.Hi=",NormalizeDouble(Pic.Hi,Digits-1)," Pic.Lo=",NormalizeDouble(Pic.Lo,Digits-1)," Hi-Lo-",NormalizeDouble(Pic.Hi-Pic.Lo,Digits-1)," SlowAtr=",NormalizeDouble(SlowAtr,Digits-1));
      MovUp[0]=Pic.Hi-Pic.Lo; // ��������� �������� �����
      MidMovUp=0; // ����������� �������� �������� �������� �����
      for (i=0; i<Movements; i++){// ����� ��������� �������� �����
         MidMovUp+=MovUp[i];// ��������� ���
         if (MovUp[i]>max) max=MovUp[i]; // ���� ������������ 
         }
      if (MathAbs(Target)<2) MidMovUp/=Movements; // ��� Target=-1..1 �������� ������������ ��� ������� ��������
      else MidMovUp=max; // ��� Target=-2 ��� Target=2 ���� ������������ ��������
      }//if (Prn) Print(ttt," Pic.Hi=",NormalizeDouble(Pic.Hi,Digits-1)," Hi-Lo-",NormalizeDouble(Pic.Hi-Pic.Lo,Digits-1)," TargetDn=",NormalizeDouble(TargetDn,Digits-1),"  max=",NormalizeDouble(max,Digits-1)," min=",NormalizeDouble(min,Digits-1)," MidMovUp=",NormalizeDouble(MidMovUp,Digits-1)," MidMovDn=",NormalizeDouble(MidMovDn,Digits-1));
   else{ // ��� ������ ����
      if (Pic.Hi-Pic.Lo<SlowAtr) return; // ������ �������� ���������� 
      if (Pic.Dir2!=Pic.Dir) for (i=Movements-1; i>0; i--) MovDn[i]=MovDn[i-1];//�������������� ������� �������� ���� � ������ ����������� �����, � ��������� ������ ������ ��������� ��������� �������� �������� ����
      MovDn[0]=Pic.Hi-Pic.Lo; // ��������� �������� �����
      MidMovDn=0; // ����������� �������� �������� �������� ����
      for (i=0; i<Movements; i++){// ����� ��������� �������� ����
         MidMovDn+=MovDn[i];// ��������� ���
         if (MovDn[i]>max) max=MovDn[i]; // ���� ������������ 
         }
      if (MathAbs(Target)<2) MidMovDn/=Movements;  // ��� Target=-1..1 �������� ������������ ��� ������� ��������     
      else MidMovDn=max; // ��� Target=-2 ��� Target=2 ���� ������������ ��������
   }  }  //if (Prn) Print(ttt," Pic.Lo=",NormalizeDouble(Pic.Lo,Digits-1)," Hi-Lo-",NormalizeDouble(Pic.Hi-Pic.Lo,Digits-1)," TargetUp=",NormalizeDouble(TargetUp,Digits-1),"  max=",NormalizeDouble(max,Digits-1)," min=",NormalizeDouble(min,Digits-1)," MidMovUp=",NormalizeDouble(MidMovUp,Digits-1)," MidMovDn=",NormalizeDouble(MidMovDn,Digits-1));
   
// ��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������
// ��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������   


//   DelBroken   �� ����������
   
    
   
           