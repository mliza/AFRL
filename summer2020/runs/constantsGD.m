%{ 
   Date:    06/24/2020
   Author:  Martin E. Liza
   File:    constantsGD.m
   Detail:  It returns the neutral Gladstone-Dale constants from papers and 
            calculates the neutral and ionized GD constants for N2, N, O2, O 
            using polarizability constants. The GD constants are returned as 
            three different structures with units of [m^3/kg].

   Ex.      [ GDconstSI, nuetralGDconstSI, ionGDConstSi ] = constantsGD()

   Author              Date            Revision
   ---------------------------------------------------
   Martin E. Liza      06/12/2020      Initial Version
   Martin E. Liza      06/24/2020      Implemented the right method 
                                       to calculate the GD-constants 
%}
clear all; close all; clc;
%function[ GDconstSI, neutralGDconstSI, ionGDconstSI ] = constantsGD() 
    
    % Physical Constants 
    vacPermittivitySI = Constant.SI.VacuumPermittivity; %[F/m]
    avogadroNumber    = Constant.SI.AvogadroNumber;     %[1/mol]

    % Gladstone-Dale constants, using table 1 from progress report 1 
    GDconstSI.N2 = 2.38E-4; %[kg/m^3]
    GDconstSI.N  = 3.01E-4; %[kg/m^3]
    GDconstSI.O2 = 1.90E-4; %[kg/m^3]
    GDconstSI.O  = 1.82E-4; %[kg/m^3] 
    GDconstSI.NO = 2.21E-4; %[kg/m^3]

    % Neutral polarizability volume, table 2a from progress report 1 [cgs]
    neutralPolCGS.N2 = 1.700E-24; %[cm^3]
    neutralPolCGS.N  = 1.100E-24; %[cm^3]
    neutralPolCGS.O2 = 1.581E-24; %[cm^3]
    neutralPolCGS.O  = 0.802E-24; %[cm^3]
    neutralPolCGS.NO = 1.700E-24; %[cm^3]

    % Ion polarizability volume, table 2b from progress report 1 [cgs]
    ionPolCGS.N2  = 2.386E-24; %[cm^3] 
    ionPolCGS.N   = 0.559E-24; %[cm^3]
    ionPolCGS.O2  = 0.238E-24; %[cm^3] 
    ionPolCGS.O   = 0.345E-24; %[cm^3]
    ionPolCGS.NO  = 1.021E-24; %[cm^3]

    % Molar mass from periodic table 
    attWeightSI.N2 = 28.014E-3; %[kg/mol]
    attWeightSI.N  = 14.007E-3; %[kg/mol]
    attWeightSI.O2 = 31.998E-3; %[kg/mol]
    attWeightSI.O  = 15.999E-3; %[kg/mol]
    attWeightSI.NO = 30.006E-3; %[kg/mol]  

    % Conversion factors 
    % https://en.wikipedia.org/wiki/Polarizability
    % https://en.wikipedia.org/wiki/Molar_refractivity
    cgsToSI =  4 * pi * vacPermittivitySI * 10^-6;    
    molarRefractConst = (4 * pi / 3) * avogadroNumber;  %Constant from table 
 
    % Loops to calculate neutral and ion Gladston-Dale constants
    fieldNames = fieldnames(GDconstSI);  
    for i = 1:length(fieldNames)
        fieldName = fieldNames{i};
        
        % Calculate molar polarizability in [cm^3/moles]
        molarNeutralPolCGS.(fieldName) = neutralPolCGS.(fieldName) * molarRefractConst;   
        molarIonPolCGS.(fieldName)     = ionPolCGS.(fieldName) * molarRefractConst;  

        % Convert molar polarizability from [cgs] to [SI]
        molarNeutralPolSI.(fieldName) = molarNeutralPolCGS.(fieldName) * cgsToSI;
        molarIonPolSI.(fieldName)     = molarIonPolCGS.(fieldName) * cgsToSI;

        % Calculate specific polarizability  
        specificNeutralPolSI.(fieldName) = molarNeutralPolSI.(fieldName) / ... 
                                           attWeightSI.(fieldName);  
        specificIonPolSI.(fieldName)     = molarIonPolSI.(fieldName) / ...
                                           attWeightSI.(fieldName);

        % Calculate Gladstone-Dale constant in [m^3/kg]
        neutralGDconstSI.(fieldName)  = specificNeutralPolSI.(fieldName) / ...
                                        (2 * vacPermittivitySI); 
        ionGDconstSI.(fieldName)      = specificIonPolSI.(fieldName) / ... 
                                        (2 * vacPermittivitySI);

        % 2nd way (Rgd =  alpha[cm^3] * NA * 2pi * E-6/M )
        neutGDconstSI.(fieldName) = 2 * pi * neutralPolCGS.(fieldName) * ... 
                                    avogadroNumber * 10^-6 / attWeightSI.(fieldName); 

        ionGDconstSec.(fieldName) =  2 * pi * ionPolCGS.(fieldName) * ... 
                                    avogadroNumber * 10^-6 / attWeightSI.(fieldName); 

        % Using table, 1A^3 = 2.5222549[cm^3/mol] 
        neutralGDtable.(fieldName) = 2.522549 * 10^18 * neutralPolCGS.(fieldName) *  ...
                                     2 * pi / attWeightSI.(fieldName) ;
    end

    % Convert the structure to a vector  
    for i = 1:length(fieldNames)
        fieldIndx = fieldNames{i}; 
        neutralFirst(i) = neutralGDconstSI.(fieldIndx) * 10^4;  
        neutralSec(i)   = neutGDconstSI.(fieldIndx) * 10^4; 
        ionFirst(i)     = ionGDconstSI.(fieldIndx) * 10^4; 
        ionSec(i)       = ionGDconstSec.(fieldIndx) * 10^4; 
        neutralConst(i) = GDconstSI.(fieldIndx) * 10^4; % tables 
        neutGDconstTable(i) = neutralGDtable.(fieldIndx) * 10^4; %using table polarizability  constants 
    end

    % Plots
    figure 
    plot(neutralConst, neutralConst, 'p', 'MarkerSize', 12)
    hold on 
    text( neutralConst, neutralConst, fieldNames,'Fontsize', 12, ...
          'HorizontalAlignment', 'left','VerticalAlignment', 'top' )
  %  plot( neutGDconstTable, neutGDconstTable, '*', 'MarkerSize', 12 )
%    text( neutGDconstTable, neutGDconstTable, fieldNames,'Fontsize', 12, ...
     %     'HorizontalAlignment', 'left','VerticalAlignment', 'top' )
    plot( neutralSec, neutralSec, 'd', 'MarkerSize', 12 )
    text( neutralSec, neutralSec, fieldNames,'Fontsize', 11, ...
          'HorizontalAlignment', 'right','VerticalAlignment', 'bottom' )
    legend( {'R_{GD}, table ' , 'R_{GD}, calculated'}, ... 
            'Location', 'southeast' )
    xlabel( 'R_{GD} \times 10^{-4} [m^3/kg]' ) 
    ylabel( 'R{_GD} \times 10^{-4} [m^3/kg]' ) 
    title('GladstoneDale constants')
    set( gcf, 'InvertHardcopy', 'off' )
    hold off 

    % Error Calculation  
    errUnitAnalysis = abs( (neutralSec - neutralConst) ./ neutralConst ) .* 100 ;
    errPolTable = abs( (neutGDconstTable - neutralConst) ./ neutralConst ) .* 100;
    errWiki = abs( (neutralFirst - neutralConst) ./ neutralConst ) .* 100; 
    errION = abs( (ionSec - neutralConst) ./ neutralConst ) .* 100 ; 
    round(errUnitAnalysis,3) 
    round(errION,3) 


%end %end function constantsGD 
