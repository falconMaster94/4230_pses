% 0) close everthing before
close all; clear all; hold off; clf;

% 1) board.tif
boardRGB = imread('board.tif');

% Convert RGB image to chosen color space
I = rgb2hsv(boardRGB);

% Define thresholds for channel 1 based on histogram settings
channel1Min = 0.171;
channel1Max = 0.500;

% Define thresholds for channel 2 based on histogram settings
channel2Min = 0.710;
channel2Max = 1.000;

% Define thresholds for channel 3 based on histogram settings
channel3Min = 0.000;
channel3Max = 0.481;

% Create mask based on chosen histogram thresholds
sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
BW = sliderBW;
% Initialize output masked image based on input image.
maskedRGBImage = boardRGB;

% Set background pixels where BW is false to zero.
maskedRGBImage(repmat(~BW,[1 1 3])) = maskedRGBImage(repmat(~BW,[1 1 3]))/2;

subplot(1,3,1);
imshow(boardRGB);
title('original');

subplot(1,3,2);
imshow(BW);
title('green imgs');

subplot(1,3,3);
imshow(maskedRGBImage);
title('final result');
pause();
close all;


% ================================================================

% 2) hands2.jpg
handsRGB = imread('hands2.jpg');
handsHSV = rgb2hsv(handsRGB);
handEDGE = edge(handsHSV(:,:,3), 'Canny', 0.7);

maskedRGBImage = handsRGB;
maskedRGBImage(repmat(handEDGE,[1 1 3])) = 0;

subplot(1,3,1);
imshow(handsRGB);
title('original');

subplot(1,3,2);
imshow(handEDGE);
title('Edge lines');

subplot(1,3,3);
imshow(maskedRGBImage);
title('final result');
pause();
close all;
% ===========================================================

% 3) detectSURFFeatures, pillsetc.png
pillRGB = imread('pillsetc.png');
pillHSV = rgb2hsv(pillRGB);
pillGray = pillHSV(:,:,3);
points = detectSURFFeatures(pillGray);
imshow(pillRGB); 


subplot(1,3,1);
imshow(pillRGB);
title('original');

subplot(1,3,2);
imshow(pillGray);
title('Gray');

subplot(1,3,3);
imshow(pillRGB);
hold on;
plot(points);
title('All surface descriptors');
pause();
close all;

% ===========================================================

% 4) centroids for the blue chips
% reference: https://au.mathworks.com/matlabcentral/answers/28996-centroid-of-an-image

% Convert RGB image to chosen color space
chipsRGB = imread('coloredChips.png');
I = rgb2hsv(chipsRGB);

% Define thresholds for channel 1 based on histogram settings
channel1Min = 0.600;
channel1Max = 0.636;

% Define thresholds for channel 2 based on histogram settings
channel2Min = 0.715;
channel2Max = 1.000;

% Define thresholds for channel 3 based on histogram settings
channel3Min = 0.683;
channel3Max = 1.000;

% Create mask based on chosen histogram thresholds
sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
BW = sliderBW;

% Initialize output masked image based on input image.
maskedRGBImage = chipsRGB;

% Set background pixels where BW is false to zero.
maskedRGBImage(repmat(~BW,[1 1 3])) = 0;


%{
% finding circle
% reference: https://au.mathworks.com/help/images/examples/detect-and-measure-circular-objects-in-an-image.html
[centers,radii] = imfindcircles(maskedRGBImage,[15 25],'ObjectPolarity','bright', ...
    'Sensitivity',0.95);

centersStrong5 = centers(:,:)
radiiStrong5 = radii(:)
viscircles(centersStrong5, radiiStrong5,'EdgeColor','r');
%}

% convert image to binary image
Ibw = im2bw(maskedRGBImage, 0.2);
Ibw = imfill(Ibw,'holes');
Ilabel = bwlabel(Ibw);
stat = regionprops(Ilabel,'centroid');


subplot(2,2,1);
imshow(chipsRGB);
title('Original');

subplot(2,2,2);
imshow(maskedRGBImage);
title('trimmed image');

subplot(2,2,3);
imshow(Ibw);
title('Binary image');

subplot(2,2,4);
imshow(chipsRGB);
hold on;
for x = 1: numel(stat)
    plot(stat(x).Centroid(1),stat(x).Centroid(2),'r+');
end
title('centroid image');


pause();
close all;





