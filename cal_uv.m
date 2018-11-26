function [UV]=cal_uv(d1x,d1y,d1z,d2x,d2y,d2z,d3x,d3y,d3z,theta1,theta2,theta1_o,theta2_o,theta1_k,theta2_k,d0z,betaa, x, y )
%   Compute Reprojection points given the camera intrinsic parameters,
%   pan-tilt parameters and pan-tilt error model

alpha=0;    gama=0;  beta=betaa;
d0x=0; d0y=0; 


%Intrinsic parameter of the camera
u0=301.39;
v0=267.57;
kx=471.34;
ky=472.98;


theta1=-theta1;
theta1=(theta1-theta1_o)*theta1_k;
theta2=(theta2-theta2_o)*theta2_k;


T_WA1=[cos( alpha)   sin( alpha) 0   0;
       sin(- alpha)   cos( alpha)  0   0;
       0            0           1   0;
       0            0           0   1;];
T_WA2=[cos( beta)    0   -sin( beta)   0;
       0            1   0           0;
       sin( beta)   0   cos( beta)   0;
       0            0   0           1;];
T_WA3=[1    0           0           0;
       0    cos( gama)   sin( gama)  0;
       0    -sin( gama)   cos( gama)   0;
       0    0           0           1;];
T_WA4=[1    0   0   -d0x;
       0    1   0   -d0y;
       0    0   1   -d0z;
       0    0   0   1;];
T_WA=T_WA4*T_WA3*T_WA2*T_WA1;


T_AB1=[cos( theta1)  sin( theta1)    0   0;
       -sin( theta1)  cos( theta1)     0   0;
       0            0               1   0;
       0            0               0   1;];
T_AB2=[1 0 0 -d1x;
       0 1 0 -d1y;
       0 0 1 -d1z;
       0 0 0 1; ];  
T_AB=T_AB2*T_AB1;


T_BC1=[cos( theta2)	0	-sin( theta2)	0;
       0          	1	0          	0;
       sin( theta2) 0   cos( theta2) 0;
       0            0   0           1;];
   
T_BC2=[1 0 0 -d2x;
       0 1 0 -d2y;
       0 0 1 -d2z;
       0 0 0 1; ];
T_BC=T_BC2*T_BC1;

T_CD=[1 0 0 -d3x;
      0 1 0 -d3y;
      0 0 1 -d3z;
      0 0 0 1; ];  

temp=T_AB*T_WA;
temp=T_BC*temp;
T_WD=T_CD*temp;
  
Pos_D=T_WD*[x,y,0,1]';
  
T_DV=[0,1,0,0;
      0,0,1,0;
      1,0,0,0;
      0,0,0,1;];

Pos_V=T_DV*Pos_D;
T_VP=[ kx,0, u0;
      0, ky, v0;
      0,0,1;];
UV=T_VP*[-Pos_V(1)/Pos_V(3);-Pos_V(2)/Pos_V(3);1];

end