

figure 
h = imshow(record{1});
hold on
step = 10;
title('1')

nowTime = clock;
temp = num2str(nowTime(1));
for i = 2:5
    temp = strcat(temp, num2str(nowTime(i)));
end
filename = strcat(temp, '.gif');
for i = [1,step:step:numT]
    set(h, 'CData', record{i});
    drawnow;
    title(num2str(i))
    pause(0.05)
    f = getframe(gcf);
    imind = frame2im(f);
    [imind, cm] = rgb2ind(imind, 256);
    if i == 1
        imwrite(imind,cm,filename,'gif', 'Loopcount',inf,'DelayTime',0.1);
    else
        imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',0.1);
    end 
end