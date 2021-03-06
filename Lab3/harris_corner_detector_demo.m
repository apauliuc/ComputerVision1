%% Harris Corner Detector on pingpong/00000001.jpg image
close all; clear; clc;
harris_corner_detector('pingpong/0000.jpeg', 2, 35000, 10, false);

%% Harris Corner Detector on person_toy/00000001.jpg image without rotation
harris_corner_detector('person_toy/00000001.jpg', 3, 16000, 14, false);

%% Harris Corner Detector on person_toy/00000001.jpg image with rotation
harris_corner_detector('person_toy/00000001.jpg', 3, 16000, 14, true);