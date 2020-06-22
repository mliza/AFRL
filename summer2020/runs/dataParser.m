%{ 
   Date:    06/22/2020
   Author:  Martin E. Liza
   File:    dataParser.m
   Detail:  Parsers the data from LeMaNs output files, and
            returns the data as a structure of matrices. Uses the 
            helper sript, dataSplit.m.

   Ex.      [ dataOutStruct ] = dataParser('fileName.plt') 

   Author              Date            Revision
   -------------------------------------------------------------------
   Martin E. Liza      06/03/2020      Initial version
   Martin E. Liza      06/18/2020      Added flags to allow output.plt 
                                       and convergence.plt to work 
   Martin E. Liza      06/20/2020      Added the helper function (dataSplit.m) 
%}

function [dataOut] = dataParser(filename)
    
    inFile = importdata(filename);
    numDataIn = inFile.data; 
    [rows, columns] = size(numDataIn);
    [rowNaN colNaN] = find(isnan(inFile.data(:,columns))); %find col where NaN starts 

    % Clean out input data header 
    % Removes the words VARIABLES and = from data file 
    headersIn = erase( convertCharsToStrings(inFile.textdata{1}), "VARIABLES" ); 
    headersIn = erase( headersIn, "=" );
    % Removes the double quotes 
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

    % Calls helper function 
    [ keyMatrixX, keyMatrixY ] = dataSplit(dataOutStruct);
    [ keyMatrixRow, keyMatrixCol ] = size(keyMatrixX);

    % Rearrange the vector structure to a matrix structure 
    % using keyMatrix from the helper Function  
    for n = 1:columns 
        headerName = headers(n); 
        dataStructVec = dataOutStruct.(headerName);
        for i = 1:keyMatrixRow 
            for j = 1:keyMatrixCol
                dataOut.(headerName) = dataStructVec( keyMatrixX ); 
            end
        end
    end

end % end function dataParser()


