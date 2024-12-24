function [BW] = mySobel(I, threshold)
    if ~exist('threshold', 'var') || isempty(threshold)
        threshold = 100; % 默认阈值
    end
    if ndims(I) > 2
        grayImage = rgb2gray(I);
    else
        grayImage = I; 
    end

    % 转换为 double 类型以进行计算
    doubleImage = double(grayImage);
    [rows, cols] = size(doubleImage);
    edgeImage = zeros(rows, cols); % 初始化边缘图像

    % 定义 Sobel 卷积核
    Gx = [1, 0, -1; 2, 0, -2; 1, 0, -1];
    Gy = [-1, -2, -1; 0, 0, 0; 1, 2, 1];

    % 使用 Sobel 算子进行边缘检测
    for i = 2:rows-1
        for j = 2:cols-1
            neighborhood = doubleImage(i-1:i+1, j-1:j+1);
            % 计算梯度
            gradientX = sum(sum(Gx .* neighborhood));
            gradientY = sum(sum(Gy .* neighborhood));
            gradientMagnitude = abs(gradientX) + abs(gradientY);
            
            if gradientMagnitude >= threshold
                edgeImage(i, j) = 255; % 边缘点
            end
        end
    end

    % 转换为二值图像
    BW = uint8(edgeImage);
end