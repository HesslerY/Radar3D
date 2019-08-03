w = 2; %�����򳤶�
d = 2; %��λ�򳤶�
C=3.0e8;  %����(m/s)
Fc=100e6;  %�״���Ƶ 1.57GHz
Lambda=C/Fc;    %�״﹤������
k = 2*pi/Lambda;
theta = pi/2*(1e-3:1e-3:1);
fai = pi/12;
deltaCar = pi^(-1)*(k.*d.*w).^2 .*sinc(k.*d.*sin(theta)*cos(fai)).^2 ...
          .*sinc(k*w*sin(theta)*sin(fai)).^2.*0.5.* ...
        ((1-sin(theta)*cos(fai).^2).^(0.5) ...
         +(1-sin(theta)*sin(fai).^2).^(0.5));
     figure(2);
     plot(theta*180/pi,20*log(deltaCar));
     
     ylabel ('RCS \delta');
xlabel ('\theta - ��');