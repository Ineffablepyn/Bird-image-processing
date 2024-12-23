function noisy_image = add_rayleigh_noise(input_image, scale)
    [row, col, channels] = size(input_image); % 获取行、列和通道数
    noise = scale * sqrt(-2 * log(rand(row, col, channels))); % 生成瑞利噪声

    noisy_image = double(input_image) + noise;

    % 限制噪声图像的值在合理范围内（0到255）
    noisy_image(noisy_image > 255) = 255;
    noisy_image(noisy_image < 0) = 0;    
    noisy_image = uint8(noisy_image);
end