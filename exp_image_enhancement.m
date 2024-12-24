function [correctedImg, a, b] =  exp_image_enhancement(img)
    % 设置指数校正参数
    a = 0.8; % 缩放因子
    b = 1.0; % 指数因子
    
    % 将图像转换为双精度浮点数以进行计算
    A1 = double(img);
    
    % 应用指数校正公式
    correctedImg = a * (A1 .^ b);
    
    % 限制像素值在0到255之间
    correctedImg(correctedImg < 0) = 0;
    correctedImg(correctedImg > 255) = 255;
    
    % 将校正后的图像转换回无符号8位整数
    correctedImg = uint8(correctedImg);
end
