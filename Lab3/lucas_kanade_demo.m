%% Lucas-Kanade algorithm on sphere images
close all; clear; clc;

fig = lucas_kanade('sphere1.ppm', 'sphere2.ppm');
saveas(fig, 'sphere_result.png');

%% Lucas-Kanade algorithm on synth images
close all; clear; clc;

fig = lucas_kanade('synth1.pgm', 'synth2.pgm');
saveas(fig, 'synth_result.png');

