function [X_loc,Y_amp] = DataSearch(Sig,Threshould,varargin)
% CopyRignt@ vastera_ma 
% email:vastera@163.com
%DATASEARCH  ������ȡ��ֵ����Ⱥ�㣩�Ĵ�С��λ��
%   Sig �����ź�
%   Threshould ����ȡ��Ⱥ�㣨��ֵ��ռ�ܵ����ı���[0~1]
%   Slice    �ֲ�����ָ�����������˴�Ĭ��Ϊ100
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
%��ԭʼ���ݾֲ������ֲ����Ŀ��Ƿ�Χ�Դ������(���ɵ㣩Ϊ���ģ�������ThreshouldӰ��
Minimum=5;%���ܳ��ȷָ����С����
% N_span=N/(N+Minimum-1)*(1/(Threshould+1/N)+Minimum-1);%�ֲ�������
span=(N+Minimum-1)/(1/(Threshould+1/N)+Minimum-1);%�ֲ�������
span=max(span,N/Slice);
hwait=waitbar(0,'Searching for peaks');
j=[1:N];
j=j(Sig>mean(Sig)/2);
for i=1:length(j)
    str=['Searching for peaks,please wait...',num2str(fix(100*i/length(j))),'%'];
    waitbar(i/length(j),hwait,str);
    k=j(i);
    Loc_min=max(1,k-floor((span-1)/2));%ʵ�ʵľֲ����ޣ�����С��1
    Loc_max=min(N,k+ceil((span-1)/2));%ʵ�ʵľֲ����ޣ����ܴ����źų���N
%     Loc_x=[Loc_min:1:Loc_max];
%     p=polyfit(Loc_x,Sig(Loc_min:Loc_max),1);%��С���˷�������ߣ�����û�б�Ҫ��ֱ����detrend����
%     Loc_y=polyval(p,Loc_x);
    Loc_y=detrend(Sig(Loc_min:Loc_max));%�ھֲ���Χ�ڵ����з�ֵ��С
%     Loc_lim=norminv(1-Threshould,mean(Loc_y),std(Loc_y));%������ֵ�Ͻ磬���ｫ�������ǳ�����̬�ֲ�

%     if Loc_y(k-Loc_min+1)>Loc_lim
    if normcdf(Loc_y(k-Loc_min+1),mean(Loc_y),std(Loc_y))>1-Threshould
        X_loc=[X_loc,k];
        Y_amp=[Y_amp,Sig(k)];
    end
end
close(hwait);
%%------delete too close points, keep the highest one
col=length(X_loc);%������ֵ�����ĵ���
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

