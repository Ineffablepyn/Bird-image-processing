function lbp_image = LBP_features(img)
    
    % 转换为灰度图像
    img = rgb2gray(img);
    
    % 获取图像尺寸
    [N, M] = size(img);
    
    % 初始化LBP矩阵
    P = 8; % 8个邻居
    R = 1; % 半径为1
    lbp = zeros(N, M);
    
    % 计算LBP特征
    for j = 2:N-1
        for i = 2:M-1
            neighbor = [j-1, i-1; j-1, i; j-1, i+1; j, i+1; j+1, i+1; j+1, i; j+1, i-1; j, i-1];
            count = 0;
            for k = 1:8
                if img(neighbor(k,1), neighbor(k,2)) > img(j,i)
                    count = count + 2^(8-k);
                end
            end
            lbp(j,i) = count;
        end
    end
    
    lbp = uint8(lbp);
    
    lbp_image = lbp;
end