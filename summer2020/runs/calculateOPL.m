% Import Data
dataIn = dataParser('output/output.plt');

% Specie's Gladsone-Dale Constants
kO  = 2.04E-4; 
kO2 = 1.93E-4;
kN  = 3.10E-4;
kNO = 2.21E-4; 
kN2 = 2.40E-4;

% Calculate total Gladsone-Dale Constant and index of refraction 
% Modify this without using loops 
for i = 1:length(dataIn.X) 
    kTotal(i) = ( (kO * dataIn.rho_O(i)) + (kO2 * dataIn.rho_O2(i)) + ...
                  (kN * dataIn.rho_N(i)) + (kNO * dataIn.rho_NO(i)) + ...
                  (kN2 * dataIn.rho_N2(i)) ) / dataIn.rho(i); 
    indexN(i) = kTotal(i) * dataIn.rho(i) + 1; 
end 

% Calculate distance formula 
distance(1) = 0; 
for i = 2:length(dataIn.X)  
    distance(i) = sqrt( (dataIn.X(i) - dataIn.X(i-1))^2 + ...
                  (dataIn.Y(i) - dataIn.Y(i-1))^2 ) + distance(i-1);
end 

% Calculating OPL and OPD 
OPL = trapz(distance,indexN); 
%OPD = OPL - mean(OPL);
