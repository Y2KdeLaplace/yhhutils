function each_subj_each_line(m,lw,c)
%EACH_SUBJ_EACH_LINE plot lines in conditions by keeping each subject each
%line. plot lines between 2 conditions among n conditions
%
% each_subj_each_line(m,c,lw)
% m: nsubj*nconds matrix
% lw: line width
% c: colors [R G B]
%
% Written by Yiheng Hu (2023.4.14)
% see SIGNSTAR
if nargin<3||isempty(c); c = repmat([0.65 0.65 0.65],size(m,1),1); end
if nargin<2||isempty(lw); lw = 0.3; end

hold on
for s = 1:size(m,1)
    plot(1:size(m,2),m(s,:),'-','Color',c(s,:),'HandleVisibility','off','LineWidth',lw)
end
hold off


