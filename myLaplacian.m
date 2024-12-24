function [outputImage] = myLaplacian(inputImage)
    if ndims(inputImage) > 2
        grayImage = rgb2gray(inputImage);
    else
        grayImage = inputImage; 
    end
    grayImage = double(grayImage);

    % 定义拉普拉斯算子
    laplacianKernel = [-1 -1 -1; -1 8 -1; -1 -1 -1];

    outputImage = zeros(size(grayImage));

    % 应用拉普拉斯算子进行边缘检测
    for j = 2:size(grayImage, 2)-1
        for i = 2:size(grayImage, 1)-1
            % 提取 3x3 邻域
            neighborhood = grayImage(i-1:i+1, j-1:j+1);
            % 计算卷积
            buffer = sum(sum(neighborhood .* laplacianKernel));
            % 处理输出值
            outputImage(i, j) = min(max(buffer, 0), 255); % 限制在 0 到 255 之间
        end
    end

    % 复制边界像素
    outputImage(1, :) = grayImage(1, :);
    outputImage(end, :) = grayImage(end, :);
    outputImage(:, 1) = grayImage(:, 1);
    outputImage(:, end) = grayImage(:, end);

    % 对输出图像进行对比度增强
    outputImage = imadjust(uint8(outputImage), [], [0; 1], 1);

    % 应用阈值处理
    threshold = 30;
    outputImage(outputImage < threshold) = 0;  % 低于阈值的设为黑色
    outputImage(outputImage >= threshold) = 255; % 高于或等于阈值的设为白色

    outputImage = uint8(outputImage);
end