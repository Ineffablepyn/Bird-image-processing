function output = median_filter(input, filter_size)
    if nargin < 2
        error('输入参数不足。请提供图像和滤波器大小。');
    end
    
    if mod(filter_size, 2) == 0
        error('滤波器大小必须为奇数。');
    end

    % 获取输入图像的维度
    [row, col, channels] = size(input);
    pad_size = floor(filter_size / 2);
    
    % 使用复制边界填充图像
    padded_image = padarray(input, [pad_size pad_size], 'replicate');

    output = zeros(row, col, channels, 'uint8');

    for r = 1:row
        for c = 1:col
            for ch = 1:channels
                % 提取当前区域
                region = padded_image(r:r + filter_size - 1, c:c + filter_size - 1, ch);
                % 计算中值并赋值
                output(r, c, ch) = median(region(:));
            end
        end
    end
end