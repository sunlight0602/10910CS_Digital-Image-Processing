clear;
close all;

img = imread('img.tif');
img = double(img);
% img = img / 255.0;

figure;
imagesc(img);
colormap(gray)
title('original image');

img_F = fft2(img);

figure;
imagesc(log(abs(fftshift(img_F)) + 1));
colormap(gray);
title('spectrum');

[M, N] = size(img);
s = sum(sum(abs(img_F)));
ave = s / (M * N);

disp(['Center freq. component: ', num2str(img_F(1,1)/(M*N))]);
disp(['Mean of spatial domain: ', num2str(sum(sum(img))/(M*N))]);
