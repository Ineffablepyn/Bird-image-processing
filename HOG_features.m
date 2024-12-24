function hog_image = HOG_features(grayImg)
    % 伽马校正
    img = double(grayImg);
    img = sqrt(img);

    % 计算边缘
    fy = [-1 0 1];
    fx = fy';
    Iy = imfilter(img, fy, 'replicate');
    Ix = imfilter(img, fx, 'replicate');
    Ied = sqrt(Ix.^2 + Iy.^2);
    Iphase = Iy ./ Ix;

    % 计算 cell 的梯度直方图
    step = 8;
    orient = 9;
    jiao = 360 / orient;
    Cell = cell(1, 1);
    cell_row = 1;
    cell_col = 1;

    [m, n] = size(img);
    for i = 1:step:m-step
        cell_row = 1;
        for j = 1:step:n-step
            tmpx = Ix(i:i+step-1, j:j+step-1);
            tmped = Ied(i:i+step-1, j:j+step-1);
            tmped = tmped / sum(sum(tmped));
            tmpphase = Iphase(i:i+step-1, j:j+step-1);
            Hist = zeros(1, orient);
            for p = 1:step
                for q = 1:step
                    if isnan(tmpphase(p, q))
                        tmpphase(p, q) = 0;
                    end
                    ang = atan(tmpphase(p, q));
                    ang = mod(ang * 180 / pi, 360);
                    if tmpx(p, q) < 0
                        if ang < 90
                            ang = ang + 180;
                        end
                        if ang > 270
                            ang = ang - 180;
                        end
                    end
                    ang = ang + 0.0000001;
                    Hist(ceil(ang / jiao)) = Hist(ceil(ang / jiao)) + tmped(p, q);
                end
            end

            Hist = Hist / sum(Hist);
            Cell{cell_row, cell_col} = Hist;
            cell_row = cell_row + 1;
        end
        cell_col = cell_col + 1;
    end

    % 显示准备工作
    angle = [40, 80, 120, 160, 200, 240, 280, 320, 360];
    rad = angle * pi / 180;
    k = tan(rad);
    [m, n] = size(Cell);
    image_hog = zeros(m * 17, n * 17);
    
    for x = 1:m-1
        for y = 1:n-1
            intensity = (Cell{x, y} + Cell{x, y + 1} + Cell{x + 1, y} + Cell{x + 1, y + 1}) * 64;
            X = -8:1:8;
            [a, b] = size(k);
            for i = 1:b
                Y(i, :) = ceil(X * k(i));
            end
            
            % 标记 block 画线
            block = zeros(17, 17);
            for i = 1:17
                X(i) = X(i) + 9;
                for j = 1:9
                    Y(j, i) = Y(j, i) + 9;
                    if Y(j, i) > 17
                        Y(j, i) = 17;
                    end
                    if Y(j, i) < 1
                        Y(j, i) = 1;
                    end
                end
            end

            % 标记
            for i = 1:17
                for j = 1:9
                    block(X(i), Y(j, i)) = intensity(j);
                end
            end
            
            % 填充 HOG 图像
            image_hog((x-1)*17+1:(x-1)*17+17 , (y-1)*17+1:(y-1)*17+17) = block(:,:);
            end
    end
    image_hog = image_hog';

    % 高斯平滑
    G = [1 2 3 2 1;
         2 5 6 5 2;
         3 6 8 6 3;
         2 5 6 5 2;
         1 2 3 2 1;]
conv2(G, image_hog);  

    % 返回 HOG 特征图像
    hog_image = image_hog;
end