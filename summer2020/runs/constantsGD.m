%{ 
   Date:    06/30/2020
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
   Martin E. Liza      06/30/2020      Cleaned up death code 
%}

function[ GDconstSI, neutGDconstSI, ionGDconstSI, attWeightSI ] = constantsGD(testFlag) 
    pathToSave = '/Users/Martin/Desktop/MDA/figures';
   % strNeutral = 

    % Test flag, if empty tests are skipt else, test are run  
    if nargin < 1
        testFlag = [ ];
    end 

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
 
    % Loops to calculate neutral and ion Gladston-Dale constants
    fieldNames = fieldnames(GDconstSI);  
    for i = 1:length(fieldNames)
        fieldName = fieldNames{i};

        % Unit Analysis (Rgd =  alpha[cm^3] * NA * 2pi * E-6/M )
        neutGDconstSI.(fieldName) = 2 * pi * neutralPolCGS.(fieldName) * ... 
                                    avogadroNumber * 10^-6 / attWeightSI.(fieldName); 

        ionGDconstSI.(fieldName) =  2 * pi * ionPolCGS.(fieldName) * ... 
                                    avogadroNumber * 10^-6 / attWeightSI.(fieldName); 
    end

    % Convert the structure to a vector  
    for i = 1:length(fieldNames)
        fieldIndx = fieldNames{i}; 
        neutralCalc(i)   = neutGDconstSI.(fieldIndx) * 10^4; 
        ionCalc(i)       = ionGDconstSI.(fieldIndx) * 10^4; 
        neutralConst(i)  = GDconstSI.(fieldIndx) * 10^4; % tables 
    end

    % labes for text 
    fieldNamesNeut = { 'N_2' ; 'N'; 'NO'; 'O'; 'O_2' };
    fieldNamesIon  = { 'N_2^+' ; 'N^+'; 'NO^+'; 'O^+'; 'O_2^+' };

    % Logical statement for plots and test results 
    if ~isempty(testFlag)
        % Plots
        figure 
        plot( neutralCalc, neutralCalc, 'd', 'MarkerSize', 12 )
        hold on
        text( neutralCalc, neutralCalc, fieldNamesNeut,'Fontsize', 11, ...
              'HorizontalAlignment', 'left','VerticalAlignment', 'top' )
        plot(ionCalc, ionCalc, 'p', 'MarkerSize', 12)
        text( ionCalc, ionCalc, fieldNamesIon,'Fontsize', 12, ...
              'HorizontalAlignment', 'left','VerticalAlignment', 'top' )
        legend( {'R_{GD}, neutral ' , 'R_{GD}, ion'}, ... 
                'Location', 'southeast' )
        xlabel( 'R_{GD} \times 10^{-4}   [m^3/kg]', 'Fontsize', 12 ) 
        ylabel( 'R_{GD} \times 10^{-4}   [m^3/kg]', 'Fontsize', 12 ) 
%        title('GladstoneDale constants')
        set( gcf, 'InvertHardcopy', 'off' )
        hold off 
        saveas(gcf, sprintf('%s/gdConst.png', pathToSave))

        % Error Calculation  
        errNeutral = abs( (neutralCalc - neutralConst) ./ neutralConst ) .* 100 ;
        errIon = abs( (ionCalc - neutralConst) ./ neutralConst ) .* 100 ; 
        round(errNeutral,3); 
        round(errIon,3);
    end 

end %end function constantsGD 
