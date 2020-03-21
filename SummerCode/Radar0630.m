clear;
PowerK = 1000;
%% Ŀ�����
global C Lambda PulseNum BandWidth PRT PRF Fs NoisePower Fc ...
    WaveNum deltaD MinDis deltaAngle CarAngle
Parameter;
%% �����������ü���ȡ
global Point PointNum Swirling
Swirling = 1;
PointNum = 3;
Point = CarSet(PointNum);
Environment;

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
    fbb_i=local_oscillator_i.*Chirp;%i·���   �Ƚ���һ����Ԫ���������ѹ��ϵ��
    fbb_q=local_oscillator_q.*Chirp;%q·���
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
    coeff=conj(fliplr(fbb)); %��Chirp����תȡ���������ѹϵ��
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
load('Environment.mat');
[AngleNum,MaxDis] = size(Envir);
TargetDistance = deltaD*(0.5:1:MaxDis-0.5);
DelayNum = fix(Fs*2*TargetDistance/C);% ��Ŀ����뻻��ɲ����㣨�����ţ� 
%fix������0��£ȡ��
Sector = round((CarAngle(1) + deltaAngle*(1:AngleNum))*180/pi);
SampleNum=fix(Fs*PRT);%����һ���������ڵĲ���������
AngleCirNum = SampleNum*AngleNum; 
%�����һ���Ƕȵ�һ�������Ե�Ƶ�����������ʣ��Ƕȣ����ѭ�����壻
TotalNum=SampleNum*PulseNum*AngleNum;%�ܵĲ���������
% BlindNum=fix(Fs*TimeWidth);%����һ���������ڵ�ä��-�ڵ���������
%% ����Ŀ��ز���
if Reality >= 0
    Signal = zeros(1,TotalNum);%����������ź�,����0
    for Inn = 1:PulseNum % 16���ز�����
        SignalAng = zeros(1,AngleCirNum);
        for ang = 1:AngleNum
            detect = find (Envir(ang,:) ~= 0);
            [~,detectN] = size(detect);
            if detectN>=MinDis
                detectAct = detect(1,MinDis:detectN);
                for k = detectAct % ���β�������Ŀ��
                    %fi=2*pi/10 * fix(10*rand);
                    SignalTemp=zeros(1,SampleNum);% һ��PRT
                    Power = PowerK*sqrt(Envir(ang,k)*TargetDistance(k)^(-4));
                    SignalTemp(DelayNum(k)+1:DelayNum(k)+WaveNum)=...
                         Power*Chirp;%*exp(1i*fi)
                    StatusNum =(ang-1)*SampleNum+(Inn-1)*AngleCirNum;
                    if Reality ==0
                        FreqMove=exp(1i*4*pi*Velocity(ang,k)*(StatusNum:1:StatusNum+SampleNum-1)/Fs/Lambda);
                    else 
                        FreqMove=cos(4*pi*Velocity(ang,k)*(StatusNum:1:StatusNum+SampleNum-1)/Fs/Lambda);
                    end
                    SignalTemp = SignalTemp.*FreqMove;
                    %һ�������1��Ŀ�꣨�Ӷ������ٶȣ�
                    %(DelayNum(k)+1):(DelayNum(k)+WaveNum)
                    SignalAng((ang-1)*SampleNum+1:ang*SampleNum)=SignalTemp;
                end
            end
            if mod(Swirling,2) ==0
                Upgrade(PRT);
            end
        end
        Signal((Inn-1)*AngleCirNum+1:Inn*AngleCirNum)=SignalAng;
        if mod(Swirling,2) ==1
            Upgrade(PRT*AngleNum);
            % ��������Swirling���˶��ֲ�������������ʷֲ�
        end
    end

    figure(2);
    subplot(2,1,1);plot(real(Signal),'r-');title('Ŀ���źŵ�ʵ��');...
    grid on;zoom on;
    subplot(2,1,2);plot(imag(Signal));title('Ŀ���źŵ��鲿');grid on;zoom on;

    %% �ܵĻز��ź�
    % ����ϵͳ�����ź�
    SystemNoise = normrnd(0,10^(NoisePower/10),1,TotalNum)...
        +1i*normrnd(0,10^(NoisePower/10),1,TotalNum);
    %��ֵΪ0����׼��Ϊ10^(NoisePower/10)������

    %�������޻ز�
    EchoAll=Signal+SystemNoise;% +SeaClutter+TerraClutter��������֮��Ļز�
    for i=1:PulseNum*AngleNum   %�ڽ��ջ�������,���յĻز�Ϊ0
        EchoAll((i-1)*SampleNum+1:(i-1)*SampleNum+WaveNum)=0; %����ʱ����Ϊ0
    end
    f3 = figure(3);%������֮����ܻز��ź�
    subplot(2,1,1);plot(real(EchoAll),'r-');title('�ܻز��źŵ�ʵ��,������Ϊ0');
    subplot(2,1,2);plot(imag(EchoAll));title('�ܻز��źŵ��鲿,������Ϊ0');
    saveas(f3,'figure3.jpg')
else
    %% ʵ�źŻز�����
    Signal = zeros(1,TotalNum);%����������ź�,����0
    for Inn = 1:PulseNum % 16���ز�����
        SignalAng = zeros(1,AngleCirNum);
        for ang = 1:AngleNum
            detect = find (Envir(ang,:) ~= 0);
            [~,detectN] = size(detect);
            if detectN>=MinDis
                detectAct = detect(1,MinDis:detectN);
                for k = detectAct % ���β�������Ŀ��
                    fi=2*pi/10 * fix(10*rand);
                    SignalTemp=zeros(1,SampleNum);% һ��PRT
                    Power = sqrt(Envir(ang,k)*TargetDistance(k)^(-4));
                    SignalTemp(DelayNum(k)+1:DelayNum(k)+WaveNum)=...
                        Power*cos(fi)*Chirp;
                    StatusNum =(ang-1)*SampleNum+(Inn-1)*AngleCirNum;
                    FreqMove=cos(4*pi*Velocity(ang,k)*(StatusNum:1:StatusNum+SampleNum-1)/Fs/Lambda);
                    SignalTemp = SignalTemp.*FreqMove;
                    %һ�������1��Ŀ�꣨�Ӷ������ٶȣ�
                    %(DelayNum(k)+1):(DelayNum(k)+WaveNum)
                    SignalAng((ang-1)*SampleNum+1:ang*SampleNum)=SignalTemp;
                end
            end

            if mod(Swirling,2) ==0
                Upgrade(PRT);
            end
        end
        Signal((Inn-1)*AngleCirNum+1:Inn*AngleCirNum)=SignalAng;
        if mod(Swirling,2) ==1
            Upgrade(PRT*AngleNum);
            % ��������Swirling���˶��ֲ�������������ʷֲ�
        end
    end

    figure(7);plot(Signal,'r-');title('ʵ�źŻز�');
    grid on;zoom on;

    % ����ϵͳ�����ź�
    SystemNoise = normrnd(0,10^(NoisePower/10),1,TotalNum);
    %��ֵΪ0����׼��Ϊ10^(NoisePower/10)������

    %�������޻ز�
    EchoAll=Signal+SystemNoise;% +SeaClutter+TerraClutter��������֮��Ļز�
    for i=1:PulseNum*AngleNum   %�ڽ��ջ�������,���յĻز�Ϊ0
        EchoAll((i-1)*SampleNum+1:(i-1)*SampleNum+WaveNum)=0; %����ʱ����Ϊ0
    end
    figure(8);%������֮����ܻز��ź�
    plot(EchoAll,'r-');title('���Ӳ���ʵ�źŻز�,������Ϊ0');
end
SignalProcess;