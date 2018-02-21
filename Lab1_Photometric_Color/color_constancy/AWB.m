clear; close; clc;

img = imread('awb.jpg');
figure, imshow(img), title('Origional Image')

[m,n,~]=size(img);
mean_R = sum(sum(img(:,:,1)))/(m*n);
mean_G = sum(sum(img(:,:,2)))/(m*n);
mean_B = sum(sum(img(:,:,3)))/(m*n);

correction_R = 128/mean_R;
correction_G = 128/mean_G;
correction_B = 128/mean_B;

img(:,:,1) = correction_R*img(:,:,1);
img(:,:,2) = correction_G*img(:,:,2);
img(:,:,3) = correction_B*img(:,:,3);

figure, imshow(img), title('White-Balanced Image Using Gray World')

imwrite(img,'generated_images/white_balanced.png')