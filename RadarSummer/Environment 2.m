load('CarSet.mat');
delta = BackPower();
% ��һ���Ǳ߽�ķ���������ڶ����ǳ��ķ��������Ĭ�ϳ��ķ��������ͬ
EnviLength = 200;
EnviWidth = 30;
MaxDistance = sqrt(EnviLength^2+EnviWidth^2);
deltaD = 1;%����ֱ���
AllLine = 4;
CarDis = 100;
CarAngle = [-pi/3,pi/3];
Linewidth = 3.5; 

Point = Compen(1,:);
% 7��ֵ�ֱ��ʾSigPower, Line, Velocity, Place, (LWH)
Selected = Compen((2:length(Compen)),:);
Uni = unique(Selected(:,1));

Target = Selected(Selected(:,5)<=CarDis ...
    & Selected(:,6)<=CarAngle(2) & Selected(:,6)>=CarAngle(1),:);

deltaAngle = 0.2*pi/180;%��
allAngle = round((CarAngle(2)-CarAngle(1))/deltaAngle);
Envir = zeros(allAngle,fix(MaxDistance/deltaD));
% ��һ��Ԫ��Ϊ���еĽǶȷ������ڶ���Ԫ��Ϊ�����ϵķֱ���

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
for i = 1:length(Radius)
    Envir(i,Radius(i)) = delta(1);
end

% ����row������cal����ֱ�Ϊ���е����飬rowǰ����Ԫ�ش���yֵ��������Ԫ�ش���xֵ
% cal��ǰ����Ԫ�ش���x��������Ԫ�ش���y
%�������Ϊ

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
Line = fix(5*(Line+pi/3)*180/pi);

for i = 1:length(Line)
    Envir((Line(i,1):1:Line(i,2)),fix(CX(i)./cos(Sector((Line(i,1):1:Line(i,2))))))=delta(2);
    Envir((Line(i,1):-1:Line(i,2)),fix(CX(i)./cos(Sector((Line(i,1):-1:Line(i,2))))))=delta(2);
    if CY(i)~=0
        Envir((Line(i,1):1:Line(i,3)),fix(abs(CY(i)./sin(Sector((Line(i,1):1:Line(i,3)))))))=delta(2);
        Envir((Line(i,1):-1:Line(i,3)),fix(abs(CY(i)./sin(Sector((Line(i,1):-1:Line(i,3)))))))=delta(2);
    else
        Envir((Line(i,1):1:Line(i,3)),CX(i))=delta(2);
        Envir((Line(i,1):-1:Line(i,3)),CX(i))=delta(2);
    end
end
%Envir(Envir(:,1)>=Line(:,1) & Envir(:,1)<=Line(:,2),
%round(X./cos(Sector)) = delta(2);
% ���г��;�����Ϊ�����壬���״ﳵΪ�����Σ��״�λ�ڳ������в�
% Point ��ʾ�ο����ĳ��������ٺ����ˮƽ���λ�á�
% ��ʱĬ��������̬�¾�Ϊб���ΰ壬��������������ʻ�����ķ������һ��
% ��ʱ������ά�Ͻ��ܿ��������һ̨��
