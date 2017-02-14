clear all
%read temp, pres,FeR
TPR  = xlsread('TPR.xlsx');
temp = TPR(:,1);
pres = TPR(:,2);
FeR  = TPR(:,3);

%composition components
MgO = 0.0327; 	%MgO's mole fraction
CaO = 0.07486;		%CaO's mole fraction
NaO = 0.0966;		%NaO0.5's mole fraction
K2O = 0.01375;		%KO0.5's mole fraction
Al2O3 = 0.16446;		%Al2O3's mole fraction
FeT = 0.0671;       %total Iron's mole fraction
FeO = FeT*(1-FeR);  %FeO's mole fraction   
Fe2O3 = FeT*FeR;    %Fe2O3's mole fraction

%oxygen fugacity part
logfo2 =-16953./temp+17.98-2.66*log10(temp)+562*pres./temp; % log10 fo2
lnfo2 = log(10.^logfo2);     %lnfo2

%pressure part
%bulk modulus
bulkmodulus = xlsread('bulkmodulus.xlsx');
Bulk_Fe2O3 = bulkmodulus(:,1);
Bulkprime_Fe2O3 = bulkmodulus(:,2);
Bulk_FeO  = bulkmodulus(:,3);
Bulkprime_FeO = bulkmodulus(:,4);
%Volume at 1 bar
V_Fe2O3 = 21070+4.54*(temp-1673);	
V_FeO = 13650+2.92*(temp-1673);

P_V_Fe2O3 = V_Fe2O3.*Bulk_Fe2O3/(1+Bulkprime_Fe2O3).*((Bulkprime_Fe2O3/Bulk_Fe2O3*pres+1).^(1+1/Bulkprime_Fe2O3)-(Bulkprime_Fe2O3/Bulk_Fe2O3*10^(-5)+1)^(1+1/Bulkprime_Fe2O3));
P_V_FeO = V_FeO.*Bulk_FeO/(1+Bulkprime_FeO).*((Bulkprime_FeO/Bulk_FeO*pres+1).^(1+1/Bulkprime_FeO)-(Bulkprime_FeO/Bulk_FeO*10^(-5)+1)^(1+1/Bulkprime_FeO));

%modle fitting
vari = log(Fe2O3./FeO)-1/4*lnfo2+(P_V_Fe2O3-P_V_FeO)./temp/8.314;
[b,stats] = robustfit...
     (vari,[1./temp,MgO./temp,CaO./temp,NaO./temp,K2O./temp,Al2O3./temp,(Fe2O3-FeO)./temp]);
% 
% vari = 1./temp.*b(1)+mgo./temp.*b(2)+cao./temp.*b(3)+nao./temp.*b(4)+k2o./temp.*b(5)+al2o3./temp.*b(6)...
%     +(fe2o3-feo)./temp.*b(7)+b(8);



figure(1)
plot(pres,FeR,'*')
ylabel('Fe^3^+/sigmaFe')
xlabel('Pressure (GPa)')
