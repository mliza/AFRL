%{ 
   Date:    06/03/2020
   Author:  Martin E. Liza
   File:    dataParser.m
   Detail:  It parsers the data from LeMaNs output files, and
            returns the data as a structure. 

   Ex.      [ dataOutStruct ] = dataParser('fileName.plt') 

   Author              Date            Revision
   -------------------------------------------------------------------
   Martin E. Liza      06/03/2020      Initial version
   Martin E. Liza      06/18/2020      Added flags to allow output.plt 
                                       and convergence.plt to work 
   Martin E. Liza      06/20/2020      Added the helper function (dataSplit.m) 
                                       that splits the output data as matrices 

%}

function [dataOut] = dataParser(filename)
    
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

    % Remove empty strings from the header 
    if headers(1) == ""
        headers(1) = [];
    end
    if headers(end) == ""
        headers(end) = [];
    end

    %Creates a data structure using header's names
    for i = 1:columns
        headerName = headers(i); 

        % Flag that allows data with and withouth NaNs on it to be parse
        if isempty(rowNaN) == true
            dataOutStruct.(headerName) = [ numDataIn(:,i) ];
        else 
            dataOutStruct.(headerName) = [ numDataIn(1:rowNaN(1)-1,i) ];
        end 

    end

    %Call helper Function 
    [ keyMatrixX, keyMatrixY ] = dataSplit(dataOutStruct);
    [ keyMatrixRow, keyMatrixCol ] = size(keyMatrixX);

    % Split the vector data to structure data using the keyMatrix 
    for n = 1:columns 
        headerName = headers(n); 
        dataStructVec = dataOutStruct.(headerName);
        for i = 1:keyMatrixRow 
            for j = 1:keyMatrixCol
                dataOut.(headerName) = dataStructVec( keyMatrixX ); 
            end
        end
    end

end


