function [PointData] = CarSet(pointcar)
% ���ɱ���CarSet.mat�ں�ʮ�о���Compen����������Ϊ��cars.mat��������Ƕȣ�CarSeries.mat�����������mat����Ϊ���pointcar��ֵ��Compen��һ��Ϊpointcar�����е��壬����ֵΪ�������;���

% �����disthorizon��ʾ���������״��ˮƽ����
% line��ʾ������pointcar��ʾ�ڼ�������Ϊ�״�λ�á�
load('CarSeries.mat');
load('cars.mat');
% ��һ�г��ͣ��ڶ��г��������������ٶȣ������г�ͷ����ĳһ�ڵ�ľ��Ծ���
Cardata = newData;%xlsread ('Cars.xlsx');
CarSeries = carSeries;
%�洢�ο�ֵ��
PointData = Cardata(pointcar,:);
PointData(1) = 0;
Cardata=Cardata-PointData;
Larger = zeros(length(Cardata),4);
Uni = unique(Cardata(:,1));
for i = 1:length(Uni)
    Larger(Cardata(:,1) ==Uni(i),:) = repmat(CarSeries(i,:),...
        length(find(Cardata(:,1) ==Uni(i))),1);
end
Line = Cardata(:,2);
Disthorizon = Cardata(:,4);
%�������ͬ�򣬸����������
Linewidth = 3.5; 
Distance = ((Linewidth*Line).^2+Disthorizon.^2).^0.5;
Angle = -atan(Linewidth*Line./Disthorizon);
Angle(Disthorizon<0) = Angle(Disthorizon<0) + pi;
    %�ڶ������޵�ֵ��Ҫ��pi���������Ƕȷ�Χ��-pi/2��3/2*pi
Compen = horzcat(Cardata,Distance,Angle,Larger);
Compen([1;pointcar],:)=Compen([pointcar;1],:);
Compen(1,[5,3,6]) = PointData(1,[2,3,4]);
save CarSet.mat Compen;
end
