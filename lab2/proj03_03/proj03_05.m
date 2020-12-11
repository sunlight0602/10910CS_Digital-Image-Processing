% Proj03-03 – Spatial Filtering
% Proj03-05 – Unsharp Masking

%(a) Implement high-boost filtering.
%The averaging part of the process should be done using the mask in Fig. 3.32(a).

%(b) Enhance it using the program you developed in (a).
%Your objective is to approximate the result in Fig. 3.40(e).


fig = Tiff('fig.tif','r');
imageData = read(fig);

mask = ones(3);
blurred = spatialFilter(imageData, mask);
subtracted = uint8(255 * mat2gray(imageData - blurred));
k = 10;
added = uint8(imageData + k*subtracted);


fig(1)
subplot(1,2,1), imshow(imageData);
title('orig img')
%subplot(1,4,2), imshow(blurred);
%subplot(1,4,3), imshow(subtracted);
subplot(1,2,2), imshow(added);
title('high boost filtering')

function img_new = spatialFilter(img_orig, mask)
    % Spatial filter with fixed size 3*3 mask
    
    [row, col] = size(img_orig);
    img_orig = double(img_orig);
    img_new = zeros(row, col);
    
    for i=2:row-1
        for j=2:col-1
            sum = 0;
            
            sum = sum + img_orig(i-1,j-1) * mask(1,1);
            sum = sum + img_orig(i-1,j) * mask(1,2);
            sum = sum + img_orig(i-1,j+1) * mask(1,3);
            sum = sum + img_orig(i,j-1) * mask(2,1);
            sum = sum + img_orig(i,j) * mask(2,2);
            sum = sum + img_orig(i,j+1) * mask(2,3);
            sum = sum + img_orig(i+1,j-1) * mask(3,1);
            sum = sum + img_orig(i+1,j) * mask(3,2);
            sum = sum + img_orig(i+1,j+1) * mask(3,3);
            
            img_new(i, j) = sum/9;
        end
    end
    img_new = uint8(img_new);
end
