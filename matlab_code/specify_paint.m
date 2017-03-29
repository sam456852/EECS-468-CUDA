%% 指定画出几个时刻的。
%% 事先人为载入record 文件
close all
recordStep = 1;
pick = [recordStep,1000,1500,2000,2500,3000,5000]/recordStep;
% strainR = 0;
lb = floor(10*min(min(rangeOi)))/10;
rb = ceil(10*max(max(rangeOi)))/10;
for i = 1:length(pick)
    figure
    imshow(record{pick(i)}, [lb, rb]);
    title(strcat(num2str(pick(i)*recordStep), ' strain rate  ', num2str(strainR)));
end