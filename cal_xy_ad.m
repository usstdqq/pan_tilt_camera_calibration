function [ Xt,Yt] = cal_xy_ad( d1x,d1y,d1z,d2x,d2y,d2z,d3x,d3y,d3z,theta1,theta2,u,v,theta1_o,theta2_o,theta1_k,theta2_k,d0z,betaa)
%ERROR_01 Summary of this function goes here
%   Detailed explanation goes here
alpha=0;    gama=0;
beta=betaa;
d0x=0; d0y=0; 

%camera intrinsic parameters
u0=301.39;
v0=267.57;
kx=471.34;
ky=472.98;

theta1=-theta1;

theta1=(theta1-theta1_o)*theta1_k;
theta2=(theta2-theta2_o)*theta2_k;

T_DC=[1 0 0 d3x;
      0 1 0 d3y;
      0 0 1 d3z;
      0 0 0 1; ];

T_CB1=[cos(theta2)	0	sin(theta2)	0;
       0          	1	0          	0;
       -sin(theta2) 0   cos(theta2) 0;
       0            0   0           1;];
T_CB2=[1 0 0 d2x;
       0 1 0 d2y;
       0 0 1 d2z;
       0 0 0 1; ];
T_CB=T_CB2*T_CB1;

T_BA1=[cos(theta1)  -sin(theta1)    0   0;
       sin(theta1)  cos(theta1)     0   0;
       0            0               1   0;
       0            0               0   1;];
T_BA2=[1 0 0 d1x;
       0 1 0 d1y;
       0 0 1 d1z;
       0 0 0 1; ];  
T_BA=T_BA2*T_BA1;

T_AW1=[cos(alpha)   -sin(alpha) 0   0;
       sin(alpha)   cos(alpha)  0   0;
       0            0           1   0;
       0            0           0   1;];
T_AW2=[cos(beta)    0   sin(beta)   0;
       0            1   0           0;
       -sin(beta)   0   cos(beta)   0;
       0            0   0           1;];
T_AW3=[1    0           0           0;
       0    cos(gama)   -sin(gama)  0;
       0    sin(gama)   cos(gama)   0;
       0    0           0           1;];
T_AW4=[1    0   0   d0x;
       0    1   0   d0y;
       0    0   1   d0z;
       0    0   0   1;];
T_AW=T_AW4*T_AW3*T_AW2*T_AW1;


aa=(u-u0)/kx;
bb=(v-v0)/ky;

OOD_D=[0,0,0,1]';
OOD_W=T_AW*T_BA*T_CB*T_DC*OOD_D;

Detarget_D=[1,-aa,-bb,1]';
Detarget_W=T_AW*T_BA*T_CB*T_DC*Detarget_D;


XD0=OOD_W(1);
YD0=OOD_W(2);
ZD0=OOD_W(3);

XDe=Detarget_W(1);
YDe=Detarget_W(2);
ZDe=Detarget_W(3);

Xt=(0-ZD0)/(ZDe-ZD0)*(XDe-XD0)+XD0;

Yt=(0-ZD0)/(ZDe-ZD0)*(YDe-YD0)+YD0;

end

