function new_img = histogram_matching(src_img, ref_img)
    if size(src_img, 3) == 1 && size(ref_img, 3) == 1
        % 两个都是灰度图像
        new_img = match_gray_images(src_img, ref_img);
    elseif size(src_img, 3) == 3 && size(ref_img, 3) == 3
        % 两个都是彩色图像
        new_img = match_color_images(src_img, ref_img);
    else
        error('输入图像类型不匹配：请确保两个图像都是灰度或彩色图像。');
    end
end

function new_img = match_gray_images(src_img, ref_img)
    % 灰度图像的直方图匹配
    hist_src = hist_img(src_img);
    hist_ref = hist_img(ref_img);
    
    cdf_src = cumsum(hist_src) / numel(src_img);
    cdf_ref = cumsum(hist_ref) / numel(ref_img);
    
    map = zeros(256, 1);
    for i = 1:256
        [~, idx] = min(abs(cdf_src(i) - cdf_ref));  
        map(i) = idx - 1;
    end
    
    new_img = uint8(arrayfun(@(x) map(x + 1), src_img));
end

function new_img = match_color_images(src_img, ref_img)
    %  彩色图像的直方图匹配
    new_img = zeros(size(src_img), 'uint8');
    
    for channel = 1:3
        src_channel = src_img(:, :, channel);
        ref_channel = ref_img(:, :, channel);
        
        hist_src = hist_img(src_channel);
        hist_ref = hist_img(ref_channel);
        
        cdf_src = cumsum(hist_src) / numel(src_channel);
        cdf_ref = cumsum(hist_ref) / numel(ref_channel);
        
        map = zeros(256, 1);
        for i = 1:256
            [~, idx] = min(abs(cdf_src(i) - cdf_ref));  
            map(i) = idx - 1;
        end
        
        new_img(:, :, channel) = uint8(arrayfun(@(x) map(x + 1), src_channel));
    end
end

function histogram = hist_img(img)
    % 手动计算图像的灰度直方图
    histogram = zeros(1, 256);
    
    [rows, cols] = size(img);
    
    for i = 1:rows
        for j = 1:cols
            gray_value = img(i, j);  
            histogram(gray_value + 1) = histogram(gray_value + 1) + 1; 
        end
    end
end