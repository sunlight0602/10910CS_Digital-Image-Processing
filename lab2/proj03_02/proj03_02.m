% Proj03-01 – Histogram Equalization
% computing the histogram of an image
% implement the histogram equalization technique
% perform histogram equalization on figure

fig = Tiff('fig.tif','r');
imageData = read(fig);

figure(1);
subplot(1,2,1), imshow(imageData);
title('orig img')
subplot(1,2,2);
frequencies = computeHistogram(imageData);
title('orig histogram')

%=====================================================================

% Build PDF
img_size = size(imageData);
pdf = frequencies ./ (img_size(1)*img_size(2));

% Build CDF and table
cul_frequency = zeros(1,256);
cdf = 255*pdf;
trans_table = zeros(1,256);
for i=1:256
    if(i>1)
        cdf(i) = cdf(i) + cdf(i-1);
    else
        cdf(i) = cdf(i);
    end
    trans_table(i) = round( cdf(i) );
end

img_new = zeros(img_size(1), img_size(2));
for i = 1:img_size(1)
    for j = 1:img_size(2)
        img_new(i,j) = trans_table(imageData(i,j) + 1);
    end
end
img_new = uint8(img_new);

figure(2)
subplot(1,3,1);
stairs(cdf);
title('CDF');

subplot(1,3,2), imshow(img_new);
title('new img');

subplot(1,3,3);
frequencies = computeHistogram(img_new);
title('new histogram')

function frequencies = computeHistogram(img_orig)
    img_size = size(img_orig);
    
    values = zeros(1,256);
    
    for i=1:img_size(1)
        for j=1:img_size(2)
            values(img_orig(i,j)+1) = values(img_orig(i,j)+1) + 1;
        end
    end
    
    bar(values);
    
    frequencies = values;
end