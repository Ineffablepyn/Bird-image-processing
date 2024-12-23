function NewImage = piecewise_Linear_Transform(Image, a, b, c, d)
    % 获取图像尺寸
    [h, w] = size(Image);
    
    % 初始化输出图像
    NewImage = zeros(h, w, 'double');
    
    % 三段线性灰度级变换
    for x = 1:w
        for y = 1:h
            if Image(y,x) < a
                NewImage(y,x) = Image(y,x) * c/a;
            elseif Image(y,x) < b
                NewImage(y,x) = (Image(y,x) - a) * (d - c) / (b - a) + c;
            else
                NewImage(y,x) = (Image(y,x) - b) * (1 - d) / (1 - b) + d;
            end
        end
    end