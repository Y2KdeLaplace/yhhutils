function errbar(dat,varargin)
%ERRSTAT to draw barplot or only errorbar
% input:
%       dat - a cell array or a matrix where each cell or each column is
%             for each errorbar and bar
% options:
%       error: errorbar stat to draw
%             sem - standard error of mean
%             boot - confidence interval of bootstrapping sample
%       color: [R G B] vector for all bar or n*3 matrix for each bar
%       setline: a cell array for errorbar input augment
%       names: names of a cell array for each bar
% Update by Yiheng Hu (2024.5.8)

% read input parameters
options = struct('error',       'sem', ...
                 'color',       [0 0 0], ...
                 'setline',     [], ...
                 'names',       []);
options = updateaug(options,varargin{:});

if isvector(options.color)
    colors = repmat(options.color,length(dat),1);
else
    colors = options.color;
end

if ~iscell(dat)
    dat = mat2cell(dat,size(dat,1),ones(1,size(dat,2)));
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

    if isempty(options.setline)
        plot(i,miu,'o','Color',colors(i,:),'LineWidth',0.75)
        errorbar(i,miu,abs(miu-ci(1)),abs(miu-ci(2)),...
            'Color',colors(i,:),'LineWidth',0.75)
    else
        plot(i,miu,'o','Color',colors(i,:),options.setline{:})
        errorbar(i,miu,abs(miu-ci(1)),abs(miu-ci(2)),'Color',colors(i,:),...
            options.setline{:})
    end
end
set(gca,'XTick',1:length(dat),'XTickLabel',options.names,'fontsize',16)
xlim([0.25 length(dat)+0.75])
hold off


