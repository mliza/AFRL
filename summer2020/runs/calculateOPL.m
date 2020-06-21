%{ 
   Date:    06/16/2020
   Author:  Martin E. Liza
   File:    calculateOPL.m
   Detail:  calculates the OPL using the dataParser.m, and the outputs from 
            contantsGD.m

   Ex.     calculateOPL 

   Author              Date            Revision
   ---------------------------------------------------------
   Martin E. Liza      06/04/2020      Initial Version
   Martin E. Liza      06/16/2020      Created Plots and implemented the  
                                       constantsGD.m file on it 
                                       

%}

clear all; close all; 
% Import Data
dataIn = dataParser('45AoA/output.plt');
[ constGD, neutrGD, ionGD ] = constantsGD(); 

% Calculate total Gladsone-Dale Constant and index of refraction 
% Modify this without using loops 
for i = 1:length(dataIn.X) 
    totConstGD(i) = ((constGD.O * dataIn.rho_O(i)) + (constGD.O2 * dataIn.rho_O2(i)) + ...
                     (constGD.N * dataIn.rho_N(i)) + (constGD.NO * dataIn.rho_NO(i)) + ...
                     (constGD.N2 * dataIn.rho_N2(i))) / dataIn.rho(i); 

    totNeutrGD(i) = ((neutrGD.O * dataIn.rho_O(i)) + (neutrGD.O2 * dataIn.rho_O2(i)) + ...
                     (neutrGD.N * dataIn.rho_N(i)) + (neutrGD.NO * dataIn.rho_NO(i)) + ...
                     (neutrGD.N2 * dataIn.rho_N2(i))) / dataIn.rho(i); 

    totIonGD(i)   = ((ionGD.O * dataIn.rho_O(i)) + (ionGD.O2 * dataIn.rho_O2(i)) + ...
                     (ionGD.N * dataIn.rho_N(i)) + (ionGD.NO * dataIn.rho_NO(i)) + ...
                     (ionGD.N2 * dataIn.rho_N2(i))) / dataIn.rho(i); 

    N.constant(i) = totConstGD(i) * dataIn.rho(i) + 1; 
    N.neutral(i)  = totNeutrGD(i) * dataIn.rho(i) + 1;
    N.ion(i)      = totIonGD(i) * dataIn.rho(i)  + 1;
end 

% Calculate distance formula 
distance(1) = 0; 
for i = 2:length(dataIn.X)  
    distance(i) = sqrt( (dataIn.X(i) - dataIn.X(i-1))^2 + ...
                  (dataIn.Y(i) - dataIn.Y(i-1))^2 ) + distance(i-1);
end 

% Calculating OPL and OPD 
%OPL = trapz(distance,indexN); 
%OPD = OPL - mean(OPL);

% Plot index of refraction 
figure 
movingAvgConst = 200;
nFieldName = fieldnames(N);
meanDistance = movmean(distance, movingAvgConst);
for i = 1:length(nFieldName)
    nIndx = nFieldName{i}; 
    OPL.(nIndx) = distance .* N.(nIndx);
    meanN.(nIndx) = movmean(N.(nIndx), movingAvgConst); 
   % plot(distance, N.(nIndx) ) 
    plot(meanDistance, ((meanN.(nIndx)-1) * 10^4))
    hold on 
end 
legend(nFieldName);
xlabel('distance [m]');
ylabel('(n-1) x 10^4 [ ]');
hold off

