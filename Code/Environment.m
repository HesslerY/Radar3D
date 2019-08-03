function Environment()
% ���ű��ļ����ȡCarSet.mat������Environment.mat���Velocity �� Envir��
% ���Ҵ��ڵ����⣺��ʱֻ������ĳ�Я���״Ԥ�ƿ�ʹ��Uni�ֿ�
%% �������ã�Ӧ���ϵ�Parameter�ļ��У�
load('CarSet.mat');
Parameter();
global mete Lambda MaxDistance deltaD AllLine ...
    CarDis CarAngle Linewidth Height deltaAngle
%% �߽绷������
% ֻ���ǻ�����ͷ
Point = Compen(1,:);
[me,~] = size(Compen);
% 10��ֵ�ֱ��ʾSigPower, Line, Velocity, Place, (LWH)...
Selected = Compen((2:me),:);
Uni = unique(Selected(:,1)); %ʹ��Uni�����ָ߰����Ĳ�ͬ������

Target = Selected(Selected(:,5)<=CarDis ...
    & Selected(:,6)<=CarAngle(2) & Selected(:,6)>=CarAngle(1),:);
[mt,~] = size(Target);

allAngle = round((CarAngle(2)-CarAngle(1))/deltaAngle);
Envir = zeros(allAngle,fix(MaxDistance/deltaD));
Velocity = zeros(allAngle,fix(MaxDistance/deltaD));
% ��һ��Ԫ��Ϊ���еĽǶȷ������ڶ���Ԫ��Ϊ�����ϵķֱ���

%% ����RCS����
%�����뼰�Ƕȷֱ����ڻ����л��ֵ�Ԫ������С��Ԫ������һ�����Σ���ΪdeltaD����Ϊ�����ߵ���ֵ
%�����ʵ�������������
[~,n] = size(Envir);
queue = deltaD*(1/2:1:n-1/2);
distance =sqrt(queue.^2+Height^2);
theta = pi/2 - atan(Height./queue);

w = deltaD; %�����򳤶�
d = queue*deltaAngle; %��λ�򳤶�
fai = 0; %ÿ���״��൱��theta��������fai��Ϊ0
Spa = 1; %�������������������ó�ģ����к�Բ����һ���������ȡ�
k = 2*pi/Lambda;
deltaEnvir = pi^(-1)*(k.*d.*w).^2 .*sinc(k.*d.*sin(theta)*cos(fai)).^2 ...
    .*sinc(k*w*sin(theta)*sin(fai)).^2.*0.5.* ...
    ((1-sin(theta)*cos(fai).^2).^(0.5)+(1-sin(theta)*sin(fai).^2).^(0.5));
%% ���������������
%����Ϊɨ������������deltaֵ���㣬����Ϊ�����Ρ�
Sector = deltaAngle+CarAngle(1):deltaAngle:CarAngle(2);
if Point(5)>0
    Radius= ( AllLine - Point(5) + 1/2 ) *Linewidth ./sin(-Sector);
    MinorR = ( AllLine  + Point(5) -1/2 ) *Linewidth ./sin(Sector);
else 
    Radius= ( AllLine - abs(Point(5)-1) + 1/2 ) *Linewidth ./sin(-Sector);
    MinorR = ( AllLine  + abs(Point(5)-1) -1/2 ) *Linewidth ./sin(Sector);
end
Radius= round(min(max(Radius,MinorR),MaxDistance));

% ���賡���߽紦�Ĳ�����һ�����ʲ�ͬ�ķ����壨�������ױ���֪������Ϊ��Զ���룩
for i = 1:length(Radius)
    Envir(i,Radius(i)) = mete(1);
    Envir(i,(1:Radius(i)-1)) =0;% deltaEnvir(1:Radius(i)-1);%0;������RCS�Ļ�%
    Velocity(i,(1:Radius(i)-1)) =0;% -Point(3)*cos((i-300)*deltaAngle);%�����ǻ��������Ļ�%
end

%% ����������λ��RCS����
% ����row������cal����ֱ�Ϊ���е����飬rowǰ����Ԫ�ش���yֵ��������Ԫ�ش���xֵ
% cal��ǰ����Ԫ�ش���x��������Ԫ�ش���y

CX = Target(:,4)-Target(:,8)*0.5;
CY = -Linewidth * Target(:,2);

%C ��������ĵ�
X = CX+Target(:,8);
Y = CY+sign(CY).*Target(:,9);

% global Point

%����
LineC = atan(CY./CX);
LineDown = atan(Y./CX);
LineRight = atan(CY./X);
Line = horzcat(LineC,LineDown,LineRight);
Line = fix((Line-CarAngle(1))/deltaAngle);


for i = 1:mt
    if Line(i,1)>Line(i,2)
        CEALR = Line(i,1):-1:Line(i,2);%Car_Environment Angle List Right
        CEALD = Line(i,1):1:Line(i,3);%Car_Environment Angle List Down
    else
        CEALR = Line(i,1):1:Line(i,2);
        CEALD = Line(i,1):-1:Line(i,3);%Car_Environment Angle List Down
    end
    for j= 2: length(CEALR)
        PorDis = CX(i)./cos(Sector(CEALR(j))); % С���б����
        theta = acos(CX(i)./sqrt(PorDis^2+0.25*Height^2));
        fai = atan(0.5*Height./sqrt(PorDis^2-CX(i)^2));
        w = Height; %�����򳤶�
        d = queue(fix(PorDis))*deltaAngle; %��λ�򳤶�
        Spa = 1; %��������������������������ˡ�
        k = 2*pi/Lambda;
        deltaCar1 = pi^(-1)*(k.*d.*w).^2 ...
            .*sinc(k.*d.*sin(theta)*cos(fai)).^2 ...
            .*sinc(k*w*sin(theta)*sin(fai)).^2.*0.5.* ...
            ((1-sin(theta)*cos(fai).^2).^(0.5) ...
            +(1-sin(theta)*sin(fai).^2).^(0.5));
        Envir(CEALR(j),fix(PorDis))=deltaCar1*mete(2);
        Envir(CEALR(j),(fix(PorDis)+1:n)) = 0;
        Velocity(CEALR(j),fix(PorDis))=Target(i,3) ...
            *cos((CEALR(j)-300)*deltaAngle);
        Velocity(CEALR(j),(fix(PorDis)+1:n)) = 0;
    end
    if CY(i) ~= 0 
        for j= 2: length(CEALD)
            PorDis = abs(CY(i)./sin(Sector(CEALD(j)))); % С���б����
            theta = acos(abs(CY(i))./sqrt(PorDis^2+0.25*Height^2));
            fai = atan(0.5*Height./sqrt(PorDis^2-CY(i)^2));
            w = Height; %�����򳤶�
            d = queue(fix(PorDis))*deltaAngle; %��λ�򳤶�
            Spa = 1; %��������������������������ˡ�
            k = 2*pi/Lambda;
            deltaCar = pi^(-1)*(k.*d.*w).^2 ...
                .*sinc(k.*d.*sin(theta)*cos(fai)).^2 ...
                .*sinc(k*w*sin(theta)*sin(fai)).^2.*0.5.* ...
                ((1-sin(theta)*cos(fai).^2).^(0.5) ...
                +(1-sin(theta)*sin(fai).^2).^(0.5));
            Envir(CEALD(j),fix(PorDis))=deltaCar*mete(2);
            Envir(CEALD(j),(fix(PorDis)+1:n))=0;
            Velocity(CEALD(j),fix(PorDis))=Target(i,3)...
                *cos((CEALD(j)-300)*deltaAngle);
            Velocity(CEALD(j),(fix(PorDis)+1:n))=0;
        end
        midval = fix(abs(CY(i)./sin(Sector(CEALD(1)))));
    else
        midval = CX(i);
    end
    Envir(CEALR(1),fix(midval/2+0.5*CX(i)./cos(Sector(CEALR(1))))) ...
        = deltaCar1*mete(2);
    Envir(CEALR(1),fix(midval/2+0.5*CX(i)/cos(Sector(CEALR(1)))+1:n))=0; 
    Velocity(CEALR(1),fix(midval/2+0.5*CX(i)./cos(Sector(CEALR(1))))) ...
        =Target(i,3)*cos((CEALR(1)-300)*deltaAngle);
    Velocity(CEALR(1),(fix(midval/2+0.5* ...
        CX(i)./cos(Sector(CEALR(1))))+1:n))=0;
    clearvars CEALR;
    clearvars CEALD;
end

% ���г��;�����Ϊ�����壬���״ﳵΪ�����Σ��״�λ�ڳ������в�
% Point ��ʾ�ο����ĳ��������ٺ����ˮƽ���λ�á�
% ��ʱĬ��������̬�¾�Ϊб���ΰ壬��������������ʻ�����ķ������һ��
% ��ʱ������ά�Ͻ��ܿ��������һ̨��
%% �ļ����漰���
figure(11);
surf(Envir);
save Environment.mat Envir Velocity;
end