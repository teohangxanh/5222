%% Read the image into the workspace and display the image
image_path = 'image.jpg';
img = rgb2gray(imread(image_path));
imshow(img)
%% Add Gaussian random noise to the image, and display both the original and the distorted images
noisy_img = imnoise(img,'gaussian', 0.01);
subplot(1,2,1);imshow(img);title('Original')
subplot(1,2,2);imshow(noisy_img);title('Noisy')
%% Remove noise and display the result image
denoised_img = wiener2(noisy_img,[3, 3]);
figure('Name','Denoised image');
imshow(denoised_img)
%% apply Sobel and Canny edge detector to the original image to extract edges and display the results.
threshold_1 = 0.2;
detected_1 = edge(img,'sobel', threshold_1);
detected_2 = edge(img,'canny', threshold_1);
figure('Name',sprintf('Sobel with threshold of %.2f', threshold_1));imshow(detected_1)
figure('Name',sprintf('Canny with threshold of %.2f', threshold_1));imshow(detected_2)
%% repeat the above step using two different thresholds for each method. 
threshold_2 = 0.4;
detected_3 = edge(img,'sobel', threshold_2);
detected_4 = edge(img,'canny', threshold_2);
figure('Name',sprintf('Sobel with threshold of %.2f', threshold_2));imshow(detected_3)
figure('Name',sprintf('Canny with threshold of %.2f', threshold_2));imshow(detected_4)

threshold_3 = 0.6;
detected_5 = edge(img,'sobel', threshold_3);
detected_6 = edge(img,'canny', threshold_3);
figure('Name',sprintf('Sobel with threshold of %.2f', threshold_3));imshow(detected_5)
figure('Name',sprintf('Canny with threshold of %.2f', threshold_3));imshow(detected_6)
%% resize the original image by a factor of 0.75, 0.5, 0.25, and repeat the edge detection using Sobel and Canny edge detector. Display the results
for k=1:3
    scale = (4 - k)*0.25;
    resized_img = imresize(img, scale);
    sobel = edge(resized_img, 'sobel');
    canny = edge(resized_img, 'canny');
    figure('Name',sprintf('Sobel %.2f of original size', scale));imshow(sobel)
    figure('Name',sprintf('Canny %.2f of original size', scale));imshow(canny)
    % Save the images to file
    imwrite(sobel, sprintf('./Sobel of %.2f original size.png', scale));
    imwrite(sobel, sprintf('./Canny %.2f of original size.png', scale));
end
