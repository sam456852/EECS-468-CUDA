
clear all



initialization;
method2 = 0;
clear record;

record = cell(1, numT);
u = zeros(numX + 2, numY + 2);
newoi = oi(:, :);
for i = 1:1:numT
   
 %   i
 %periodicalize x
    oi(1, :) = oi(1 + numY, :);
    oi(numY + 2, :) = oi(2, :);
    %periodicalize y
    oi(:, 1) = oi(:, 1 + numX);
    oi(:, numX + 2) = oi(:, 2);
   
    if optionOi
    tempRecordOi2 = zeros(numY + 2, numX + 2);
    tempRecordOi4 =zeros(numY + 2, numX + 2);
    tempRecordOi6 = zeros(numY + 2, numX + 2);
    tempRecordOi32 = zeros(numY + 2, numX + 2);
    end
   
    deltaX = deltaX0 + i*strainR*deltaT;
    deltaY = deltaY0*deltaX0/deltaX;
    for j = 2:numX + 1
        
        for k = 2:numY + 1

            foi = oi(k - 1: k+1,j -1 :j + 1);               
            tempOi2= laplaceCal(foi, deltaX, deltaY, 2);  
            tempOi32 = laplaceCal(foi.^3, deltaX, deltaY, 2); 
            if method2        
                tempOi4 = laplaceCal(foi, deltaX, deltaY, 4);
                tempOi6 = laplaceCal(foi, deltaX, deltaY, 6);
            end
            
            if optionOi
            tempRecordOi2(k, j) = tempOi2;
            tempRecordOi32(k, j) = tempOi32;
                if method2
                tempRecordOi4(k, j) = tempOi4;
                tempRecordOi6(k, j) = tempOi6;            
                u(j, k) = tempOi32 + tempOi6 + 2*tempOi4 + (1-paraA)*tempOi2;%inside of the laplace
                end;
            end
        end

    end
    if method2
        newOi = oi + deltaT*u;
    end

    tempRecordOi2 = periodicalize(tempRecordOi2, numY + 2, numX + 2);
        tempRecordOi32 = periodicalize(tempRecordOi32, numY + 2, numX + 2);
    if method2 == 0
        for j = 2:numY + 1
            for k = 2:numX + 1
                foi2 = tempRecordOi2(j -1 :j + 1, k - 1:k + 1);
                tempOi4 = laplaceCal(foi2, deltaX, deltaY, 2);
                tempRecordOi4(j, k) = tempOi4;
            end
        end
        tempRecordOi4 = periodicalize(tempRecordOi4, numY + 2, numX + 2);
        for j = 2:numY + 1
            for k = 2:numX + 1
                foi4 = tempRecordOi4(j -1: j+ 1, k -1: k + 1);
                tempOi6 = laplaceCal(foi4, deltaX, deltaY, 2);
                tempRecordOi6(j, k) = tempOi6;
            end
        end
        tempRecordOi6 = periodicalize(tempRecordOi6, numY + 2, numX + 2);
   

%% calculate new oi
        newOi = oi + deltaT*((1 - paraA)*tempRecordOi2 + 2*tempRecordOi4 + tempRecordOi6 + tempRecordOi32);
    end
    record{i} = newOi;
    oi = newOi;
    
     %figure
    rangeOi(i, :) = getRange(oi);
     %imshow(oi,[rangeOi(1)-0.1, rangeOi(2)+0.1])
end 
nowTime = clock;
temp = num2str(nowTime(1));
for i = 2:5
    temp = strcat(temp, num2str(nowTime(i)));
end
save(strcat(temp, '.mat'));
save(strcat(temp,'record'), 'record', '-v7.3');
paint_result
