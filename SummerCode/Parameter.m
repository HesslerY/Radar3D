function Parameter()
global C Lambda PulseNum BandWidth ...
    TimeWidth PRT PRF Fs NoisePower Fc WaveNum...
    mete EnviLength EnviWidth MaxDistance deltaD AllLine ...
    CarDis CarAngle Linewidth Height deltaAngle MinDis
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
NoisePower=-5;%(dB);%�������ʣ�Ŀ��Ϊ0dB��

WaveNum=fix(Fs*TimeWidth);%�ز��Ĳ�������=��ѹϵ������=��̬����Ŀ+1
if mod(WaveNum,2)~=0
    WaveNum=WaveNum+1;
end   %��WaveNum��Ϊż��

%����ĵ�һ�������ǣ�Ft��Wavenum���εļ�����󣬻���˵ÿ��2pi��������һ���Ĳ�����
% �����ں���ͼ���Ͽ��������Chirp����

carSeries = [0.9,4.5,2.0,1.2;1,8,2.5,3];
% �ĸ���Ϣ���ֱ�Ϊ������������������ߡ�
save CarSeries.mat carSeries;

%% ����ΪEnvironment ����Ҫ����ز���
mete = [0,10];
% mete������ڵ���ķ����������һ���Ǳ߽�ķ���������ڶ����ǳ��ķ��������Ĭ�ϳ��ķ��������ͬ
EnviLength = 100;
EnviWidth = 30;
MaxDistance = sqrt(EnviLength^2+EnviWidth^2);
deltaD = 1;%����ֱ���
AllLine = 4;
CarDis = 100;
CarAngle = [-pi/12,pi/24];
Linewidth = 3.5;
Height = 1.2; %�״ﳵ�߶�
deltaAngle = pi/180;%��
MinDis = 1;
end