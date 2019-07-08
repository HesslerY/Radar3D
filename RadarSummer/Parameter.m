function Parameter()
global C Lambda PulseNum BandWidth ...
    TimeWidth PRT PRF Fs NoisePower Fc WaveNum
%% Radar Parameter
C=3.0e8;  %����(m/s)
Fc=100e6;  %�״���Ƶ 1.57GHz
Lambda=C/Fc;    %�״﹤������
PulseNum=24;   %�ز�������
BandWidth=2e8;  %�����źŴ��� ����B=1/�ӣ�����������
TimeWidth=4.0e-8; %�����ź�ʱ��
PRT=8e-7;   % �״﷢�������ظ�����(s),
%240us��Ӧ1/2*240*300=36000�������ģ������
PRF=1/PRT;
Fs=2.5e10;  %����Ƶ��
NoisePower=5;%(dB);%�������ʣ�Ŀ��Ϊ0dB��

WaveNum=fix(Fs*TimeWidth);%�ز��Ĳ�������=��ѹϵ������=��̬����Ŀ+1
if mod(WaveNum,2)~=0
    WaveNum=WaveNum+1;
end   %��WaveNum��Ϊż��

%����ĵ�һ�������ǣ�Ft��Wavenum���εļ�����󣬻���˵ÿ��2pi��������һ���Ĳ�����
% �����ں���ͼ���Ͽ��������Chirp����

carSeries = [5,4.5,2.0,1.2;3,8,2.5,3];
save CarSeries.mat carSeries;
end
