
global C PulseNum BandWidth TimeWidth PRT Fs NoisePower Fc
C
PulseNum

load('cars.mat')

Target = newData;
SigPower = Target(:,1)'; %Ŀ�깦��,������ [5,1,100,10.250000000000000]
TargetDistance = Target(:,2)'; %Ŀ�����,��λm  �������Ϊ[3000 8025 15800 8025]
TargetVelocity = Target(:,3)'; %Ŀ�꾶���ٶ� ��λm/s  �ٶȲ���Ϊ[50 0 10000 100]
TargetAngle = round(Target(:,4))'; %Ŀ��Ƕ� ��λ�� �ǶȲ��� [30 60 90 120]
TargetWaveNum = length(SigPower)