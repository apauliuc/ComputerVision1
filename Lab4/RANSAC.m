function [bm1, bm2, bm3, bm4, bt1, bt2] = RANSAC(features_image1, features_image2, matches, N, P)
%RANSAC Perform RANSAC algorithm to get best transformation
%   ...

best_count_inliers = 0;

% get approximation on first P random points
for repeat = 1:N
    % generate random order of points and index them
    perm = randperm(size(matches,2));    
%     points_image1 = features_image1(2:-1:1,matches(1,perm));
%     points_image2 = features_image2(2:-1:1,matches(2,perm));
    
    points_image1 = features_image1(1:2,matches(1,perm));
    points_image2 = features_image2(1:2,matches(2,perm));
    
    % get trasnformation parameters
    x = compute_transformation_params(points_image1(:,1:P), points_image2(:,1:P));
    [m1, m2, m3, m4, t1, t2] = x{:};  
    
    % transform points in first image and count inliers
    transformed_points = [m1, m2; m3, m4] * points_image1 + [t1; t2];
    [count_inliers, inliers_set] = detect_count_inliers(transformed_points, points_image2);
    
    % if count is the best, save parameters and inliers
    if count_inliers > best_count_inliers
        best_count_inliers = count_inliers;
        inliers_image1 = points_image1(:,inliers_set);
        inliers_image2 = points_image2(:,inliers_set);
    end
end

% Use this if we want to perform least squares on all inliers
x = compute_transformation_params(inliers_image1, inliers_image2);
[bm1, bm2, bm3, bm4, bt1, bt2] = x{:};

end

function [x] = compute_transformation_params(points_first_img, points_second_img)
% get A and b matrices
no_points = size(points_first_img,2);
A = zeros(2*no_points, 6);
b = zeros(2*no_points, 1);
for i = 1:no_points
    A(i*2-1,:)      = [points_first_img(:,i)', 0, 0, 1, 0];
    A(i*2,:)        = [0, 0, points_first_img(:,i)', 0, 1];
    b(i*2-1:i*2,1)  = points_second_img(:,i);
end

% compute transformation parameters
x = num2cell(pinv(A)*b);
end

function [count, inliers_set] = detect_count_inliers(new_points, old_points)
% count number of inliers that are not further away than 10 pixels
count = 0;
inliers_set = [];
for i = 1:size(new_points,2)
    coord = [old_points(:,i)'; new_points(:,i)'];
    if pdist(coord, 'euclidean') < 10
        count = count + 1;
        inliers_set = [inliers_set, i]; %#ok<AGROW>
    end
end

end

