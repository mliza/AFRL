%{ 
   Date:    07/27/2020
   Author:  Martin E. Liza
   File:    calculateOPL.m
   Detail:  calculates N, OPL and OPD using the 
            dataParser.m, and the outputs from contantsGD.m

   Ex.     [ N ] = calculateOPL('data/10Laminar.dat', plotFlag)  

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
   Martin E. Liza      07/14/2020      Made a function that returns the index
                                       of refraction as a structure.  
   Martin E. Liza      07/27/2020      Fixed the nargin and this fuction works with one script  
%}

function [ ] = calculateOPL(dataFile, cuttingAxis, species, plotFlag) 
    
    pathToSave = 'gridData/plots'; 

    %plotFlag if off, plots are not generate  
    if nargin < 4
        plotFlag = [ ];
    end 

    % Import Data
    dataIn = dataParser(dataFile);
    [ constGD, neutrGD, ionGD, attWeight ] = constantsGD(); 
    [ rowIn, colIn ] = size(dataIn.X);

    % Create title template 
    saveTitle = strrep(dataFile, 'gridData/', '');
    saveTitle = strrep(saveTitle, '.dat', '');

    % Calculate total Gladsone-Dale Constant and index of refraction 
    neutrSpGD = ( (neutrGD.O .* dataIn.rho_O) + (neutrGD.O2 .* dataIn.rho_O2) + ...
                  (neutrGD.N .* dataIn.rho_N) + (neutrGD.NO .* dataIn.rho_NO) + ...
                  (neutrGD.N2 .* dataIn.rho_N2) ) ./ dataIn.rho; 

    % Calculates the ion GD constants for 5 species 
    if (species == 5) % for 5 species 
        ionSpGD   = ( (ionGD.O .* dataIn.rho_O) + (ionGD.O2 .* dataIn.rho_O2) + ...
                   (ionGD.N .* dataIn.rho_N) + (ionGD.NO .* dataIn.rho_NO) + ...
                   (ionGD.N2 .* dataIn.rho_N2) ) ./ dataIn.rho; 
    end 

    % Calculates the ion GD constants for 11 species 
    if (species == 11) 

        ionSpGD   = ( (ionGD.O .* dataIn.rho_Op) + (ionGD.O2 .* dataIn.rho_O2p) + ...
                      (ionGD.N .* dataIn.rho_Np) + (ionGD.NO .* dataIn.rho_NOp) + ...
                      (ionGD.N2 .* dataIn.rho_N2p) ) ./ dataIn.rho; 
    end 


    % Populates GD and N structures  
    GD.neutral = neutrSpGD;
    GD.ion     = ionSpGD;
 %   GD.total   = GD.neutral + GD.ion; 
    N.neutral  = neutrSpGD .* dataIn.rho;
    N.ion      = ionSpGD .* dataIn.rho;
%    N.total    = N.neutral + N.ion; 

    % Calculates OPL and OPD 
    nFieldName = fieldnames(N);
    for n = 1:length(nFieldName)
        headerName = nFieldName{n};
        indexN = N.(headerName);
        for i = 1:colIn 

            %Compare if it is x or y data cutt
            if ( strcmp(cuttingAxis, 'y') || strcmp(cuttingAxis, 'Y') ) 
                OPL.(headerName) = dataIn.X .* indexN; 
            end 
            if ( strcmp(cuttingAxis, 'x') || strcmp(cuttingAxis, 'X') ) 
                OPL.(headerName) = dataIn.Y .* indexN; 
            end 

            OPD.(headerName) = OPL.(headerName) - mean(OPL.(headerName));
        end
    end

    %flag to activate plots 
    if ~isempty(plotFlag)     
        
        % Plot Index of Refraction  
        figure 
        for i = 1:length(nFieldName)
            nIndx = nFieldName{i}; 

            %Compare if it is x or y data cutt
            if ( strcmp(cuttingAxis, 'y') || strcmp(cuttingAxis, 'Y') ) 
                plot(dataIn.X, N.(nIndx), '-')
            end 
            if ( strcmp(cuttingAxis, 'x') || strcmp(cuttingAxis, 'X') ) 
                plot(dataIn.Y, N.(nIndx), '-')
            end 
            hold on 
        end 
        legend(nFieldName, 'Location', 'southeast');
        if ( strcmp(cuttingAxis, 'y') || strcmp(cuttingAxis, 'Y') ) 
            xlabel('distance-x    [m]', 'Interpreter', 'tex', 'Fontsize', 12);
        end 
        if ( strcmp(cuttingAxis, 'x') || strcmp(cuttingAxis, 'X') ) 
            xlabel('distance-y    [m]', 'Interpreter', 'tex', 'Fontsize', 12);
        end 
        ylabel('(n-1)   [ ]','Interpreter', 'tex', 'Fontsize', 12);
        set(gcf, 'InvertHardcopy', 'off');
        hold off
       % saveas(gcf, sprintf('%s/%sindexN%s.png', pathToSave, cuttingAxis, saveTitle))

        % Plot OPL 
        figure 
        for i = 1:length(nFieldName)
            nIndx = nFieldName{i}; 
            plot(dataIn.X, OPL.(nIndx), '-')
            hold on 
        end 
        legend(nFieldName, 'Location', 'southeast');
        if ( strcmp(cuttingAxis, 'y') || strcmp(cuttingAxis, 'Y') ) 
            xlabel('distance-x    [m]', 'Interpreter', 'tex', 'Fontsize', 12);
        end 
        if ( strcmp(cuttingAxis, 'x') || strcmp(cuttingAxis, 'X') ) 
            xlabel('distance-y    [m]', 'Interpreter', 'tex', 'Fontsize', 12);
        end 
        ylabel('(OPL - 1)   [m]','Interpreter', 'tex', 'Fontsize', 12);
        set(gcf, 'InvertHardcopy', 'off');
        hold off
       % saveas(gcf, sprintf('%s/%sOPL%s.png', pathToSave, cuttingAxis, saveTitle))

        % Plot OPD 
        figure 
        for i = 1:length(nFieldName)
            nIndx = nFieldName{i}; 
            plot(dataIn.X, OPD.(nIndx), '-')
            hold on 
        end 
        legend(nFieldName, 'Location', 'southeast');
        if ( strcmp(cuttingAxis, 'y') || strcmp(cuttingAxis, 'Y') ) 
            xlabel('distance-x   [m]', 'Interpreter', 'tex', 'Fontsize', 12);
        end 
        if ( strcmp(cuttingAxis, 'x') || strcmp(cuttingAxis, 'X') ) 
            xlabel('distance-y   [m]', 'Interpreter', 'tex', 'Fontsize', 12);
        end 
        ylabel('OPD    [m]','Interpreter', 'tex', 'Fontsize', 12);
        set(gcf, 'InvertHardcopy', 'off');
        hold off
       % saveas(gcf, sprintf('%s/%sOPD%s.png', pathToSave, cuttingAxis, saveTitle))
    end 
   % clear all; clc; close all; 

end 
