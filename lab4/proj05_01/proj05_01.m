close all;
clear all;

img = imread('image.tif');
img = im2double(img);

figure(1);
%subplot(1,3,1);
imshow(img);
%title('original image');

% Gaussian noise
figure(2);
img_nse1 = GaussianNoise(img, 0.2, 0.01);
%subplot(1,3,2);
imshow(img_nse1);
%title('Gaussian noise, mean=0.2, variance=0.01');

% Salt-and-Pepper noise
figure(3);
img_nse3 = SaltPepper(img, 0.4, 0.1);
%subplot(1,3,3);
imshow(img_nse3);
%title('Salt&Pepper noise, ps=0.3, pp=0.1');



function new_img = GaussianNoise(orig_img, mean, variance)
    sizeA = size(orig_img);
    new_img = orig_img + sqrt(variance) * randn(sizeA) + mean;
end

function new_img = SaltPepper(orig_img, ps, pp)
    new_img = orig_img;
    size_ = size(orig_img);
    %x = rand(sizeA);
    
    probability = ones(1,100);
    for i=1:100*ps
        probability(i) = 255;
    end
    for j=i:i+100*pp
        probability(i) = 0;
    end
    
    for i=1:size_(1)
        for j=1:size_(2)
            idx = randperm(100,1);
            if(probability(idx) ~= 1)
                new_img(i,j) = probability(idx);
            end
        end
    end
    
end