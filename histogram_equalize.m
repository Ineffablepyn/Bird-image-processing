function [equalized_image, equalized_hist] = histogram_equalize(input_image)
    % 检查输入图像的灰度值范围
    if max(input_image(:)) > 1 || min(input_image(:)) < 0
        error('输入图像的灰度值必须在0到1之间');
    end
    
    % 将图像值调整到256个级别
    num_levels = 256; % 定义级别数
    input_image = round(input_image * (num_levels - 1)); % 变换到0-255的范围
    
    % 计算原始直方图
    total_pixels = numel(input_image);
    original_hist = histcounts(input_image, 0:num_levels); % 计算直方图，区间[0,256]
    
    % 计算累积概率
    prob = original_hist / total_pixels;
    cumulative_prob = cumsum(prob);
    
    % 计算新的灰度级，并将其归一化到[0, 1]
    new_levels = round(cumulative_prob * (num_levels - 1)); % 变换到0-255的范围
    
    % 创建新图像
    equalized_image = new_levels(input_image + 1) / (num_levels - 1); % 使用new_levels映射
    
    % 计算均衡化后的直方图
    equalized_hist = histcounts(equalized_image * (num_levels - 1), 0:num_levels); % 计算均衡化后的直方图
end