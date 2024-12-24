function output = guided_filter(I, p, r, eps)
    % 计算均值
    mean_I = mean_filter(I, 2 * r + 1);
    mean_p = mean_filter(p, 2 * r + 1);
    mean_Ip = mean_filter(I .* p, 2 * r + 1);
    
    % 计算协方差和方差
    cov_Ip = mean_Ip - mean_I .* mean_p;
    var_I = mean_filter(I .* I, 2 * r + 1) - mean_I .* mean_I;

    % 计算线性模型参数 a 和 b
    a = cov_Ip ./ (var_I + eps);
    b = mean_p - a .* mean_I;

    % 计算均值
    mean_a = mean_filter(a, 2 * r + 1);
    mean_b = mean_filter(b, 2 * r + 1);

    % 计算输出图像
    output = mean_a .* I + mean_b;
end