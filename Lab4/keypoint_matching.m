function [matches, f1, f2] = keypoint_matching(image1,image2)
%KEYPOINT_MATCHING Get keypoint matchings between two images
%   Use David Lowe's SIFT to get keypoints in 2 images and get the
%   matchings between them
%   - ARGUMENTS
%       image1      First image as matrix (taken as reference point)
%       image2      Second image as matrix
%
%   - OUTPUT
%       matches     Array of matched features between image1 and image2
%       f1          Array of found features in image1
%       f2          Array of found features in image2

% transform to single, and grayscale if needed
if size(image1,3) > 1
    image1 = single(rgb2gray(image1));
    image2 = single(rgb2gray(image2));
else
    image1 = single(image1);
    image2 = single(image2);
end

% get frames and descriptors
[f1, d1] = vl_sift(image1);
[f2, d2] = vl_sift(image2);

% perform keypoint matching
[matches, ~] = vl_ubcmatch(d1, d2);
end

