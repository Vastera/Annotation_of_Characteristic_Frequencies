%% to change the units of the xlabel and ylabel in figures from [units] to / units

clear h_xlabel h_ylabel
set(gcf,'color',[1 1 1]);
h_xlabel=get(gca,'xlabel');
xstr=h_xlabel.String;
brac1= max(strfind(xstr,'['));
brac2= max(strfind(xstr,']'));
if ~isempty(brac1)
    xstr_new=[xstr(1:brac1-1),' / ',xstr(brac1+1:brac2-1)];
    set(h_xlabel, 'String', xstr_new);
end

h_ylabel=get(gca,'ylabel');
ystr=h_ylabel.String;
slash=strfind(ystr,'/');
if ~isempty(slash)
    supperscript=strfind(ystr,'^');
    if ~isempty(supperscript)
        brac2= max(strfind(ystr,']'));
        if ~isempty(brac2)
            ystr_new=[ystr(1:slash-1),ystr(slash+1:supperscript),'{-',ystr(supperscript+1:brac2-1),'}',ystr(brac2:end)];
        else
            ystr_new=[ystr(1:slash-1),ystr(slash+1:supperscript),'{-',ystr(supperscript+1:end),'}'];
        end
    else
        ystr_new=[ystr(1:slash-1),ystr(slash+1:end-1),'{-1}',ystr(end)];
    end
else
    ystr_new=ystr;
end

brac1= max(strfind(ystr_new,'['));
brac2= max(strfind(ystr_new,']'));
if ~isempty(brac1)
    ystr_new=[ystr_new(1:brac1-1),' / ',ystr_new(brac1+1:brac2-1)];
    set(h_ylabel, 'String', ystr_new);
end
saveas(gcf,get(gcf,'FileName'));
FigureSave;
close all;