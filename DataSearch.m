function [X_loc,Y_amp] = DataSearch(Sig,Threshould,varargin)
% CopyRignt@ vastera_ma 
% email:vastera@163.com
%DATASEARCH  用来提取峰值（离群点）的大小和位置
%   Sig 输入信号
%   Threshould 待提取离群点（峰值）占总点数的比例[0~1]
%   Slice    局部区域分割的最大份数，此处默认为100
%   interv   the smallest position interval between adjecent points
%           (default:5)
Slice=100;
interv=5;
if nargin>3
    interv=varargin{2};Slice=varargin{1};
elseif nargin>2
    Slice=varargin{1};
end

if size(Sig,1)~=1
    Sig=Sig';
end

X_loc=[];
Y_amp=[];
N=length(Sig);
Threshould=Threshould/N;
%将原始数据局部化，局部化的考虑范围以待计算点(可疑点）为中心，长度受Threshould影响
Minimum=5;%将总长度分割的最小份数
% N_span=N/(N+Minimum-1)*(1/(Threshould+1/N)+Minimum-1);%局部化份数
span=(N+Minimum-1)/(1/(Threshould+1/N)+Minimum-1);%局部化长度
span=max(span,N/Slice);
hwait=waitbar(0,'Searching for peaks');
j=[1:N];
j=j(Sig>mean(Sig)/2);
for i=1:length(j)
    str=['Searching for peaks,please wait...',num2str(fix(100*i/length(j))),'%'];
    waitbar(i/length(j),hwait,str);
    k=j(i);
    Loc_min=max(1,k-floor((span-1)/2));%实际的局部下限，不能小于1
    Loc_max=min(N,k+ceil((span-1)/2));%实际的局部上限，不能大于信号长度N
%     Loc_x=[Loc_min:1:Loc_max];
%     p=polyfit(Loc_x,Sig(Loc_min:Loc_max),1);%最小二乘法拟合曲线，好像没有必要，直接用detrend即可
%     Loc_y=polyval(p,Loc_x);
    Loc_y=detrend(Sig(Loc_min:Loc_max));%在局部范围内的所有幅值大小
%     Loc_lim=norminv(1-Threshould,mean(Loc_y),std(Loc_y));%计算阈值上界，这里将样本考虑成了正态分布

%     if Loc_y(k-Loc_min+1)>Loc_lim
    if normcdf(Loc_y(k-Loc_min+1),mean(Loc_y),std(Loc_y))>1-Threshould
        X_loc=[X_loc,k];
        Y_amp=[Y_amp,Sig(k)];
    end
end
close(hwait);
%%------delete too close points, keep the highest one
col=length(X_loc);%符合阈值条件的点数
A={X_loc,Y_amp};
B{1}(1)=A{1}(1);
B{2}(1)=A{2}(1);
m=1;
for k=2:col
    if abs(A{1}(k)-B{1}(m))<=interv
        if A{2}(k)>B{2}(m)
         B{1}(m)=A{1}(k);
         B{2}(m)=A{2}(k);
        end
    else
        m=m+1;
        B{1}(m)=A{1}(k);
        B{2}(m)=A{2}(k);
    end
end
        X_loc=B{1};
        Y_amp=B{2};
end

