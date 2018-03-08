function [V, points_x, points_y] = tracking_optical_flow(img1, img2, points_x, points_y, window_size)
%TRACKING_OPTICAL_FLOW Apply Lucas-Kanade method to track the interest
%points with coordinates (x,y)
half = round(window_size/2);
pad = half - 1;

% compute partial derivatives in x, y, and t directions
Ix_full = conv2(img1, [-1 1; -1 1], 'same');
Iy_full = conv2(img1, [-1 -1; 1 1], 'same');
It_full = conv2(img1, ones(2), 'same') + conv2(img2, -ones(2), 'same');

V = zeros(size(points_x, 1), 2);

% for each region, take the Ix, Iy and It, compute A, At, b and Vx and Vy
for idx = 1:size(points_x, 1)
    x = round(points_x(idx));
    y = round(points_y(idx));
    
    lower_x = max(x-pad, 1);
    upper_x = min(x+pad, size(img1, 1));
    
    lower_y = max(y-pad, 1);
    upper_y = min(y+pad, size(img1, 2));
    
    % slice matrices to get values for pixels in region
    Ix = Ix_full(lower_x:upper_x, lower_y:upper_y);
    Iy = Iy_full(lower_x:upper_x, lower_y:upper_y);
    It = It_full(lower_x:upper_x, lower_y:upper_y);

    % compute A, At, b
    Ix = Ix(:);
    Iy = Iy(:);
    b = -It(:);
    A = [Ix Iy];

    % compute V = (Vx, Vy) and place in matrix
    v_at_point = pinv(A) * b;

    V(idx, :) = reshape(v_at_point, 1, 2);
    points_x(idx) = points_x(idx) + v_at_point(2);
    points_y(idx) = points_y(idx) + v_at_point(1);
end
end

