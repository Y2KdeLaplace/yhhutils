function barstat(dat,varargin)
%BARSTAT to draw barplot or only errorbar
% input:
%       dat - a cell array for each errorbar and bar
% options:
%       error: errorbar stat to draw
%             sem - standard error of mean
%             boot - confidence interval of bootstrapping sample
%       color: [R G B] vector for all bar or n*3 matrix for each bar
%       setbar: a cell array for BAR input augment
%       names: names of a cell array for each bar
% Update by Yiheng Hu (2024.5.8)

% read input parameters
options = struct('error',       'sem', ...
                 'color',       [0 0.4470 0.7410], ...
                 'setbar',      [], ...
                 'names',       []);
options = updateaug(options,varargin{:});

if isvector(options.color)
    colors = repmat(options.color,length(dat),1);
else
    colors = options.color;
end

hold on
for i = 1:length(dat)
    miu = mean(dat{i});
    if strcmpi(options.error,'sem')
        sem = std(dat{i},[],1)/sqrt(length(dat{i}));
        ci = [miu-sem; miu+sem];
    elseif strcmpi(options.error,'boot')
        sampled_dist = bootstrp(10000,@mean,dat{i},'Options', ...
            statset('UseParallel',false));
        ci = prctile(sampled_dist,[2.5 97.5]);
    end

    if isempty(options.setbar)
        bar(i,miu,0.7,'EdgeColor',colors(i,:),'FaceColor',colors(i,:), ...
            'FaceAlpha',0.55,'LineWidth',0.5)
    else
        bar(i,miu,0.7,options.setbar{:})
    end
    errorbar(i,miu,abs(miu-ci(1)),abs(miu-ci(2)),...
        'k','LineWidth',0.75)
end
set(gca,'XTick',1:length(dat),'XTickLabel',options.names,'fontsize',16)
xlim([0.25 length(dat)+0.75])
hold off
default_fig(20,0.5,[100 100 400 400])


