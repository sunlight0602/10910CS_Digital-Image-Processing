% Proj02-03 – Zooming and Shrinking Images by Pixel Replication
% (Nearest Neighbor)
% fac means length of edge

t = Tiff('fig2.tif','r');
imageData = read(t);

img_shrink = Shrink(imageData, 10);
img_zoom = Zoom(img_shrink, 10);

figure(1)
subplot(1,2,1), imshow(imageData)
title('original');
subplot(1,2,2), imshow(img_zoom)
title('shrinked and zoomed by factor 10');

function img_new = Shrink(img_orig, fac)
    img_size = size(img_orig);

    img_new = [];
    for i=1:fac:img_size(1)
        temp = [];
        for j=1:fac:img_size(2)
            nearest_value = img_orig(i,j); % 取左上點吧
            temp = horzcat(temp, nearest_value);
        end
        img_new = vertcat(img_new, temp);
    end
end

function img_new = Zoom(img_orig, fac)
    img_size = size(img_orig);
    img_new = zeros(img_size(1)*fac, img_size(2)*fac);
    
    for i=1:img_size(1)*fac
        for j=1:img_size(2)*fac
            map_col = round(j/fac + 1);
            map_row = round(i/fac + 1);
            
            if map_col>img_size(2)
                map_col = img_size(2);
            end
            
            if map_row>img_size(1)
                map_row = img_size(1);
            end
                    
            img_new(i,j) = img_orig(map_row, map_col);
        end
    end
    img_new = uint8(img_new);
end