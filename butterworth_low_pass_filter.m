function [filteredImage] = butterworth_low_pass_filter(inputImage, cutoffFrequency, order)
    if (ndims(inputImage) == 3) && (size(inputImage, 3) == 3)
        grayImage = rgb2gray(inputImage);
    else
        grayImage = inputImage; 
    end

    grayImage = double(grayImage);
    [M, N] = size(grayImage);
    filter = zeros(M, N); % 初始化滤波器

    % 计算每个频率点的距离，并构造滤波器
    for i = 1:M
        for j = 1:N
            distance = sqrt((i - M/2)^2 + (j - N/2)^2);
            filter(i, j) = 1 / (1 + (distance / cutoffFrequency)^(2 * order));
        end
    end

    % 快速傅立叶变换
    F = fft2(grayImage);

    % 移动频谱原点
    F_shifted = fftshift(F);

    % 应用滤波器
    filteredFreq = F_shifted .* filter;

    % 傅里叶反变换
    outputImage = ifft2(ifftshift(filteredFreq));

    % 求模值并归一化以便显示
    outputImage = abs(outputImage);
    filteredImage = outputImage / max(outputImage(:)); % 归一化
    
end