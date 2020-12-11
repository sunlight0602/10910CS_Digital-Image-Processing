t = Tiff('fig1.tif','r'); % declare tiff object
imageData = read(t); % read image

img_1 = reduceIntensity(imageData,1);
img_2 = reduceIntensity(imageData,2);
img_3 = reduceIntensity(imageData,3);
img_4 = reduceIntensity(imageData,4);
img_5 = reduceIntensity(imageData,5);
img_6 = reduceIntensity(imageData,6);
img_7 = reduceIntensity(imageData,7);
img_8 = reduceIntensity(imageData,8);

figure(1);
subplot(2,4,1), imshow(img_1);
title('2^1');
subplot(2,4,2), imshow(img_2);
title('2^2');
subplot(2,4,3), imshow(img_3);
title('2^3');
subplot(2,4,4), imshow(img_4);
title('2^4');
subplot(2,4,5), imshow(img_5);
title('2^5');
subplot(2,4,6), imshow(img_6);
title('2^6');
subplot(2,4,7), imshow(img_7);
title('2^7');
subplot(2,4,8), imshow(img_8);
title('2^8');

function img_new = reduceIntensity( img_orig, level )

    level = 2^level;
    imagesize = size(img_orig);
    num = 256 / level; % 256/8=32, 8個分區, 一個分區32格

    img_new = uint8( zeros(imagesize(1), imagesize(2)) );

    for r = 1:1:imagesize(1)
        for c = 1:1:imagesize(2)
            img_new(r, c) = fix( double( img_orig(r,c) ) / num ) * 255/(level-1);
        end
    end

end