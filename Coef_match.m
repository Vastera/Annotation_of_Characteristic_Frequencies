function [Coef,simi] = Coef_match(f_target,f_can,varargin)
%Coef_match   match a frequency with possible combatinations of frequency candidates 
% CopyRignt@ vastera_ma 
% email:vastera@163.com
%%%%%%%%%  INPUT:       
%   f_target    a number: 
%               target frequency
%
%   f_can       an array: 
%               frequecies candidates 
% --------Optional:
%   weight_Coef a vector: length(weight_Coef)=Coef, default=ones(size(f_can))
%               Determine the weightings of each item in coefficients(frequency). for example, if weight_Coef=[1,10,%               1,1], denoting that the second item is important, and it is more likely to be chosen
%               
%   err         a number: 
%               error tolerance which is allowed in matching process
%
%   N_max       a number or an array: 
%               when it is a number , it is max number of all f_can's multiples,
%               when it is an array it assaigns a limits for each frequency  
%
%  Disp     a number
%               1(default) is to display errors and waitbars, or 0 is to display
%               warnings and no waitbars
%    
%%%%%%%%%  OUTPUT:
%   Coef        a matrix:
%               each row is a possible combination of coefficients within the error tolerance.
%
%   simi        an array:(has the same length with Coef)
%               difference bewteen the target frequency and the Coefficients combination
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% initialization for optional inputs
weight_Coef=ones(size(f_can));
err=1e-2;
N_max=2;% default value of N_max
Disp=1; %default display mode
if nargin>=6
    Disp=varargin{4};
end
if nargin>=5
    weight_Coef=varargin{3};
end
if nargin>=4
    N_max=varargin{2};
end
if nargin>=3
    err=varargin{1};
end
N_can=length(f_can);
if max(size(N_max))==1
    N_max=ones(N_can,1)*N_max;
end
%% search for each possible combination of coefficients
%% -----------Recursive algorithm to traverse every possiblities
i_f=1;
f_t=0;
Coef_t=[];
Norm_coef=[];
if Disp
    h=waitbar(0,'Coefficients matching...');
end
perms_recur(N_can);
if Disp, close(h); end
%% Sort the Coefficient according to their Norm
[~,I]=sort(Norm_coef);
if exist('Coef','var')==0 , Coef=NaN;simi=NaN;
    if Disp, msgbox('Can''t find any coefficient combination!');end 
    return; 
end

Coef=Coef(I,:);simi=simi(I);
%% ----support functions-----------
function  perms_recur(i)

    if i>=2
        for j=-N_max(i):N_max(i)
            if i==N_can && Disp
                waitbar((j+N_max(i))/N_max(i)/2,h,'Coefficients matching...');
            end
            Coef_t(i)=j;
            f_t=f_t+f_can(i)*j;
            perms_recur(i-1);
            f_t=f_t-f_can(i)*j;
        end
    elseif i==1
        for j = -N_max(i):N_max(i)
            Coef_t(i)=j;
            f_t=f_t+f_can(i)*j;

            if abs((f_t-f_target)/f_target)<err && abs(f_t-f_target)<sqrt(f_target)*5*err% judge whether the f_t is similar to f_target or not
                Coef(i_f,:)=Coef_t;
                simi(i_f)=abs(f_t-f_target);
                Norm_coef(i_f)=Penalty(Coef_t,simi(i_f),weight_Coef);
                i_f=i_f+1;
            end
            f_t=f_t-f_can(i)*j;
        end
%         Coef_t=zeros(1,N_can);
    end
end
%------------------ Penalty function of Coefficients-------------
function Pty=Penalty(Coef,simi,weight_Coef)
    if length(Coef)~=length(weight_Coef)
        error('the size of coefficients must match the size of weights of coefficients!')
    end
    Pty=norm(Coef./weight_Coef,1)*sum(Coef~=0)+simi*100;
end

end

