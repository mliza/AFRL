iclose all
clear all 
clc
format long
%c=xlsread('mach13.xlsx');

p=importdata('fort.57');
x=importdata('fort.55');
y=importdata('fort.56');
  %   p_n2=importdata('fort.58');
  %   p_o2=importdata('fort.59');
  %   p_n=importdata('fort.61');
  %   p_o=importdata('fort.62');
  %   p_no=importdata('fort.60');
% %    
  %   K_n2=2.38*10^-4;
  %   K_n=3.1*10^-4;
  %   K_o=2.04*10^-4;
  %   K_o2=1.93*10^-4;
  %   K_no=2.21*10^-4;
K_GD=2.27*10^-4;
%rinf=0.138;
for ii=1:numel(p)
%        K_GD(ii)=((p_n2(ii))*K_n2)+((p_n(ii))*K_n)+((p_o(ii))*K_o)+((p_o2(ii))*K_o2)+((p_no(ii))*K_no);
        n1(ii)=K_GD*p(ii);
%       n1(ii)=rinf*p(ii)*((2.227e-4+1.675e-6)/.5^2);
end

 d(1)=0;
 for ii=2:length(x)
 d(ii)=sqrt((x(ii)-x(ii-1))^2+(y(ii)-y(ii-1))^2)+d(ii-1);
 end
 
%%SIMPSONS RULE
a=d(1);
b=d(end);
n=numel(d);
h=abs(b-a)/n;
%n1=n1;
OPL=trapz(d,n1); %h/3*(n1(1)+2*sum(n1(3:2:end-1))+4*sum(n1(2:2:end))+n1(end));
%OPL=sum((n1*h)