function [ stitched_image ] = stitch(image_left, image_right, N, P)
%STITCH creates a stitched image from an image pair
%  stitched_image = stitch(image_left, image_right)
%
%   - ARGUMENTS
%     image_left     Left image as matrix
%     image_right    Right image as matrix
%     N              Number of iterations in RANSAC
%     P              Number of points initially selected in RANSAC
%   
%   - OUTPUT
%     stitched_image  A stitched image

if nargin == 2
    N = 50;
    P = 3;
end

% get keypoint matchings between two images
[matches, feat_right, feat_left] = keypoint_matching(image_right, image_left);

% perform RANSAC algorithm to get best transformation
[m1, m2, m3, m4, t1, t2] = RANSAC(feat_right, feat_left, matches, N, P);
T = maketform('affine', [m1 -m2 0; -m3 m4 0; t1 t2 1]);

% transform right image using transformation found by RANSAC
transformed_image = imtransform(image_right, T);

% Compute image sizes
[h_right, w_right, ~] = size(image_right);
[h_left, w_left, ~] = size(image_left);
[h_tr, w_tr, ~] = size(transformed_image);

% Compute the transformed coordinate of the lower right corner
coords = [1 1 w_right w_right; 1 h_right 1 h_right];
end_coord = num2cell(max(round([m1 m2; m3 m4]*coords + [t1; t2]), [], 2));
[x_end, y_end] = end_coord{:};

% Compute size of stitched image
w_canvas = max([x_end w_left]);
h_canvas = max([y_end h_left]);

% Define black canvases
new_right=uint8(zeros(h_canvas,w_canvas,3));
new_left=uint8(zeros(h_canvas,w_canvas,3));

% Place left and right images in the two canvases
new_left(1:h_left,1:w_left,:) = image_left;
new_right((y_end-h_tr+1):y_end,(x_end-w_tr+1):x_end,:) = transformed_image;

% Combine the two canvases to create the stitched image
stitched_image = imadd(imsubtract(new_left,new_right),new_right);

% Visualize the stitched image alongside with the orignal images
figure, imshow(image_left), title('left image')
figure, imshow(image_right), title('right image')
figure, imshow(stitched_image), title('stitched image')
end