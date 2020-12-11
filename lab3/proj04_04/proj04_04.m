clear;
close all;

img = imread('img.tif');
img = double(img);
img = img / 255.0;
figure;
subplot(1,3,1);
imagesc(img);
colormap(gray);
title('orig');

D = [60,160];
idx = 2;

for i=1:2
    D0 = D(i);
    H = LowPassFilter(688,688,D0);
    H = 1-H;
    % figure;
    % imagesc(H);
    % colormap(gray);
    % title('H, Low pass filter');

    img_F = fft2(img);
    img_F = fftshift(img_F);
    F = H .* img_F;
    % figure;
    % imagesc(log(abs(F) + 1));
    % colormap(gray);
    % title('H.*F, spectrum');

    img_reconstruct = abs(ifft2(F));
    subplot(1,3,idx);
    imagesc(img_reconstruct);
    colormap(gray);
    title('filtered image, ', D0);
    idx = idx+1;
end

function H = LowPassFilter(M, N, D0)

    H = zeros(M, N);
    
    center_y = floor(N/2);
    center_x = floor(M/2);
    for i = 1:M
        for j = 1:N
            D2 = (center_y - i)^2 + (center_x -j)^2;
            H(i,j) = exp(-D2 / 2 / D0^2);
        end
    end

end
