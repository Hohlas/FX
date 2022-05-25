struct ImpulseStruct{  
   double Val;    // �������� ���������������� ��������
   double Highest,Lowest;  // ������������ � ����������� ���� � ������� ������������� ��������
   double UpLim,DnLim;  // �������� �������� � ������� ������� ������������, ��� ���������� ������� ����������� �������
   double Sig;          // �������� ������� (�������������� ������ � �������� ������ ������������)
   double HCO, CO;      // 
   double Cur;          // �������� �������� �� ������ ����
   } Imp; 
   
void IMPULSE(){ // ������������ ������ ���������. ���� ������ ��� �>>O ���� ��� �������� ���� ����� ������ �� L. ���� ������ ��� �<<O, ���� �������� ���� ������ �� �.
   Imp.HCO=Close[bar]-Low[bar] - (High[bar]-Close[bar]);   // ������� = ������� ���� � ����: �� �������� �� �������� - �� ��������� �� ��������
   Imp.CO=Close[bar]-Open[bar];
   if (MathAbs(Imp.HCO)>MathAbs(Imp.CO))  Imp.Cur=Imp.HCO; else Imp.Cur=Imp.CO;
   
   Imp.UpLim= SlowAtr*Impulse*0.01;  // ������� ��� �����������
   Imp.DnLim=-Imp.UpLim;    // ���������� ����
   if (Imp.Sig>0){   // ���� ������ �������� �����
      if (High[bar]>Imp.Highest) Imp.Highest=High[bar]; // ������������ ���� � ������� �������
      if (Imp.Highest-Low[bar]>Imp.Val*ImpBack*0.01)  Imp.Sig=0; // ���� ������� �� ������������ ���� �� �������� ���������������� �������� ��������, �������� ������
      }
   if (Imp.Sig<0){  // ���� ������ �������� ����
      if (Low[bar]<Imp.Lowest) Imp.Lowest=Low[bar]; // ������������ ���� � ������� �������
      if (High[bar]-Imp.Lowest>Imp.Val*ImpBack*0.01)  Imp.Sig=0;
      }
   if (Imp.Cur>Imp.UpLim){       // ������ ������� �����, ����������� SlowAtr*N*0.01
      Imp.Val=High[bar]-Low[bar];// �������� ��������
      Imp.Highest=High[bar];     // �������� � ������� ������ ��������
      Imp.Sig=Imp.UpLim;         // ��������� �������
      }                   
   if (Imp.Cur<Imp.DnLim){
      Imp.Val=High[bar]-Low[bar];
      Imp.Lowest=Low[bar]; 
      Imp.Sig=Imp.DnLim; 
   }  }