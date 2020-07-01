%{ 
   Date:    06/22/2020
   Author:  Martin E. Liza
   File:    calculateOPL.m
   Detail:  calculates N, OPL and OPD using the 
            dataParser.m, and the outputs from contantsGD.m

   Ex.     calculateOPL 

   Author              Date            Revision
   ----------------------------------------------------------------------
   Martin E. Liza      06/04/2020      Initial Version.
   Martin E. Liza      06/16/2020      Created Plots and implemented the  
                                       constantsGD.m file on it. 
   Martin E. Liza      06/21/2020      Revised the script to work with 
                                       multiple dimension structures, 
                                       implemented OPL and OPD.
%}

clear all; close all; clc; 
% Import Data
dataIn = dataParser('dataOut.dat');
[ constGD, neutrGD, ionGD ] = constantsGD(); 
[ rowIn, colIn ] = size(dataIn.X);


% Calculate total Gladsone-Dale Constant and index of refraction 
totConstGD = ( (constGD.O .* dataIn.rho_O) + (constGD.O2 .* dataIn.rho_O2) + ...
               (constGD.N .* dataIn.rho_N) + (constGD.NO .* dataIn.rho_NO) + ...
               (constGD.N2 .* dataIn.rho_N2) ) ./ dataIn.rho; 

totNeutrGD = ( (neutrGD.O .* dataIn.rho_O) + (neutrGD.O2 .* dataIn.rho_O2) + ...
               (neutrGD.N .* dataIn.rho_N) + (neutrGD.NO .* dataIn.rho_NO) + ...
               (neutrGD.N2 .* dataIn.rho_N2) ) ./ dataIn.rho; 

totIonGD   = ( (ionGD.O .* dataIn.rho_O) + (ionGD.O2 .* dataIn.rho_O2) + ...
               (ionGD.N .* dataIn.rho_N) + (ionGD.NO .* dataIn.rho_NO) + ...
               (ionGD.N2 .* dataIn.rho_N2) ) ./ dataIn.rho; 

N.constant = totConstGD .* dataIn.rho; 
N.neutral  = totNeutrGD .* dataIn.rho;
N.ion      = totIonGD .* dataIn.rho;

% Calculating OPL and OPD 
nFieldName = fieldnames(N);
for n = 1:length(nFieldName)
    headerName = nFieldName{n};
    indexN = N.(headerName);
    for i = 1:colIn 
        vectorOPL(i) = trapz(dataIn.Y(:,1),indexN(:,i)); 
        OPL.(headerName) = vectorOPL; 
        OPD.(headerName) = OPL.(headerName) - mean(OPL.(headerName));
    end
end

% Plot OPD  
figure 
for i = 1:length(nFieldName)
    nIndx = nFieldName{i}; 
    plot(dataIn.X(1,:), OPD.(nIndx), 'o-')
    hold on 
end 
legend(nFieldName);
xlabel('distance-X [m]');
ylabel('OPD [m]');
hold off

