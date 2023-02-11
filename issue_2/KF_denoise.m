clc;
clear;

tic

%% 导入语音信号
[source,fs] = audioread('newgaoshan.wav');   %导入语音信号和采样频率
t = (0 : 1/fs : (length(source)-1)/fs)';     %计算语音信号持续时间

%% 加噪
SNR = 20;                          %信噪比
noise_signal = awgn(source,SNR);   %高斯白噪声污染后的信号

%% 分帧
frame_sec = 0.34;                                    %单位帧时长
frame_move_rate = 1;                                 %帧移比例
frame_sample = ceil(frame_sec * fs);                 %每帧的样本数
sample_move = ceil(frame_sample * frame_move_rate);  %帧移的样本数
frame_num = ceil((length(source) - frame_sample) / sample_move); %帧数
frame_signal = zeros(frame_num,frame_sample); %为分帧后的带噪声信号分配内存
source_frame= zeros(frame_num,frame_sample);  %为分帧后的原始信号分配内存 
for i = 1 : frame_num
   interval = (i - 1) * (sample_move) + (1 : frame_sample);
   frame_signal(i, :) = noise_signal(interval);    %带噪声信号分帧
   source_frame(i,:) = source(interval);           %原始信号分帧
end

%% 线性建模
AR_order = 400;                     %AR模型阶数 400阶线性模型
[AR_coeff, Q] = lpc(source_frame', AR_order); %每帧原始语音的AR模型系数arCoeff和过程噪声方差Q、

%% 初始化参数
H = [zeros(1, AR_order - 1), 1];   %观测矩阵
R = var(noise_signal);             %测量噪声方差
P = R * eye(AR_order);             %后验估计误差协方差矩阵初始化为测量方程噪声方差
Est_filter_signal = noise_signal(1 : AR_order,1);  %初始化后验估计
filter_signal = zeros(1, length(noise_signal));    %为输出信号分配内存
filter_signal(1:AR_order) = noise_signal(1 : AR_order, 1)'; % 初始化输出信号，

%% 卡尔曼滤波过程
for k = 1:frame_num                 %对每一帧进行卡尔曼滤波
    % 初始化开始进行卡尔曼滤波的位置
    if k == 1 
        iiStart = AR_order + 1; %如果是第一帧，则从第arOrder+1个点开始处理
    end
    %得到当前帧的信号状态方程的系数矩阵A
    A = [zeros(AR_order - 1, 1), eye(AR_order - 1); fliplr(-AR_coeff(k, 2 : end))]; % fliplr:左右翻转
    for ii = iiStart : frame_sample
	    % 计算先验估计
		aheadEstOutput = A * Est_filter_signal;		
		% 计算先验估计误差的协方差矩阵p-
		aheadErrCov  = A * P * A' + H' * Q(k) * H;
		% 计算卡尔曼增益
		K = (aheadErrCov * H') / (H * aheadErrCov * H' + R);
		% 计算后验估计
		Est_filter_signal = aheadEstOutput + K * (frame_signal(k, ii) - H * aheadEstOutput);
		% 更新输出结果
		index = ii - iiStart + AR_order + 1 + (k - 1) * frame_sample;
		filter_signal(index - AR_order + 1 : index) = Est_filter_signal';
		% 计算后验估计误差的协方差矩阵p
		P  = (eye(AR_order) - K * H) * aheadErrCov;
    end
    iiStart = 1;
end
filter_signal = filter_signal';


len_of_signal = fs;                                 %信号频率范围长度                                            
id = 1:len_of_signal/2+1;                           %设置索引号序列
freq_id = (id-1)*len_of_signal/fs;                  %设置频率刻度
freq_noise = fft(noise_signal,len_of_signal);       %带噪声信号的频域图
freq_original = fft(source,len_of_signal);          %原始信号的频域图
freq_filtered = fft(filter_signal,len_of_signal);   %去噪后的信号频域图
%% 画出结果
figure
subplot(311);
plot(t, source)
xlabel('Time/s')
ylabel('Amlitude')
title('原始语音信号时域图')

subplot(312);
plot(t, noise_signal)
xlabel('Time/s')
ylabel('Amlitude')
title('20dB带噪声信号时域图')

subplot(313);
plot(t, filter_signal(1:length(t)))
xlabel('Time/s')
ylabel('Amlitude')
title('卡尔曼滤波后的信号时域图')

figure
plot(freq_id,abs(freq_original(id))*2/fs,'k');
xlabel('频率/Hz'); ylabel('幅值')
title('原信号频域图')

figure
plot(freq_id,abs(freq_noise(id))*2/fs,'k');
xlabel('频率/Hz'); ylabel('幅值')
title('20dB高斯白噪声污染的信号频域图')

figure
plot(freq_id,abs(freq_filtered(id))*2/fs,'k');
xlabel('频率/Hz'); ylabel('幅值')
title('卡尔曼滤波后的信号频域图')

audiowrite('Noise_20dB.wav',noise_signal,fs);
audiowrite('Noise_reduction_20dB.wav',filter_signal,fs);

toc
disp(['运行时间: ',num2str(toc)]);