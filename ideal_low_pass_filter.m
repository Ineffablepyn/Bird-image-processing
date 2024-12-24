function [filteredImage] = ideal_low_pass_filter(inputImage, cutoffFrequency)
    if (ndims(inputImage) == 3) && (size(inputImage, 3) == 3)
        grayImage = rgb2gray(inputImage);
    else
        grayImage = inputImage; 
    end
    grayImage = double(grayImage);

    [M, N] = size(grayImage);

    % 创建理想低通滤波器
    H = ones(M, N); 
    for i = 1:M
        for j = 1:N
            if (sqrt(((i - M/2)^2 + (j - N/2)^2)) > cutoffFrequency)
                H(i, j) = 0; % 超过截止频率的设置为 0
            end
        end
    end

    % 快速傅立叶变换
    F = fft2(grayImage);

    % 移动频谱原点
    F_shifted = fftshift(F);

    % 应用滤波器
    filteredFreq = F_shifted .* H;

    % 傅里叶反变换
    filteredImage = ifft2(ifftshift(filteredFreq));

    % 求模值并归一化以便显示
    filteredImage = abs(filteredImage);
    filteredImage = filteredImage / max(filteredImage(:));
end