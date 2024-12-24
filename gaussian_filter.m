function output = gaussian_filter(input, sigma)
    % 计算滤波器大小
    filter_size = 2 * ceil(3 * sigma) + 1;
    [x, y] = meshgrid(-floor(filter_size / 2):floor(filter_size / 2), -floor(filter_size / 2):floor(filter_size / 2));
    
    % 生成高斯滤波器
    g = exp(-(x.^2 + y.^2) / (2 * sigma^2));
    g = g / sum(g(:)); % 归一化滤波器

    % 检查输入图像的维度
    if ndims(input) == 3
        % 对于RGB图像，逐通道应用高斯滤波
        output = zeros(size(input), 'like', input); 
        for channel = 1:size(input, 3)
            output(:, :, channel) = conv2(input(:, :, channel), g, 'same');
        end
    else
        % 对于灰度图像，直接应用卷积
        output = conv2(input, g, 'same');
    end
end