
%imshow(A)

%imdisp(A)

%{
a. Segment the visible green circuit board in the ‘board.tif’
 image using colour segmentation and display it                
in green with the remainder of the image shown in grayscale with 50%
 intensity (2 points). 
Hint:  imread?, double, imdisp, imerode, imclose, imopen, imdilate ?
are useful functions to          
get you started and you may need to use ?repmat ?to convert 
a binary image to (m x n x 3) format. 
%}

% 0) close everthing before
close all; clear all; clf;

% 1) converting into L*a*b*
boardRGB = imread('board.tif');
boardLAB = rgb2lab(boardRGB);

ab = boardLAB(:,:,2:3);
nrows = size(ab,1);
ncols = size(ab,2);
ab = reshape(ab,nrows*ncols,2);

nColors = 3;

[cluster_idx, cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean', ...
                                      'Replicates',3);

                                  
pixel_labels = reshape(cluster_idx,nrows,ncols);
imshow(pixel_labels,[]), title('image labeled by cluster index');

pause();

segmented_images = cell(1,3);
rgb_label = repmat(pixel_labels,[1 1 3]);

for k = 1:nColors
    color = boardRGB;
    color(rgb_label ~= k) = 0;
    segmented_images{k} = color;
end

subplot(1,3,1);
imshow(segmented_images{1}), title('objects in cluster 1');
subplot(1,3,2);
imshow(segmented_images{2}), title('objects in cluster 2');
subplot(1,3,3);
imshow(segmented_images{3}), title('objects in cluster 3');
%{
following codes are to test imerode
se = strel('line',11,90);
B= imerode(A, se);
%}

%{
subplot(1,2,1);
imshow(boardRGB);
subplot(1,2,2);
imshow(boardLAB);
%}