function [filteredImage] = bexponential_low_pass_filter(inputImage, cutoffDistance)
    if (ndims(inputImage) == 3) && (size(inputImage, 3) == 3)
        grayImage = rgb2gray(inputImage);
    else
        grayImage = inputImage;
    end
    [M, N] = size(grayImage);

    % 计算傅里叶变换并移动频谱原点
    J = fftshift(fft2(grayImage));

    % 初始化滤波器
    H = zeros(M, N);
    centerX = floor(M / 2);
    centerY = floor(N / 2);

    % 构造指数低通滤波器
    for i = 1:M
        for j = 1:N
            distance = sqrt((i - centerX)^2 + (j - centerY)^2);
            H(i, j) = exp(- (distance / cutoffDistance)^2);
        end
    end

    % 应用滤波器
    filteredFrequencyDomain = H .* J;

    % 傅里叶反变换
    filteredImage = real(ifft2(ifftshift(filteredFrequencyDomain)));

    filteredImage = mat2gray(filteredImage); 
end