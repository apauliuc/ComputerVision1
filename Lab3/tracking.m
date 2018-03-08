% Using Harris Corner Detector, locate feature points and track them in
% a given sequence of images
close all; clear; clc;
image_set = 'person_toy';
save_to_gif = false;
save_file = strcat(image_set, '.gif');
h = figure;

if strcmp(image_set, 'pingpong')
    images_folder = 'pingpong';
    filePattern = fullfile(images_folder, '*.jpeg');
else
    images_folder = 'person_toy';
    filePattern = fullfile(images_folder, '*.jpg');
end

% read all files in directory that match the pattern
x = zeros(1); y = zeros(1);
images = dir(filePattern);
for k = 1 : length(images)
    baseFileName = images(k).name;
    fullFileName = fullfile(images_folder, baseFileName);
%     fprintf(1, 'Now reading %s\n', fullFileName);
    curr_img = rgb2gray(imread(fullFileName));
    
    if k == 1
        % for the first image, locate feature points
        [x, y] = tracking_locate_points(curr_img);
        
        % display initial image and feature points
        imshow(curr_img);
        hold on; % Prevent image from being blown away.
        plot(x,y,'r+', 'MarkerSize', 20);
        drawnow;
        
        prev_img = curr_img;
        
        % save frame to gif file
        if save_to_gif
            frame = getframe(h);
            im = frame2im(frame);
            [imind,cm] = rgb2ind(im,256);
            imwrite(imind, cm, save_file, 'gif', 'Loopcount', inf, 'DelayTime',0.2);
        end 
    else
        % get velocities and updated points using Lucas-Kanade algorithm
        [V, y, x] = tracking_optical_flow(prev_img, curr_img, y, x, 30);
        
        % display optical flow for current image
        imshow(curr_img);
        hold on;
        quiver(x, y, V(:,1), V(:,2), 'r');
        drawnow;
        
        prev_img = curr_img;
        
        % save frame to gif file
        if save_to_gif
            im = frame2im(getframe(h));
            [imind,cm] = rgb2ind(im,256);
            imwrite(imind, cm, save_file, 'gif', 'WriteMode', 'append', 'DelayTime',0.2);
        end
    end
end