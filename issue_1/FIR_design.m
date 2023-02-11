clc;
clear;

%%%%%%%%%%%%%%%%%%%%导入发送语音信号%%%%%%%%%%%%%%%%%%%%%
[source,Fs] = audioread('newgaoshan.wav');
source = source';                  %导入语音信号为双声道信号
source_t = 1:1:length(source);     %原语音信号时间向量
figure(1)
plot(source_t,source);
xlabel('时间t')
ylabel('幅值')
title('读入语音信号的时域图')

%%%%%%%%%%%%%%%%%%%信号加噪环节%%%%%%%%%%%%%%%%%
send_signal = source;                             %发送已调信号
SNR = [5,10,15,20,25,30];                         %5种信噪比
trans_signal = zeros(6,length(send_signal));      %存储5种不同信噪比下的传输信号
receive_signal = zeros(6,length(send_signal));
for j = 1:6
    trans_signal(j,:) = awgn(send_signal,SNR(j)); %信道传输引入加性高斯噪声
    receive_signal = trans_signal;                %接收信号
end

%%%%%%%%%%%%%%%%%%%频域变换%%%%%%%%%%%%%%%%%
len_of_signal = Fs;                                   %信号长度     
fs = Fs;                                              %采样率
id = 1:len_of_signal/2+1;                             %设置索引号序列
freq_id = (id-1)*len_of_signal/fs;                    %设置频率刻度
freq_orignal = fft(send_signal,len_of_signal);
freq_signal = zeros(6,len_of_signal);
for i = 1:6
    freq_signal(i,:) = fft(receive_signal(i,:),len_of_signal);
end

%%%%%%%%%%%%%%%%%%%低通滤波参数设置%%%%%%%%%%%%%%%%%
freq_pass = 5000;             %通带截止频率
freq_stop = 8000;             %阻带截止频率
wp = 2 * pi * freq_pass/Fs;                          
ws = 2 * pi * freq_stop/Fs;                         
wc = (wp + ws)/2;             %理想低通滤波器截止范围  
delta_w = ws - wp;            %过渡带宽 

%%%%%%%%%%%%%%%%%%%%矩形窗函数滤波%%%%%%%%%%%%%%%%%%
N_box = ceil(1.8*pi/delta_w);     %窗长                   
hd_box = Ideal_lpf(wc,N_box);     %FIR脉冲响应                
wd_box = boxcar(N_box)';                     
h_box = hd_box.*wd_box;                         
[H_box,w] = freqz(h_box ,1);       
figure;
plot( w/pi, 10*log10(abs(H_box)));
title('矩形窗频率响应');

%%%%%%%%%%%%%%%%%%布莱克曼窗函数滤波%%%%%%%%%%%%%%%%%
N_blackman = ceil(6.1*pi/delta_w);
wdblack = blackman(N_blackman)';
hd_blackman = Ideal_lpf(wc,N_blackman);
h_blackman = hd_blackman.*wdblack;
[H_blackman,w] = freqz(h_blackman,1);
figure;
plot( w/pi , 10*log10(abs(H_blackman)));
title('布莱克曼窗频率响应');

%%%%%%%%%%%%%%%%%%%低通滤波器去噪%%%%%%%%%%%%%%%%%
box_signal = zeros(6,length(source));           %矩形窗函数低通滤波去噪(时域)
blackman_signal = zeros(6,length(source));      %布莱克曼窗函数低通滤波去噪(时域)
freq_box_signal = zeros(6,len_of_signal);       %矩形窗函数低通滤波去噪(频域)
freq_blackman_signal = zeros(6,len_of_signal);  %布莱克曼窗函数低通滤波去噪(频域)

for k = 1:6
    box_signal(k,:) = fftfilt(h_box,receive_signal(k,:),Fs);
    freq_box_signal(k,:) = fft(box_signal(k,:),len_of_signal);
    blackman_signal(k,:) = fftfilt(h_blackman,receive_signal(k,:),Fs);
    freq_blackman_signal(k,:) = fft(blackman_signal(k,:),len_of_signal);
end

%%%%%%%%%%%%%%%%%%%%%%%%作图%%%%%%%%%%%%%%%%%%%%
%原信号频谱图
figure
plot(freq_id,abs(freq_orignal(id))*2/Fs,'k');
xlabel('频率/Hz'); ylabel('幅值')
title('原信号幅值谱图')

%画出高斯白噪声不同信噪比下信号的时域图和频谱图
noisesignal_figure(source_t,receive_signal,freq_id,freq_signal,id,Fs);
%画出使用矩形窗低通滤波去噪后信号的时域和频域图
box_figure(source_t,box_signal,freq_id,freq_box_signal,id,Fs);
%画出使用布莱克曼窗低通滤波去噪后信号的时域和频域图
blackman_figure(source_t,blackman_signal,freq_id,freq_blackman_signal,id,Fs);

%%%%%%%%%%%%%%%%%%%%%%%%导出语音文件%%%%%%%%%%%%%%%%%%%%
audiowrite('Noise_signal\Noise_5dB.wav',receive_signal(1,:),Fs);
audiowrite('Noise_signal\Noise_10dB.wav',receive_signal(2,:),Fs);
audiowrite('Noise_signal\Noise_15dB.wav',receive_signal(3,:),Fs);
audiowrite('Noise_signal\Noise_20dB.wav',receive_signal(4,:),Fs);
audiowrite('Noise_signal\Noise_25dB.wav',receive_signal(5,:),Fs);
audiowrite('Noise_signal\Noise_30dB.wav',receive_signal(6,:),Fs);
 
audiowrite('Noise_reduction\box_5dB.wav',box_signal(1,:),Fs);
audiowrite('Noise_reduction\box_10dB.wav',box_signal(2,:),Fs);
audiowrite('Noise_reduction\box_15dB.wav',box_signal(3,:),Fs);
audiowrite('Noise_reduction\box_20dB.wav',box_signal(4,:),Fs);
audiowrite('Noise_reduction\box_25dB.wav',box_signal(5,:),Fs);
audiowrite('Noise_reduction\box_30dB.wav',box_signal(6,:),Fs);

audiowrite('Noise_reduction\blackman_5dB.wav',blackman_signal(1,:),Fs);
audiowrite('Noise_reduction\blackman_10dB.wav',blackman_signal(2,:),Fs);
audiowrite('Noise_reduction\blackman_15dB.wav',blackman_signal(3,:),Fs);
audiowrite('Noise_reduction\blackman_20dB.wav',blackman_signal(4,:),Fs);
audiowrite('Noise_reduction\blackman_25dB.wav',blackman_signal(5,:),Fs);
audiowrite('Noise_reduction\blackman_30dB.wav',blackman_signal(6,:),Fs);