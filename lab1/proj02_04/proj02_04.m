% Proj02-04 – Zooming and Shrinking Images by Bilinear Interpolation
% 將原圖縮小1250/100=12.5倍後，再放大1250/100=12.5倍即可。
% 縮放倍率以圖片長/寬的pixel個數而論。

t = Tiff('fig2.tif','r');
imageData = read(t);
rate = 12.5;

img_size = size(imageData);
out_dims = [round(img_size(1)/rate), round(img_size(2)/rate)];
img_shrink = bilinearInterpolation(imageData, out_dims);

img_size = size(img_shrink);
out_dims = [round(img_size(1)*rate), round(img_size(2)*rate)];
img_zoom = bilinearInterpolation(img_shrink, out_dims);

figure(1)
subplot(1,3,1), imshow(imageData)
title('original');
subplot(1,3,2), imshow(img_zoom)
title('zoomed by Bilinear Interpolation');
subplot(1,3,3), imshow(img_shrink)
title('shrink');

function img_new = bilinearInterpolation(img_orig, out_dims)
    img_size = size(img_orig);
    
    img_new = zeros(out_dims);
    
    % ratio = orig / new
    if img_size(1) >= out_dims(1) % shrink
        ratio_row = img_size(1) / out_dims(1);
    else % zoom
        ratio_row = img_size(1) / out_dims(1);
        %ratio_row = out_dims(1) / img_size(1);
    end
    if img_size(2) >= out_dims(2)
        ratio_col = img_size(2) / out_dims(2);
    else
        %ratio_col = out_dims(2) / img_size(2);
        ratio_col = img_size(2) / out_dims(2);
    end
    
    % Iterate through img_new
    for i=1:out_dims(1)
        for j=1:out_dims(2)
            x_l = fix(ratio_row * i)+1; % higher, lower
            y_l = fix(ratio_col * j)+1;
            x_h = ceil(ratio_row * i)+1;
            y_h = ceil(ratio_col * j)+1;
            
            x_weight = abs((ratio_row * i) - x_l);
            y_weight = abs((ratio_col * j) - y_l);
            
            a = GetValue(x_l, y_l);
            b = GetValue(x_l, y_h);
            c = GetValue(x_h, y_l);
            d = GetValue(x_h, y_h);
            
            r1 = a*(1-y_weight) + b*y_weight;
            r2 = c*(1-y_weight) + d*y_weight;
            p = r1*(1-x_weight) + r2*x_weight;
            
            img_new(i,j) = p;
        end
    end
    img_new = uint8(img_new);
    
    function value = GetValue(x, y)
        try
            value = img_orig(x, y);
        catch
            value = 255;
        end
    end
end
