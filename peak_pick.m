function [Coef,simi]=peak_pick(f_can,varargin)
% CopyRignt@ vastera_ma 
% email:vastera@163.com
%% INPUT:
% f_can:        a vector of numbers
%                       candidates of characteristic frequency (such as
%                       [0.31, 3.55,4.68];
%---OPTIONAL:
% f_name:       a cell of strings whose length is same as f_can
%                       names of characteristic frequencies (such as
%                       {'{\it{f}}_5','{\it{f}}_s','{\it{f}}_{mesh}'}
%   err         a number: 
%               error tolerance which is allowed in matching process
%
%   N_max       a number or an array: 
%               when it is a number , it is max number of all f_can's multiples,
%               when it is an array it assaigns a limits for each frequency  
%% OUTPUT:
% Coef:         a N*length(f_can)
%               the N possible coefficient combinations
% simi          an N array
%               the  errors correponding to each Coefficients combination
%% get the cursor data
narginchk(1, 5);
err=1e-3;
N_max=6;
weight_Coef=ones(size(f_can));
if nargin>=2
    f_name=varargin{1};
    if length(f_name)~=length(f_can), error('f_name need to have the same length with f_can');end
end
if nargin>=3
    err=varargin{2};
end
if nargin>=4
    N_max=varargin{3};
    if length(N_max)~=length(f_can), error('N_max need to have the same length with f_can');end
end
if nargin>=5
    weight_Coef=varargin{4};
    if length(weight_Coef)~=length(f_can), error('weight_Coef need to have the same length with f_can');end
end
%% sort the frequency candidates in an ascending order
[f_can_sorted,I]=sort(f_can,'descend');
if nargin>=2, f_name=f_name(I); end
if nargin>=5, weight_Coef=weight_Coef(I); end
%% get the current cursor
 gcf_cursor=datacursormode(gcf);
 cursor_info=getCursorInfo(gcf_cursor);
 if isempty(cursor_info), msgbox('Please pick a piont in a figure by cursor'); Coef=NaN;simi=NaN;return; end
for ii=1:length(cursor_info)
    annotate(cursor_info(ii).Position(1),cursor_info(ii).Position(2));
end

%% Support functions
%------------- annotate one point data --------------
function annotate(x,y)
        %% match the coefficients with cursor data
% f_can=[0.661956522	1	0.241666667	0.057168459	1.025459229	1.025459229	0.020509185	0.008337067	0.190858472	0.137288482	0.061137879];
% f_can=[0.241666667	0.057168459	1.025459229	0.020509185	0.008337067	0.190858472];
% f_name={'{\it{f}}_5','{\it{f}}_s','{\it{f}}_{mesh}','{\it{f}}^{(s)}_o','{\it{f}}_c','{\it{f}}_i'};
%% main content as follows
% f_associate=0;
% if nargin>=2% when displayment is required
    [Coef,simi] = Coef_match(x,f_can_sorted,err,N_max,weight_Coef); 
% else
%     [Coef,simi] = Coef_match(x,f_can,err,N_max,weight_Coef); 
% end

if isnan(Coef) , warning('can''t find any appropriate coefficient!'); return;end
    if nargin>=2% if number of input arguments is more than 1, then display the outcome visually
        for i=1:min(5,size(Coef,1))
            str=Gen_Str(Coef(i,:),f_name);         
            disp(str);
            if i==1
                Annotate(str, [x, y*1.01]);
            end
        end
    else
       display(Coef(1,:)); 
end
%-------------Generate the annotation string----------
function str=Gen_Str(Coef_row,f_name)
    % if the first coefficients is negtive, then shift the postions, until
    % the first positive coefficients
    Index_positive=find(Coef_row>0,1,'first');% the positive coefficients
    jj=1:length(Coef_row);
    jj(1:Index_positive)=circshift(jj(1:Index_positive),1);
    Coef_row=Coef_row(jj);
    f_name=f_name(jj);
    % initialize the ouput string as empty string
    str=[];
    for j=1:size(Coef,2)
        if Coef_row(j)>1 
            str=[str, '+',num2str(Coef_row(j)),f_name{j},' '];
        elseif Coef_row(j)==1 
            str=[str, '+',f_name{j},' '];
        elseif Coef_row(j)==-1
            str=[str,'-', f_name{j},' '];
        elseif Coef_row(j)<-1
            str=[str, num2str(Coef_row(j)),f_name{j},' '];
        end
    end
    if str(1)=='+', str(1)=[]; end% cut the first '+' on the head
    str=['$', str,'$'];
end

end
end
