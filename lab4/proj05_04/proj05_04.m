% 講義那個j是什麼？虛數嗎？

close all;
clear all;

img = imread('image.tif');
img = im2double(img);

figure(1);
imshow(img);
title('original image');

% blurring filter
PSF = fspecial('motion', 60, 45);
%img1 = imfilter(img, PSF, 'conv', 'circular');
[img1, H] = LinearMotionBlur(img, 0.1, 0.1, 1);

figure(2);
imagesc(abs(img1));
colormap(gray);
title('filtered image');

figure(3);
imagesc(log(abs(H)+1));
colormap(gray);

% gaussian noise
noise_var = 0.001;
img2 = imnoise(img1, 'gaussian', 0, noise_var);
figure(4);
imshow(img2);
title('add gaussian noise');

% wiener filter
estimated_NSR = noise_var / var(img(:));
k = 0.00025;
%img3 = deconvwnr(real(img2), real(H), k);
img3 = WienerFilter(img2, H, k);
figure(5);
imagesc(log(abs(img3)+1));
colormap(gray);
title('k=0.00025');

k = 0.001;
%img3 = deconvwnr(real(img2), real(H), k);
img4 = WienerFilter(img2, H, k);
figure(6);
imagesc(log(abs(img4)+1));
colormap(gray);
title('k=0.001');

k = 0.01;
%img3 = deconvwnr(real(img2), real(H), k);
img5 = WienerFilter(img2, H, k);
figure(7);
imagesc(log(abs(img5)+1));
colormap(gray);
title('k=0.01');



function new_img = WienerFilter(orig_img, H, k)
    W = orig_img;
    img_size = size(orig_img);
    
    for u=1:img_size(1)
        for v=1:img_size(2)
            W(u,v) = 1/H(u,v) * abs(H(u,v))^2/(abs(H(u,v))^2+k);
        end
    end
    
    orig_img = fft2(orig_img);
    new_img = W .* orig_img;
    new_img = ifft2(new_img);
end

function [new_img, H] = LinearMotionBlur(orig_img, a, b, T)
    img_size = size(orig_img);
    H = orig_img;
    e = exp(1);
    
    for u = 1:img_size(1)
        for v = 1:img_size(2)
            H(u,v) = T * sin(pi*(a*(u-344)+b*(v-344)))/(pi*(a*(u-344)+b*(v-344))) * e^(-1j*pi*(a*(u-344)+b*(v-344)));
            %H(u,v) = T * sinc(a*(u-344)+b*(v-344)) * e^(-1j*pi*(a*(u-344)+b*(v-344)));
            % sinc
            % - img_size(1)/2
            % sin0/0 = 1
            %sinc(t) = sin(pi*t) / pi*t
            if isnan(H(u,v))
                H(u,v) = 1;
            end
        end
    end
    
    orig_img = fft2(orig_img);
    new_img = H .* fftshift(orig_img);
    new_img = ifft2(new_img);
end