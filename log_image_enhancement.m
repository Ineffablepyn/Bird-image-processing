function enhanced_image = log_image_enhancement(input_image, n, a, beta)
    % 将输入图像转换为double类型
    f = double(input_image) / 255; % 归一化到[0, 1]
    
    % 计算对数变换
    ln_f = log(f + 1); % 加1以避免对0取对数

    [rows, cols] = size(ln_f);
    lnA = zeros(rows, cols);
    
    % 计算局部均值
    for i = 1:rows
        for j = 1:cols
            % 确保窗口不会超出图像边界
            x1 = max(i - floor(n/2), 1);
            x2 = min(i + floor(n/2), rows);
            y1 = max(j - floor(n/2), 1);
            y2 = min(j + floor(n/2), cols);
            lnA(i, j) = mean(mean(ln_f(x1:x2, y1:y2)));
        end
    end

    % 计算增强后的图像
    lnf_prime = a * lnA + beta * (ln_f - lnA);
    enhanced_f = exp(lnf_prime) - 1; % 减1恢复原始范围
    
    % 限制像素值在0到1之间
    enhanced_f(enhanced_f < 0) = 0;
    enhanced_f(enhanced_f > 1) = 1;
    
    % 转换回uint8格式
    enhanced_image = uint8(enhanced_f * 255); % 乘以255转回[0, 255]
end