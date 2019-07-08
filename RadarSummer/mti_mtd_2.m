close all;
clear all;
clc;
% ===================================================================================%
%                                    �״����                                        %
% ===================================================================================%
C=3.0e8;  %����(m/s)
f0=30e6;  %�״���Ƶ
Lambda=C/f0;%�״﹤������  Ϊ10m
PulseNumber=16;   %�ز������� 
BandWidth=4.0e6;  %�����źŴ���
TimeWidth=10.0e-6; %�����ź�ʱ��
PRT=1e-3;   % �״﷢�������ظ�����(s),  ���̽�����Ϊ1/2 * 3 *10^5 = 150000M
Pf0=1/PRT;%�״﷢�������ظ�Ƶ�ʣ�Hz�� 
fs=100.0e6;  %����Ƶ��
NoisePower=-8;%(dB);%�������ʣ�Ŀ��Ϊ0dB��
fc = f0-0.5*BandWidth; %�״����ʼƵ��

% ---------------------------------------------------------------%
SampleNumber=fix(fs*PRT);%����һ���������ڵĲ�������200 000 ��
TotalNumber=SampleNumber*PulseNumber;%�ܵĲ�������200 000*16=3200 000��
BlindNumber=fix(fs*TimeWidth);%����һ���������ڵ�ä��-�ڵ�������84��

%===================================================================================%
%                                    Ŀ�����                                       %
%===================================================================================%
 TargetNumber=4;%Ŀ�����
SigPower(1:TargetNumber)=[1 0 1 1];%Ŀ�깦��,�����٣�����Ϊ[1 1 0.5 1]��
 TargetDistance(1:TargetNumber)=[30000  67500 12000 55020];%Ŀ�����,  
 DelayNumber(1:TargetNumber)=fix(fs*2*TargetDistance(1:TargetNumber)/C);% ��Ŀ����뻻��ɲ����㣨�����ţ�
TargetVelocity(1:TargetNumber)=[0 10000 1875 937.5];%Ŀ�꾶���ٶ� ��λm/s  
TargetFd(1:TargetNumber)=2*TargetVelocity(1:TargetNumber)/Lambda; %����Ŀ�������// �״﹤������Lambda=0.1911,TargetFd=[523,1047,0,3234]
%====================================================================================%
%                                   �������Ե�Ƶ�ź�                                  %
%====================================================================================%
 number=fix(fs*TimeWidth);%�ز��Ĳ�������=��ѹϵ������=��̬����Ŀ+1  //number=84��
if rem(number,2)~=0
   number=number+1;%��֤numberΪż������Ϊ������1��ż��
end   

for i=0:fix(number)-1
   Chirp(i+1)=cos(2*pi*fc*(i/fs)+pi*(BandWidth/TimeWidth)*(i/fs)^2);%exp(j*pi*u*(t^2));
end
figure(1);subplot(2,1,1),plot(Chirp);
Chirp_fft = abs(fft(Chirp(1:number)));
subplot(2,1,2),plot((0:fs/ number:fs/2-fs/ number),abs(Chirp_fft(1: number/2)));
title('�����ź�Ƶ��');
%====================================================================================%
%                                   �����������                                     %
%====================================================================================%
n = 0:fix(number)-1;
M = 131126;     %131126��fft
local_oscillator_i=cos(n*f0/fs*2*pi);%i·�����ź�
local_oscillator_q=sin(n*f0/fs*2*pi);%q·�����ź�
fbb_i=local_oscillator_i.*Chirp;%i·���   �Ƚ���һ����Ԫ���������ѹ��ϵ��
fbb_q=local_oscillator_q.*Chirp;%q·���
window=chebwin(51,40); %�б�ѩ�򴰺���
[b,a]=fir1(50,2*BandWidth/fs,window); %b a �ֱ��Ǿ��˲�������ķ��ӷ�ĸϵ������
fbb_i=[fbb_i,zeros(1,25)];  %��Ϊ��FIR�˲�����25���������ڵ��ӳ٣�Ϊ�˱�֤���е���Ч��Ϣȫ��ͨ���˲�����������źź�����չ��25��0
fbb_q=[fbb_q,zeros(1,25)];
fbb_i=filter(b,a,fbb_i);   %I · Q·�źž�����ͨ�˲���
fbb_q=filter(b,a,fbb_q);
fbb_i=fbb_i(26:end);%��ȡ��Ч��Ϣ
fbb_q=fbb_q(26:end);%��ȡ��Ч��Ϣ  
fbb=fbb_i+j*fbb_q;
fbb_fft_result = fft(fbb);
figure(2);subplot(2,1,1),plot(fbb_i);
xlabel('t(��λ����)');title('�״﷢���ź����ڽ����I·�ź�');
subplot(2,1,2),plot(fbb_q);
xlabel('t(��λ����)');title('�״﷢���ź����ڽ����Q·�ź�');
figure(3)
plot((0:fs/number:fs/2-fs/number),abs(fbb_fft_result(1:number/2)));
xlabel('Ƶ��f(��λ Hz)');title('�״﷢���ź����ڽ���źŵ�Ƶ��');
%====================================================================================%
%                                   ��������ѹ��                                     %
%====================================================================================%

coeff=conj(fliplr(fbb));%������ѹϵ��  //Chirp��һ��1*84˫���ȵ�������fliplr��x��ʵ�־������ҷ�ת(ƥ���˲���h(t)���������źŵķ�ת�����ӳ٣�����û�����ӳ�)��conj���������Ĺ��

%====================================================================================%
%                                   ����Ŀ��ز�                                     %
%====================================================================================%
%-------------------------����Ŀ��ز���-----------------------------------------------------------------------------------------%
SignalAll=zeros(1,TotalNumber);%����������ź�,����0
for k=1% ���β�������Ŀ��
   SignalTemp=zeros(1,SampleNumber);% һ������480
   SignalTemp(DelayNumber(k)+1:DelayNumber(k)+number)=sqrt(SigPower(k))*Chirp;%���Ե�Ƶ���������źŵĸ����磻
   %Ŀ��һ��41��124��41+83�� Ŀ�����Ŀ������108-191��108+83��Ŀ���ģ�305-388��305+83������Ŀ�����Ŀ�����ǽ��е���
   %һ�������1��Ŀ�꣨δ�Ӷ������ٶȣ�DelayNumber=[40 107 107 304];
   %number=84 ��ʾ���ǶԷ����źŵĲ�������;SigPower(1:TargetNumber)=[1 1 0.25 1]Ŀ�깦��,������;
   Signal=zeros(1,TotalNumber);
   for i=1:PulseNumber   %�ز������� 
       Signal((i-1)*SampleNumber+1:i*SampleNumber)=SignalTemp;%16�������ظ���ֵ��
   end
   FreqMove=cos(2*pi*TargetFd(k)*(0:TotalNumber-1)/fs);
   %Ŀ��Ķ������ٶ�*ʱ��=Ŀ��Ķ���������
   %���������Ŀ�����Ŀ�����Ĳ�ͬ����Ȼ��ͼ��������ʾ��������һ���ģ�����Ⱥ�����Ҳ�����˱任
   %TargetFd=[523,1047,0,3234]
   Signal=Signal.*FreqMove;%�Ӷ�����Ƶ�ƣ�
   SignalAll=SignalAll+Signal;
end
figure(4);
subplot(2,1,1);plot(real(SignalAll),'r-');title('û�м������ͱ����������£���⵽��Ŀ���źŵ�ʵ��');

%====================================================================================%
%                                   ����ϵͳ�����ź�                                  %
%====================================================================================%
%SystemNoise=normrnd(0,10^(NoisePower/10),1,TotalNumber)+j*normrnd(0,10^(NoisePower/10),1,TotalNumber);
SystemNoise=normrnd(0,10^(NoisePower/10),1,TotalNumber);
% %====================================================================================%
% %                                   �ܵĻز��ź�                                     %
% %====================================================================================%
 Echo=SignalAll+SystemNoise;% +SeaClutter+TerraClutter;�Ӹ�˹������
 %Echo=SignalAll;% +SeaClutter+TerraClutter;�Ӹ�˹������
% for i=1:PulseNumber   %�ڽ��ջ�������,���յĻز�Ϊ0
%       Echo((i-1)*SampleNumber+1:(i-1)*SampleNumber+number)=0;
%       %��1��84�ز��ź�����Ϊ�㣬�������ڣ������84Ϊ�źŲ���������
%       %�ᵼ��Ŀ��һ�Ĳ��ֻز��ź�40-84Ϊ�㣬�������ڲ�����ֻ�����źţ�
% end
figure(3);
subplot(2,1,1);plot(real(Echo));title('�ܻز��źŵ�ʵ��,������Ϊ0');grid on;
subplot(2,1,2);plot(imag(Echo));title('�ܻز��źŵ��鲿,������Ϊ0');grid on;%ͼ2ʼ��40�㣬ͼ3ʼ��85��

%====================================================================================%
%                                   �Իز�Ŀ�괮�����������                          %
%====================================================================================%
Echo_number=PulseNumber*PRT*fs;
n=0:Echo_number-1;
local_oscillator_i=cos(n*f0/fs*pi);%I·�����ź�
local_oscillator_q=cos(n*f0/fs*pi);%Q·�����ź�
s_echo_i=local_oscillator_i.* Echo;%I·���
s_echo_q=local_oscillator_q.* Echo;%Q·���
window=chebwin(51,40);%���ǲ�50��cheby����FIR��ͨ�˲���
[b,a]=fir1(50,2*BandWidth/fs,window);
s_echo_i=[s_echo_i,zeros(1,25)];
s_echo_q=[s_echo_q,zeros(1,25)];
s_echo_i=filter(b,a,s_echo_i);
s_echo_q=filter(b,a,s_echo_q);
s_echo_i=s_echo_i(26:end);%��ȡ��Ч��Ϣ
s_echo_q=s_echo_q(26:end);%��ȡ��Ч��Ϣ
s_echo_mf=s_echo_i+j*s_echo_q;
figure(4)
subplot(2,1,1),plot((0:1/fs:PulseNumber*PRT-1/fs),s_echo_i);
xlabel('t(unit:s)'); title('�״�ز��źŽ�����I·�ź�');

subplot(2,1,2),plot((0:1/fs:PulseNumber*PRT-1/fs),s_echo_q);
xlabel('t(unit:s)'); title('�״�ز��źŽ�����q·�ź�');

%====================================================================================%
%                      ���Ѿ���������Ļز��ź�����ѹ��                               %
%====================================================================================%
coeff_fft=fft(coeff,M);
for i=1:PulseNumber
     s_echo_fft_result=fft(s_echo_mf(1,(i-1)*PRT*fs+1:i*PRT*fs),M);
     s_pc_fft=s_echo_fft_result.*coeff_fft;
     s_pc_result(i,:)=ifft(s_pc_fft,M);    
end

figure(6);
plot(abs(s_pc_result(1,:)));%һ������������ֵ��������Ϊ40 107 304

s_pc_result_1=s_pc_result;
s_pc_result_1=reshape((s_pc_result_1)',1,PulseNumber*M);   %%%%%%%%%%ע�⣬��������reshape�������㷨����Ҫ������ת�ò�����β����һ��
figure(5),subplot(2,1,1),plot((0:1/fs:PulseNumber*M/fs-1/fs),abs(s_pc_result_1)),
%N_echo_frame*T_frame-ts
xlabel('t(��λ:s)'),title('����ѹ�����������ʵ����');
subplot(2,1,2),plot((0:1/fs:PulseNumber*M/fs-1/fs),imag(s_pc_result_1)),
xlabel('t(��λ:s)'),title('����ѹ������������鲿��');

%====================================================================================%
%                      MTI                                                           %
%====================================================================================%

for i=1:PulseNumber-1  %��������������һ������
   mti(i,:)=s_pc_result(i+1,:)-s_pc_result(i,:);
end
figure(7);
mesh(abs(mti));title('MTI  result');



%====================================================================================%
%                      MTD                                                           %
%====================================================================================%
% mtd=zeros(PulseNumber,SampleNumber);
% for i=1:SampleNumber
%    buff(1:(PulseNumber))= s_pc_resultmt(1:PulseNumber,i);
%    buff_fft=fftshift(fft(buff)); %��fftshift����Ƶ���Ƶ��м� �������Է���۲��ٶ�����
%    mtd(1:PulseNumber,i)=buff_fft(1:PulseNumber)';
% end
% x=0:1:SampleNumber-1;
% y=-8:1:7;%ͨ��������������ͨ�����˵�λֵ�����ٶ�ֵ��
% figure(8);mesh(x,y,abs(mtd));title('MTD  result');

mtd=zeros(PulseNumber,SampleNumber);
for i=1:SampleNumber
   buff(1:(PulseNumber-1))= mti(1:(PulseNumber-1),i);
   buff_fft=fftshift(fft(buff)); %��fftshift����Ƶ���Ƶ��м� �������Է���۲��ٶ�����
   mtd(1:PulseNumber-1,i)=buff_fft(1:PulseNumber-1)';
end
x=0:1:SampleNumber-1;
y=-7:1:8;%ͨ��������������ͨ�����˵�λֵ�����ٶ�ֵ��
figure(8);mesh(x,y,abs(mtd));title('MTD  result');