function noisesignal_figure(source_t,receive_signal,freq_id,freq_signal,id,Fs)
%noisesignal_figure 画出不同信噪比高斯白噪声污染下的信号时域图和频谱图
    figure;
    subplot(2,3,1);
    plot(source_t,receive_signal(1,:),'r');
    xlabel('时间t')
    ylabel('幅值')
    title('5dB噪声污染的信号')
    subplot(2,3,2);
    plot(source_t,receive_signal(2,:),'g');
    xlabel('时间t')
    ylabel('幅值')
    title('10dB噪声污染的信号')
    subplot(2,3,3);
    plot(source_t,receive_signal(3,:),'b');
    xlabel('时间t')
    ylabel('幅值')
    title('15dB噪声污染的信号')
    subplot(2,3,4);
    plot(source_t,receive_signal(4,:),'c');
    xlabel('时间t')
    ylabel('幅值')
    title('20dB噪声污染的信号')
    subplot(2,3,5);
    plot(source_t,receive_signal(5,:),'m');
    xlabel('时间t')
    ylabel('幅值')
    title('25dB噪声污染的信号')
    subplot(2,3,6);
    plot(source_t,receive_signal(6,:),'y');
    xlabel('时间t')
    ylabel('幅值')
    title('30dB噪声污染的信号')
    
    figure
    subplot(2,3,1);
    plot(freq_id,abs(freq_signal(1,id))*2/Fs,'k');
    xlabel('频率/Hz'); ylabel('幅值')
    title('(5dB)幅值谱图')
    subplot(2,3,2);
    plot(freq_id,abs(freq_signal(2,id))*2/Fs,'k');
    xlabel('频率/Hz'); ylabel('幅值')
    title('(10dB)幅值谱图')
    subplot(2,3,3);
    plot(freq_id,abs(freq_signal(3,id))*2/Fs,'k');
    xlabel('频率/Hz'); ylabel('幅值')
    title('(15dB)幅值谱图')
    subplot(2,3,4);
    plot(freq_id,abs(freq_signal(4,id))*2/Fs,'k');
    xlabel('频率/Hz'); ylabel('幅值')
    title('(20dB)幅值谱图')
    subplot(2,3,5);
    plot(freq_id,abs(freq_signal(5,id))*2/Fs,'k');
    xlabel('频率/Hz'); ylabel('幅值')
    title('(25dB)幅值谱图')
    subplot(2,3,6);
    plot(freq_id,abs(freq_signal(6,id))*2/Fs,'k');
    xlabel('频率/Hz'); ylabel('幅值')
    title('(30dB)幅值谱图')
end