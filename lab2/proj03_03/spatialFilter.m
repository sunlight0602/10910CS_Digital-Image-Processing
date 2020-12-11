function img_new = spatialFilter(img_orig, mask)
    % Spatial filter with fixed size 3*3 mask
    
    [row, col] = size(img_orig);
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
end

