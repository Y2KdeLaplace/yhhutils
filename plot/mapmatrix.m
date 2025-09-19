function mapmatrix(mat,varargin)
%TPMATRIX  to draw heatmap with self-defined index
%
% tpmatrix(mat,varargin)
% 
% Input:
% 
% mat                  - m*n matrix to plot heatmap
% 
% tpmatrix(mat, 'PARAM1',val1, 'PARAM2',val2, ...)
% 
% 'setaxis'            - set up {xaxis,yaxis} in real time course (second) 
%                       in a cell array with each element representing a
%                       tp. If it's a vector, xaxis and yaxis share the  
%                       same time course
%
% 'setgca'              - setup the figure in second, a cell array like 
%                       below: e.g.
%                       setgca_perc = {
%                       'XLim',[-0.2 0.5], ...
%                       'YLim',[-0.2 0.5], ...
%                       'XTick',[-0.2 0 0.5], ...
%                       'YTick',[-0.2 0 0.5], ...
%                       'XTickLabel',num2cell([-0.2 0 0.5]), ...
%                       'YTickLabel',num2cell([-0.2 0 0.5]), ...
%                       'Colormap',cm, ...
%                       'CLim',[0.5 0.7]};
% 
% 'dash_x'              - x tick seconds dashline on x-axis; same as 'dash_y'
% 
% 'setdash'             - a 1*2 cell array indicates the second ticks to draw dash
%                       lines; the 1st cell is color of each line, the 2nd 
%                       cell is linewidth of eachline; see DASHLINES
%
% 'title'               - a cell array where {'heatmap title','colorbar title'}
%
% %% unusual options
% 'colorbar'            - set up a colorbar or not, true or false (true by
% default)
% 'upY'                 - normal or reverse ('normal' by default); up-down
% 
% Written by Yiheng Hu (2023.4.17)
% Updated by Yiheng Hu (2023.9.26)
mapping_keys = {'XLim','YLim','XTick','YTick'};
[ylen,xlen] = size(mat);
options = struct('setaxis',         [], ...
                 'dash_x',          [], ...
                 'dash_y',          [], ...
                 'setdash',         [], ...
                 'setgca',          [], ...
                 'colorbar',        true, ...
                 'upY',             'normal');

% setup default parameters
options.title = {'',''};
options.setdash = {[0 0 0],1};
options.setaxis = {1:xlen,1:ylen};
options.setgca = {'XLim',[1 size(mat,2)], ...
                  'YLim',[1 size(mat,1)]};

% read input parameters
options = updateaug(options,varargin{:});
if contains('setaxis',varargin(1:2:end))&&~contains('setgca',varargin(1:2:end))
    options.setgca = {'XLim',[options.setaxis{1}(1) options.setaxis{1}(end)], ...
        'YLim',[options.setaxis{2}(1) options.setaxis{2}(end)]};
elseif ~contains('setaxis',varargin(1:2:end))&&contains('setgca',varargin(1:2:end))
    error('this function is not for this type usage')
end

% timing correction
if ~iscell(options.setaxis)
    % sample rate above 20Hz, align to 0 (ignore tiny lag from resample)
    tmp = options.setaxis;
    options.setaxis = cell(1,2);
    options.setaxis{1} = tmp;
    options.setaxis{2} = tmp;
    clear tmp
end

% check time course length
if length(options.setaxis{1})~=size(mat,2)||length(options.setaxis{2})~=size(mat,1)
    error('Unmatched time course')
end

% map time course to heat map
mapx = @(x_sec) ((xlen-1).*x_sec+(options.setaxis{1}(end)-options.setaxis{1}(1)*xlen))/...
    (options.setaxis{1}(end)-options.setaxis{1}(1));
mapy = @(y_sec) ((ylen-1).*y_sec+(options.setaxis{2}(end)-options.setaxis{2}(1)*ylen))/...
    (options.setaxis{2}(end)-options.setaxis{2}(1));
for i = 1:length(mapping_keys)
    if any(strcmp(mapping_keys{i}, options.setgca))
        if strcmpi(mapping_keys{i}(1),'y')
            options.setgca{find(strcmp(mapping_keys{i}, options.setgca))+1} = ...
                mapy(options.setgca{find(strcmp(mapping_keys{i}, options.setgca))+1});
        elseif strcmpi(mapping_keys{i}(1),'x')
            options.setgca{find(strcmp(mapping_keys{i}, options.setgca))+1} = ...
                mapx(options.setgca{find(strcmp(mapping_keys{i}, options.setgca))+1});
        end
        if i == 1 || i == 2
            options.setgca{find(strcmp(mapping_keys{i}, options.setgca))+1} = ...
                options.setgca{find(strcmp(mapping_keys{i}, options.setgca))+1} + [-0.5 0.5];
        end
    end
end
options.dash_x = mapx(options.dash_x);
options.dash_y = mapy(options.dash_y);

% plotting
imagesc(mat);hold on;
if ~isempty(options.dash_x)
    xline(options.dash_x,'--','Color',options.setdash{1},'LineWidth',options.setdash{2})
end
if ~isempty(options.dash_y)
    yline(options.dash_y,'--','Color',options.setdash{1},'LineWidth',options.setdash{2})
end

if options.colorbar
    h = colorbar;
    h.Label.String = options.title{2};
    h.Label.FontName = 'Arial';
    h.Label.Rotation = 270;
    h.Label.VerticalAlignment = 'bottom';
    h.Label.HorizontalAlignment = 'center';
end
title(options.title{1},'FontWeight','normal')
set(gca,'YDir',options.upY,options.setgca{:})

if size(mat,1)==size(mat,2)
    axis square
end

end

