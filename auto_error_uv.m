function [ err ] = auto_error_uv( XX )
%AUTO_ERROR Summary of this function goes here
%   Detailed explanation goes here
%   Compute the reprojection error for optimization solver

data =evalin('base','A');
theta1_o=XX(1);
theta2_o=XX(2);
theta1_k=XX(3);
theta2_k=XX(4);
d3x=XX(5);
d3y=XX(6);
d3z=XX(7);
betaa=XX(8);
d0z=XX(9);

d1x=0;
d1y=0;
d1z=5.2;
d2x=0.58;
d2y=0;
d2z=2.2;

MAX_ERR=50;

total_error=0;


n= size(data);

n= size(data);

for i=1:n(1)
    theta1=data(i,1);
    theta1=(theta1/180)*pi;
    
    theta2=data(i,2);
    theta2=(theta2/180)*pi;

    u=data(i,3)*2;
    v=data(i,4)*2;
    
    x_real=data(i,5);
    y_real=data(i,6);
    
    [ UV] = cal_uv( d1x,d1y,d1z,d2x,d2y,d2z,d3x,d3y,d3z,...
    theta1,theta2,theta1_o,theta2_o,theta1_k,theta2_k,...
    d0z,betaa,x_real,y_real);
    
    
    err(i)=sqrt((u-UV(1))^2+(v-UV(2))^2);
    

    
end





