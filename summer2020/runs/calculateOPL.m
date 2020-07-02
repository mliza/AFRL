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
   Martin E. Liza      07/01/2020      Revised the Script to work with the
                                       sliced data from tecplot. OPL, OPD and
                                       index of Reraction plots were added.
%}

clear all; close all; clc; 
% Import Data
dataIn = dataParser('outData01.dat');
numIn = 0.10; 
[ constGD, neutrGD, ionGD ] = constantsGD(); 
[ rowIn, colIn ] = size(dataIn.X);

% Create title template 
dyCut = sprintf('y = %s[m],', num2str(numIn));
titleName = strcat(dyCut, ' AoA = 45^{\circ}');
saveTitle = strrep(num2str(numIn), '.', '');
pathToSave = '/Users/Martin/Desktop/MDA/figures';


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

GD.tables  = totConstGD;  
GD.neutral = totNeutrGD;
GD.ion     = totIonGD;

N.tables   = totConstGD .* dataIn.rho; 
N.neutral  = totNeutrGD .* dataIn.rho;
N.ion      = totIonGD .* dataIn.rho;

% Calculating OPL and OPD 
nFieldName = fieldnames(N);
for n = 1:length(nFieldName)
    headerName = nFieldName{n};
    indexN = N.(headerName);
    for i = 1:colIn 
        OPL.(headerName) = dataIn.X .* indexN; 
        OPD.(headerName) = OPL.(headerName) - mean(OPL.(headerName));
    end
end

% Plot Index of Refraction  
figure 
for i = 1:length(nFieldName)
    nIndx = nFieldName{i}; 
    plot(dataIn.X, N.(nIndx), '-')
    hold on 
end 
legend(nFieldName);
title(titleName, 'Interpreter', 'tex');
xlabel('distance-x [m]', 'Interpreter', 'tex');
ylabel('(n-1) [ ]','Interpreter', 'tex');
set(gcf, 'InvertHardcopy', 'off');
xlim([0 0.5]);
hold off
%saveas(gcf, sprintf('%s/indexN_%s.png', pathToSave, saveTitle))

% Plot OPL 
figure 
for i = 1:length(nFieldName)
    nIndx = nFieldName{i}; 
    plot(dataIn.X, OPL.(nIndx), '-')
    hold on 
end 
legend(nFieldName, 'Location', 'southeast');
title(titleName, 'Interpreter', 'tex');
xlabel('distance-x [m]', 'Interpreter', 'tex');
ylabel('(OPL - 1) [m]','Interpreter', 'tex');
set(gcf, 'InvertHardcopy', 'off');
xlim([0 0.5]);
hold off
%saveas(gcf, sprintf('%s/OPL_%s.png', pathToSave, saveTitle))

% Plot OPD 
figure 
for i = 1:length(nFieldName)
    nIndx = nFieldName{i}; 
    plot(dataIn.X, OPD.(nIndx), '-')
    hold on 
end 
legend(nFieldName, 'Location', 'southeast');
title(titleName, 'Interpreter', 'tex');
xlabel('distance-x [m]', 'Interpreter', 'tex');
ylabel('OPD [m]','Interpreter', 'tex');
set(gcf, 'InvertHardcopy', 'off');
xlim([0 0.5]);
hold off
%saveas(gcf, sprintf('%s/OPD_%s.png', pathToSave, saveTitle))

