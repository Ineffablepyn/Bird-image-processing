function noisy_image = add_uniform_noise(input_image, lower_bound, upper_bound)
    [row, col, channels] = size(input_image); % 获取行、列和通道数
    noise = lower_bound + (upper_bound - lower_bound) * rand(row, col, channels); % 生成均匀噪声
    noisy_image = double(input_image) + noise;

    % 限制噪声图像的值在合理范围内（0到255）
    noisy_image(noisy_image > 255) = 255; 
    noisy_image(noisy_image < 0) = 0;     
    noisy_image = uint8(noisy_image);
end