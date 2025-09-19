function time_course_curve(timecourse,acc,colors,varargin)
%TIME_COURSE_CURVE(timecourse,acc,colors,varargin)
% timecourse            - time course of a vector in seconds
% acc                   - a cell array with 1*n, n is condition number;
%                           each cell is nsubj*ntp
% 
% 'chance'              - chance level of decoding
%
% 'dash_x'              - x tick dashline on x-axis
% 
% 'setdash'             - a 1*2 cell array indicates the ticks to draw dash
%                       lines; the 1st cell is color of each line, the 2nd 
%                       cell is linewidth of eachline; see DASHLINES
%
% 'setgca'              - setup the figure, a cell array like below:
%                       e.g.
%                       Defaults = {'YTick',perc_tsel.time_tick, ...
%                                   'XTick',perc_tsel.time_tick, ...
%                                   'YTickLabel',[1 2], ...
%                                   'XTickLabel',[-0.2 0 1.3], ...
%                                   'XLim',[-0.2 1.3], ...
%                                   'YLim',[1 2]};
% 
% 'xname'               - variate name of x
% 
% 'yname'               - variate name of y
%
% 'title'               - figure title
%
% 'legend'              - a cell array of labels
% 
% %% unusual options
% 'face'                - face of error stripe
% 'linewidth'           - a number of line width
%
% Written by Yiheng Hu (2023.9.26)

% read input parameters
options = struct('chance',          0.5, ...
                 'dash_x',          [], ...
                 'setgca',          [], ...
                 'legend',          [], ...
                 'linewidth',       1, ...
                 'face',            0.4, ...
                 'title',           [], ...
                 'yname',           '', ...
                 'xname',           'Time (s)');
options.setdash = {[0 0 0],0.75};
options = updateaug(options,varargin{:});

if isempty(options.setgca)
    options.setgca = {'YLim',[-0.5 1]};
end

if ~iscell(timecourse)
    xtime = cell(1,length(acc));
    for icond = 1:length(acc)
        xtime{icond} = timecourse;
    end
end

if isempty(options.legend)
    options.legend = cell(1,length(acc));
    for i = 1:length(acc)
        options.legend{i} = '';
    end
end

for icond = 1:length(acc)
    x = xtime{icond}; % sample rate above 20Hz, align to 0 (ignore tiny lag from resample)
    y = mean(acc{icond},1);
    if isempty(options.legend{icond})
        plot(x,y,'color',colors(icond,:),'LineWidth',options.linewidth, ...
            'HandleVisibility','off');
    else
        plot(x,y,'color',colors(icond,:),'LineWidth',options.linewidth, ...
            'DisplayName',options.legend{icond});
    end
    errors=squeeze(std(acc{icond},[],1))/sqrt(size(acc{icond},1));
    errorstripe(errors(:), x(:), y(:), colors(icond,:), options.face)
end
if ~isempty(options.dash_x)
    xline(options.dash_x,'--','Color',options.setdash{1},'LineWidth',options.setdash{2},'HandleVisibility','off')
end
yline(options.chance,'--','Color',options.setdash{1},'LineWidth',options.setdash{2},'HandleVisibility','off')
set(gca,options.setgca{:})
box off
if ~isempty(cell2mat(options.legend))
    legend('Location','best')
end
if ~isempty(options.title)
    title(options.title)
end
if ~isempty(options.yname)
    ylabel(options.yname)
end
if ~isempty(options.xname)
    xlabel(options.xname)
end
