
clear all

initialization;
method2 = 0;
clear record;

record = cell(1, numT);
u = zeros(numX + 2, numY + 2);
newoi = oi(:, :);
t1=clock;
for i = 1:1:numT

    i
    %periodicalize x
    oi(1, :) = oi(1 + numY, :);
    oi(numY + 2, :) = oi(2, :);
    %periodicalize y
    oi(:, 1) = oi(:, 1 + numX);
    oi(:, numX + 2) = oi(:, 2);
   

    tempRecordOi2 = zeros(numY + 2, numX + 2);
    tempRecordOi4 =zeros(numY + 2, numX + 2);
    tempRecordOi6 = zeros(numY + 2, numX + 2);
    tempRecordOi32 = zeros(numY + 2, numX + 2);

    deltaX = deltaX0 + i*strainR*deltaT;
    deltaY = deltaY0*deltaX0/deltaX;
    parfor j = 2:numX + 1        
        for k = 2:numY + 1                      
           tempRecordOi2(k, j)= laplaceCal(oi(k - 1: k+1,j -1 :j + 1), deltaX, deltaY, 2);  
           tempRecordOi32(k, j) = laplaceCal(oi(k - 1: k+1,j -1 :j + 1).^3, deltaX, deltaY, 2);               
        end
    end
 
    tempRecordOi2 = periodicalize(tempRecordOi2, numY + 2, numX + 2);
    tempRecordOi32 = periodicalize(tempRecordOi32, numY + 2, numX + 2);
   
    parfor j = 2:numY + 1
         for k = 2:numX + 1
            tempRecordOi4(j, k) = laplaceCal(tempRecordOi2(j -1 :j + 1, k - 1:k + 1), deltaX, deltaY, 2);
        end
    end
    tempRecordOi4 = periodicalize(tempRecordOi4, numY + 2, numX + 2);
    parfor j = 2:numY + 1
        for k = 2:numX + 1
              tempRecordOi6(j, k) = laplaceCal(tempRecordOi4(j -1: j+ 1, k -1: k + 1), deltaX, deltaY, 2);
         end
    end
    tempRecordOi6 = periodicalize(tempRecordOi6, numY + 2, numX + 2);
   
%% calculate newOi
        newOi = oi + deltaT*((1 - paraA)*tempRecordOi2 + 2*tempRecordOi4 + tempRecordOi6 + tempRecordOi32);
    
    record{i} = newOi;
    oi = newOi;
   
%     figure
    rangeOi(i, :) = getRange(oi);
%     imshow(oi,[rangeOi(1)-0.1, rangeOi(2)+0.1])
end 
t2=clock;
etime(t2,t1)
nowTime = clock;
temp = num2str(nowTime(1));
for i = 2:5
    temp = strcat(temp, num2str(nowTime(i)));
end
save(strcat(temp, '.mat'));
save(strcat(temp,'record'), 'record', '-v7.3');
paint_result
