function [ height_map ] = construct_surface( p, q, path_type )
%CONSTRUCT_SURFACE construct the surface function represented as height_map
%   p : measures value of df / dx
%   q : measures value of df / dy
%   path_type: type of path to construct height_map, either 'column',
%   'row', or 'average'
%   height_map: the reconstructed surface


if nargin == 2
    path_type = 'column';
end

[h, w] = size(p);
height_map = zeros(h, w);

switch path_type
    case 'column'
        % =================================================================
        % YOUR CODE GOES HERE
        % top left corner of height_map is zero
        % for each pixel in the left column of height_map
        %   height_value = previous_height_value + corresponding_q_value
        for row = 2:h
            height_map(row, 1) = height_map(row-1, 1) + q(row, 1);
        end
        % for each row
        %   for each element of the row except for leftmost
        %       height_value = previous_height_value + corresponding_p_value
        for col = 2:w
            height_map(:, col) = height_map(:, col-1) + p(:, col);
        end
        
        % =================================================================
        
    case 'row'
        
        % =================================================================
        % YOUR CODE GOES HERE
        for col = 2:w
            height_map(1, col) = height_map(1, col-1) + p(1, col);
        end
        
        for row = 2:h
            height_map(row, :) = height_map(row-1, :) + q(row, :);
        end
        
        
        % =================================================================
        
    case 'average'
        
        % =================================================================
        % YOUR CODE GOES HERE
        
        height_map = (construct_surface(p, q, 'column') - construct_surface(p, q, 'row')) / 2;
        
        % =================================================================
end


end

