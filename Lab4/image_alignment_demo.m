%%
close all; clear; clc;

image1 = imread('boat1.pgm');
image2 = imread('boat2.pgm');

if size(image1,3) > 1
    frame1 = single(rgb2gray(image1));
    frame2 = single(rgb2gray(image2));
else
    frame1 = single(image1);
    frame2 = single(image2);
end

[matches, f1, f2] = keypoint_matching(image1, image2);

%%
perm = randperm(size(matches,2));
selection = perm(1:50);
frames_image1 = transpose(f1(1:2,matches(1,selection)));
frames_image2 = transpose(f2(1:2,matches(2,selection)));
frames_image2(:,1) = frames_image2(:,1) + size(image1, 2);

imshowpair(image1, image2, 'montage');
hold on
for i = 1:size(frames_image1,1)
    x_coord = [frames_image1(i,1), frames_image2(i,1)];
    y_coord = [frames_image1(i,2), frames_image2(i,2)];
    line(x_coord, y_coord, 'color', rand(1,3), 'linewidth', 1.5);
end


%%
% perm = randperm(size(f1,2));
% sel = perm(1:50);
% figure, imshow(image1);
% h1 = vl_plotframe(f1(:,matches(1,selection)));
% h2 = vl_plotframe(f1(:,matches(1,selection)));
% h3 = vl_plotsiftdescriptor(d1(:,sel), f1(:,sel));
% set(h1, 'color', 'k', 'linewidth', 3);
% set(h2, 'color', 'y', 'linewidth', 2);
% set(h3, 'color', 'g');