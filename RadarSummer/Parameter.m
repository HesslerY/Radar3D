function Parameter()
global C Lambda PulseNum BandWidth TimeWidth PRT PRF Fs NoisePower Fc
%% Radar Parameter
C=3.0e8;  %����(m/s)
Fc=200e9;  %�״���Ƶ 1.57GHz
Lambda=C/Fc;    %�״﹤������
PulseNum=24;   %�ز�������
BandWidth=4.0e6;  %�����źŴ��� ����B=1/�ӣ�����������
TimeWidth=4.0e-8; %�����ź�ʱ��
PRT=8e-7;   % �״﷢�������ظ�����(s),240us��Ӧ1/2*240*300=36000�������ģ������
PRF=1/PRT;
Fs=2.5e10;  %����Ƶ��
NoisePower=5;%(dB);%�������ʣ�Ŀ��Ϊ0dB��