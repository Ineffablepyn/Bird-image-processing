function [BW] = myRoberts(I, th)
    if ~exist('th', 'var') || isempty(th)
        th = 0.08; % 默认阈值
    end

    if ndims(I) > 2
        grayI = rgb2gray(I);
    else
        grayI = I; 
    end
    [m, n] = size(grayI);
    newI = grayI; 

    % 使用 Roberts 算子进行边缘检测
    for j = 1:m-1
        for k = 1:n-1
            robertsNum = abs(grayI(j,k) - grayI(j+1,k+1)) + abs(grayI(j+1,k) - grayI(j,k+1));
            if robertsNum > th * 255  % 比较与阈值
                newI(j,k) = 255; % 边缘点
            else
                newI(j,k) = 0;   % 非边缘点
            end
        end
    end

    BW = im2bw(newI);
end