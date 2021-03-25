function [Txt]=Coef2Text(Coef,f_name,varargin)
% Copyright@ vastera@163.com
% General introduction:convert coefficents of characteristic frequency into text for labeling in the figure
%% ====================== INPUT ========================
% Coef:          Type:Matrix of coefficients
%                           Coef description:each row is a set of coefficients for a frequency point, each column is a characteristic frequency
% 
% f_name:          Type:cell array
%                           Coef description: names of characteristic frequencies
% ---------------------OPTIONAL:
% optional arg:  sigType            Type: string
%                            description: the type of signal: 'envelope'(default), 'original'(need add the f_{\rm n} as natural frequency)
%% ====================== OUTPUT =======================
% Txt{ii}:          Type:Cell array
%                           Txt{ii} description:the text content converted
%% =====================================================
sigType='envelope';
if nargin>=3
    sigType=varargin{1};
end
for ii=1:size(Coef,1)
    Txt{ii}=[];
    if strcmp(sigType,'envelope')
        for jj=1:size(Coef,2)
            if Coef(ii,jj)~=0
                if Coef(ii,jj)>1
                    Txt{ii}=[Txt{ii}, '+',num2str(Coef(ii,jj)),f_name{jj}];
                elseif Coef(ii,jj)==1
                    Txt{ii}=[Txt{ii}, '+',f_name{jj}];
                elseif Coef(ii,jj)==-1
                    Txt{ii}=[Txt{ii}, '-',f_name{jj}];
                elseif Coef(ii,jj)<-1
                    Txt{ii}=[Txt{ii},num2str(Coef(ii,jj)),f_name{jj}];
                end
                if Txt{ii}(1)=='+', Txt{ii}(1)=[]; end% cut the first '+' on the head
            end
        end
    elseif strcmp(sigType,'original')
        for jj=1:size(Coef,2)
            if Coef(ii,jj)>1
                Txt{ii}=[Txt{ii}, '+',num2str(Coef(ii,jj)),f_name{jj}];
            elseif Coef(ii,jj)==1
                Txt{ii}=[Txt{ii}, '+',f_name{jj}];
            elseif Coef(ii,jj)==-1
                Txt{ii}=[Txt{ii}, '-',f_name{jj}];
            elseif Coef(ii,jj)<-1
                Txt{ii}=[Txt{ii},num2str(Coef(ii,jj)),f_name{jj}];
            end
        end
        Txt{ii}=['f_{\rm n}',Txt{ii}];
    else
        error('unKnown signal type!');
    end
    Txt{ii}=['$', Txt{ii},'$'];
end
end

