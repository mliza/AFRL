function [dataOutStruct] = dataParser(filename)
    
    inFile = importdata(filename);
    numDataIn = inFile.data; 
    [rows, columns] = size(numDataIn);

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

    [rowNaN colNaN] = find(isnan(inFile.data(:,6))); %find col where NaN starts 

    %Creates a data structure using header's names
    for i = 1:columns
        headerName = headers(i); 
        dataOutStruct.(headerName) = [ numDataIn(1:rowNaN(1)-1,i) ];
    end

end


