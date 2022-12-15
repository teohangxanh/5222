clc; clear all; close all;
image_path = 'D:\BitBucket\5222\Assignments\Assignment 4\Goku.jpg';
%% Read one image (img1) into the workspace  
Img1 = imread(image_path);
%% Apply Fourier transform to img1 (15 points)
fImg1 = fft2(Img1);
%% Display both frequency and phase matrix as images. (15 points)
% Images will be shown at the end
% Frequency
shifted_fImg1 = fftshift(fImg1);
% Phase
phase = angle(shifted_fImg1);
%% Remove the low-frequency components from the Fourier coefficient matrix 
% and reconstruct the image (imgR) from the new Fourier coefficient matrix.
% Images will be shown at the end
% (15 points)
% Ideal high-pass filter
[f1,f2] = freqspace(size(Img1, 1), 'meshgrid');
% Radius at the center
r = sqrt(f1.^2 + f2.^2);
% Background is black
ihf = ones(size(Img1, 1));
% The central circle is white
ihf(r < 0.25) = 0;
% Copy from shifted transformed image
no_low = shifted_fImg1;
% Apply the filter
no_low = imfilter(no_low, ihf);
%% Construct and apply a spatial filter to img1 to match the reconstructed 
% image imgR (20 points)
% Images will be shown at the end
sfilter = fspecial('gaussian',3,1);
spatial_img = imfilter(Img1,sfilter,'replicate');
%% Compute and display the similarity score between the results of spatial filter and imgR (10 points)
% Images will be shown at the end
[ssimval,ssimmap] = ssim(Img1,spatial_img);
%% Displaying all images
figure(1);
subplot(321); imshow(abs(Img1),[]); title('Original');
subplot(322); imshow(log(abs(fImg1) + 1),[]); title('spectrum magnitude');
subplot(323); imshow(phase,[]); title('spectrum phase');
subplot(324); imshow(abs(ifft2(shifted_fImg1)),[]); title('reconstructed');
subplot(325); imshow(abs(ifft2(abs(shifted_fImg1))),[]); title('reconstructed magnitude only');
subplot(326); imshow(abs(ifft2(shifted_fImg1 ./ abs(shifted_fImg1))),[]); title('reconstructed phase only');
figure(2);
subplot(321);imshow(spatial_img);title("Image reconstructed after spially filtered");
subplot(322);imshow(ssimmap,[]);title("Structural similarity (SSIM) index for measuring image quality");