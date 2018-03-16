close all; clear; clc;

% load pair of images
image_left = imread('left.jpg');
image_right = imread('right.jpg');

% stitch images
stitch(image_left, image_right);