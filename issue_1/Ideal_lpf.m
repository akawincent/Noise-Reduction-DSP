function my_output = Ideal_lpf(wc,N)
%理想低通滤波器
%[hd]=Ideal_lpf(wc,N)
% hd：理想单位脉冲响应
% wc：理想截止频率
% N： 窗长
%
    alpha=(N-1)/2;
    n=0:1:(N-1);
    m=n-alpha+eps;
    my_output=sin(wc*m)./(pi*m);
end
