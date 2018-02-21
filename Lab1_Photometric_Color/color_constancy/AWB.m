clear; close; clc;

% load the original image
img = imread('awb.jpg');

% show the original image
figure, imshow(img), title('Origional Image')

% determine the height and width
[m,n,~]=size(img);

% calculate the mean of the three channels
mean_R = sum(sum(img(:,:,1)))/(m*n);
mean_G = sum(sum(img(:,:,2)))/(m*n);
mean_B = sum(sum(img(:,:,3)))/(m*n);

% calculate the correction needed using the grey world assumption
correction_R = 128/mean_R;
correction_G = 128/mean_G;
correction_B = 128/mean_B;

% recalculate the three channels using the correction
img(:,:,1) = correction_R*img(:,:,1);
img(:,:,2) = correction_G*img(:,:,2);
img(:,:,3) = correction_B*img(:,:,3);

% show the white balanced image
figure, imshow(img), title('White-Balanced Image Using Grey World')

% save the white balanced image
imwrite(img,'generated_images/white_balanced.png')