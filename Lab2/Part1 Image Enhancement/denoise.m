function [ imOut ] = denoise( image, kernel_type, varargin)

switch kernel_type
    case 'box'
        % box filtering requires box size parameter
        if nargin ~= 3
            error('Invalid number of parameters for box filtering')
        end
        imOut = imboxfilt(image, varargin{1});
    case 'median'
        % median filtering requires parameter 'n' if neighborhood is n-by-n
        % or parameters 'n' and 'm' if it is defined by m-by-n
        switch nargin
            case 3
                imOut = medfilt2(image, [varargin{1}, varargin{1}]);
            case 4
                imOut = medfilt2(image, [varargin{1}, varargin{2}]);
            otherwise
                error('Invalid number of parameters for median filtering') 
        end
    case 'gaussian'
        % gaussian filter requires sigma and kernel size parameters
        if nargin ~= 4
           error('Invalid number of parameters for Gaussian filtering')
        end
        imOut = imfilter(image, gauss2D(varargin{1}, varargin{2}));
end
end
