%% �ز��ź�����
Folder = {'ʱ����ѹ','ʱƵ����ѹ�Ա�','Ƶ����ѹ����','MTI','MTD','ReceiverIQ'};
for i = 1:length(Folder)
    if exist(char(Folder(i)),'dir')
        rmdir(char(Folder(i)),'s')
    end
    mkdir(char(Folder(i)))
end
EchoRoute = reshape(EchoAll, [SampleNum,AngleNum,PulseNum]);
for argerich = 1: AngleNum;
    Echo = reshape(EchoRoute(:,argerich,:),1,[]);
    if Reality ==1
        %% ʵ�źŽ��յ���
        EchoNum=SampleNum*PulseNum;
        n=0:EchoNum-1;
        receiver_oscillator_i=cos(n*Fc/Fs*2*pi);%I·�����ź�
        receiver_oscillator_q=cos(n*Fc/Fs*2*pi);%Q·�����ź�
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
    end
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
    hug4 = figure('visible','off');
    mesh(abs(mtd));title('MTD  result');
    filename=['MTD/ɨ��' num2str(Sector(argerich)) '��.png'];
    saveas(hug4,filename)
%        close(gcf)
    %%  �ҵ�������??�����ͼ�з�ֵ��ߵ�Ŀ��
    abs_mtd = abs(mtd); %�����������ĸ�����ģ
    max_target = max(max(abs_mtd));
    [row,cell] = find( abs_mtd == max_target);
    target_D = cell/Fs*C/2;
end