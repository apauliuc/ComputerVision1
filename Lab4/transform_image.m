function transform_image(image1, image2, m1, m2, m3, m4, t1, t2, implementation)
%TRANSFORM_IMAGE Transform image1 to new image using the best
%transformation parameters computed with RANSAC
%   ...

if nargin < 9
    implementation = 'matlab';
end

if strcmp(implementation,'matlab')
    % use MATLAB functions to transform image
    new_image = imwarp(image1, affine2d([m1 -m2 0; -m3 m4 0; t1 t2 1]));
    t = 'Transformed image with MATLAB functions';
else
    % create array of all (x,y) coordinates from image1 and compute the
    % transformed coordinates
    [h,w] = size(image1);
    [C,R] = meshgrid(1:w, 1:h);
    img1_coord = [C(:)'; R(:)'];
    transf_coord = round([m1, m2; m3, m4] * img1_coord + [t1; t2]);
    % transf_coord = round(flipud([m1, m2; m3, m4] * flipud(img1_coord) + [t1; t2]));
    
    % pad transformed coordinates
    transf_coord(2,:) = transf_coord(2,:) - min(transf_coord(2,:)) + 1;
    transf_coord(1,:) = transf_coord(1,:) - min(transf_coord(1,:)) + 1;

    % compute the new height and width
    new_width = max(transf_coord(1,:)) - min(transf_coord(1,:)) + 1;
    new_height = max(transf_coord(2,:)) - min(transf_coord(2,:)) + 1;

    new_image = zeros(new_height, new_width);

    % for each (x,y) coordinate, take the pixel value from image1
    for i = 1:size(transf_coord,2)
        old_points = img1_coord(:,i);
        new_points = transf_coord(:,i);
        new_image(new_points(2), new_points(1)) = image1(old_points(2), old_points(1));
    end

    new_image = mat2gray(new_image);
    t = 'Transformed image with own implementation';
end

figure, imshow(image1), title('Initial image');
figure, imshow(image2), title('Desired output image');
figure, imshow(new_image), title(t);
end

