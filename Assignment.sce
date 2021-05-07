clc;clear();xdel(winsid());
s = poly(0 , 's');

givenFile = fullfile(pwd(), "data.csv");
table = csvRead(givenFile, [], [], "double", [], [], [], 1);
frequencies = table(1:40, 1);
magnitude = table(1:40, 12)';
phase = table(1:40, 16)';

fp=110;fz=880;
zeta=0.3; k=6.5
wp=2*%pi*fp; wz=2*%pi*fz;
Cs=k*(s^2/wz^2+2*zeta*s/wz+1)/(s^2/wp^2+2*zeta*s/wp+1);
Cs1=syslin('c',Cs);
c=repfreq (Cs1, table(1:40, 1));
mprintf("Controller TF");disp(Cs1);
mprintf("Poles");disp(roots(Cs1.den));mprintf("Zeros");disp(roots(Cs1.num));


cMagnitude = ones(length(frequencies));
cPhase = ones(length(frequencies));
[cMagnitude, cPhase] = dbphi(c);

magCG= ones(length(frequencies));
phaseCG = ones(length(frequencies));
magCG = magnitude + cMagnitude;
phaseCG = phase + cPhase;

G = 10^(magnitude/20).*(cos(phase*%pi/180)+%i*sin(phase*%pi/180));

magBN = ones(length(frequencies));
phaseBN = ones(length(frequencies));
BN = G./(1+G.*c);
[magBN, phaseBN] = dbphi(BN);

magBV = ones(length(frequencies));
phaseBV = ones(length(frequencies));
BV = (G.*c)./(1+G.*c);
[magBV, phaseBV] = dbphi(BV);


figure('BackgroundColor' ,[1 1 1]);
subplot(2,1,1);
plot2d("ln",frequencies,magnitude);
xlabel("Frequency in Hz");
ylabel("Magnitude");
title("Magnitude of Plant TF");
xgrid(2);

subplot(2,1,2);
plot2d("ln", frequencies,phase);
xlabel("Frequency in Hz");
ylabel("Phase ");
title("Phase of Plant TF");
xgrid(2);


figure('BackgroundColor' ,[1 1 1]);
subplot(2,1,1);
plot2d("ln", frequencies,magBV);
xlabel("Frequency in Hz");
ylabel("Magnitude");
title("Magnitude of B(s)/Vi(s)");
xgrid(2);

subplot(2,1,2);
plot2d("ln",frequencies,phaseBV);
xlabel("Frequency in Hz");
ylabel("Phase");
title("Phase of B(s)/Vi(s)");
xgrid(2);


figure('BackgroundColor' ,[1 1 1]);
subplot(2,1,1);
plot2d("ln",frequencies,magBN);
xlabel("Frequency in Hz");
ylabel("Magnitude");
title("Magnitude of B(s)/N(s)");
xgrid(2);

subplot(2,1,2);
plot2d("ln",frequencies,phaseBN);
xlabel("Frequency in Hz");
ylabel("Phase ");
title("Phase of B(s)/N(s)");
xgrid(2);


figure('BackgroundColor' ,[1 1 1]);
bode(Cs1,10,10000);
bode_asymp(Cs1,10,10000);
title("Bode plot of Controller C(s)");


figure('BackgroundColor' ,[1 1 1]);
subplot(2,1,1);
plot2d("ln",frequencies,magCG);
xlabel("Frequency in Hz");
ylabel("Magnitude");
title("Magnitude of Open Loop TF");
xgrid(2);

subplot(2,1,2);
plot2d("ln", frequencies,phaseCG);
xlabel("Frequency in Hz");
ylabel("Phase ");
title("Phase of Open Loop TF");
xgrid(2);
