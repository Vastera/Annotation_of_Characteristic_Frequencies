function SetFigureProperties(varargin)
%SETFIGUREPROPERTIES to set the figure properties in an united way
%   including fonts,axes,positions and so on
%   users can choose different types for different figures in different
%   papers, for example: 2-D figure in English paper or 3-D in Chinese etc.
%---------INPUT:
%   type:         an index number  to choose a set of
%                  properties(default=1);
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
narginchk(0,1);
type=1;
if nargin==1 
    type=varargin{1};
end
switch type
    case 1
        set(gcf,'Units','centimeters','Position',[6 6 12 6]);%12��8
        set(gca,'Position',[.13 .17 .80 .75]);%����xy����ͼƬ��ռ�ı���
        set(get(gca,'XLabel'),'FontSize',8,'FontName','Times New Roman');%ͼ������Ϊ8 point��С5��
        set(get(gca,'YLabel'),'FontSize',8,'FontName','Times New Roman');
        set(gca,'fontsize',8,'FontName','Times New Roman');
        h=gca;
%         set(h.Children,'Color',[0,0,1]);%set the color as blue
end

end

