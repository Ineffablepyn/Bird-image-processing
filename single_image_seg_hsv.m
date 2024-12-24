function [result, img_foreground, img_background] = single_image_seg_hsv(img)
    % 转换为灰度图像
    grayImg = rgb2gray(img);
    
    % 使用自适应阈值方法
    T = adaptthresh(grayImg, 'ForegroundPolarity', 'dark');
    result = imbinarize(grayImg, T);
    
    % 使用形态学操作去除噪点和填充孔洞
    se_open = strel('disk', 3);  % 腐蚀和膨胀结构元素
    se_close = strel('disk', 5);
    
    result = imopen(result, se_open);  % 去除小物体
    result = imclose(result, se_close); % 填充孔洞

    % 边缘检测（可选）
    edges = edge(grayImg, 'Canny');
    result = result | edges;  % 合并边缘信息

    % 连通区域分析
    [L, num] = bwlabel(result);
    stats = regionprops(L, 'Area');

    % 过滤小区域
    minArea = 500; % 最小区域面积
    for k = 1:num
        if stats(k).Area < minArea
            result(L == k) = 0; % 将小区域设为背景
        end
    end

    % 获取图像尺寸
    [N, M] = size(result);
    
    % 初始化前景和背景图像
    img_foreground = zeros(N, M, 3, 'uint8');
    img_background = zeros(N, M, 3, 'uint8');
    
    % 根据二值化结果更新前景和背景图像
    for c = 1:3
        for i = 1:N
            for j = 1:M
                if result(i, j) == 1  % 前景
                    img_foreground(i, j, c) = img(i, j, c); % 保持原色
                    img_background(i, j, c) = 255; % 背景标记为白色
                else  % 背景
                    img_foreground(i, j, c) = 0; % 前景标记为黑色
                    img_background(i, j, c) = img(i, j, c); % 背景保持原色
                end
            end
        end
    end
end