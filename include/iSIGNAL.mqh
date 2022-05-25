struct Signals{  //  C � � � � � � � �   � � � � � � � �   � �   � � � � 
   int MaUp;      int MaDn;
   double Buy;    double Sell;   // ���� ����� �� ������ ������������� �������
   double BuyStp; double SellStp;// ���� ����� �� ������ ������������� �������
   double BuyPrf; double SellPrf;// ���� ����� �� ������ ������������� �������
   } s; 

double memUP, memDN; // �������� ����, �� ������� ������ ������, ��� ����������� ������� ������������� ������ �������  
           
// ����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������
// ����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������   
void SIG_MIRROR_LEVELS(){// ����� �� ���������� �������
   int f, Shift, BreakTime=0;
   double LevContact=MathAbs(iLevContact)*Pic.Lim; // "����������� ����������� � �������",  Pic.Lim-������ ���������� �������
   if (dm>-1){ // ������ � ���������� �������, ������������� �����
      double MirDn=LEV[dm][P]*Point; // �������� ����������� ������
      LINE("MirDn", bar+1,MirDn, bar,MirDn, cSIG1);
      if (memUP!=MirDn){// ��������� ������� ������������� ������� 
         Shift=iBarShift(NULL,0,LEV[dm][T],false); // ����� �������� ������� 
         BreakTime=0;
         for (f=Shift-1; f>=bar; f--){// �� �������� ������� �� �������� ���� 
            if (High[f]>=MirDn && Low[f]<=MirDn){// ������� ����������� ���� 
               BreakTime=f; // ����� ������� ����, ���������� ������� 
               break;
            }  } //if (Prn) Print(ttt," BreakBars=",BreakBars," BreakTime=",TimeToString(Time[BreakTime],TIME_DATE | TIME_MINUTES));        
         LINE("+MirDn",0,MirDn+LevContact, 0,0, cSIG2); LINE("-MirDn",0,MirDn-LevContact, 0,0, cSIG2); 
         if (iBar==0) sUP=0; // � ����� iBar=0 ������ ���������� ���� ��� ���������� ������ ������� � ��� ������; ��� iBar>0 ����� iBar ���.
         if (//BreakTime>FltLen/3 && // ����� �������� ������ ���������� �������
            High[iHighest(NULL,0,MODE_HIGH,Shift,0)]-MirDn>iParam*ATR && // ������ ��� ���������� ������
            Shift-BreakTime>FltLen){// ���-�� ��� �� �������� ������� �� ������� ��������
            if (iLevContact==0 && Low[bar]>MirDn) MIR_UP(Shift); // ���������� ��� ��������
            if (iLevContact >0 && Low[bar]>MirDn && Low[bar]<MirDn+LevContact) MIR_UP(Shift); // ����������� � ������� � �������� iLevContact*Pic.Lim, ���� ��� ���������� ������� � ����� ������ � ����
            if (iLevContact <0 && Low[bar]<MirDn && Low[bar]>MirDn-LevContact) MIR_UP(Shift);// �������� ������ (Break==2~����������) ������� � �������� LevContact
      }  }  }
   if (um>-1){ // ������ � ����������� ���, �������������� ������
      double MirUp=LEV[um][P]*Point; // �������� ����������� ������
      LINE("MirDn", bar+1,MirUp, bar,MirUp, cSIG1);
      if (memDN!=MirUp){// ��������� ������� ������������� �������        
         Shift=iBarShift(NULL,0,LEV[um][T],false); // ����� ��������� ��� 
         BreakTime=0;
         for (f=Shift-1; f>=bar; f--){// �� ��������� ��� � �������� ����   
            if (High[f]>=MirUp && Low[f]<=MirUp){// ������� ����������� ���� 
               BreakTime=f; // ����� ������� ����, ���������� ������� 
               break;
            }  }
         LINE("+MirUp",0,MirUp+LevContact, 0,0, cSIG2); LINE("-MirUp",0,MirUp-LevContact, 0,0, cSIG2); 
         if (iBar==0) sDN=0; // � ����� iBar=0 ������ ���������� ���� ��� ���������� ������ ������� � ��� ������; ��� iBar>0 ����� iBar ���.
         if (//BreakTime>FltLen/3 && // ����� �������� ������ ���������� �������
            MirUp-Low [iLowest (NULL,0,MODE_LOW ,Shift,0)]>iParam*ATR && // ������ ��� ���������� ������
            Shift-BreakTime>FltLen){// ���-�� ��� �� ��������� ��� �� ������� ��������
            if (iLevContact==0 && High[bar]<MirUp) MIR_DN(Shift);// ���������� ��� �������� 
            if (iLevContact >0 && High[bar]<MirUp && High[bar]>MirUp-LevContact) MIR_DN(Shift); // ����������� � ������� �� ��������, ������� ��� iLevContact*Pic.Lim
            if (iLevContact <0 && High[bar]>MirUp && High[bar]<MirUp+LevContact) MIR_DN(Shift); // ������ ������� �� �������� ������� ��� iLevContact*Pic.Lim  
   }  }  }  }
void MIR_UP(int Shift){// ��������� ������� � ���� ��� ������� � �������, ����������� �����
   memUP=LEV[dm][P]*Point; // ���������� �������� ������, ����� �� ��������� ������
   sUP=MathMax(1,iBar);  //LINE("memUP="+DoubleToStr(memUP,Digits), 0,memUP-0.003, 0,0, clrGold);
   s.Buy =memUP; // ���� �� ��������� ����  
   s.BuyStp =Low [iLowest (NULL,0,MODE_LOW ,Shift,0)]; // ��� ����� ���� �� ����������� ���� �� �������� ���� �� ����, �� �������� ��� ������, � 
   s.BuyPrf =High[iHighest(NULL,0,MODE_HIGH,Shift,0)]; // ���� �� ������������ ���� �� �������� ���� �� ����, �� �������� ��� ������
   }
void MIR_DN(int Shift){// ��������� ������� � ���� ��� ������� �� �������, ����������� ������
   memDN=LEV[um][P]*Point; // ���������� �������� ������, ����� �� ��������� ������
   sDN=MathMax(1,iBar);  //LINE("memDN="+DoubleToStr(memDN,Digits), 0,memDN+0.003, 0,0, clrGold);
   s.Sell=memDN; // ���� �� ��������� ���
   s.SellStp=High[iHighest(NULL,0,MODE_HIGH,Shift,0)]; // ��� ����� -
   s.SellPrf=Low [iLowest (NULL,0,MODE_LOW ,Shift,0)]; // ���������� 
   }     
// ����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������
// ����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������
void SIG_FLAT(){// ��������� �����. ����������� � ��������(+) / ������(-)
   if (Trend!=0) {sUP=0; sDN=0; return;} // ���� ��������
   double LevContact=MathAbs(iLevContact)*Pic.Lim; // "����������� ����������� � �������" 
   LINE("FlatLo",0,FlatLo, 0,0, cSIG1);   LINE("FlatHi",0,FlatHi, 0,0, cSIG1);
   if (FlatHi-FlatLo<iParam*ATR) return; // ����� ����� ����������
   if (memUP!=FlatLo){ 
      if (iBar==0) sUP=0;   // ������ ������� ���������,  ������� �������
      if (iLevContact >0 && Low [bar]>FlatLo && Low [bar]<FlatLo+LevContact) FLAT_UP(); // ������ ����� ��� ������� � ������ ������� �����
      if (iLevContact==0 && High[bar]>FlatHi+LevContact) FLAT_UP(); // ������ ����� ��� ������ ������� ������� ����� 
      if (iLevContact <0 && Low [bar]<FlatLo && Low [bar]>FlatLo-LevContact) FLAT_UP(); // ������ ����� ��� ������ �� ������ ������� �����
      }
   if (memDN!=FlatHi){
      if (iBar==0) sDN=0;  // ������ ������� ���������,  ������� �������
      if (iLevContact >0 && High[bar]<FlatHi && High[bar]>FlatHi-LevContact) FLAT_DN(); // ������ ���� ��� ������� � ������� ������� �����
      if (iLevContact==0 && Low [bar]<FlatLo-LevContact) FLAT_DN(); // ������ ���� ��� ������ ������ ������� ����� 
      if (iLevContact <0 && High[bar]>FlatHi && High[bar]<FlatHi+LevContact) FLAT_DN(); // ������ ���� ��� ������ �� ������� ������� �����
   }  }   
void FLAT_UP(){// ������ ����� ��� ������� � ������ ������� �����, ���� ������ ������� 
   memUP=FlatLo;
   sUP=MathMax(1,iBar);
   if (iLevContact==0) {s.Buy =FlatHi;   s.BuyStp =FlatLo;   s.BuyPrf =FlatHi+(FlatHi-FlatLo);}
   else {s.Buy =FlatLo;   s.BuyStp =FlatLo-ATR;   s.BuyPrf =FlatHi;}
   }
void FLAT_DN(){// ������ ���� ��� ������� � ������� ������� �����, ���� ������ ������
   memDN=FlatHi;
   sDN=MathMax(1,iBar);
   if (iLevContact==0) {s.Sell=FlatLo;   s.SellStp=FlatHi;   s.SellPrf=FlatLo-(FlatHi-FlatLo);}
   else {s.Sell=FlatHi;   s.SellStp=FlatHi+ATR;   s.SellPrf=FlatLo;}
   }            
// ����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������
// ����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������   
void SIG_FALSE_LEV(){// ������ ������
   switch (iParam){// � � � � � �   � � � � � � � � , �.�. ������ ����������� ��� ��������:    
      case 0: FALSE_LEVELS (Pic.Hi,HiTime, Pic.Lo,LoTime, iLevContact); break;  // ���������� ����
      case 1: FALSE_LEVELS (UP1_2,Tup1_2, DN1_2,Tdn1_2, iLevContact); break;  // ���������� ������ c ����� � ����� ��������
      case 2: FALSE_LEVELS (UP2_2,Tup2_2, DN2_2,Tdn2_2, iLevContact); break;  // �������� ��������� ������ � ����� � ����� ���������
      case 3: if (Trend==0) FALSE_LEVELS (FlatHi,FlatHiTime, FlatLo,FlatLoTime, iLevContact); break;  // ��������� ������ ��������������� ������
      case 4: FALSE_LEVELS (Poc.UpLev,Poc.StartTime, Poc.DnLev,Poc.StartTime, iLevContact); break;
      }
   if (Fls.UP!=4) sDN=0; 
   else{// �������� ������� ������� �������     //if (Prn) Print(ttt,"SIG_FALSE_LEV(): Fls.UP=",Fls.UP);
      sDN=MathMax(1,iBar);
      s.Sell =Fls.UPuplev; // �������� �������� ������� �������
      s.SellStp=Fls.Max;   
      s.SellPrf=Fls.UPdnlev;   // ��������������� ������� �����, ��� ����������� ��������� ������� 
      }
   if (Fls.DN!=4) sUP=0; 
   else{// �������� ������� ������� �������
      sUP=MathMax(1,iBar); 
      s.Buy=Fls.DNdnlev; // �������� �������� ������ �������
      s.BuyStp =Fls.Min;   
      s.BuyPrf =Fls.DNuplev;
   }  }   
// ����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������
// ����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������   
void SIG_FALSE_LEV_2(){// ������������ ������ ������ ������ ��������� �� �� �������� ������ ������� (Fls.UP=4), � ��� ������ ������ (Fls.UP=3)
   switch (iParam){// � � � � � �   � � � � � � � � , �.�. ������ ����������� ��� ��������:    
      case 0: FALSE_LEVELS (Pic.Hi,HiTime, Pic.Lo,LoTime, iLevContact); break;  // ���������� ����
      case 1: FALSE_LEVELS (UP1_2,Tup1_2, DN1_2,Tdn1_2, iLevContact); break;  // ���������� ������ c ����� � ����� ��������
      case 2: FALSE_LEVELS (UP2_2,Tup2_2, DN2_2,Tdn2_2, iLevContact); break;  // �������� ��������� ������ � ����� � ����� ���������
      case 3: if (Trend==0) FALSE_LEVELS (FlatHi,FlatHiTime, FlatLo,FlatLoTime, iLevContact); break;  // ��������� ������ ��������������� ������
      case 4: FALSE_LEVELS (Poc.UpLev,Poc.StartTime, Poc.DnLev,Poc.StartTime, iLevContact); break;
      }
   if (Fls.UP!=3) sDN=0; 
   else{// �������� ������� ������� �������     //if (Prn) Print(ttt,"SIG_FALSE_LEV(): Fls.UP=",Fls.UP);
      sDN=MathMax(1,iBar);
      s.Sell =Fls.UPuplev; // �������� �������� ������� �������
      s.SellStp=Fls.Max;   
      s.SellPrf=Fls.UPdnlev;   // ��������������� ������� �����, ��� ����������� ��������� ������� 
      }
   if (Fls.DN!=3) sUP=0; 
   else{// �������� ������� ������� �������
      sUP=MathMax(1,iBar); 
      s.Buy=Fls.DNdnlev; // �������� �������� ������ �������
      s.BuyStp =Fls.Min;   
      s.BuyPrf =Fls.DNuplev;
   }  }      
// ����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������
// ����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������   
void SIG_NULL(){// ���������� ����������� ������� (���� ������ �� ��������)
   sUP=1; s.Buy =Ask;
   sDN=1; s.Sell=Bid; 
   }     
// ����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������
// ����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������
int Friday, LastMonth;
void NON_FARM(){// ������� ������ ������ ������� � 16 ���
   bool NonFarm=false;
   if (TimeHour(Time[bar])<TimeHour(Time[bar+1])){ // ����� ���� 
      if (Month()!=LastMonth){// �������� �����
         LastMonth=Month();
         Friday=0;
         }
      if (DayOfWeek()==5) {Friday++; TEXT("UP","Friday="+DoubleToStr(Friday,0), Low[bar]-0.002);}  
      }
      
   if (DayOfWeek()==5 && Friday==1) NonFarm=true; // ������ ������� ������
   if (NonFarm && Hour()==15){// 
      
      sUP=MathMax(1,iBar);
      sDN=MathMax(1,iBar);
      s.Buy =UP1; s.BuyStp =DN1;   s.BuyPrf =UP3; 
      s.Sell=DN1; s.SellStp=UP1;   s.SellPrf=DN3;
      //TEXT("UP","SetBUY "+DoubleToStr(SetBUY ,Digits-1)+" "+DoubleToStr(s.BuyStp ,Digits-1)+" "+DoubleToStr(s.BuyPrf ,Digits-1)+" UP3="+DoubleToStr(UP3 ,Digits-1), Low [bar]-0.005);
      //TEXT("DN","SetSELL"+DoubleToStr(SetSELL,Digits-1)+" "+DoubleToStr(s.SellStp,Digits-1)+" "+DoubleToStr(s.SellPrf,Digits-1)+" DN3="+DoubleToStr(DN3 ,Digits-1), High[bar]+0.005);
      }
   
      
   }



/*
switch(D){// ���� ����� �� ������ ������������� �������
      case  3: s.Buy=Pic.MirDn+ATR*0.5;   s.Sell=Pic.MirUp-ATR*0.5;  break;
      case  2: s.Buy=Pic.MirDn+ATR*0.2;   s.Sell=Pic.MirUp-ATR*0.2;  break;
      case  1: s.Buy=Pic.MirDn;           s.Sell=Pic.MirUp;          break;
      case  0: s.Buy=Pic.MirDn-ATR*0.2;   s.Sell=Pic.MirUp+ATR*0.2;  break;
      case -1: s.Buy=Pic.MirDn-ATR*0.5;   s.Sell=Pic.MirUp+ATR*0.5;  break;
      case -2: s.Buy =Low [iHighest(NULL,0,MODE_LOW ,PicPer*2+1,iBarShift(NULL,0,Pic.MirDnTime,false)-PicPer)];            // ���� �� ���������� ������ ����, �� �������� ��� ������
               s.Sell=High[iLowest (NULL,0,MODE_HIGH,PicPer*2+1,iBarShift(NULL,0,Pic.MirUpTime,false)-PicPer)];   break; 
      case -3: s.Buy =Low [iBarShift(NULL,0,Pic.MirDnTime,false)]-ATR*0.5;          // ���� �� ��� ����, �� �������� ��� ������  
               s.Sell=High[iBarShift(NULL,0,Pic.MirUpTime,false)]+ATR*0.5;  break;  // ���� �� ��� ����, �� �������� ��� ������ 
      }
   switch(S){// ���� ����� �� ������ ������������� �������
      case 1: s.BuyStp =Low [iLowest (NULL,0,MODE_LOW ,iBarShift(NULL,0,Pic.MirDnTime,false),bar)]; // ��� ����� ���� �� ����������� ���� �� �������� ���� �� ����, �� �������� ��� ������ 
              s.SellStp=High[iHighest(NULL,0,MODE_HIGH,iBarShift(NULL,0,Pic.MirUpTime,false),bar)]; break;
      case 2: s.BuyStp =Low [iLowest (NULL,0,MODE_LOW ,iBarShift(NULL,0,Pic.MirDnTime,false),bar)]; // ��� ����� ���� �� ����������� ���� �� �������� ���� �� ����, �� �������� ��� ������ 
              s.SellStp=High[iHighest(NULL,0,MODE_HIGH,iBarShift(NULL,0,Pic.MirUpTime,false),bar)]; break;//   
   } }
   
   
   
   switch(D){
      case  2: s.Buy=FlatLo+ATR*0.5;   s.Sell=FlatHi-ATR*0.5;  break;
      case  1: s.Buy=FlatLo;           s.Sell=FlatHi;          break;
      case  0: s.Buy=FlatLo-ATR*0.5;   s.Sell=FlatHi+ATR*0.5;  break;
      case -1: s.Buy=FlatLo-ATR;       s.Sell=FlatHi+ATR;      break;
      } 
   switch(S){
      case 1: SetPROFIT_BUY =FlatLo-ATR*0.5;   SetPROFIT_SELL=FlatHi+ATR*0.5;  break; // ��������������� ������� �����
      case 2: SetPROFIT_BUY =FlatLo-ATR;       SetPROFIT_SELL=FlatHi+ATR;      break;// ��������������� ������� �����
      }  
   
    
   */ 

    
 
 