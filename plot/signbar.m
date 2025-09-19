function  signbar(timecourse,sig,y,varargin)
%SIGNBAR This function used to mark the significant point with a horizontal
%line. Before using it, you should have something drawn on a figure to hold
%on it.
%   signbar(timecourse,sig,y,c)
%   timecourse: the entire timecourse for figure
%   sig: an array combined with 0 or 1, which 1 indicates significant point
%   y: the line position on y axis
%   c: color of the line. [0 0 0] by default.
%   lw: line width. 1 by default
%   label: legend for this significant bar
% Written by Yiheng Hu(2022.4.12)
%
% ------------- log ---------------
% Debug & updated by Luchengcheng Shu(2022.7.5) -- add dots ploting
% Change 'bwboundaries' to 'bwlabel' and add linewidth parameter 'lw' (2023.5.25 Yiheng Hu)
% Update self-defined timecourse and optimize code (2024.2.5 Yiheng Hu)
% add legends and optimize code (2025.1.15 Yiheng Hu)

opt.c = 'black';
opt.lw = 1;
opt.label = [];
keys = {'c','lw','label'};
if nargin > 3
    for i = 1:length(varargin)
        if ~isempty(varargin{i})
            opt.(keys{i}) = varargin{i};
        end
    end
end
if isempty(timecourse)
    timecourse = 1:length(sig);
end

L = bwlabel(sig(:),4);

hold on
for i = 1:max(L)
    if isempty(opt.label)
        if sum(L==i)>1
            plot(timecourse(L==i),y*ones(1,length(timecourse(L==i))),'-','Color',opt.c, ...
                'LineWidth',opt.lw,'HandleVisibility','off');
        else
            plot(timecourse(L==i),y,'Marker','.','LineWidth',opt.lw,'MarkerFaceColor',opt.c, ...
                'MarkerEdgeColor',opt.c,'HandleVisibility','off');
        end
    elseif i == 1
        if sum(L==i)>1
            plot(timecourse(L==i),y*ones(1,length(timecourse(L==i))),'-','Color',opt.c, ...
                'LineWidth',opt.lw,'DisplayName',opt.label);
        else
            plot(timecourse(L==i),y,'Marker','.','LineWidth',opt.lw,'MarkerFaceColor',opt.c, ...
                'MarkerEdgeColor',opt.c,'DisplayName',opt.label);
        end
        opt.label = [];
    end
end
hold off
if any(sig==1)
    legend('Location','best')
end