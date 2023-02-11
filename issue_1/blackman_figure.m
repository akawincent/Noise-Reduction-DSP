function blackman_figure(source_t,blackman_signal,freq_id,freq_blackman_signal,id,Fs)
%box_figure 画出使用矩形窗低通滤波去噪后信号的时域和频域图
    figure;
    subplot(2,3,1);
    plot(source_t,blackman_signal(1,:),'r');
    xlabel('时间t')
    ylabel('幅值')
    title('5dB去噪恢复信号（blackman窗）')
    subplot(2,3,2);
    plot(source_t,blackman_signal(2,:),'g');
    xlabel('时间t')
    ylabel('幅值')
    title('10dB去噪恢复信号（blackman窗）')
    subplot(2,3,3);
    plot(source_t,blackman_signal(3,:),'b');
    xlabel('时间t')
    ylabel('幅值')
    title('15dB去噪恢复信号（blackman窗）')
    subplot(2,3,4);
    plot(source_t,blackman_signal(4,:),'c');
    xlabel('时间t')
    ylabel('幅值')
    title('20dB去噪恢复信号（blackman窗）')
    subplot(2,3,5);
    plot(source_t,blackman_signal(5,:),'m');
    xlabel('时间t')
    ylabel('幅值')
    title('25dB去噪恢复信号（blackman窗）')
    subplot(2,3,6);
    plot(source_t,blackman_signal(6,:),'y');
    xlabel('时间t')
    ylabel('幅值')
    title('30dB去噪恢复信号（blackman窗）')

    figure
    subplot(2,3,1);
    plot(freq_id,abs(freq_blackman_signal(1,id))*2/Fs,'k');
    xlabel('频率/Hz'); ylabel('幅值')
    title('5db去噪幅值谱图')
    subplot(2,3,2);
    plot(freq_id,abs(freq_blackman_signal(2,id))*2/Fs,'k');
    xlabel('频率/Hz'); ylabel('幅值')
    title('10db去噪幅值谱图')
    subplot(2,3,3);
    plot(freq_id,abs(freq_blackman_signal(3,id))*2/Fs,'k');
    xlabel('频率/Hz'); ylabel('幅值')
    title('15db去噪幅值谱图')
    subplot(2,3,4);
    plot(freq_id,abs(freq_blackman_signal(4,id))*2/Fs,'k');
    xlabel('频率/Hz'); ylabel('幅值')
    title('20db去噪幅值谱图')
    subplot(2,3,5);
    plot(freq_id,abs(freq_blackman_signal(5,id))*2/Fs,'k');
    xlabel('频率/Hz'); ylabel('幅值')
    title('25db去噪幅值谱图')
    subplot(2,3,6);
    plot(freq_id,abs(freq_blackman_signal(6,id))*2/Fs,'k');
    xlabel('频率/Hz'); ylabel('幅值')
    title('30db去噪幅值谱图')
end