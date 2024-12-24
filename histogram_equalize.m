function [equalized_image, equalized_hist] = histogram_equalize(input_image)
    if size(input_image, 3) == 3
        input_image = (0.2989 * input_image(:,:,1) + 0.5870 * input_image(:,:,2) + 0.1140 * input_image(:,:,3));
    end
  
    img = im2double(input_image); 
    img_out = zeros(size(img));
    [m, n] = size(img);
    
    % 计算直方图
    h = zeros(1, 256); % 初始化直方图
    for i = 1:m
        for j = 1:n
            gray_value = round(img(i,j) * 255) + 1; 
            h(gray_value) = h(gray_value) + 1; % 统计每个灰度值的出现次数
        end
    end
    h = h / (m * n); 
    s = zeros(1, 256); % 创建输出灰度值向量
    rk = 0.0; 
    
    % 计算累计分布函数并映射到新的灰度值
    for i = 1:length(h)
        rk = rk + h(i);
        s(i) = round(rk * 255); 
    end
    
    % 应用直方图均衡化
    for i = 1:m
        for j = 1:n
            gray_value = round(img(i,j) * 255) + 1; % 获取灰度值并调整索引
            img_out(i,j) = s(gray_value) / 255; % 映射到0到1范围
        end
    end
    
    
    equalized_image = img_out;
    equalized_hist = zeros(1, 256); 
    
    % 计算均衡化后的直方图
    for i = 1:m
        for j = 1:n
            gray_value = round(equalized_image(i,j) * 255) + 1; 
            equalized_hist(gray_value) = equalized_hist(gray_value) + 1;
        end
    end
    equalized_hist = equalized_hist / (m * n); 
end
