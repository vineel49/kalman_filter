% Kalman filter tutorial

clear all
close all
clc
len = 10^2; % length of the samples
s_mean = 0;
s_var = 1;
s_ini = normrnd(s_mean,sqrt(s_var),1,1); % s[-1]
a = 1/2; 
var_u = 2;
% signal model (Gauss Markov Process)
% s[n] = a*s[n-1]+u[n] 
u = normrnd(0,sqrt(var_u),1,len+2000);
s = filter(1,[1 -a],u,s_ini);
s(1:2000) = []; % ignoring transient samples

% observation model
% x[n]=s[n]+w[n]
var_w = 0.1;
noise = normrnd(0,var_w,1,len);
x=s+noise;

% kalman filter
% initial conditions
ini_s = s_mean;
ini_mse = s_var;
est_s = zeros(1,len);
pred_s = a*ini_s; % prediction
pred_mse = a^2*ini_mse + var_u; % prediction mse
kalman_gain = pred_mse/(var_w+pred_mse); % Kalman gain
est_s(1) = pred_s + kalman_gain*(x(1)-pred_s); % correction
mse = (1-kalman_gain)*pred_mse; % mse

for i1=2:len
    pred_s = a*est_s(i1-1); % prediction
    pred_mse = a^2*mse + var_u; % prediction mse
    kalman_gain = pred_mse/(var_w+pred_mse); % Kalman gain
    est_s(i1) = pred_s + kalman_gain*(x(i1)-pred_s); % correction
    mse = (1-kalman_gain)*pred_mse;% mse
end

plot(s,'r')
hold on
plot(x,'b')
plot(est_s,'g')
legend('actual signal','noisy signal','estimated signal')