double   NewHi, NewLo, LastHi, LastLo, HH, LL, HHH, LLL,
         FirstUp, FirstDn, // ������ ������� �� �������/�������
         FirstUpCenter, FirstDnCenter, // ��������� ������ ������� �� �������/�������
         FirstUpPic, FirstDnPic, // ��������� ������ ������ �������
         FlatHi, FlatLo, // �������� ������ (��� ������� �������)
         MostVisited, // �������� ���������� ������� ����� ������� ��������
         MovUp[5], MovDn[5], // ������� ��������, ���������������� � init() �� Movements ������
         TargetUp, TargetDn, // ���� ��������
         MidMovUp, MidMovDn, // ������� �������� ���������� �������� �������� ��������
         HighestLo, // ����� ������� ������� �� ������
         LowestHi,  // ����� ������ ������� �� ������
         UP1, DN1, // ��������� ������
         UP2, DN2, // �������� ������ � PowerCheck ���������
         UP3, DN3, DN3Pic, UP3Pic, UpCenter, DnCenter; // ��������� ������, �� ���� � ���������
int   LevelsAmount=50, Trend=0, HiTime, LoTime;
int   Tup1,Tdn1,Tup2,Tdn2; // ����� ������������ ������� UP1,...DN2  
int   TrendLevels[5], TrLevCnt; // ������ � ���������� ����� ���������� �������� ��� ���������� �����       
int   LEV[1][10], Impulse, 
      u1, u2, u3, d1, d2, d3, um, dm, // ������� ������� ������� UP1..DN3
      intH, intL,  // HH � LL �������� ���� ��� ���������
      Movements=3,  // ���-�� ��������� �������� ��� ����������� ����������� ��������
      LastDir, FrDir, // ����������� ���� ��� ������� ��������� � �������� LevPer
      LastUp=0, LastDn=0, // ������ ������� � �������, ������� � HH(LL) ��� ������� ��������. ����� �� ���������� ���� ������ � ������ �� ������� ����, � �������� � ���� ������. 
      TrendLevBreakUp=0, TrendLevBreakDn=0, // ���� ������ ���������� ������ �� �������/������� ��� ����� ������. ��� ������ ������ �� ������� TrendLevBreakUp ������������� �� 1, � TrendLevBreakDn ����������. � ��������
      GlobalTrend, // ����� ������������ ������� ������ (�������) ������� �� �������/������� 
      FirstUpTime, FirstDnTime, // ����� ����������� ������ �������
      FlatHiTime,  FlatLoTime,   // ����� ������������ ���������� ���� �����
      FlatTime;
struct PicLevels{  //  C � � � � � � � �   P I C
   int   Dir;  // ����������� ���� ��� ������ ��������� � �������� PicPer: 1-�������, -1-�������
   int   Free; // �������������� ���� 
   double New; // ��������� �� ����������������
   double Atr; // ������������ ��� �������� 
   int    intAtr; // ����� ���
   double Avg; // ������� ������� ��������� ���� ��������� ��� ����������� ������
   double MirUp;  // ���������� ������� ������
   double MirDn;  // ���������� ������� �����
   int MirUpTime; // ����� ������������� ����������� ������ ������
   int MirDnTime; // ����� ������������� ����������� ������ �����
   double Lim;    // �������� ���������� �������
   } Pic;    

            
// ��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������
// ��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������
void LEVELS_MAIN(){// �������� ���� ������ �������
   Pic.New=0;
   HH =High[iHighest(NULL,0,MODE_HIGH,PicPer*2+1,bar)];   // �������� �������� ��� 
   LL =Low [iLowest (NULL,0,MODE_LOW ,PicPer*2+1,bar)];   // ������������ ������� � NEW_LEVEL().
   HHH=High[iHighest(NULL,0,MODE_HIGH,LevPer*2+1,bar)];   // ����������� �������� ���
   LLL=Low [iLowest (NULL,0,MODE_LOW ,LevPer*2+1,bar)];   // ����������� ��������, ������, ��������� � ������� �������...
   intH  =int(High[bar]/Point);
   intL  =int(Low [bar]/Point);
   Pic.Atr=iATR(NULL,0,SlowAtrPer,bar); if (Pic.Atr==0) return;
   Pic.intAtr=int(Pic.Atr/Point);
   if (High[bar+PicPer]==HH){ // ����� ������ �������  ///////////////////////////////////////////////////////
      Pic.New=HH; Pic.Dir=1;
      Impulse=int(((HH-Low[bar+PicPer-1])+(HH-Low[bar+PicPer+1]))*0.5*PowerPlus/Pic.Atr); // ���� ��������, � ������� ���� ����������� �� ������, ����� ����������� � ���������
      NEW_LEVEL();
      }
   if (Low[bar+PicPer]==LL){ // ����� ������ �������  /////////////////////////////////////////////////////////
      Pic.New=LL; Pic.Dir=-1;  
      Impulse=int(((High[bar+PicPer-1]-LL)+(High[bar+PicPer+1]-LL))*0.5*PowerPlus/Pic.Atr); // ���� ��������, � ������� ���� ����������� �� ������, ����� ����������� � ���������
      NEW_LEVEL();
      }
   if (High[bar+LevPer]==HHH){// // ����� ������� �������
      LastHi=NewHi;  NewHi=HHH; LastDir=FrDir; FrDir=1; HiTime=int(Time[bar+PicPer]); // 
      TARGET_COUNT();// ������ ������� ������� ��������� �������� �� ��������� ��������� ���������� ����������� �������� 
      LIM_DETECT(); // ����������� Pic.Lim ������ ���������� �������
      }  
  if (Low[bar+LevPer]==LLL){// ����� ������� �������
      LastLo=NewLo; NewLo=LLL;  LastDir=FrDir; FrDir=-1; LoTime=int(Time[bar+PicPer]);//
      TARGET_COUNT();// ������ ������� ������� ��������� �������� �� ��������� ��������� ���������� ����������� ��������
      LIM_DETECT(); // ����������� Pic.Lim ������ ���������� �������
      }  
   if (TimeHour(Time[bar])<TimeHour(Time[bar+1])){ // � � � � �   � � � �       
      // if (Prn) Print(ttt,"NewDay ","  ",TimeToString(Time[bar],TIME_DATE | TIME_MINUTES)," LastHi=",LastHi);
      }  
   LEVELS_FIND_AROUND(); // � � � � �   � � � � � � � � � � �   � � � � � � �      
   TREND_DETECT();   // � � � � � � � � � � �   � � � � � � 
   switch (FlsLev){// � � � � � �   � � � � � � � � , �.�. ������ ����������� ��� ��������:    
      case 1: FALSE_LEVELS (NewHi,HiTime,NewLo,LoTime); break;  // ���������� ����
      case 2: FALSE_LEVELS (UP1,Tup1,DN1,Tdn1); break;  // ���������� ������ c ����� � ����� ��������
      case 3: FALSE_LEVELS (UP2,Tup2,DN2,Tdn2); break;  // �������� ��������� ������ � ����� � ����� ���������
      case 4: if (Trend==0) FALSE_LEVELS (FlatHi,FlatHiTime,FlatLo,FlatLoTime); break;  // ��������� ������ ��������������� ������
   }  }
   
     
// ��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������
// ��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������      
void NEW_LEVEL(){
   int NEW =int(Pic.New/Point);   // ������������� Pic.New
   int LIM=int(Pic.Lim/Point);  // ������ ���������� �������
   int f,j=0, Shift, center=0, pwr, From=bar, FrPeriod=2, BreakBars; 
   int ExPicTime=0; // ����� ����������� �������������� ���� ����� ����� (��� ������� - ���������� �������, ��� ������� - ���������� �������)
   int OppositeTop; // ����� ���� ��������������� �������, ������� ����� ����� � ������������� ��� ������ (��� ����������� ��������, �������������� ����� ��� ������ ������ �������)
   int Concur=1;   // ���-�� ���������� �����
   int Visits=0; // ���-�� ��������� ��� �������� ����������� ������
   int FlatBegin=0;// ����� ������ �����
   double PowerLevel=Pic.New; // ������� ������� ��������� �����
   double lev; // lev=LEV[f][0]*Point
   int PicCnt=1; // ������� ������, �������������� ����
   Pic.Free=-1; // ��������� ������
   int OldestCell=0,  OldestTime=int(Time[bar]);  // ����� � ����� ����� ������ ������
   int DeletedCell=-1, DeletedTime=int(Time[bar]); // ����� � ����� ����� ������ ��������� ������
   bool  FirstDnFind=false; // ���� ����������� ������, ���� �� ������ ���� 
   //if (Prn) Print(ttt,"              NEW=",NEW," intH=",intH," intL=",intL);
   for (f=0; f<LevelsAmount; f++){// ���������� ���� ������ ��������� �� �������� � ��������
      if (LEV[f][0]==0) {Pic.Free=f; break;} // ��������� �� ������� ��������, �������� � ������� �����������
      if (LEV[f][1]<OldestTime) {OldestTime=LEV[f][1]; OldestCell=f;} // ����� ������ ������� �� ����������� ������� �� ������, ���� �� �������� ��������� ����� �������
      if (LEV[f][9]==0 && LEV[f][1]<DeletedTime) {DeletedTime=LEV[f][1]; DeletedCell=f;}// ����� ������ �� ���������������, � ������ ������� ������ ����� ����
      Shift=iBarShift(NULL,0,LEV[f][1],false); // ����� �������� �� ������� ������������ �������� (��������) ����
      lev=LEV[f][0]*Point;
      // � � � � � � � � � � �   � � � � �
      if (MathAbs(NEW-LEV[f][0])<LIM){// ������������ �������� � �������� LIM
         LEV[f][2]++; Concur++;// ����� ����������� �������, ����������� ���-�� ����������
         if (Pic.Dir==LEV[f][5] && //  ����� ����� ������, ���� ������� - ����� ������
            Time[bar+PicPer]-LEV[f][1]>FlatTime && // ����������� ���������� ����� �� ������ ����
          ((Pic.Dir>0 && int(High[iHighest(NULL,0,MODE_HIGH,Shift-bar+1,bar)]/Point)<NEW+LIM) || // ����� ���������� � ����� ������ ������ �� ���������
           (Pic.Dir<0 && int(Low [iLowest (NULL,0,MODE_LOW ,Shift-bar+1,bar)]/Point)>NEW-LIM))){ // ����� ���������� � ����� ������ ������ �� ���������  
            PicCnt++; // ���������� ��������� ������
            PowerLevel+=lev; // � �� ����� ��� ���������� 
            if (LEV[f][1]>FlatBegin) FlatBegin=LEV[f][1];  // ����� ������ ���, ����������� � �����, ����� �������� ����� ���� ��������������� ������� �����    
         }  }//if (PicCnt>2) Print(TimeToString(Time[bar],TIME_DATE | TIME_MINUTES),":  NEW=",NEW,"  PicCnt=",PicCnt," FlatBegin=",TimeToString(LEV[f][1],TIME_DATE | TIME_MINUTES)," Htop=",High[iHighest(NULL,0,MODE_HIGH,Shift-bar+1,bar)]," Ltop=",Low [iLowest (NULL,0,MODE_LOW ,Shift-bar+1,bar)]);
      pwr=LEV[f][2]+LEV[f][4]; // "���������" ������ = ���-�� �������� + �������� �������. ����������, �� ������� ����������� ������ �������� ��� ��������         
      if (LEV[f][2]>PowerCheck && LEV[f][2]>Visits && lev<=FirstUp && lev>=FirstDn) {Visits=LEV[f][2]; MostVisited=lev;}// ����� ������ ����������� ������
      // � � � � � � � � �    � � � � � �    � � � � � � � � �
      if (LEV[f][5]>0 && LEV[f][0]+LIM>=int(High[iHighest(NULL,0,MODE_HIGH,(Shift-bar)*2,bar)]/Point)) LEV[f][7]=Shift-bar; // ���� ������� ���������,
      if (LEV[f][5]<0 && LEV[f][0]-LIM<=int(Low [iLowest (NULL,0,MODE_LOW ,(Shift-bar)*2,bar)]/Point)) LEV[f][7]=Shift-bar; // ������ ��� ������
      // � � � � � � � �   � � � � � � � � � � � � �   � � � � � � �                  //if (LEV[f][3]==112906) Print(ttt," LEV[",f,"] ",LEV[f][0],"  ",TimeToString(LEV[f][1],TIME_DATE | TIME_MINUTES)," [2]=",LEV[f][2]," 4=",LEV[f][4]," [3]=",LEV[f][3]);   
      if (PowerPlus<0){// �������� ������, ���� ����� ���� ��������� ����� ������� (������������ ������� ��������)
         for (j=f; j<LevelsAmount; j++){// ������� ������� ������� � ����������� ���� �� ������, 
            if (LEV[j][0]==0) continue;
            if (LEV[j][5]!=LEV[f][5]) continue; // ������� ���������� ������ � ���������, ������� ����� � ���������
            if (LEV[f][1]<LEV[j][1] && LEV[f][8]<LEV[j][8]){  // ������� ������� ������ � ������ ����������  //if (Prn) Print(ttt,"DEL fLEV[",f,"] ",LEV[f][0],"  ",TimeToString(LEV[f][1],TIME_DATE | TIME_MINUTES)," [8]=",LEV[f][8]," jLEV[",j,"] ",LEV[j][0],"  ",TimeToString(LEV[j][1],TIME_DATE | TIME_MINUTES)," [8]=",LEV[j][8]);
               LEVEL_DELETE(f,DelSmall); break; // ������� ������� �������, ���������� ������ ������
               }
            if (LEV[f][1]>LEV[j][1] && LEV[f][8]>LEV[j][8]){  // ������� ������� ������ � ������� ������������� //if (Prn) Print(ttt,"DEL jLEV[",j,"] ",LEV[j][0],"  ",TimeToString(LEV[j][1],TIME_DATE | TIME_MINUTES)," [8]=",LEV[j][8]," fLEV[",f,"] ",LEV[f][0],"  ",TimeToString(LEV[f][1],TIME_DATE | TIME_MINUTES)," [8]=",LEV[f][8]);
               LEVEL_DELETE(j,DelSmall);  // ������� ��������� �������  
         }  }  }
      else if (LEV[f][7]*pwr<Shift-bar) {LEVEL_DELETE(f,DelSmall); continue;} // ������� �� ��������� � ������ "������������ = ���.�� ���������� + ��������� �������"
      // � � � � � � � �   � � � � � � � � � � � � � �   � � � � � � � � �
      if (LEV[f][6]==0){// ��� �� �������� ������� (1-������ ������������� �����, 2-������ �������� �����)
         if (LEV[f][5]>0 && Pic.Dir>0 && NEW>LEV[f][0]+LIM) LEV[f][6]=1;// ���������� ��������� ������ ���� ����� ������� ������������ � ����������� � ����������� ��
         if (LEV[f][5]<0 && Pic.Dir<0 && NEW<LEV[f][0]-LIM) LEV[f][6]=1;// ���������� ��������� ������ ���� ����� ������� ������������ � ����������� � ���� ��
         }
      else{// � � � � � � � �   � � � � � � � � � � � � � � �   � � � � � � � � �
         if (LEV[f][5]>0 && Pic.Dir<0 && NEW<LEV[f][0]-LIM) {LEV[f][6]=2; LEVEL_DELETE(f,DelBroken); continue;} // �������� ����� ������� ����������� ���� (� �������) ���������� ��������,
         if (LEV[f][5]<0 && Pic.Dir>0 && NEW>LEV[f][0]+LIM) {LEV[f][6]=2; LEVEL_DELETE(f,DelBroken); continue;} // ���� �� ���������� ������� ���������� ������ � �������� ������� (�.�. ��� ���������� � �� �����)
         } 
      //  � � � � � � � �   � � � � � � � � � � � � �   � � � � � � 
      if (LEV[f][9]>0 && LEV[f][6]>0 && LEV[f][5]==Pic.Dir){// ���� �� ���������������, ��������, ��������� � ������� �����
         BreakBars=0;  for (j=bar; j<Shift; j++) if (High[j]>=lev && Low[j]<=lev) BreakBars++;// �� �������� ���� �� �������� ������� ������� ���-�� ���, ������������ ������� 
         if (LevBreak>0 && BreakBars>LevBreak) {LEVEL_DELETE(f,0); continue;} // ������ �������� ��������� ������   if (Prn) Print(ttt,"LEV[",f,"] ",LEV[f][0],"  ",TimeToString(LEV[f][1],TIME_DATE | TIME_MINUTES)," BreakBars=",BreakBars);   
         }     
      // �������� ������� �������/�������, ����� ������ ��� �������� ��������� �������    //if (Prn && LEV[f][0]==112827) Print(ttt," NEW=",NEW," LIM=",LIM," LEV-LIM=",LEV[f][0]-LIM,"  LEV[",f,"]=",LEV[f][0],"  ",TimeToString(LEV[f][1],TIME_DATE | TIME_MINUTES), " LEV6=",LEV[f][6]," LEV9=",LEV[f][9]); 
      if (LEV[f][3]>0){// ������� ������� ���� �� ������
         center=(LEV[f][0]+LEV[f][3])/2; // �������� ����� ������� (���������)
         if (Prn && LEV[f][3]==1277430) Print(ttt,"  LEV[",f,"]=",LEV[f][0]," [3]=",LEV[f][3],"  ",TimeToString(LEV[f][1],TIME_DATE | TIME_MINUTES)); 
         if (LEV[f][5]>0 && NEW>center && int(High[iLowest (NULL,0,MODE_HIGH,Shift-(bar+PicPer),bar+PicPer)]/Point)<LEV[f][3]) {// ������� ������� ������ � �� ���������� �� ������ ���� �� ������� ������ ������� ���� ���� ��� ��������� ���� ����.  
            LEV[f][3]=0; // �������� ������ �������
            if (LEV[f][7]>=LevPer) {TrendLevBreakUp++; TrendLevBreakDn=0;}} // ���� ��� ��� ���������� ������� �������, ����������� ���-�� ������� �����, �������� ������ ����  
         if (LEV[f][5]<0 && NEW<center && int(Low [iHighest(NULL,0,MODE_LOW ,Shift-(bar+PicPer),bar+PicPer)]/Point)>LEV[f][3]) {// ������� ������� ������ � �� ���������� �� ������ ���� �� ������� ������ ������� ���� ���� ��� ���������� ��� ���. 
            if (Prn) Print(ttt,"  DEL LEV[",f,"]=",LEV[f][0]," [3]=",LEV[f][3],"  ",TimeToString(LEV[f][1],TIME_DATE | TIME_MINUTES)); 
            LEV[f][3]=0;  // �������� ������ �������
            if (LEV[f][7]>=LevPer) {TrendLevBreakDn++; TrendLevBreakUp=0;}} // ���� ��� ��� ���������� ������� �������, ����������� ���-�� ������� ����, �������� ������ �����.       
      }  }
   if (Pic.Free<0){// ���� ������ ����� ��� ���,  
      if (DeletedCell>-1)  Pic.Free=DeletedCell; // ���� ���� ���������������, ����� ����� ������ �� ��� (������������ ������, ����������� ��� ���������, �� ������� �� �������� ������)  Print(TimeToString(Time[bar],TIME_DATE | TIME_MINUTES)," DeletedCell[",DeletedCell,"] ",LEV[DeletedCell][0],"  ",TimeToString(LEV[DeletedCell][1],TIME_DATE | TIME_MINUTES));} 
      else                 Pic.Free=OldestCell; // ����� ������ ����� ������
      } 
   if (Impulse<0) Impulse=0; // ��� PowerPlus<0 Impulse �� �����, �.�. �������� ���������� �� ������ ��������
   // ��������� ������������� ���  (��� ���������� ����� ��� � Pic.New ��������������� ����. �� ���� ��������� ��������, ������� ��������� ������ ��� � ������������/������������ ����
   if (Pic.Dir>0) {for (f=bar+PicPer+1; f<Bars; f++) {if (High[f]>=High[bar+PicPer]) {ExPicTime=int(Time[f]); break;}}} // ����������� �� �����������, ��������� �� ������� � ������ ����
   else           {for (f=bar+PicPer+1; f<Bars; f++) {if (Low [f]<=Low [bar+PicPer]) {ExPicTime=int(Time[f]); break;}}} // ��� ������ ���� ���� (��� �����) ������, ������� ������ ���� ���� (��� �����) �����
   Shift=iBarShift(NULL,0,ExPicTime,false);// �����  �������������� ����
   LEV[Pic.Free][0]=NEW;            // ����� � ��������� ������ �������� ��������
   LEV[Pic.Free][1]=int(Time[bar+PicPer]);    // ����� ��������
   LEV[Pic.Free][2]=Concur; // ��������� = ���-�� ���������� � ����������� �������� 
   if (Pic.Dir>0){// �������  
      LEV[Pic.Free][3]=int(Low [iHighest(NULL,0,MODE_LOW ,PicPer*2+1,bar)]/Point); // ��� ������� ��������� ������� �� �������
      OppositeTop=int(Low [iLowest (NULL,0,MODE_LOW ,Shift-(bar+PicPer)+1,bar+PicPer)]/Point); // ��������������� �������, ������� ����� ����� � ������������� ��� ������ (��� ����������� ��������, ������� ��������� ������ ���) 
      }
   else{          // �������      
      LEV[Pic.Free][3]=int(High[iLowest (NULL,0,MODE_HIGH,PicPer*2+1,bar)]/Point); // ��� ������� ��������� ������� �� �������
      OppositeTop=int(High[iHighest(NULL,0,MODE_HIGH,Shift-(bar+PicPer)+1,bar+PicPer)]/Point);  // ��������������� �������, ������� ����� ����� � ������������� ��� ��������� (��� ����������� ��������, ������� ���������� ������ �������)
      }//if (Prn) Print(ttt," NEW=",NEW," OppositeTop=",OppositeTop," ExPicTime=",TimeToString(ExPicTime,TIME_DATE | TIME_MINUTES));
   LEV[Pic.Free][4]=Impulse;  // ��� ��������� - �������� �������     if (Prn) Print(ttt," Impulse=",Impulse); 
   LEV[Pic.Free][5]=Pic.Dir;  // ����������� ��������: 1=�������, -1=�������
   LEV[Pic.Free][6]=0;        // ���������� ������: 1-������ ����� ���� �� �����������, 2-������ ����� ���������������� �����������
   LEV[Pic.Free][7]=PicPer;   // ���� �������� - ������, �� ������� �� ���������
   LEV[Pic.Free][8]=MathAbs(NEW-OppositeTop); // ��������, ������� ��������� �������, �.�. ��� ����. �������� ����� ��� ����� � �������������� ��������, �� ������� �������� ��������.
   LEV[Pic.Free][9]=1;        // 1-�������� ������� (������������ �� �������), 0-��� ������ ������, �.�. �� ������������ �� �������, � �������� � ������� ���� ��� ��������� � ������ ��� ���������� �������� �������.
   AVG_TREND_LEV(NEW,LEV[Pic.Free][3]);// �������� �������� ��������� ���� ��������� ��� �����
   //FIRST_LEVELS(uf,df);     //if (Prn) Print(ttt," LEV[",d1,"] "," 3=",DN3);
   Shift=iBarShift(NULL,0,LEV[Pic.Free][1],false);// ����� �������      
   FrPeriod=int(iBarShift(NULL,0,LEV[Pic.Free][8],false) - Shift); // ��� Up ����: ������ �� ������ ���� �� ����������� (���� ��� ������� �������). �.�. ���� ������������ ������������ �������� �������, ����� ����� ��������� ������� ������������ ��������� ��� ����������� ������� �� ����
   ArraySort (LEV,WHOLE_ARRAY,0,MODE_DESCEND); // ����������� ������ �� �������� (34, 23, 17, 8, 3, 0, 0, 0) 
   if (PicCnt<2) return; // �� ��������� ��������� ������ ��� ������������ �����
   Shift=iBarShift(NULL,0,FlatBegin,false); // ����� ������� ������� �����   
   Trend=0; // � � � �
   FlsDel(Pic.Dir);// �������� ������� �������/������� �� ������� ��������
   TrendLevBreakUp=0;   TrendLevBreakDn=0; // ����� ���-�� ������� ��������� ������� ��� ������������ ������
   if (Pic.Dir>0){// ������������ �������
      OppositeTop=iLowest (NULL,0,MODE_LOW ,Shift-(bar+PicPer)+1,bar+PicPer); // ����� ���� ��������������� ������� �����
      FlatHi=PowerLevel/PicCnt; // ������� ������� �����
      FlatLo=Low [OppositeTop]; // ������� ����� �������� ��������� �����
      FlatHiTime=int(Time[bar+PicPer]);  // ����� ������������ ��������� ������� ����� ��� �������� �������
      FlatLoTime=int(Time[OppositeTop]); // ����� ������������ ��������������� �������
   }else{ // ������������ �������
      OppositeTop=iHighest(NULL,0,MODE_HIGH,Shift-(bar+PicPer)+1,bar+PicPer); // ����� ���� ��������������� ������� �����
      FlatLo=PowerLevel/PicCnt; // ������ ������� ����� - ���������
      FlatHi=High[iHighest(NULL,0,MODE_HIGH,Shift-(bar+PicPer)+1,bar+PicPer)]; // �������� ����� ����� ���������
      FlatHiTime=int(Time[OppositeTop]); // ����� ������������ ��������������� �������
      FlatLoTime=int(Time[bar+PicPer]);  // ����� ������������ ��������� ������� ����� ��� �������� �������
   }  }
// ��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������
// ��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������   
void LEVEL_DELETE(int LevToDel, int DelFactor){ // ���������: ������� ��� ��������, ������� 1-������� ���������, 2-������ ��������������� �������� 
   //if (LEV[LevToDel][0]==110574) Print(ttt," LEV[",LevToDel,"][0]=",LEV[LevToDel][0],"  ",TimeToString(Time[bar],TIME_DATE | TIME_MINUTES));
   if (DelFactor==0){ // ������ ������ �������� "0",  
      LEV[LevToDel][9]=0; // ������ �����, �.�. ��������� ������� � �������, �� �� ���������� ��� �� ������� 
      LEV[LevToDel][3]=0; // �� ���� ������� ��� ���������
   }else{// ������ �������� �������� "1" 
      LEV[LevToDel][0]=0; // ������� ���� �������� ����
      LEV[LevToDel][3]=0; // �� ���� ������� ��� ���������
      Pic.Free=LevToDel; // ����� �������������� ������ ��� ����� ��������
   }  }
// ��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������
// ��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������   
void AVG_TREND_LEV(int L1, int L2){ // ������� �������� ��������� ���� ��������� ��� �����
   TrendLevels[TrLevCnt]=MathAbs(L1-L2); // �������� ���� � ��� ���������� ������ (������ ���������� ������)
   TrLevCnt++; if (TrLevCnt>4) TrLevCnt=0;
   int i,Max=0,Min=TrendLevels[0],Sum=0;
   for (i=0; i<5; i++){
      if (TrendLevels[i]>Max) Max=TrendLevels[i];
      if (TrendLevels[i]<Min) Min=TrendLevels[i];
      Sum+=TrendLevels[i];
      }
   Pic.Avg=(Sum-Max-Min)/3*Point; // Print(" Pic.Avg=",Pic.Avg," Atr=",Pic.Atr);
   }   
// ��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������
// ��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������   
void LIM_DETECT(){   // ������ ���������� �������. ������������� ��� ������� (��� LimType<0), ������� (LimType=0) ��� ������� (��� LimType>0) �� ��������� �� �������� ATR, ����������� ����� ����� ���������� ������, � ������� ��������.
   double LastMovLimit, TargetLimit, FastAtr, SlowAtr;
   int d; // ����������� ��������: ��� ������ ������������� �������� �� >1 � ��������. �.�. ������ ������ ������������ �� ���� ��������, ���������� �� d. ��� ����, ����� �� ������ ��� ������ ���������
   int n=0; // ���-�� ����������� �������� ��� ���������� ��������
   if (LimType>=0) {Pic.Lim=0; d=1;} // ������������ �� �������� ��������
   else {Pic.Lim=-9999999999;d=-1;} // ����������� �� �������� �������� 
   if (LimATR>0){// %^2 ATR
      FastAtr=iATR(NULL,0,FastAtrPer,bar)*LimATR*LimATR*0.01; 
      SlowAtr=iATR(NULL,0,SlowAtrPer,bar)*LimATR*LimATR*0.01; 
      if (LimType==0) {Pic.Lim+=(FastAtr+SlowAtr)*0.5; n++;} // ����������� ��������, ����
      else Pic.Lim=MathMax(FastAtr*d,SlowAtr*d); // ������� �� ���� ���
      }
   if (LimMov>0){ // %^2 �� ���������� ����� ����� ���������� ������
      LastMovLimit=(NewHi-NewLo)*LimMov*LimMov*0.01; // �������� ����� ���������� ������ ����� � ���� 
      if (LimType==0) {Pic.Lim+=LastMovLimit; n++;}      // ����������� �������� � �����������, ����
      else {if (LastMovLimit*d>Pic.Lim) Pic.Lim=LastMovLimit*d;}// ������� �� ������� � �������� 
      }
   if (LimTarget>0){ // %^2 �� �������� �������� (�����+����) 
      TargetLimit=(MidMovUp+MidMovDn)*0.5*LimTarget*LimTarget*0.01; // ����������� �������� ������� ��������
      if (LimType==0) {Pic.Lim+=TargetLimit; n++;} // ����������� �������� � �����������, ���� 
      else {if (TargetLimit*d>Pic.Lim) Pic.Lim=TargetLimit*d;}  // ������� �� �������, �������� � �������� 
      } 
   if (d<0) Pic.Lim*=d; // ������������ ������������� ��������, ����������� � ������������� �������� 
   if (n>0) Pic.Lim/=n; // ��� ���������� ����� �� ���-�� ���������
   //if (Prn) Print(ttt," Pic.Lim=",NormalizeDouble(Pic.Lim,Digits-1)," FastAtr=",NormalizeDouble(FastAtr,Digits-1)," SlowAtr=",NormalizeDouble(SlowAtr,Digits-1)," LastMovLimit=",NormalizeDouble(LastMovLimit,Digits-1)," TargetLimit=",NormalizeDouble(TargetLimit,Digits-1)," MidMovUp=",NormalizeDouble(MidMovUp,Digits-1)," MidMovDn=",NormalizeDouble(MidMovDn,Digits-1)," n=",n);   
   }
// ��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������   
// ��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������   
void LEVELS_FIND_AROUND(){ // � � � � �   � � � � � � � � � � �   � � � � � � � 
   u1=-1; u2=-1; u3=-1; d1=-1; d2=-1; d3=-1; um=-1; dm=-1; UP2=0; DN2=0; UP3=0; DN3=0; UpCenter=0; DnCenter=0; 
   int f, uf=-1, df=-1; // ������ � ������� ���������� ������ �������
   int mirUp=Pic.intAtr*5, mirDn=Pic.intAtr*5, FirstLevForce=Pic.intAtr*FirstLev; // ��������� ���������� �� ���������� ��������
   for (f=0; f<LevelsAmount; f++){// ��������������� ����� ������   
      if (LEV[f][0]==0) break; // ����� 00
      if (LEV[f][7]<LevPer || LEV[f][9]==0) continue; // ����� �������� � ������ �������� ������ ����������. ��� ��������� � ������� ��� ���������, �� �� ������������ �� �������
      if (LEV[f][0]>intH && ((LEV[f][5]>0 && LEV[f][6]==0) || LEV[f][5]<0)) u1=f;  //  ��������� ������ ��� ������ ��������� ������ ���� ���. ��� ������ ���� ���������� ���, ���� �������� ���������� �������
      if (LEV[f][0]<intL && ((LEV[f][5]<0 && LEV[f][6]==0) || LEV[f][5]>0)) {d1=f; break;}//  ��������� ������ ��� ������ ��������� ������ ���� ���. ��� ������ ���� ���������� �������, ���� �������� ���������� ���
      } //if (Prn) Print(ttt," LEV[",f,"]=",LEV[f][0]," intH=",intH," u1=",u1);
   if (u1>-1){ // ���� ��� ������ ��������� �������, ���� ���� ����� �������, ��������� � �������� ������ 
      UP1=LEV[u1][0]; // ��������������� �������� (����� ���� ����� �������� ������� ���������)
      for (f=u1; f>=0; f--){ // ����� ���� ���������� UP1
         if (u3>-1 && u2>-1 && uf>-1 && LEV[f][0]-UP1>Pic.intAtr) break; // ��� ������ �������
         if (LEV[f][7]<LevPer || LEV[f][9]==0) continue; // ����� �������� � ������ �������� ������ ����������. ��� ��������� � ������� ��� ���������, �� �� ������������ �� �������
         if (LEV[f][0]-UP1<Pic.intAtr && (LEV[f][7]>LEV[u1][7] || LEV[f][2]>LEV[u1][2])) u1=f; // ���� ���������� ����� �������[7] �������� � � ������� ���-��� ��������[2]  && (LEV[f][7]>LEV[u1][7] || LEV[f][2]>LEV[u1][2])
         if (u2<0 && LEV[f][2]>=PowerCheck) u2=f; // ����� �������� ������ � ����������� ���-��� ��������
         if (LEV[f][5]<0){ // �������
            if (LEV[f][6]==1 && MathAbs(LEV[f][0]-intH)<mirUp) {um=f; mirUp=MathAbs(LEV[f][0]-intH);} // ����� �������� ������� ����, �� ������� ����� ��������� ���������� ������
         }else{            // �������
            if (LEV[f][3]>0 && LEV[f][0]>intH){ // ����� ������, ���������� ������� �� �������   (LEV[f][3]+LEV[f][0])*0.5>intH
               if (u3<0) u3=f; // ��������� ������� �� �������
               if (uf<0 && LEV[f][8]>FirstLevForce) uf=f; // ������ ������� �� �������
         }  }  }
      UP1=LEV[u1][0]*Point;   Tup1=LEV[u1][1]; // ��������� ������� ��� ���� � ������ ����� ��������  
      TargetUp=LEV[u1][8]*Point;
      if (u3>-1) {UP3=LEV[u3][3]*Point;   UP3Pic=LEV[u3][0]*Point;  UpCenter=(UP3+UP3Pic)*0.5*Point;} // ��������� ������� �� �������, ��� ��� � ��� ���������
      if (u2>-1) {UP2=LEV[u2][0]*Point;   Tup2=LEV[u2][1];}// ������� �������� ������� � ����������� ���-��� �������� 
      if (um>-1) {Pic.MirUp=LEV[um][0]*Point; Pic.MirUpTime=LEV[um][1];}  // ���������� ������� ������
      //if (MathAbs(High[bar]-Pic.MirUp)>Pic.Atr) Pic.MirUp=0; // �������� ����������� ������ ������
      }//if (Prn && uf>=0) Print(ttt," LEV[",uf,"]=",LEV[uf][0],"  ",TimeToString(LEV[uf][1],TIME_DATE | TIME_MINUTES)," 3=",LEV[uf][3]); 
   if (d1>-1){// ���� ��� ������ ��������� �������, ���� ���� ����� �������, ��������� � �������� ������ 
      DN1=LEV[d1][0]; // ��������������� �������� (����� ���� ����� �������� ������� ���������)
      for (f=d1; f<LevelsAmount; f++){ // ����� ���� ���������� DN1
         if (LEV[f][0]==0) break; // ����� 000
         if (d3>-1 && d2>-1 && df>-1 && DN1-LEV[f][0]>Pic.intAtr) break; // ��� ������ �������
         if (LEV[f][7]<LevPer || LEV[f][9]==0) continue; // ����� �������� � ������ �������� ������ ����������. ��� ��������� � ������� ��� ���������, �� �� ������������ �� �������
         if (LEV[f][6]==1 && LEV[f][5]>0 && MathAbs(LEV[f][0]-intL)<mirDn) {dm=f; mirDn=MathAbs(LEV[f][0]-intL);}// ����� �������� ������� ���� ����� ��������, �� ������� ����� ��������� ���������� ������
         if (DN1-LEV[f][0]<Pic.intAtr && (LEV[f][7]>LEV[d1][7] || LEV[f][2]>LEV[d1][2])) d1=f; // ���� ���������� ����� �������[7] �������� � � ������� ���-��� ��������[2]   && (LEV[f][7]>LEV[d1][7] || LEV[f][2]>LEV[d1][2])
         if (d2<0 && LEV[f][2]>=PowerCheck) d2=f; // ����� �������� ������ � ����������� ���-��� �������� 
         if (LEV[f][5]<0 && LEV[f][3]>0 && LEV[f][0]<intL){// ����� ������, ���������� ������� �� �������    (LEV[f][3]+LEV[f][0])*0.5<intL
            if (d3<0)  d3=f; // ��������� ������� �� ������� 
            if (df<0 && LEV[f][8]>FirstLevForce) df=f;  // ������ ������� �� �������
         }  }
      DN1=LEV[d1][0]*Point;   Tdn1=LEV[d1][1]; // if (Prn) Print(ttt,"  LEV[",d1,"]=",LEV[d1][0],"  ",TimeToString(LEV[d1][1],TIME_DATE | TIME_MINUTES)," L[6]=",LEV[d1][6]," L[5]=",LEV[d1][5]);   
      TargetDn=LEV[d1][8]*Point;
      if (d3>-1) {DN3=LEV[d3][3]*Point;   DN3Pic=LEV[d3][0]*Point;   DnCenter=(DN3+DN3Pic)*0.5;} // ��������� ������� �� �����k�, ��� ��� � ��� ���������
      if (d2>-1) {DN2=LEV[d2][0]*Point;   Tdn2=LEV[d2][1];}// ������� ������� � ����������� ���-��� ��������
      if (dm>-1) {Pic.MirDn=LEV[dm][0]*Point;  Pic.MirDnTime=LEV[dm][1];}   // ����������   ������� �����
      //if (MathAbs(Pic.MirDn-Low[bar])>Pic.Atr) {Pic.MirDn=0;}// �������� ����������� ������ �����
      //if (Prn) Print(ttt," Pic.MirDn=",Pic.MirDn," fff=",fff,"  ",TimeToString(Pic.MirDnTime,TIME_DATE | TIME_MINUTES), " Pic.Atr=",Pic.Atr);//
      }
   if (Pic.New>0){
      if (Pic.Dir<0 && Pic.New<Pic.MirDn) Pic.MirDn=0; // ����� ������� ������� ���������� ������� �����, ������� ���
      if (Pic.Dir>0 && Pic.New>Pic.MirUp) Pic.MirUp=0; // ����� ������� ������� ���������� ������� ������, ������� ���  
      }
   FIRST_LEVELS(uf,df);   //  if (Prn && u2>0) Print(ttt," LEV[",u2,"]=",LEV[u2][0]," Power=",LEV[u2][2]," Pic.Lim=",Pic.Lim);   
   }     //if (Prn) Print(ttt,"d1=",d1," DN1=",DN1," LEV[2]=",LEV[d1][2]," LEV[4]=",LEV[d1][4] );  
// ��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������
// ��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������
void FIRST_LEVELS(int FirstUpNum, int FirstDnNum){// ���������� ������ ������� �� ��������� ���������   
   // ������ ������ ������� ��������� �������� �������
   if (FirstUpNum>-1){//if (Prn) Print(ttt," FIRST UP LEVEL[",FirstUpNum,"]=",LEV[FirstUpNum][0]*Point," Pic=",LEV[FirstUpNum][5]);
      FirstUp=LEV[FirstUpNum][3]*Point;     // ������ ��������� �� �������
      FirstUpPic=LEV[FirstUpNum][0]*Point;  // ������� ������� ������ �� �������
      FirstUpCenter=(FirstUp+FirstUpPic)/2; // ��������� � ������� ������� ���������� 
      FirstUpTime=LEV[FirstUpNum][1];       // ����� ��� ������������
      }
   if (FirstDnNum>-1){// if (Prn) Print(ttt," FIRST DN LEVEL[",FirstDnNum,"]=",LEV[FirstDnNum][0]*Point," Pic=",LEV[FirstDnNum][5]);
      FirstDn=LEV[FirstDnNum][3]*Point;     // ������ ��������� �� �������
      FirstDnPic=LEV[FirstDnNum][0]*Point;  // ������� ������� ������ �� �������
      FirstDnCenter=(FirstDn+FirstDnPic)/2; // ��������� � ������� ������� ���������� 
      FirstDnTime=LEV[FirstDnNum][1];       // ����� ��� ������������
      }
   // ���. �������� �� ������������ ����������. ��������, ��������� FirstUp ����� FirstDn (����� ����), �� ����� ���� ���� ����� ������ Low<FirstDn    
   //int OldestPic=MathMin(FirstUpTime,FirstDnTime);    // ����� ������ ���������� �� �������� ���� ����
   //int Shift=iBarShift(NULL,0,OldestPic,false);       // ����� ������ ���������� ���� �� �������� ����
   //int LowestBar=iLowest (NULL,0,MODE_LOW ,Shift-bar,bar); // ����� ���� �������� �� ������� �� ������ ���������� ����
   //int HighestBar=iHighest(NULL,0,MODE_HIGH,Shift-bar,bar); // ����� ���� ��������� �� ������� �� ������ ���������� ����
   //if (FirstDnPic>Low [LowestBar]+Pic.Lim){// ���������� �� ������� FirstDn �������� �� ����� ������ �� ���������� �� FirstUp �� �������� ����
   //   FirstDn=High[iLowest (NULL,0,MODE_HIGH,PicPer*2+1,LowestBar-PicPer)]; // ��� ������� ��������� ������� �� �������
   //   FirstDnPic=Low [LowestBar];
   //   FirstDnTime=OldestPic; // Print(TimeToString(Time[bar],TIME_DATE | TIME_MINUTES),":   FirstDnPic=",FirstDnPic," ",TimeToString(FirstDnTime,TIME_DATE | TIME_MINUTES),"   FirstDnPic=",Low [LowestBar]," OldestPicTime=",TimeToString(OldestPic,TIME_DATE | TIME_MINUTES), " FirstDn=",FirstDn);
   //   FirstDnCenter=(FirstDn+FirstDnPic)/2;
   //   }
   //if (FirstUpPic<High[HighestBar]-Pic.Lim){// ���������� �� ������� FirstUp �������� �� ����� ������� �� ���������� �� FirstDn �� �������� ����
   //   FirstUp=Low[iHighest(NULL,0,MODE_LOW,PicPer*2+1,HighestBar-PicPer)]; 
   //   FirstUpPic=High[HighestBar];
   //   FirstUpTime=OldestPic; // if (Prn) Print(ttt," FirstUpPic=",FirstUpPic,"  ",TimeToString(FirstUpTime,TIME_DATE | TIME_MINUTES)," High[HighestBar]",High[HighestBar]);
   //   FirstUpCenter=(FirstUp+FirstUpPic)/2; // ��������� � ������� ������� ����������        
   //   }  
   } 
// ��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������
// ��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������   
void TREND_DETECT(){ // � � � � � � � � � � �   � � � � � � 
   if (GlobalTrend< 1 && High[bar]>FirstUpCenter)  GlobalTrend= 1;  // Print(TimeToString(Time[bar],TIME_DATE | TIME_MINUTES)," GlobalTrend=",GlobalTrend);}  
   if (GlobalTrend>-1 && Low[bar]<FirstDnCenter)   GlobalTrend=-1;  // Print(TimeToString(Time[bar],TIME_DATE | TIME_MINUTES)," GlobalTrend=",GlobalTrend);}   
   if (TrNewPic>0){ // ����� ������ ��� �������� ���������� ����� �����������
      if (Trend==0){
         if (NewHi-FlatHi>Pic.Lim) Trend= 1; // ��� ��� �������� �����
         if (FlatLo-NewLo>Pic.Lim) Trend=-1;} // ��� ��� �������� �����
      else{   
         if (NewHi-LastHi>Pic.Lim && NewLo-LastLo>Pic.Lim) Trend= 1; // ��� ��� ������� �����
         if (LastLo-NewLo>Pic.Lim && LastHi-NewHi>Pic.Lim) Trend=-1; // ��� ��� ������� �����
      }  }
   if (TrOppPic>0){ // ����� ������ ��� �������� ���������� ��������������� ���������o� 
      if (Trend==0){
         if (NewLo>FlatHi) Trend= 1;   // ��� ������� �������� ����� �������������� ������� 
         if (NewHi<FlatLo) Trend=-1;}  // ��� ������ �������� ����� �������������� �������
      else{   
         if (NewLo>LastHi) Trend= 1; // ��� �������������� �������������� ������� 
         if (NewHi<LastLo) Trend=-1; // ��� ���������� �������������� �������
      }  }
   if (TrLoOnHi>0){ // ����� ������ ��� �������� ������ ������� ��������� ���������
      if (UP1<LowestHi) LowestHi=UP1; // ���� ����� ������ �������� �� �������� ����� ������� ������� �������������
      if (NewLo>LowestHi) {// ������ ������������� � �������� (������ ���������)
         Trend=1; HighestLo=DN1;} //NewHi=HighestLo; ��������� ����� ���������
      if (DN1>HighestLo) HighestLo=DN1; // ���� ����� ������� ������� ��� �������� ����� ������� ������� ���������
      if (NewHi<HighestLo) { // ������ ��������� � �������� (������� ���������)
         Trend=-1; LowestHi=UP1; //NewLo=LowestHi; ��������� ����� �������������
      }  }
   if (TrLevBrk>0){ // ����� ������ ��� �������� ��������� �������
      if (TrendLevBreakUp>TrLevBrk) Trend= 1; // �������� ������ TrLevBrk ��������� ������� �� �������
      if (TrendLevBreakDn>TrLevBrk) Trend=-1; // �������� ������ TrLevBrk ��������� ������� �� �������
   }  }
// ��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������
// ��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������
void TARGET_COUNT(){// ������ ������� ������� ��������� �������� �� ��������� ��������� ���������� ����������� ��������
   double max=0, min=1000000;
   int i;// if (Pic.Dir==LastPic) Print(TimeToString(Time[bar],TIME_DATE | TIME_MINUTES)+"    Pic.Dir==LastPic=",Pic.Dir);
   if (FrDir>0){// ��� ������� ����
      TargetDn=NewHi-MidMovDn;// �������� ���� �������� �����
      if (NewHi-NewLo<Pic.Atr) return; // ������������ ���� ����������
      if (LastDir!=FrDir) for (i=Movements-1; i>0; i--) MovUp[i]=MovUp[i-1];//�������������� ������� �������� ���� � ������ ����������� �����, � ��������� ������ ������ ��������� ��������� �������� �������� �����
      MovUp[0]=NewHi-NewLo; // ��������� �������� �����
      MidMovUp=0; // ����������� �������� �������� �������� �����
      for (i=0; i<Movements; i++){// ����� ���� �������� �����
         MidMovUp+=MovUp[i];// ��������� ���
         if (MovUp[i]>max) max=MovUp[i]; // ���� ������������ 
         if (MovUp[i]<min) min=MovUp[i]; // � ����������� ��������
         }
      MidMovUp=(MidMovUp-max-min)/(Movements-2); // ������� ������� �������� ��� ���������� ������������� � ������������
      //if (Prn) Print(ttt," NewHi=",NormalizeDouble(NewHi,Digits-1)," Hi-Lo-",NormalizeDouble(NewHi-NewLo,Digits-1)," TargetDn=",NormalizeDouble(TargetDn,Digits-1),"  max=",NormalizeDouble(max,Digits-1)," min=",NormalizeDouble(min,Digits-1)," MidMovUp=",NormalizeDouble(MidMovUp,Digits-1)," MidMovDn=",NormalizeDouble(MidMovDn,Digits-1));
      }    
   else{ // ��� ������ ����
      TargetUp=NewLo+MidMovUp;   // �������� ���� �������� ������
      if (NewHi-NewLo<Pic.Atr) return; // ������������ ���� ���������� Pic.Atr
      if (LastDir!=FrDir) for (i=Movements-1; i>0; i--) MovDn[i]=MovDn[i-1];//�������������� ������� �������� ���� � ������ ����������� �����, � ��������� ������ ������ ��������� ��������� �������� �������� ����
      MovDn[0]=NewHi-NewLo; // ��������� �������� �����
      MidMovDn=0; // ����������� �������� �������� �������� ����
      for (i=0; i<Movements; i++){// ����� ���� �������� ����
         MidMovDn+=MovDn[i];// ��������� ���
         if (MovDn[i]>max) max=MovDn[i]; // ���� ������������ 
         if (MovDn[i]<min) min=MovDn[i]; // � ����������� ��������
         }
      MidMovDn=(MidMovDn-max-min)/(Movements-2); // ������� ������� �������� ��� ���������� ������������� � ������������     
      //if (Prn) Print(ttt," NewLo=",NormalizeDouble(NewLo,Digits-1)," Hi-Lo-",NormalizeDouble(NewHi-NewLo,Digits-1)," TargetUp=",NormalizeDouble(TargetUp,Digits-1),"  max=",NormalizeDouble(max,Digits-1)," min=",NormalizeDouble(min,Digits-1)," MidMovUp=",NormalizeDouble(MidMovUp,Digits-1)," MidMovDn=",NormalizeDouble(MidMovDn,Digits-1));
   }  }
   
   
     
   
    
   
           