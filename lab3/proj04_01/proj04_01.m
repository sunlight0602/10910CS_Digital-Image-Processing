clear;
close all;

a = imread('img.tif');
%a = imresize(a, 0.3);
b = im2double(a);

% (a) orig image
figure
imshow(b);
title('original image');

% (b) pad
[m,n] = size(b);
c = zeros(2*m,2*n);
[p,q] = size(c);
for i = 1:p
    for j = 1:q
        if i <= m && j<= n
            c(i,j) = b(i,j);
        else
            c(i,j) = 0;
        end
    end
end

figure;
imshow(c);
title('padded image');

% (c) with noise
d = zeros(p,q);
for i = 1:p
    for j = 1:q
        d(i,j) = c(i,j).*(-1).^(i + j);
    end
end
figure;
imshow(d);
title('with noise');

% (d) spectrum
%e = fft2(d);
e = FFT_2D(d);
figure;
imagesc(log(abs(e)+1))
colormap(gray)
title('spectrum');


% (e) transfer function of gaussian low pass filter
H = fspecial('gaussian', [p, q], 10);

figure;
imagesc(H);
colormap(gray);
%figure;imshow(H);
title('gaussian low pass filter, H');

% (f) spectrum of H.*F
h1 = H .* e;

figure;
imshow(h1);
%imagesc(log(abs(h1)+1));
%colormap(gray);
title('spectrum of H.*F');


% (g) inverse fourier tranform to spatial domain
h2 = ifft2(h1);
h3 = zeros(p,q);

for i = 1:p
    for j = 1:q
        h3(i,j) = h2(i,j).*((-1).^(i+j));
    end
end

figure;
%imshow(h3);
h3 = log(abs(h3)+1);
imagesc(h3);
colormap(gray);
title('inverse fourier tranform');

% (h) extract
out = zeros(m,n);
for i = 1:m
    for j = 1:n
        out(i,j) = h3(i,j);
    end
end

figure;
subplot(1,2,1);
%imshow(b);
imagesc(b);
colormap(gray);
title('orig image');

subplot(1,2,2);
%imshow(out);
imagesc(out);
colormap(gray);
title('output image');

function result = FFT_2D(image)
    [h, w] = size(image);
    result = zeros(size(image));
    
    % separate 2D image into two 1D FFT
    disp('FFT for rows');
    for i = 1:h
        result(i, :) = FFT_1D(image(i, :));
    end
    disp('FFT for columns');
    for i = 1:w
        result(:, i) = transpose(FFT_1D(transpose(result(:, i))));
    end
end

function result = FFT_1D(array)
    N = size(array);
    N = N(2);
    even_array = zeros(1, N/2);
    odd_array = zeros(1, N/2);
    even_dft = zeros(1, N/2);
    odd_dft = zeros(1, N/2);
    result = zeros(size(array));
    
    % split input array into even and odd parts
    for i = 1:N/2
        even_array(1, i) = array(1, 2*i-1);
        odd_array(1, i) = array(1, 2*i);
    end
    
    % 2 DFT of even and odd part
    for u = 1:N/2
        for x = 1:N/2
            even_dft(1, u)= even_dft(1, u) + (even_array(1, x) * exp(-(1j*2*pi*u*x)/(N/2)));
            odd_dft(1, u) = odd_dft(1, u) + (odd_array(1, x) * exp(-(1j*2*pi*u*x)/(N/2)));
        end
    end
    
    % bind even and odd results together
    W = exp(-(1j*2*pi)/N);
    for i = 1:N
        if(i <= N/2) % the first half of the result
            result(1, i) = even_dft(1, i) + (odd_dft(1, i) * W^(i-1));
        else % the second half of the result
            result(1, i) = even_dft(1, i-N/2) + (odd_dft(1, i-N/2) * W^(i-1));
        end
    end
end

