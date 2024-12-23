function noisy_image = add_gamma_noise(input_image, shape, scale)
    % shape: 形状参数
    % scale: 尺度参数
    [row, col, channels] = size(input_image); 

    % 生成与输入图像同维的伽马分布随机数
    noise = generate_gamma_noise(shape, scale, [row, col, channels]);

    noisy_image = double(input_image) + noise;

    % 限制噪声图像的值在合理范围内（0到255）
    noisy_image(noisy_image > 255) = 255; 
    noisy_image(noisy_image < 0) = 0;   

    % 转换为uint8格式
    noisy_image = uint8(noisy_image);
end
function noise = generate_gamma_noise(shape, scale, size)
    noise = zeros(size); % 初始化噪声矩阵

    for i = 1:numel(noise)
        % 生成形状参数为 'shape' 的 'scale' 指数分布随机数
        noise(i) = sum(exprnd(scale, shape, 1)); % 生成 'shape' 个指数随机数并求和
    end
end