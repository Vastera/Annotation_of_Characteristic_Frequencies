% CopyRignt@ vastera_ma 
% email:vastera@163.com
function Annotate(varargin)
Text='$f_{\rm ps}$';
if nargin>0
    Text=varargin{1};
end

if nargin>1
    Xdata=varargin{2}(1);
    Ydata=varargin{2}(2);
else
    [Xdata,Ydata]=ginput(1);
end

hold on;
ylim_max=max(ylim);
% plot([Xdata Xdata],[Ydata*1.1 200],'k-.');%»­³öÐéÏß
plot([Xdata Xdata],[Ydata+length(Text)*ylim_max/140 ylim_max],'k-.');
text(Xdata,Ydata,Text,'FontSize',20,'FontName','Times New Roman','Rotation',90,'Interpreter','latex','Color','Black');
hold off;
% global Fn
% Fn=114.6;
% PlotDash_Fourier(Xdata,Ydata);
end
