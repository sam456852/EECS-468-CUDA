
% selectSet = [8:2:16;7.5e-3, 2e-3, 7e-4, 2.5e-4, 1e-4];
% chooseSelect = 1;
% n = selectSet(1, chooseSelect);
% 
% deltaT = selectSet(2, chooseSelect);
%%  
% strainR = 1e-5;
clear all
% strainR = 0;
paraA = 0.35;

% numA = 18;
oi0 = 0.3;
qh = sqrt(3)/2;
optionOi = 1;
%% 2D initialization 

areaX = 100;
areaY = 100;
numT = 200;
deltaX0 = pi/4;
deltaY0 = pi/4;
nucleusR = 11;
% upDeltaT = deltaX0^6/8;
% deltaT = upDeltaT/4;
deltaT = 0.0075
strainR = 1e-5/deltaT;

totalT = numT*deltaT;
numX = round(areaX/deltaX0);
numY = round(areaY/deltaY0);
oi = oi0*ones(numX + 2, numY + 2 );
%oi initialization

axisX = repmat(deltaX0*([1:numX+2] - round(numX/2)), numY + 2, 1) ;
axisY = repmat(deltaY0*([numY + 2 :-1: 1]' - round(numY/2)),1, numX + 2);
temp = axisX.^2 + axisY.^2 ;
chooseX = (temp)<= nucleusR^2;%
% figure
% imshow(chooseX)


At = -4/5*(oi0 + 1*sqrt(5/3*paraA - 4*oi0^2));
axisX = axisX.*cos(15/180*pi) + axisY.*sin(15/180*pi);
axisY = -axisX.*sin(15/180*pi) + axisY.*cos(15/180*pi);

nucleusOi = At*(cos(qh.*axisX).*cos(1/sqrt(3)*qh.*axisY) + 1/2*cos(2/sqrt(3)*qh.*axisY));
% nucleusOi =  At*(cos(qh.*axisX)*cos(qh.*axisY./sqrt(3)) + cos(2*qh.*axisY/sqrt(3)*2));
oi = oi + chooseX.*nucleusOi;

rangeOi = zeros(numT, 2);
rangeOi(1, :) = getRange(oi);
%% 
figure
imshow(oi,[rangeOi(1)-0.1, rangeOi(2)+0.1])