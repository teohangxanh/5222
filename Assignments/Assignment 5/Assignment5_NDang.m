%% Read an image into the workspace
clc; clear all; close all;
image_path = 'D:\BitBucket\5222\Assignments\Assignment 5\Teppi.jpg';
img = imread(image_path);
% Return gray image if not
[rows, columns, numberOfColorChannels] = size(img);
if numberOfColorChannels > 1
  gray_image = rgb2gray(img);
  imshow(gray_image);
end
[cA, cH, cV, cD] = perform_wavelet(gray_image);
[inverse_wavelet]= inv_wavelet(cA, cH, cV, cD);
visualize_wavelet(cA, cH, cV, cD, inverse_wavelet);
subplot(1,2,1); 
[points, strongest] = detect_corner_SIFT(gray_image);
title("Before remove LL subband");
sz = size(cA);
LL = zeros(sz);

%% plot the detected corners to the wavelet reconstruction (without LL subband)  (15 points)
[inverse_wavelet2]= inv_wavelet(LL, cH, cV, cD);
subplot(1,2,2), imagesc(inverse_wavelet2), title("After remove LL subband"); hold on;
plot_corners(inverse_wavelet2, strongest);

%% Develop a function to perform the wavelet transform and inverse wavelet transform. Save the wavelet coefficients (30 points)
function [LL1, HL1, LH1, HH1]= perform_wavelet(img)
    [LL1, HL1, LH1, HH1] = dwt2(img,'haar');
end

% Perform the inverse wavelet transform
function [inverse_w]= inv_wavelet(LL1, HL1, LH1, HH1)
    inverse_w = idwt2(LL1, HL1, LH1, HH1,'haar');
end

% Perform wavelet decomposition one level.
function wImg = wavelet_reconstruction(LL1, HL1, LH1, HH1, img)
    wImg(1:size(img, 1)/2, 1:size(img,2)/2) = LL1;
    wImg(size(img, 1)/2+1:size(img, 1), 1:size(img,2)/2) = HL1;
    wImg(1:size(img, 1)/2, size(img,2)/2+1:size(img, 2)) = LH1;
    wImg(size(img, 1)/2+1:size(img, 1), size(img,2)/2+1:size(img, 2)) = HH1;
end
%% develop a function to visualize wavelet coefficient subbands and display the reconstruction using the inverse wavelet transform (10 points)
function visualize_wavelet(cA, cH, cV, cD, inverse_wavelet)
    figure();
    subplot(2,2,1)
    imagesc(cA)
    colormap gray
    title('Approximation')
    subplot(2,2,2)
    imagesc(cH)
    colormap gray
    title('Horizontal')
    subplot(2,2,3)
    imagesc(cV)
    colormap gray
    title('Vertical')
    subplot(2,2,4)
    imagesc(cD)
    colormap gray
    title('Diagonal')
    figure;
    imagesc(inverse_wavelet), colormap gray, title('Inverse Wavelet');
end

%% develop a SIFT function to detect corners in the input image (25 points)
function [points, strongest_points] = detect_corner_SIFT(img)
    points = detectHarrisFeatures(img);
    strongest_points = selectStrongest(points, 20);
    imshow(img)
    hold on
    plot(strongest_points)
end

%% Plot the detected corners to the wavelet reconstruction (without LL subband)  (15 points)
function plot_corners(Img, st)
    imagesc(log(1+abs(Img)));
    colormap gray; axis equal; axis tight; axis off;
    plot(st)
end
