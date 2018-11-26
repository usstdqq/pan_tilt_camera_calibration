clear;
clc;
close all;
%%  Load the data
A_o=load('calibration_data.log');

%%  Setup range for each parameter
range=[-5/180*pi 5/180*pi;...
    -5/180*pi 5/180*pi;...
    0.85 1.15;...
    0.85 1.15;...
    -2 5;...
    -5 5;...
    5 12;...
    0 0;...
    40 50];

%%  Reference estimation of the parameters
%   Used as initialization of the optimization problem
para0 = [-0.0573516436344404;-0.0261139237231264;0.999434092540735;0.992892894217912;5;1.46026347671590;9.39653235128675;-0.0307160633193101;43.4065831717579;]

ref_para=para0;


d1x=0;
d1y=0;
d1z=5.2;
d2x=0.58;
d2y=0;
d2z=2.2;


A=A_o;
 
figure(1);
hold on;
for i=1:length(A)
    plot(A(i,5),A(i,6),'+');
end

P=[50 5000 48 2 2 0.9 0.4 1500 10^(-20) 350 NaN 0 0];


%%  Optimization Solver
opt = optimset('Display','iter-detailed','Algorithm','levenberg-marquardt','FunValCheck','on');
[result resnorm exitflag] = lsqnonlin(@auto_error_uv,para0,[],[],opt);


%%  Retrieve Results
theta1_o=result(1);
theta2_o=result(2);
theta1_k=result(3);
theta2_k=result(4);
d3x=result(5);
d3y=result(6);
d3z=result(7);
betaa=result(8);
d0z=result(9);
d1x=0;
d1y=0;
d1z=5.2;
d2x=0.58;
d2y=0;
d2z=2.2;

%%  Visualization Calibration Results
figure(1)
for i=1:length(A)
    theta1=A(i,1);
    theta1=(theta1*pi)/180;
    
    theta2=A(i,2);
    theta2=(theta2*pi)/180;
    
    u=A(i,3)*2;
    
    v=A(i,4)*2;
    
    [ xt,yt] = cal_xy_ad( d1x,d1y,d1z,d2x,d2y,d2z,d3x,d3y,d3z,theta1,theta2,u,v,theta1_o,theta2_o,theta1_k,theta2_k,d0z,betaa);

    temp = [xt,yt,i];

    plot(xt,yt,'*r');
end

grid on;

%%  Print Results
result