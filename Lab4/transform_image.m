function new_image = transform_image(image1, m1, m2, m3, m4, t1, t2, implementation)
%TRANSFORM_IMAGE Transform image1 to new image using the best
%transformation parameters computed with RANSAC
%   new_image = transform_image(image1, m1, m2, m3, m4, t1, t2, implementation)
%   - ARGUMENTS
%       image1                  First image as matrix
%       [m1,m2,m3,m4,t1,t2]     Best transformation parameters from RANSAC
%       implementation          Type of implementation (matlab or own)
%
%   - OUTPUT
%       new_image               Image1 transformed using given parameters

if nargin == 7
    implementation = 'matlab';
end

if strcmp(implementation,'matlab')
    % use MATLAB functions to transform image
    new_image = imwarp(image1, affine2d([m1 -m2 0; -m3 m4 0; t1 t2 1]));
else
    % create array of all (x,y) coordinates from image1 and compute the
    % transformed coordinates using the given parameters
    [h,w] = size(image1);
    [C,R] = meshgrid(1:w, 1:h);
    img1_coord = [C(:)'; R(:)'];
    transf_coord = round([m1, m2; m3, m4] * img1_coord + [t1; t2]);
    
    % pad transformed coordinates to take into account rotation into the
    % negative side of (x,y)-axis.
    transf_coord(2,:) = transf_coord(2,:) - min(transf_coord(2,:)) + 1;
    transf_coord(1,:) = transf_coord(1,:) - min(transf_coord(1,:)) + 1;

    % compute height and width of the new image
    new_width = max(transf_coord(1,:)) - min(transf_coord(1,:)) + 1;
    new_height = max(transf_coord(2,:)) - min(transf_coord(2,:)) + 1;

    new_image = zeros(new_height, new_width);

    % for each (x,y) coordinate, take the pixel value from image1
    for i = 1:size(transf_coord,2)
        old_points = img1_coord(:,i);
        new_points = transf_coord(:,i);
        new_image(new_points(2), new_points(1)) = image1(old_points(2), old_points(1));
    end
    
    % transform image to grayscale
    new_image = mat2gray(new_image);
    
    % iterate over the new image to apply neighbour interpolation by
    % filling in the black pixels with the median in 3x3 window
    [h, w] = size(new_image);
    for i = 2:(h-1)
        for j = 2:(w-1)
            if new_image(i,j) == 0
                window = new_image(i-1:i+1,j-1:j+1);
                new_image(i,j) = median(window(:));            
            end
        end
    end
end
end

