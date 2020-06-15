%{ 
   Date:    06/03/2020
   Author:  Martin E. Liza
   File:    dataParser.m
   Detail:  It parsers the data from LeMaNs output files, and
            returns the data as a structure. 

   Ex.      [ dataOutStruct ] = dataParser('fileName.plt') 

   Author              Date            Revision
   ---------------------------------------------------
   Martin E. Liza      06/03/2020      Initial Version

%}

function [dataOutStruct] = dataParser(filename)
    
    inFile = importdata(filename);
    numDataIn = inFile.data; 
    [rows, columns] = size(numDataIn);
    [rowNaN colNaN] = find(isnan(inFile.data(:,columns))); %find col where NaN starts 

    % Cleanout input data header  
    % This might need to be modify to work with other data files 
    % Removes the words VARIABLES and = from data file 
    headersIn = erase( convertCharsToStrings(inFile.textdata{1}), "VARIABLES" ); 
    headersIn = erase( headersIn, "=" );
    % Remodes the double quotes 
    headersOut = strrep(headersIn, '"', '');
    % Split the headers 
    headers = strsplit(headersOut, ' ');
    headers(end) = [];
   % headers(1) = []; %uncomment me for convergenec.plt


    %Creates a data structure using header's names
    for i = 1:columns
        headerName = headers(i); 
        dataOutStruct.(headerName) = [ numDataIn(1:rowNaN(1)-1,i) ];
    end

end


