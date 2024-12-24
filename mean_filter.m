function filtered_img = mean_filter(img, kernelSize)
    % 检查卷积核大小是否为正奇数
    if mod(kernelSize, 2) == 0 || kernelSize <= 0
        error('卷积核大小必须是正奇数。');
    end
    [rows, cols, channels] = size(img);

    % 计算卷积核中心
    pad = floor(kernelSize / 2);
    filtered_img = zeros(rows, cols, channels, 'like', img);

    for i = 1 + pad:rows - pad
        for j = 1 + pad:cols - pad
            for k = 1:channels
                neighborhood = img(i - pad:i + pad, j - pad:j + pad, k);                
                mean_val = mean(neighborhood(:));                
                % 将平均值赋给当前像素
                filtered_img(i, j, k) = mean_val;
            end
        end
    end
    filtered_img = cast(filtered_img, 'like', img);
end