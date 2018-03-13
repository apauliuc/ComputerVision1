function [matches, f1, f2] = keypoint_matching(image1,image2)
%KEYPOINT_MATCHING Get keypoint matchings between two images

% transform to grayscale and single
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

