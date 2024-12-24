function filteredImage = bilateral_filter(image, spatial_sigma, color_sigma)
    if size(image, 3) ~= 3
        error('Input image must be a true color image.');
    end    
    % 分离图像的三个颜色通道
    R = double(image(:,:,1));
    G = double(image(:,:,2));
    B = double(image(:,:,3));
    [rows, cols] = size(R);    
    % 初始化滤波后的图像
    R_filtered = zeros(size(R));
    G_filtered = zeros(size(G));
    B_filtered = zeros(size(B));

    for i = 1:rows
        for j = 1:cols
            % 计算邻域
            neighborhood = getNeighborhood(i, j, rows, cols, spatial_sigma);
            % 初始化权重和和权重和的总和
            weightSum = 0;
            R_weightedSum = 0;
            G_weightedSum = 0;
            B_weightedSum = 0;
            
            for k = 1:size(neighborhood, 1)
                x = neighborhood(k, 1);
                y = neighborhood(k, 2);
                
                % 计算空间和灰度差异的高斯权重
                spaceWeight = exp(-((x-i)^2 + (y-j)^2) / (2 * spatial_sigma^2));
                intensityWeight = exp(-((R(x,y)-R(i,j))^2 + (G(x,y)-G(i,j))^2 + (B(x,y)-B(i,j))^2) / (2 * color_sigma^2));
                
                % 计算总权重
                weight = spaceWeight * intensityWeight;
                
                % 更新权重和和权重和的总和
                weightSum = weightSum + weight;
                R_weightedSum = R_weightedSum + R(x,y) * weight;
                G_weightedSum = G_weightedSum + G(x,y) * weight;
                B_weightedSum = B_weightedSum + B(x,y) * weight;
            end
            
            % 计算双边滤波后的像素值
            R_filtered(i,j) = R_weightedSum / weightSum;
            G_filtered(i,j) = G_weightedSum / weightSum;
            B_filtered(i,j) = B_weightedSum / weightSum;
        end
    end
    
    % 合并滤波后的通道
    filteredImage = cat(3, R_filtered, G_filtered, B_filtered);
    
    filteredImage = uint8(filteredImage);
end

% 获取邻域坐标点的函数
function neighborhood = getNeighborhood(i, j, rows, cols, sigma_s)
    % 计算邻域范围
    radius = ceil(3 * sigma_s);
    xMin = max(i - radius, 1);
    yMin = max(j - radius, 1);
    xMax = min(i + radius, rows);
    yMax = min(j + radius, cols);
    
    % 生成邻域坐标
    [xGrid, yGrid] = meshgrid(xMin:xMax, yMin:yMax);
    neighborhood = [xGrid(:), yGrid(:)];
    
    % 排除中心点
    neighborhood(neighborhood(:,1) == i & neighborhood(:,2) == j, :) = [];
end