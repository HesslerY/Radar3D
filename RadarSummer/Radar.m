%% Ŀ�����
close all; clear ; clc;
Parameter()
global C Lambda PulseNum BandWidth TimeWidth PRT PRF Fs NoisePower Fc WaveNum
load('CarSet.mat');
Target = Compen;%xlsread ('Cars.xlsx');%
CarNum = length(Compen);
SigPower = Target((2:CarNum),1)'; %Ŀ�깦��,������
TargetDistance = Target((2:CarNum),2)'; %Ŀ�����,��λm
TargetVelocity = Target((2:CarNum),3)'; %Ŀ���ٶ� ��λm/s
%������Ҫ�޸���Ϊ�ٶ��Ǿ����ٶ�
TargetAngle = round(5*Target((2:CarNum),4)')/5; %Ŀ��Ƕ� ��λ�� �ǶȲ���

DelayNum = fix(Fs*2*TargetDistance/C);% ��Ŀ����뻻��ɲ����㣨�����ţ� 
%fix������0��£ȡ��
TargetFd = 2*TargetVelocity/Lambda;%����Ŀ��ಷ��Ƶ��2v/��


%% �źŲ���-�������Ե�Ƶ�ź�

%[Chirp,Reality] = SigGeneration();
[Chirp,Reality] = SigGeneration(1);

%% ����ѹ��ϵ��
if Reality ==0

    coeff=conj(fliplr(Chirp)); %��Chirp����תȡ���������ѹϵ��
    % �򵥽���һ�¾�������ȡ���� h(t) = x(^*)(t_0-t) �� t_0 = 0 ���龰
    figure(13);
    subplot(2,1,1),plot(real(coeff));
    subplot(2,1,2),plot(imag(coeff));
elseif Reality ==1
    %ʵ�ź���?����
    LocalIQNum = 0:fix(WaveNum)-1;
    M = 131126;     %131126��fft
    local_oscillator_i=cos(LocalIQNum*Fc/Fs*2*pi);%i·�����ź�
    local_oscillator_q=sin(LocalIQNum*Fc/Fs*2*pi);%q·�����ź�
    fbb_i=local_oscillator_i.*RealChirp;%i·���   �Ƚ���һ����Ԫ���������ѹ��ϵ��
    fbb_q=local_oscillator_q.*RealChirp;%q·���
    window=chebwin(51,40); %�б�ѩ�򴰺���
    [b,a]=fir1(50,2*BandWidth/Fs,window); %b a �ֱ��Ǿ��˲�������ķ��ӷ�ĸϵ������
    fbb_i=[fbb_i,zeros(1,25)];  %��Ϊ��FIR�˲�����25���������ڵ��ӳ٣�Ϊ�˱�֤���е���Ч��Ϣȫ��ͨ���˲�����������źź�����չ��25��0
    fbb_q=[fbb_q,zeros(1,25)];
    fbb_i=filter(b,a,fbb_i);   %I · Q·�źž�����ͨ�˲���
    fbb_q=filter(b,a,fbb_q);
    fbb_i=fbb_i(26:end);%��ȡ��Ч��Ϣ
    fbb_q=fbb_q(26:end);%��ȡ��Ч��Ϣ  
    fbb=fbb_i+1i*fbb_q;
    fbb_fft_result = fft(fbb);
    
    figure(14);subplot(2,1,1),plot(real(fbb_fft_result));
    subplot(2,1,2),plot(imag(fbb_fft_result));
    figure(3);subplot(2,1,1),plot(fbb_i);
    xlabel('t(��λ����)');title('�״﷢���ź����ڽ����I·�ź�');
    subplot(2,1,2),plot(fbb_q);
    xlabel('t(��λ����)');title('�״﷢���ź����ڽ����Q·�ź�');
    figure(4)
    plot((0:Fs/WaveNum:Fs/2-Fs/WaveNum),abs(fbb_fft_result(1:WaveNum/2)));
    xlabel('Ƶ��f(��λ Hz)');title('�״﷢���ź����ڽ���źŵ�Ƶ��');
end
%% ��ز�������
totalAngle = 120;
startAngle = 30;
deltaAngle = 3;

AngleNum = totalAngle/deltaAngle;
Sector = startAngle + deltaAngle*(1:AngleNum);

SampleNum=fix(Fs*PRT);%����һ���������ڵĲ���������
AngleCirNum = SampleNum*AngleNum; 
%�����һ���Ƕȵ�һ�������Ե�Ƶ�����������ʣ��39���Ƕȣ����ѭ��16�����壻
TotalNum=SampleNum*PulseNum*AngleNum;%�ܵĲ���������
BlindNum=fix(Fs*TimeWidth);%����һ���������ڵ�ä��-�ڵ���������

%% ����Ŀ��ز���
% ����ǰ3��Ŀ��Ļز���
SignalAll=zeros(1,TotalNum);%����������ź�,����0
for ang = 1:AngleNum
    detect = find (TargetAngle == Sector(ang));
    if ~isempty(detect)
        for k = detect % ���β�������Ŀ��
            fi=2*pi/10 * fix(10*rand);
            SignalTemp=zeros(1,SampleNum);% һ��PRT
            SignalTemp(DelayNum(k)+1:DelayNum(k)+WaveNum)=...
                sqrt(SigPower(k))*exp(1i*fi)*Chirp;
            %һ�������1��Ŀ�꣨δ�Ӷ������ٶȣ�
            %(DelayNum(k)+1):(DelayNum(k)+WaveNum)
            Signal = zeros(1,TotalNum);
            SignalAng = zeros(1,AngleCirNum);
            SignalAng((ang-1)*SampleNum+1:ang*SampleNum)=SignalTemp;
            for i=1:PulseNum % 16���ز�����
                Signal((i-1)*AngleCirNum+1:i*AngleCirNum)=SignalAng;
                %ÿ��Ŀ���16��SignalTemp����һ��
            end
            FreqMove=exp(1i*2*pi*TargetFd(k)*(0:TotalNum-1)/Fs);
            %Ŀ��Ķ������ٶ�*ʱ��=Ŀ��Ķ���������
            Signal=Signal.*FreqMove;%���϶������ٶȺ��16������1��Ŀ��
            SignalAll=SignalAll+Signal;%���϶������ٶȺ��16������4��Ŀ��
        end
    end
end

figure(2);
subplot(2,1,1);plot(real(SignalAll),'r-');title('Ŀ���źŵ�ʵ��');...
grid on;zoom on;
subplot(2,1,2);plot(imag(SignalAll));title('Ŀ���źŵ��鲿');grid on;zoom on;


%% �ܵĻز��ź�
% ����ϵͳ�����ź�
SystemNoise = normrnd(0,10^(NoisePower/10),1,TotalNum)...
    +1i*normrnd(0,10^(NoisePower/10),1,TotalNum);
%��ֵΪ0����׼��Ϊ10^(NoisePower/10)������

%�������޻ز�
EchoAll=SignalAll+SystemNoise;% +SeaClutter+TerraClutter��������֮��Ļز�
for i=1:PulseNum*AngleNum   %�ڽ��ջ�������,���յĻز�Ϊ0
    EchoAll((i-1)*SampleNum+1:(i-1)*SampleNum+WaveNum)=0; %����ʱ����Ϊ0
end
f3 = figure(3);%������֮����ܻز��ź�
subplot(2,1,1);plot(real(EchoAll),'r-');title('�ܻز��źŵ�ʵ��,������Ϊ0');
subplot(2,1,2);plot(imag(EchoAll));title('�ܻز��źŵ��鲿,������Ϊ0');
saveas(f3,'figure3.jpg')

% ʵ�źŻز�����
RealSignalAll=zeros(1,TotalNum);%����������ź�,����0
for ang = 1:AngleNum
    detect = find (TargetAngle == Sector(ang));
    if ~isempty(detect)
        for k = detect % ���β�������Ŀ��
            fi=2*pi/10 * fix(10*rand);
            RealSignalTemp=zeros(1,SampleNum);% һ��PRT
            RealSignalTemp(DelayNum(k)+1:DelayNum(k)+WaveNum)=...
                sqrt(SigPower(k))*cos(fi)*RealChirp;
            %һ�������1��Ŀ�꣨δ�Ӷ������ٶȣ�
            %(DelayNum(k)+1):(DelayNum(k)+WaveNum)
            RealSignal = zeros(1,TotalNum);
            RealSignalAng = zeros(1,AngleCirNum);
            RealSignalAng((ang-1)*SampleNum+1:ang*SampleNum)=RealSignalTemp;
            for i=1:PulseNum % 16���ز�����
                RealSignal((i-1)*AngleCirNum+1:i*AngleCirNum)=RealSignalAng;
                %ÿ��Ŀ���16��RealSignalTemp����һ��
            end
            RealFreqMove=cos(2*pi*TargetFd(k)*(0:TotalNum-1)/Fs);
            %Ŀ��Ķ������ٶ�*ʱ��=Ŀ��Ķ���������
            RealSignal=RealSignal.*RealFreqMove;
            %���϶������ٶȺ��16������1��Ŀ��
            RealSignalAll=RealSignalAll+RealSignal;
            %���϶������ٶȺ��16������4��Ŀ��
        end
    end
end

figure(7);plot(RealSignalAll,'r-');title('ʵ�źŻز�');
grid on;zoom on;

% ����ϵͳ�����ź�
RealSystemNoise = normrnd(0,10^(NoisePower/10),1,TotalNum);
%��ֵΪ0����׼��Ϊ10^(NoisePower/10)������

%�������޻ز�
RealEchoAll=RealSignalAll;
%+RealSystemNoise;% +SeaClutter+TerraClutter��������֮��Ļز�
for i=1:PulseNum*AngleNum   %�ڽ��ջ�������,���յĻز�Ϊ0
    RealEchoAll((i-1)*SampleNum+1:(i-1)*SampleNum+WaveNum)=0; %����ʱ����Ϊ0
end
figure(8);%������֮����ܻز��ź�
plot(RealEchoAll,'r-');title('���Ӳ���ʵ�źŻز�,������Ϊ0');


%% �ز��ź�����
Folder = {'ʱ����ѹ','ʱƵ����ѹ�Ա�','Ƶ����ѹ����','MTI','MTD'};
for i = 1:length(Folder)
    if exist(char(Folder(i)),'dir')
        rmdir(char(Folder(i)),'s')
    end
    mkdir(char(Folder(i)))
end

EchoRoute = reshape(RealEchoAll, [SampleNum,AngleNum,PulseNum]);
for argerich = 1 % 1 : AngleNum
    Echo = reshape(EchoRoute(:,argerich,:),1,[]);
    %% ʵ�źŽ��յ���
    EchoNum=SampleNum*PulseNum;
    n=0:EchoNum-1;
    receiver_oscillator_i=cos(n*Fc/Fs*pi);%I·�����ź�
    receiver_oscillator_q=cos(n*Fc/Fs*pi);%Q·�����ź�
    s_echo_i=receiver_oscillator_i.* Echo;%I·���
    s_echo_q=receiver_oscillator_q.* Echo;%Q·���
    receiverwindow=chebwin(51,40);%���ǲ�50��cheby����FIR��ͨ�˲���
    [Rb,Ra]=fir1(50,2*BandWidth/Fs,receiverwindow);
    s_echo_i=[s_echo_i,zeros(1,25)];
    s_echo_q=[s_echo_q,zeros(1,25)];
    s_echo_i=filter(Rb,Ra,s_echo_i);
    s_echo_q=filter(Rb,Ra,s_echo_q);
    s_echo_i=s_echo_i(26:end);%��ȡ��Ч��Ϣ
    s_echo_q=s_echo_q(26:end);%��ȡ��Ч��Ϣ
    Echo=s_echo_i+1i*s_echo_q;
    hug_1 = figure('visible','off');
    subplot(2,1,1),plot((0:1/Fs:PulseNum*PRT-1/Fs),s_echo_i);
    xlabel('t(unit:s)'); title('�״�ز��źŽ�����I·�ź�');
    subplot(2,1,2),plot((0:1/Fs:PulseNum*PRT-1/Fs),s_echo_q);
    xlabel('t(unit:s)'); title('�״�ز��źŽ�����q·�ź�');
    filename=['ReceiverIQ/ɨ��' num2str(Sector(argerich)) '��.png'];
    saveas(hug_1,filename)
    close(gcf)
     
    %% ʱ����ѹ
    hugo = figure('visible','off');
    subplot(3,1,1)
    plot(real(Echo),'r-');title('�ܻز��źŵ�ʵ��,������Ϊ0'); 
    pc_time0=conv(Echo,coeff);%pc_time0ΪEcho��coeff�ľ��
    pc_time1=pc_time0(WaveNum:length(Echo)+WaveNum-1);%ȥ����̬�� WaveNum-1��
    %figure(4);%ʱ����ѹ����ķ���
    subplot(3,1,2);plot(abs(pc_time0),'r-');title('ʱ����ѹ����ķ���,����̬��');
    %pc_time0��ģ������
    subplot(3,1,3);plot(abs(pc_time1));title('ʱ����ѹ����ķ���,����̬��');
    %pc_time1��ģ������
    filename=['ʱ����ѹ/ɨ��' num2str(Sector(argerich)) '��.png'];
    saveas(hugo,filename)
%        close(gcf)
    
    %% Ƶ����ѹ
    Echo_fft=fft(Echo,length(Echo)+WaveNum-1);
    %��Ӧ����length(Echo)+WaveNum-1��FFT,��Ϊ����������ٶ�,������8192���FFT
    coeff_fft=fft(coeff,length(Echo)+WaveNum-1);
    pc_fft=Echo_fft.*coeff_fft;
    pc_freq0=ifft(pc_fft);
    hug1 = figure('visible','off');
    subplot(2,1,1);plot(abs(pc_freq0(1:length(Echo)+WaveNum-1)));
    title('Ƶ����ѹ����ķ���,��ǰ��̬��');
    subplot(2,1,2);
    plot(abs(pc_time0(1:length(Echo)+WaveNum-1)-...
            pc_freq0(1:length(Echo)+WaveNum-1)),'r');
    title('ʱ���Ƶ����ѹ�Ĳ��');
    filename=['ʱƵ����ѹ�Ա�/ɨ��' num2str(Sector(argerich)) '��.png'];
    saveas(hug1,filename)
%        close(gcf)
    
    pc_freq1=pc_freq0(WaveNum:length(Echo)+WaveNum-1);
    %ȥ����̬�� WaveNum-1��,����������(8192-WaveNum+1-length(Echo))
    %% ��������š������ź���������=================================%
    for i=1:PulseNum
        pc(i,1:SampleNum)=pc_freq1((i-1)*SampleNum+1:i*SampleNum);
        %ÿ��PRTΪһ�У�ÿ��480�������������
    end
    hug2 = figure('visible','off');
    plot(abs(pc(1,:)));title('Ƶ����ѹ����ķ���,û����̬��');
    filename=['Ƶ����ѹ����/ɨ��' num2str(Sector(argerich)) '��.png'];
    saveas(hug2,filename)
%        close(gcf)
    
    %% MTI����Ŀ����ʾ��,������ֹĿ��͵���Ŀ��---�������Ӳ�%
    for i=1:PulseNum-1  %��������������һ������
        mti(i,:)=pc(i+1,:)-pc(i,:);
    end
    hug3 = figure('visible','off');
    mesh(abs(mti));title('MTI  result');
    filename=['MTI/ɨ��' num2str(Sector(argerich)) '��.png'];
    saveas(hug3,filename)
%        close(gcf)
    %% MTD����Ŀ���⣩,���ֲ�ͬ�ٶȵ�Ŀ�꣬�в�������
    mtd=zeros(PulseNum,SampleNum);
    for i=1:SampleNum
        buff(1:PulseNum)=pc(1:PulseNum,i);
        buff_fft=fft(buff);
        mtd(1:PulseNum,i)=buff_fft(1:PulseNum);
    end
    hug4 = figure(argerich+30)%'visible','off');
    mesh(abs(mtd));title('MTD  result');
    filename=['MTD/ɨ��' num2str(Sector(argerich)) '��.png'];
    saveas(hug4,filename)
%        close(gcf)
    %%  �ҵ�������??�����ͼ�з�ֵ��ߵ�Ŀ��
    abs_mtd = abs(mtd); %�����������ĸ�����ģ
    max_target = max(max(abs_mtd));
    [row,cell] = find( abs_mtd == max_target);
    target_D = cell/Fs*C/2;
    target_V = (fix(row - 1)/PulseNum)*PRF*Lambda/2;
%     %% ��ά���龯
%     ex_PulseNum = PulseNum+4-1;
%     ex_SampleNum = SampleNum+4;
%     ex_mtd = zeros(ex_PulseNum ,ex_SampleNum);
%     cfar_mtd = zeros(ex_PulseNum ,ex_SampleNum);
%     T = 0.40;     %���龯CFAR ��ֵ����
%     for i = 3:(ex_PulseNum-2)
%         for j = 3:(ex_SampleNum-2)
%               ex_mtd(i,j) = abs_mtd(i-2,j-2); 
%��������ÿ�߶���������ľ��󹩺��龯���ڼ��
%         end
%     end
% 
%     for i = 3:(ex_PulseNum-2)
%         for j = 3:(ex_SampleNum-2)    %����Ŀ��Ĵ����н��м��
%             cfar_sx = ex_mtd(i-2,j-2) + ex_mtd(i-2,j-1) +ex_mtd(i-1,j-2) 
%+ex_mtd(i,j-2)+ex_mtd(i+1,j-2)+ex_mtd(i+2,j-2) + ex_mtd(i+2,j-1);                   
%             cfar_sy = ex_mtd(i-2,j+1) + ex_mtd(i-2,j+2) +ex_mtd(i-1,j+2) 
%+ex_mtd(i,j+2)+ex_mtd(i+1,j+2)+ex_mtd(i+2,j+1) + ex_mtd(i+2,j+2);
%             cfar_s = T*min(cfar_sx, cfar_sy);      %ʹ��GO?CFAR��ά���龯��
%             if (ex_mtd(i,j)>= cfar_s)
%                 cfar_mtd(i,j) = ex_mtd(i,j);
%             end
%         end
%     end
% %     x=0:1:ex_SampleNum-1;
% %     y=-9:1:9;%ͨ��������������ͨ�����˵�λֵ�����ٶ�ֵ��
%     figure(argerich+10);mesh(abs(cfar_mtd));title('cfar  result'); 
end
