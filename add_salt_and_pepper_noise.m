function noisy_image = add_salt_and_pepper_noise(input_image, density)
    % density: 噪声密度，范围在 [0, 1] 之间
    noisy_image = input_image; 
    num_pixels = round(density * numel(input_image)); % 计算需要添加的噪声像素数
    % 随机选择盐和胡椒的位置
    for i = 1:num_pixels
        row = randi(size(input_image, 1)); 
        col = randi(size(input_image, 2));
        channel = randi(size(input_image, 3)); % 随机通道
        
        if rand() < 0.5
            noisy_image(row, col, channel) = 255; % 盐噪声
        else
            noisy_image(row, col, channel) = 0;   % 胡椒噪声
        end
    end
end