%{ 
   Date:    07/14/2020
   Author:  Martin E. Liza
   File:    calculateOptLength.m
   Detail:  calculates the optical length  

   Ex.      [ keyMatrixX, keyMatrixY ] = dataSplit('fileName.plt') 

   Author              Date            Revision
   ---------------------------------------------------
   Martin E. Liza      07/14/2020      Initial version

%}

dataIn = dataParser('data/outData030.dat');
[ constGD, neutrGD, ionGD, attWeight ] = constantsGD();
[ N ] = calculateOPL();

wavelenght   = 400E-09;  %[m] 
speedOfSound = 343;      %[m/s]
indxOfRefrac = 1.65E-05; %[ ]
zetaFactor   = 0.05;     %[percentage]
epsilon      =  1;       %[ ]
constBp      = 8.5;      %[ ], constant of order unity 
gasConstant  = 8.314;    %[J/mol K] 
gamma        = 1.2;      %[ ] 

% Calcualte total attomic Weight 
totAttWeight = 0;
headerName = fieldnames(attWeight);
for i=length(fieldnames(attWeight))
    totAttWeight = totAttWeight + attWeight.(headerName{i});
end 

% Calcualate delta X 
for i=1:length(dataIn.X)-1  
    deltaX(i) = dataIn.X(i+1) - dataIn.X(i); 
end 
deltaX = [ deltaX(1) deltaX ]';


% Speed of sound 
speedOfSound = ( gamma .* gasConstant .* dataIn.T ./ totAttWeight ).^(1/2) ; 

% Calculates the grid resolution 
lenC = (( 7 * wavelenght^2 * zetaFactor .* speedOfSound.^4 .* (2 * pi)^(7/3) ) ./ ... 
     ( deltaX .* (N.ion - 1).^2 .* epsilon.^(4/3) .* (12 * pi^3) * constBp )).^(3/7);

plot(dataIn.T, lenC) 

