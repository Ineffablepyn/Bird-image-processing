function NewImage = piecewise_Linear_Transform(Image, a, b, c, d)
    [h, w] = size(Image);
    NewImage = zeros(h, w, 'double');

    output_max = min(d, 230); % 将上限设为230以减少高光

    % 三段线性灰度级变换
    for x = 1:w
        for y = 1:h
            if Image(y,x) < a
                NewImage(y,x) = Image(y,x) * (c / a);  % 线性缩放
            elseif Image(y,x) < b
                NewImage(y,x) = (Image(y,x) - a) * (output_max - c) / (b - a) + c; % 线性映射
            else
                NewImage(y,x) = (Image(y,x) - b) * ((output_max - d) / (255 - b)) + output_max; 
            end
        end
    end
    
    NewImage = min(max(NewImage, 0), 255);
    
    NewImage = uint8(NewImage);
end
