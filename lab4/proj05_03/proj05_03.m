% 3,4做.*的結果(5)跟想像中的不一樣，type的問題？

close all;
clear all;

img = imread('image.tif');
img = im2double(img);
figure(1);
imshow(img);
title('original img');

% generate noise spectrum
noise_img = NoiseGenerate(img, 0.5, 10, 10);
%figure;
%imshow(noise_img)
%title('noise (spatial)');

% spatial domain filtering
new_img = img + noise_img; % simple additive noise
figure(2);
imshow(new_img);
title('noised img (spatial)');

% transfer to frequency domain
pf = fft2(new_img);
figure(3);
imagesc(log(abs(fftshift(pf))+1)); % +eps
colormap(gray);
title('noised img (frequency)');

% implement notch filter
H = NotchFilter(new_img, 3, 10, 10);
figure(4);
imshow(H);
title('notch filter')

% frequency domain filtering
pf = fftshift(pf);
pfn = H .* pf;
figure(5);
imagesc(log(abs(pfn)+1));
colormap(gray);
title('after notch filter (frequency)');

% transfer to spatial domain
img_aft = ifft2(pfn);
figure(6);
%imshow(img_aft);
imagesc(abs(img_aft));
colormap(gray);
colorbar; % to see the range of image
title('after notch filter (spatial)')

% 學好一種show圖function
% plot image with correct scale (imagesc) (map to -1~1)
% imshow has a map function too


function new_img = NoiseGenerate(orig_img, A, u0, v0)
    new_img = orig_img;
    img_size = size(orig_img);
    M = img_size(2);
    N = img_size(1);
    
    for i=1:img_size(1)
        for j=1:img_size(2)
            new_img(i,j) = A * sin( 2 * pi * (u0*i/M + v0*j/N));
        end
    end
end

function new_img = NotchFilter(orig_img, D0, u0, v0) %(u0,v0) is center, D0 is radius
    img_size = size(orig_img);
    M = img_size(2);
    N = img_size(1);
    H = orig_img;
    
    for i=1:img_size(1)
        for j=1:img_size(2)
            D1 = ((i - M/2 - u0)^2 + (j - N/2 - v0)^2)^(1/2);
            D2 = ((i - M/2 + u0)^2 + (j - N/2 + v0)^2)^(1/2);
            
            if(D1<=D0)||(D2<=D0)
                H(i,j) = 0;
            else
                H(i,j) = 1;
            end
        end
    end
    
    new_img = H;
end