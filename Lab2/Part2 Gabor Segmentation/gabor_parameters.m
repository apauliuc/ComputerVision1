close all; clear; clc;

count = 0;
for i = [0.1 0.5:0.5:1.5 2.5 4:2:8]
    figure(1)
    count = count + 1;
    subplot(2,4,count)
    gabor = createGabor(i,0,3.5,0,0.8);
    imshow(gabor(:,:,1), []);
    title(['sigma =  ' num2str(i)])
end

count = 0;
for i = 0:pi/8:pi/2
    figure(2)
    count = count + 1;
    subplot(1,5,count)
    gabor = createGabor(4,i,3.5,0,0.8);
    imshow(gabor(:,:,1), []);
    if count == 1
        title('theta = 0')
    elseif count == 2
        title('theta = \pi/8')
    elseif count == 3
        title('theta = \pi/4')
    elseif count == 4
        title('theta = (\pi*3)/8')
    else
        title('theta = \pi/2')
    end
        
end

count = 0;
for i = [0.1 0.25:0.25:1]
    figure(3)
    count = count + 1;
    subplot(1,5,count)
    gabor = createGabor(4,0,3.5,0,i);
    imshow(gabor(:,:,1), []);
    title(['gamma = ' num2str(i)])
end