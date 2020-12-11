% Proj03-01 – Image Enhancement Using Intensity Transformations
% log transformation
% power-law transformation

fig = Tiff('fig.tif','r');
imageData = read(fig);

c = 1;
img_new = logTransformation(imageData, c);

figure(1);
subplot(1,2,1), imshow(imageData);
title('orig');
subplot(1,2,2), imshow(img_new);
title('log transformation, c=1');

%==============================================================

c = 1;
pow = 0.1;
img_new_1 = powerLawTransformation(imageData, c, pow);

pow = 0.3;
img_new_2 = powerLawTransformation(imageData, c, pow);

pow = 0.4;
img_new_3 = powerLawTransformation(imageData, c, pow);

pow = 0.6;
img_new_4 = powerLawTransformation(imageData, c, pow);

pow = 0.8;
img_new_5 = powerLawTransformation(imageData, c, pow);

figure(2);
subplot(2,3,1), imshow(imageData);
title('orig');
subplot(2,3,2), imshow(img_new_1);
title('power-law, pow=0.1');
subplot(2,3,3), imshow(img_new_2);
title('power-law, pow=0.3');
subplot(2,3,4), imshow(img_new_3);
title('power-law, pow=0.4');
subplot(2,3,5), imshow(img_new_4);
title('power-law, pow=0.6');
subplot(2,3,6), imshow(img_new_5);
title('power-law, pow=0.8');

function img_new = logTransformation(img_orig, c)
    img_new = c * log(1+double(img_orig));
    img_new = uint8(255 * mat2gray(img_new));
end

function img_new = powerLawTransformation(img_orig, c, pow)
    img_new = c * double(img_orig).^pow;
    img_new = uint8(255 * mat2gray(img_new));
end