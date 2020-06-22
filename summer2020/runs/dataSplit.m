%{ 
   Date:    06/20/2020
   Author:  Martin E. Liza
   File:    dataSplit.m
   Detail:  It parsers the data from LeMaNs output files, as a 
            matrix instead of vectos  

   Ex.      [ dataOut ] = dataSplit('fileName.plt') 

   Author              Date            Revision
   -------------------------------------------------------------------
   Martin E. Liza      06/20/2020      Initial version

%}


function [ keyMatrixIndxX, keyMatrixIndxY ] = dataSplit(dataStruct)
    dataIn = dataStruct;

    % Find the indices where, yAxis=0 and xAxis=0
    [ rowIndxX0 ] = find( dataIn.Y == min(dataIn.Y) ); 
    [ colIndxY0 ] = find( dataIn.X == min(dataIn.X) ); 

    % Find the Y grid size, to truncate the data where all elements have the same length  
    for i = 1:length(colIndxY0) 
        yLimVec(i) = length( find( dataIn.Y == dataIn.Y(colIndxY0(i)) ) );
        yGridLim = min(yLimVec);
    end

    % Find the X grid size, to truncate the data where all elements have the same length  
    for i = 1:length(rowIndxX0) 
        xLimVec(i) = length( find( dataIn.X == dataIn.X(rowIndxX0(i)) ) );
        xGridLim = min(xLimVec); 
    end

    % Creates the index combination to re arrange the data on Y 
    for i = 1:xLimVec
        lookUpYindx(i) = dataIn.Y(colIndxY0(i));
        keyVector = find( dataIn.Y == lookUpYindx(i) );  
        keyMatrixIndxY(i,:) = keyVector(1:yGridLim); 
    end


    % Creates the index combination to re arrange the data on Y 
    for i = 1:yLimVec
        lookUpXindx(i) = dataIn.X(rowIndxX0(i));
        keyVector = find( dataIn.X == lookUpXindx(i) );  
        keyMatrixIndxX(:,i) = keyVector(1:xGridLim); 
    end
    %Flip the first column with second  
    temp = keyMatrixIndxX(:,1);
    keyMatrixIndxX(:,1) = keyMatrixIndxX(:,2); 
    keyMatrixIndxX(:,2) = temp; 

    %Flip the first column with second  
    temp = keyMatrixIndxX(2,1);
    keyMatrixIndxX(2,1) = keyMatrixIndxX(1,1); 
    keyMatrixIndxX(1,1) = temp; 
end
