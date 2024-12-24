function varargout = Bird_Image_Processing(varargin)
% BIRD_IMAGE_PROCESSING MATLAB code for Bird_Image_Processing.fig
%      BIRD_IMAGE_PROCESSING, by itself, creates a new BIRD_IMAGE_PROCESSING or raises the existing
%      singleton*.
%
%      H = BIRD_IMAGE_PROCESSING returns the handle to a new BIRD_IMAGE_PROCESSING or the handle to
%      the existing singleton*.
%
%      BIRD_IMAGE_PROCESSING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BIRD_IMAGE_PROCESSING.M with the given input arguments.
%
%      BIRD_IMAGE_PROCESSING('Property','Value',...) creates a new BIRD_IMAGE_PROCESSING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Bird_Image_Processing_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Bird_Image_Processing_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Bird_Image_Processing

% Last Modified by GUIDE v2.5 25-Dec-2024 02:47:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Bird_Image_Processing_OpeningFcn, ...
                   'gui_OutputFcn',  @Bird_Image_Processing_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Bird_Image_Processing is made visible.
function Bird_Image_Processing_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Bird_Image_Processing (see VARARGIN)

% Choose default command line output for Bird_Image_Processing
handles.output = hObject;
% 设置 slider2 的最小值、最大值和初始值
set(handles.figure1, 'CloseRequestFcn', @CloseRequestFcn);   
set(handles.slider2, 'Min', -180, 'Max', 180, 'Value', 0); % 初始值设置为 0
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Bird_Image_Processing wait for user response (see UIRESUME)
% uiwait(handles.figure1);
function CloseRequestFcn(hObject, eventdata)
    % 获取 handles 结构
    handles = guidata(hObject);
    
    % 清空所有 axes 的图像
    axes(handles.axes1);
    cla; % 清空 axes1
    axes(handles.axes2);
    cla; % 清空 axes2
    axes(handles.axes3);
    cla; % 清空 axes3
    axes(handles.axes4);
    cla; % 清空 axes4

    % 清空其他需要清空的变量
    handles.input_image = []; % 清空输入图像
    handles.extracted_target = []; % 清空提取目标
  
    % 更新 handles 结构
    guidata(hObject, handles);
    
    % 关闭窗口
    delete(hObject);

% --- Outputs from this function are returned to the command line.
function varargout = Bird_Image_Processing_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
  
    % 打开文件选择对话框
    [filename, pathname] = uigetfile({'*.jpg;*.png;*.bmp;*.tif', 'Image Files (*.jpg, *.png, *.bmp, *.tif)'}, ...
                                      'Select an Image File');
    if isequal(filename, 0)
        disp('User selected Cancel');
    else
        % 读取图像
        fullpath = fullfile(pathname, filename);
        handles.imagePath = fullpath; 
        input_image = imread(fullpath);
        
        % 存储原始图像
        handles.input_image = input_image; 
        guidata(hObject, handles); % 更新handles结构
        
        % 显示原始图像
        axes(handles.axes1); 
        imshow(input_image); 
        title('原图');
         input_image=double(input_image) / 255;
        % 计算并显示灰度直方图
        gray_image = rgb2gray(input_image); % 转换为灰度图像
        axes(handles.axes3); % 在 axes3 中显示直方图
        cla reset; % 清空当前轴
        imhist(gray_image); % 显示灰度直方图
        title('灰度直方图');
    end
    
% --- Executes on button press in pushbutton2 (处理图像的按钮).
function pushbutton2_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton2 (see GCBO)
    
    % 从handles结构中获取输入图像
    input_image = handles.input_image;  

    % 归一化图像到[0, 1]
    normalized_image = double(input_image) / 255; 

    % 调用直方图均衡化函数
    try
        [equalized_image, equalized_hist] = histogram_equalize(normalized_image);
        
        % 显示均衡化后的图像在axes2中
        axes(handles.axes2); 
        imshow(equalized_image); 
        title('直方图均衡化');

        % 计算并显示均衡化后的灰度直方图
        axes(handles.axes4); % 在 axes4 中显示直方图
        cla reset; % 清空当前轴
        
        % 直接显示均衡化后的直方图
        imhist(equalized_image); % 显示灰度直方图 
        title('均衡化后灰度直方图');

    catch ME
        errordlg(ME.message, 'Error'); 
    end

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to axes2 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % 清空 axes2
    axes(hObject);
    cla; % 清除当前坐标轴
    title('处理后图像'); % 设置标题

% Hint: place code in OpeningFcn to populate axes2


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
    % hObject    handle to popupmenu1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    try
        % 获取用户选择的菜单项
        contents = cellstr(get(hObject, 'String'));
        selected_option = contents{get(hObject, 'Value')};

        % 从handles结构中获取输入图像
        if isfield(handles, 'input_image')
            input_image = handles.input_image; 
        else
            errordlg('请先加载一张图像。', 'Error');
            return; % 退出函数
        end

        % 检查输入图像是否为彩色图像，并进行灰度化
        if size(input_image, 3) == 3
            input_image = rgb2gray(input_image); % 将彩色图像转换为灰度图像
        end

        % 计算图像的直方图和累积分布
        histogram_values = imhist(input_image);
        cumulative_histogram = cumsum(histogram_values);
        total_pixels = sum(histogram_values);

        % 设置 a 和 b 为 5% 和 95% 的灰度值
        percentile_a = 0.05; % 5%
        percentile_b = 0.95; % 95%

        a = find(cumulative_histogram >= percentile_a * total_pixels, 1);
        b = find(cumulative_histogram >= percentile_b * total_pixels, 1);
        c = 50;   % 输出灰度范围下限
        d = 255; % 输出灰度范围上限

        % 根据选择的项调用相应的图像增强函数
        switch selected_option
            case '指数变换'
                [correctedImg, a, b] = exp_image_enhancement(input_image);
                axes(handles.axes2);
                imshow(correctedImg);
                title('指数变换后图像');

            case '对数变换'
                n = 5; % 窗口大小，可根据需要调整
                a = 1;  % 可调参数
                beta = 0.5; % 可调参数
                enhanced_image = log_image_enhancement(input_image, n, a, beta);
                axes(handles.axes2);
                imshow(enhanced_image);
                title('对数变换后图像');

            case '线性变换'
                NewImage = piecewise_Linear_Transform(input_image, a, b, c, d);
                axes(handles.axes2);
                imshow(NewImage);
                title('线性变换后图像');

            otherwise
                errordlg('未知的增强选项。', 'Error');
        end
    catch ME
        errordlg(ME.message, 'Error');
    end

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
    % hObject    handle to slider1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % 获取当前滑块的值
    scale_factor = get(hObject, 'Value');

    % 从handles结构中获取输入图像
    if isfield(handles, 'input_image')
        input_image = handles.input_image; 
    else
        errordlg('请先加载一张图像。', 'Error');
        return; % 退出函数
    end

    
    % 使用 imresize 函数进行图像缩放
    resized_image = imresize(input_image, scale_factor);

    % 在 axes2 中显示缩放后的图像
    axes(handles.axes2);
    imshow(resized_image);
    axis on; % 显示坐标轴
    axis image; % 保持图像的纵横比
    title('缩放后的图像');
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
    % hObject    handle to slider2 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % 获取当前滑块的值，假设此值表示旋转角度
    rotation_angle = get(hObject, 'Value'); % 旋转角度值

    % 从handles结构中获取输入图像
    if isfield(handles, 'input_image')
        input_image = handles.input_image; 
    else
        errordlg('请先加载一张图像。', 'Error');
        return; % 退出函数
    end

    % 使用 imrotate 函数进行图像旋转
    rotated_image = imrotate(input_image, rotation_angle);

    % 在 axes2 中显示旋转后的图像
    axes(handles.axes2);
    imshow(rotated_image);
    axis on; % 显示坐标轴
    axis image; % 保持图像的纵横比
    title(['旋转角度: ', num2str(rotation_angle), '°']);


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 获取选中的噪声类型
    contents = cellstr(get(hObject, 'String'));
    selected_noise = contents{get(hObject, 'Value')}; % 选中的噪声类型
    handles.selected_noise = selected_noise; % 存储选定的噪声类型
    guidata(hObject, handles); % 更新 handles 结构
% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2
% --- Executes during object creation, after setting all properties.

function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function pushbutton4_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton4 (see GCBO)
    % handles    structure with handles and user data (see GUIDATA)

    % 检查是否选择了噪声类型
    if ~isfield(handles, 'selected_noise') || isempty(handles.selected_noise)
        errordlg('请先选择一种噪声类型。', 'Error');
        return;
    end
    
    % 从handles结构中获取输入图像
    if ~isfield(handles, 'input_image')
        errordlg('请先加载一张图像。', 'Error');
        return; % 退出函数
    end
    input_image = handles.input_image; 

    % 根据选定的噪声类型调用相应的函数
    switch handles.selected_noise
        case '高斯噪声'
            mean_value = 0; 
            variance = 500; % 增加方差以增强噪声
            sigma = sqrt(variance);
            noisy_image = add_gaussian_noise(input_image, mean_value, sigma);
        
        case '椒盐噪声'
            density = 0.04; % 噪声密度
            noisy_image = add_salt_and_pepper_noise(input_image, density);
        
        case '瑞利噪声'
            scale = 20; % 瑞利分布的尺度参数
            noisy_image = add_rayleigh_noise(input_image, scale);
        
        case '伽马噪声'
            shape = 2; % 形状参数
            scale = 20; % 尺度参数
            noisy_image = add_gamma_noise(input_image, shape, scale);
        
        case '指数噪声'
            scale_exp = 20; % 指数尺度参数
            noisy_image = add_exponential_noise(input_image, scale_exp);
        
        case '均匀噪声'
            lower_bound = -30; % 下界
            upper_bound = 30;  % 上界
            noisy_image = add_uniform_noise(input_image, lower_bound, upper_bound);
        
        otherwise
            msgbox('请选择有效的噪声类型'); % 提示信息
            return;
    end

    % 显示带噪声的图像
    axes(handles.axes2); % 假设在 axes2 中显示图像
    imshow(noisy_image, []); % 使用[]参数进行自动缩放
    % 设置标题显示当前噪声类型
    title(['添加的噪声类型: ', handles.selected_noise]);
    % 更新 handles 结构
    handles.imggray_add_noise = noisy_image; % 保存带噪声的图像
    guidata(hObject, handles);


% --- Executes on selection change in listbox3.
function listbox3_Callback(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    contents = cellstr(get(hObject, 'String'));
    selected_noise = contents{get(hObject, 'Value')}; 
    handles.selected_noise = selected_noise; 
    guidata(hObject, handles); 
% Hints: contents = cellstr(get(hObject,'String')) returns listbox3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox3


% --- Executes during object creation, after setting all properties.
function listbox3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton5 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    if ~isfield(handles, 'imggray_add_noise')
        errordlg('请先加载一张图像。', 'Error');
        return; 
    end
    
    contents = cellstr(get(handles.listbox3, 'String'));
    selected_item = contents{get(handles.listbox3, 'Value')};

    original_image = handles.imggray_add_noise;

    % 根据选择应用不同的滤波器
    switch selected_item
        case '均值滤波'
             % 设置滤波器大小
            filter_size = 3; % 根据需要修改        
            % 调用均值滤波器
            filtered_image = mean_filter(original_image, filter_size);
        case '高斯滤波'
            % 设置高斯标准差
            sigma = 1.5;            
            % 调用高斯滤波器
            filtered_image = gaussian_filter(original_image,  sigma); % 选择适当的 sigma
        case '中值滤波'
            % 设置滤波器大小
            filterSize = 3; % 选择适当的奇数大小
            filtered_image = median_filter(original_image, filterSize);
        case '双边滤波'
            spatial_sigma = 5; % 空间标准差
            color_sigma = 50; % 颜色标准差
            filtered_image = bilateral_filter(original_image, spatial_sigma, color_sigma); % 选择适当的参数
        case '导向滤波'
            % 确保图像是灰度图像
            if size(original_image, 3) == 3
                original_image = rgb2gray(original_image);
            end
            
            if size(original_image, 3) == 3
                original_image = rgb2gray(original_image);
            end
            
            % 设置滤波参数
            r = 5;        % 半径
            eps = 0.01;  % 正则化参数
            
            % 应用引导滤波
            filtered_image = guided_filter(original_image, original_image, r, eps); % 选择适当的参数
        otherwise
            errordlg('未选择有效的滤波器', '错误');
            return;
    end

    % 显示滤波后的图像
    axes(handles.axes4); 
    imshow(filtered_image);
    % 获取当前使用的噪声类型
    noise_type = handles.selected_noise; % 从handles中获取已选择的噪声类型
    
    % 设置标题显示当前噪声类型和应用的滤波器
    title(['噪声类型: ', noise_type, ' | 应用的滤波器: ', selected_item]);


% --- Executes on selection change in listbox4.
function listbox4_Callback(hObject, eventdata, handles)
    % hObject    handle to listbox4 (see GCBO)
    contents = cellstr(get(hObject, 'String'));
    selected_filter = contents{get(hObject, 'Value')}; 
    handles.selected_filter = selected_filter; 
    guidata(hObject, handles); 

% Hints: contents = cellstr(get(hObject,'String')) returns listbox4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox4


% --- Executes during object creation, after setting all properties.
function listbox4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton6 (see GCBO)

    % 检查是否已加载图像
    if ~isfield(handles, 'imggray_add_noise')
        errordlg('请先加载一张图像。', 'Error');
        return;
    end
    
    % 获取用户选择的滤波器类型
    contents = cellstr(get(handles.listbox4, 'String'));
    selected_filter = contents{get(handles.listbox4, 'Value')};

    original_image = handles.imggray_add_noise; % 获取原图像

    % 根据选择的滤波器类型进行处理
    switch selected_filter
        case '理想低通滤波'
             % 设置固定的截止频率
            cutoff_freq = 100;
            % 调用理想低通滤波器
            filtered_image = ideal_low_pass_filter(original_image, cutoff_freq);
        case '巴特沃斯低通滤波'
             % 设置截止频率和阶数
            cutoff_freq = 100; % 根据需要修改
            order = 2; % 根据需要修改
            % 调用巴特沃斯低通滤波器
            filtered_image = butterworth_low_pass_filter(original_image, cutoff_freq, order); % 直接调用
        case '指数低通滤波'
             % 设置截止距离
            cutoff_distance = 100;       
            % 调用指数低通滤波器
            filtered_image = exponential_low_pass_filter(original_image, cutoff_distance);
        otherwise
            errordlg('未选择有效的滤波器', '错误');
            return;
    end

    % 显示滤波后的图像
    axes(handles.axes4);
    imshow(filtered_image);
     % 获取当前使用的噪声类型
    noise_type = handles.selected_noise; % 从handles中获取已选择的噪声类型
    
    % 设置标题显示当前噪声类型和应用的滤波器
    title(['噪声类型: ', noise_type, ' | 应用的滤波器: ', selected_filter]);


% --- Executes on selection change in listbox5.
function listbox5_Callback(hObject, eventdata, handles)
    % hObject    handle to listbox5 (see GCBO)
    contents = cellstr(get(hObject, 'String'));
    selected_operator = contents{get(hObject, 'Value')}; 
    handles.selected_operator = selected_operator; 
    guidata(hObject, handles); 

% Hints: contents = cellstr(get(hObject,'String')) returns listbox5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox5


% --- Executes during object creation, after setting all properties.
function listbox5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton7 (see GCBO)

    % 检查是否已加载图像
    if ~isfield(handles, 'input_image')
        errordlg('请先加载一张图像。', 'Error');
        return;
    end
    
    % 获取用户选择的边缘检测算子
    contents = cellstr(get(handles.listbox5, 'String'));
    selected_operator = contents{get(handles.listbox5, 'Value')};

    original_image = handles.input_image; % 获取原图像

    % 检查图像是否为彩色图像，如果是则转换为灰度图像
    if size(original_image, 3) == 3
        original_image = rgb2gray(original_image);
    end

    % 根据选择的算子进行处理
    switch selected_operator
        case 'Robert算子'
            edge_image = myRoberts(original_image);
        case 'Prewitt算子'
            edge_image = myPrewitt(original_image);
        case 'Sobel算子'
            edge_image = mySobel(original_image);
        case '拉普拉斯算子'
            edge_image = myLaplacian(original_image);
        otherwise
            errordlg('未选择有效的边缘检测算子', '错误');
            return;
    end
    % 显示边缘检测后的图像
    axes(handles.axes2);
    imshow(edge_image);
    title(['应用的边缘检测算子: ', selected_operator]);

    function popupmenu3_Callback(hObject, eventdata, handles)
    % popupmenu3_Callback 处理用户选择的特征提取类型
    % hObject    handle to popupmenu3 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % 获取用户选择的特征提取类型
    contents = cellstr(get(hObject, 'String'));
    selected_feature = contents{get(hObject, 'Value')};

    % 确保原始图像存在
    if isfield(handles, 'input_image')
        input_image = handles.input_image;

        % 特征提取
        switch selected_feature
            case 'LBP'
                % 计算 LBP 特征
                lbp_image = LBP_features(input_image);
                % 在 axes4 中显示原图的 LBP 特征图
                axes(handles.axes4);
                cla reset;
                imshow(lbp_image);
                title('原图的 LBP 特征');

            case 'HOG'
                % 计算原图的 HOG 特征
                hog_image = HOG_features(rgb2gray(input_image));
                % 在 axes4 中显示原图和 HOG 特征可视化
                axes(handles.axes4);
                cla reset;
                imshow(hog_image,[0 max(max(hog_image))]);
                title('原图的 HOG 特征');

            otherwise
                disp('未选择有效的特征提取类型。');
        end
        
        % 检查提取的目标是否存在
        if isfield(handles, 'extracted_target')
            target_image = handles.extracted_target;  % 获取提取的目标

            switch selected_feature
                case 'LBP'
                    % 计算提取目标的 LBP 特征
                    lbp_target_image = LBP_features(target_image);
                    % 在 axes5 中显示提取目标的 LBP 特征
                    axes(handles.axes5);
                    cla reset;
                    imshow(lbp_target_image);
                    title('提取目标的 LBP 特征');

                case 'HOG'
                    % 计算提取目标的 HOG 特征                    
                    hog_target_image = HOG_features(rgb2gray(target_image));
                    % 在 axes5 中显示提取目标的 HOG 特征可视化
                    axes(handles.axes5);
                    cla reset;
                    imshow(hog_target_image,[0 max(max(hog_target_image))]);
                    title('提取目标的 HOG 特征');

                otherwise
                    disp('未选择有效的特征提取类型。');
            end
        else
            disp('提取目标不存在，请先提取目标。');
        end
    else
        disp('请先加载一张图像。');
    end

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3


% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton8.
    function pushbutton8_Callback(hObject, eventdata, handles)
    % 确保原始图像存在
    if isfield(handles, 'input_image')
        input_image = handles.input_image;
        
        % 在这里进行图像处理（例如，提取目标）
        [result, img_foreground] = single_image_seg_hsv(input_image);
        
        % 显示提取的目标图像在 axes3 中
        axes(handles.axes2);
        imshow(img_foreground); % 显示提取的前景
        title('提取的目标');

        % 将提取的目标存储在 handles 结构中
        handles.extracted_target = img_foreground;  % 存储提取的目标
        guidata(hObject, handles); % 更新 handles 结构
    else
        disp('请先加载一张图像。');
    end

% --- Executes during object creation, after setting all properties.
function axes3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes3


% --- Executes during object creation, after setting all properties.
function axes4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes4


% --- Executes during object creation, after setting all properties.
function axes5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes5


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
     % 检查是否已加载图像路径
    if ~isfield(handles, 'imagePath') || isempty(handles.imagePath)
        errordlg('请先加载一张图像。', 'Error');
        return;
    end

     % 添加路径到 Python 环境
    py.sys.path().append('D:/Code/matlab/Bird_Image_Processing');
   
    % 导入 Python 模块 'train'
    py.importlib.import_module('train');  
   
    model = 'D:/Code/matlab/Bird_Image_Processing/best.pt';
   
    % 从 Python 获取预测结果
    try
        result = py.train.img_pre(handles.imagePath, model);  % 获取预测结果
        
        % 将 Python 字符串转换为 MATLAB 字符串
        resultStr = char(result);
        
        % 如果结果为空或不可识别，显示 "无法识别的"
        if isempty(resultStr) || strcmp(resultStr, '')
            resultStr = '无法识别的';
        end
        
    catch
        % 如果发生错误，显示 "无法识别的"
        resultStr = '无法识别的';
    end
    
    % 将预测结果显示在 GUI 中
    set(handles.text12, 'String', resultStr);

function pushbutton10_Callback(hObject, eventdata, handles)
     [filename, pathname] = uigetfile({'*.jpg;*.png;*.bmp;*.tif', 'Image Files (*.jpg, *.png, *.bmp, *.tif)'}, ...
                                      'Select an Image File');
    if isequal(filename, 0)
        disp('User selected Cancel');
    else
        % 读取图像
        fullpath = fullfile(pathname, filename);
        img1 = imread(fullpath);  % 使用不同的变量名
        
        % 存储原始图像
        handles.img1 = img1; 
        guidata(hObject, handles); % 更新handles结构
        
        % 显示原始图像
        axes(handles.axes2); 
        imshow(img1); 
        title('原图 1');
        
        % 计算并显示灰度直方图
        gray_image1 = rgb2gray(img1); % 转换为灰度图像
        axes(handles.axes4); % 在 axes3 中显示直方图
        cla reset; % 清空当前轴
        imhist(gray_image1); % 显示灰度直方图
        title('灰度直方图 1');
    end


function pushbutton11_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton11 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % 确保有两个图像可以进行直方图匹配
    if ~isfield(handles, 'input_image') || ~isfield(handles, 'img1')
        msgbox('请确保已加载两个图像以进行直方图匹配', '错误', 'error');
        return;
    end
    
    % 获取图像
    img1 = handles.input_image;  % 源图像
    img2 = handles.img1;  % 参考图像
    
    
    % 调用直方图匹配函数
    matched_image = histogram_matching(img1, img2);
    
    % 显示匹配后的图像
    axes(handles.axes5);
    cla reset;
    imshow(matched_image);
    title('直方图匹配后的图像');
    
