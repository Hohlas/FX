#property version    "161.028" // yym.mdd

struct FalseLevels{  //  C � � � � � � � �   � � � � � �   � � � � � � �
   double Max; // �������� ������� (��� ���������� �����)
   double Min; // ������� ������� (��� �����)
   double Buy; // ������� �������, �� �������� ��������� ������
   double Sel; // ������� �������, �� �������� ��������� ������ 
   double DNuplev;// ������� ������� ����� ������� ����
   double DNdnlev;// ������ ������� ����� ������� ����
   double UPuplev;// ������� ������� ����� ������� �����
   double UPdnlev;// ������ ������� ����� ������� �����
   double Lim;    // ����������� ������������ = ������� �� ������ ������������ ������ ��� ���
   int UP;     // ���� ������ �������
   int DN;     // ���� ������ �������
   int Tr;     // ����� ������ ��� ������ �������
   } Fls;      // ���������� �������
double UP1_1, UP1_2, DN1_1, DN1_2, UP2_1, UP2_2, DN2_1, DN2_2;
int Tup1_1, Tup1_2, Tup2_1, Tup2_2, Tdn1_1, Tdn1_2, Tdn2_1, Tdn2_2;

FalseLevels FALSE_LEVELS (double UpLevel,datetime TimeUp, double DnLevel,datetime TimeDn, int FalseLimit){ // � � � � � �   � � � � � � � �
   int f, h, l;
   if (FalseLimit>0) Fls.Lim=(UpLevel-DnLevel)*FalseLimit*0.1;   // ����������� ������������ = ������� �� ������ ������������ ������ 
   else              Fls.Lim=MathPow(FalseLimit-2,2)*0.1*ATR;  // ��� ������� ��� (0.4 0.9)
   if (Fls.UP==0 &&                 // ������� ���� ��� 
       High[bar]>UpLevel+Fls.Lim &&  // ������ ������ �� ����������� �������� FlatLim
      (High[bar+1]<=UpLevel+Fls.Lim || High[bar+2]<=UpLevel+Fls.Lim) && // ����������� ������ ���� ������
       Time[bar]-TimeUp>FlatTime){   // ������ ����������� �� ����������� �������� �� ����������� �������
      Fls.UP=1;            // ���� ������ �������
      h=bar+1; while(High[h]>=High[h+1]) h++; // ���� ������� ������� �� ���������� �����
      l=bar;   while(Low [l]>=Low [l+1]) l++; // ���� ������� ������� �� ��������� �����
      f=MathMin(h,l); // ����� ����� �������
      Fls.Buy=(High[f]+Low[f])*0.5;   if (Fls.Buy-Low[f]>ATR*0.5) Fls.Buy=Low[f]+ATR*0.5; // ������� ������� - ��������� ���������� ������, �� �������� ��������� ������. � ��������� ��� ������
      Fls.Max=High[bar];   // ��������� �������� ������� (��� ���������� �����)
      Fls.UPuplev=UpLevel; // �������� �������� ������� �������
      Fls.UPdnlev=DnLevel;   // ��������������� ������� �����, ��� ����������� ��������� ������� 
      }//if (Prn) Print(ttt,"1.         Fls.UP=",Fls.UP);
   if (Fls.DN==0 &&                 // ������� ���� ���
      Low[bar]<DnLevel-Fls.Lim &&   // ������ ������ �� ����������� �������� FlatLim
      (Low[bar+1]>=DnLevel-Fls.Lim || Low[bar+2]>=DnLevel-Fls.Lim) && // ����������� ������ ���� ������
      Time[bar]-TimeDn>FlatTime){   // ������ ����������� �� ����������� �������� �� ����������� �������
      Fls.DN=1;            // ���� ������ �������
      h=bar;   while(High[h]<=High[h+1]) h++; // ���� ������� ������� �� ���������� �����
      l=bar+1; while(Low [l]<=Low [l+1]) l++; // ���� ������� ������� �� ��������� �����
      f=MathMin(h,l); // ����� ����� �������
      Fls.Sel=(High[f]+Low[f])*0.5;   if (High[f]-Fls.Sel>ATR*0.5) Fls.Sel=High[f]-ATR*0.5; // ������� ������� - ��������� ���������� ������, �� �������� ��������� ������. � ��������� ��� ������
      Fls.Min=Low[bar];    // ��������� ������� ������� (��� �����)  
      Fls.DNdnlev=DnLevel; // �������� �������� ������ �������
      Fls.DNuplev=UpLevel;   // ���������� ��������������� ������� �����, ��� ����������� ��������� ������� 
      } 
   
   bool TrChFls=false; // ����� ������ ��������   
   if (Fls.UP>0){ // ������������� ������ ����� (�������������)
      if (Fls.UP<3){
         if (High[bar]>Fls.Max) Fls.Max=High[bar]; // ������������ ��������� �������� (������ ����� �� ������� �� �������)
         if (High[bar]<Fls.Max) Fls.UP=3;}// ������ ���� �����������  //X("3", Fls.Max, clrYellow);
      if (Fls.UP>1 && Low[bar]<Fls.Buy){ // ������ ������� ������� �������, (�� ������ ����� �������) 
         if (TrChFls) Trend=-1; // ������ �����
         Fls.UP=4;} // ���������� �������
      if (Fls.UP>2 && High[bar]>Fls.Max) {// c������������� ������ �������� ������,
         if (TrChFls) {Trend=1;} // ������ � �������� �������� ������� ����������
        Fls.UP=0;}  // �������� ������� �����   X("UP", Fls.Max, clrWhite); 
      if (Fls.UP==1) Fls.UP++; // ����� ������� ������� �� ���������� ������ �� ������� ����� �������  
      if (Low[bar]-Fls.UPdnlev<Fls.Lim) Fls.UP=0;; // ����� �� ������ ������� �����, ������ ���������
      if (High[bar]-Fls.UPuplev>Fls.UPuplev-Fls.UPdnlev) Fls.UP=0;;  // ������ �������� �� �������� ������� �� ������ ����� (���� ������� �������)
      }  
   if (Fls.DN>0){// ������������� ������ ���� (���������)
      if (Fls.DN<3){
         if (Low[bar]<Fls.Min) Fls.Min=Low[bar]; // ������������ �������� �������� (������ ����� �� ������� �� �������)
         if (Low[bar]>Fls.Min) Fls.DN=3;}  // ������ ���� �����������
      if (Fls.DN>1 && High[bar]>Fls.Sel){   // ������ ������� ������� �������,
         if (TrChFls) Trend=1; //  ������ �����
         Fls.DN=4;} // ���������� �������
      if (Fls.DN>2 && Low[bar]<Fls.Min) {// c������������� ������ �������� ������,
         if (TrChFls) {Trend=-1;}//������ � �������� �������� ������� ����������
         Fls.DN=0;} // �������� ������� ����    
      if (Fls.DN==1) Fls.DN++;   
      if (Fls.DNuplev-High[bar]<Fls.Lim) Fls.DN=0;; // ����� �� ������� ������� �����, ������ ���������
      if (Fls.DNdnlev-Low[bar]>Fls.DNuplev-Fls.DNdnlev) Fls.DN=0;;  // ������ �������� �� �������� ������� �� ������ ����� (���� ������� �������)
      } 
   //if (Prn) Print(ttt," Fls.UP=",Fls.UP," Fls.Lim=",NormalizeDouble(Fls.Lim,Digits-1)," UpLevel=",UpLevel," Fls.Max=",Fls.Max," Fls.Buy=",Fls.Buy);   // ," TimeUp=",TimeToString(TimeUp,TIME_DATE | TIME_MINUTES)," Time[bar]-TimeUp=",Time[bar]-TimeUp," FlatTime=",FlatTime
   UP1_2=UP1_1; UP1_1=UP1; Tup1_2=Tup1_1; Tup1_1=Tup1;  UP2_2=UP2_1; UP2_1=UP2; Tup2_2=Tup2_1; Tup2_1=Tup2; 
   DN1_2=DN1_1; DN1_1=DN1; Tdn1_2=Tdn1_1; Tdn1_1=Tdn1;  DN2_2=DN2_1; DN2_1=DN2; Tdn2_2=Tdn2_1; Tdn2_1=Tdn2;  
   //if (Trend==0)  FlsDel(Pic.dir);// �������� ������� �������/������� �� ������� ��������   
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
