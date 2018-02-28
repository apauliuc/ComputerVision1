%% Read img1
img = imread('images/image1_gaussian.jpg');
%% Denoising
denoised = denoise(img, 'gaussian', 2, 3);
imwrite(denoised, 'results/gaussian noise/gaussian_std_2.jpg');
% figure, imshow(denoised);
myPSNR(orig_img, imread('results/gaussian noise/gaussian_std_2.jpg'))

%% Load initial image
orig_img = imread('images/image1.jpg');

%% PSRN computation
myPSNR(orig_img, imread('results/gaussian noise/gaussian_std_2.jpg'))

%%

%% Read img2
img = imread('test\test.jpg');

%% First order gradient
% [Gx1, Gy1] = imgradientxy(img);
% [Gmag1, Gdir1] = imgradient(img);

[Gx2, Gy2, Gmag2, Gdir2] = compute_gradient(img);

% figure, imshow(Gx1, []), title('Directional gradient: X axis MATLAB')
% figure, imshow(Gy1, []), title('Directional gradient: Y axis MATLAB')
% figure, imshow(Gmag1, []), title('Gradient magnitude MATLAB')
% figure, imshow(Gdir1, []), title('Gradient direction MATLAB')
%%
figure, imshow(Gx2)%, title('Directional gradient: X axis')
figure, imshow(Gy2)%, title('Directional gradient: Y axis')
figure, imshow(Gmag2)%, title('Gradient magnitude')
figure, imshow(Gdir2)%, title('Gradient direction')

%% Second order gradient
LoG = compute_LoG(img, 2);
figure, imshow(LoG);

