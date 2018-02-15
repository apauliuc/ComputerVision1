function visualize(input_image)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Visualises the given image, together with the individual
% channels which compose it.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[~, ~, no_channels] = size(input_image);
figure

if no_channels == 4
    % Display each grayscale method separately
    titles = ["Lightness method" "Average method" "Luminosity method" "MATLAB function"];
    for channel = 1:no_channels
        subplot(2, 2, channel);
        imshow(input_image(:, :, channel));
        title(titles(channel));
    end
elseif no_channels == 3
    % Display the resulting image and the 3 channels separately
    subplot(2, 2, 1);
    imshow(input_image);
    title("New image");
    
    subplot(2, 2, 2);
    imshow(input_image(:, :, 1));
    title("Channel 1");
    
    subplot(2, 2, 3);
    imshow(input_image(:, :, 2));
    title("Channel 2");
    
    subplot(2, 2, 4);
    imshow(input_image(:, :, 3));
    title("Channel 3");
end
    

end

