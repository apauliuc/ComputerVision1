%% Sphere images
image1 = imread('sphere1.ppm');
image2 = imread('sphere2.ppm');

lucas_kanade(image1, image2);

%% Synth images
image1 = imread('synth1.pgm');
image2 = imread('synth2.pgm');

lucas_kanade(image1, image2);