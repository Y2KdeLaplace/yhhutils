function ft_topobrowser(cfg,data)
%FT_TOPOBROWSER 

h = figure('Position', [100, 100, 800, 600]);
set(h,'Resize','off')
h.AutoResizeChildren = 'off';

% set the defaults
if isempty(cfg); cfg = []; end
cfg.zlim            = ft_getopt(cfg, 'zlim',           'maxabs');
cfg.parameter       = ft_getopt(cfg, 'parameter',      'avg');
cfg.colormap        = ft_getopt(cfg, 'colormap',       'default');
cfg.colorbar        = ft_getopt(cfg, 'colorbar',       'no');
cfg.colorbartext    = ft_getopt(cfg, 'colorbartext',   '');
cfg.interpolatenan  = ft_getopt(cfg, 'interpolatenan', 'yes');
cfg.style           = ft_getopt(cfg, 'style',          'straight');
cfg.gridscale       = ft_getopt(cfg, 'gridscale',      67); % 67 in original
if isfield(data,'mask')
    cfg.highlightsymbol    = '.';
    cfg.highlightsize      = 4; % 6
    cfg.highlightcolor     = [0 0 0];
    cfg.highlightfontsize  = 8;
end

% Set ft_plot_topo specific options
if strcmp(cfg.style, 'both');            style = 'surfiso';     end
if strcmp(cfg.style, 'straight');        style = 'surf';        end
if strcmp(cfg.style, 'contour');         style = 'iso';         end
if strcmp(cfg.style, 'fill');            style = 'isofill';     end
if strcmp(cfg.style, 'straight_imsat');  style = 'imsat';       end
if strcmp(cfg.style, 'both_imsat');      style = 'imsatiso';    end

% read or create the layout that will be used for plotting:
tmpcfg = [];
tmpcfg.layout = cfg.layout;
layout = ft_prepare_layout(tmpcfg, data);

% select the channels in the data that match with the layout:
[seldat, sellay] = match_str(data.label, layout.label);
if isempty(seldat)
  ft_error('labels in data and labels in layout do not match');
end

parameter = data.(cfg.parameter);
parameter = parameter(seldat,:);
if isfield(data,'mask')
    mask = data.mask(seldat,:);
end

% get the x and y coordinates and labels of the channels in the data
chanx = layout.pos(sellay,1);
chany = layout.pos(sellay,2);

% check for nans along the time and/or freq dimension
nanInds = any(isnan(parameter), [2 3]);
if istrue(cfg.interpolatenan) && any(nanInds)
  ft_warning('removing channels with NaNs from the data');
  chanx(nanInds) = [];
  chany(nanInds) = [];
  parameter(nanInds,:) = [];
end

% get the z-range
if ischar(cfg.zlim) && strcmp(cfg.zlim, 'maxmin')
  cfg.zlim    = [];
  cfg.zlim(1) = min(parameter(:));
  cfg.zlim(2) = max(parameter(:));
elseif ischar(cfg.zlim) && strcmp(cfg.zlim,'maxabs')
  cfg.zlim     = [];
  cfg.zlim(1)  = -max(abs(parameter(:)));
  cfg.zlim(2)  =  max(abs(parameter(:)));
elseif ischar(cfg.zlim) && strcmp(cfg.zlim,'zeromax')
  cfg.zlim     = [];
  cfg.zlim(1)  = 0;
  cfg.zlim(2)  = max(parameter(:));
elseif ischar(cfg.zlim) && strcmp(cfg.zlim,'minzero')
  cfg.zlim     = [];
  cfg.zlim(1)  = min(parameter(:));
  cfg.zlim(2)  = 0;
end

% check if the colormap is in the proper format
if ~isequal(cfg.colormap, 'default')
  if ischar(cfg.colormap)
    cfg.colormap = ft_colormap(cfg.colormap);
  elseif iscell(cfg.colormap)
    cfg.colormap = ft_colormap(cfg.colormap{:});
  elseif isnumeric(cfg.colormap) && size(cfg.colormap,2)~=3
    ft_error('cfg.colormap must be Nx3');
  end
  % the actual colormap will be set below
end

% non-interactive mode
[~, hs] = ft_plot_topo(chanx, chany, parameter(:,1), 'mask', layout.mask, 'outline', layout.outline, ...
    'interpmethod', 'v4', 'interplim', 'mask', 'style', style, 'clim', cfg.zlim, 'gridscale', cfg.gridscale, ...
    'isolines', 6);
hf = ancestor(hs,'axes');
axis equal;
axis off;
axis manual;
hold on

% check if the colormap is in the proper format
if ~isequal(cfg.colormap, 'default')
  if ischar(cfg.colormap)
    cfg.colormap = ft_colormap(cfg.colormap);
  elseif iscell(cfg.colormap)
    cfg.colormap = ft_colormap(cfg.colormap{:});
  elseif isnumeric(cfg.colormap) && size(cfg.colormap,2)~=3
    ft_error('cfg.colormap must be Nx3');
  end
  % the actual colormap will be set below
end
if ~isempty(cfg.colormap)
  set(gcf,  'colormap', cfg.colormap);
end

% set up color bar
if istrue(cfg.colorbar)
    cb = colorbar;
    cb.Label.String = cfg.colorbartext;
    cb.Label.FontSize = 12;
    cb.Label.FontWeight = 'normal';
    cb.Location = 'eastoutside';
end

% mark out significance
if isfield(data,'mask')
    p = plot(hf, chanx(mask(:,1)), chany(mask(:,1)), cfg.highlightsymbol, 'markersize', cfg.highlightsize, 'color', cfg.highlightcolor);
end
%%% debug layout plot
% text(chanx+0.005, chany+0.0075, data.label ,'horizontalalignment', 'center', 'verticalalignment', 'middle', 'fontsize', cfg.highlightfontsize, 'fontweight', 'normal');

%% slider
% 创建滑块
slider = uicontrol('Style', 'slider', ...
    'Min', 1, 'Max', length(data.time), 'Value', 1, ...
    'SliderStep', [1/(length(data.time)-1), 1/(length(data.time)-1)], ...
    'Position', [100, 50, 600, 20]);

% 创建滑块旁边的文字
txt = uicontrol('Style', 'text', ...
    'Position', [700, 50, 50, 20], ...
    'String', '1');

xdata   = get(hs, 'xdata');
ydata   = get(hs, 'ydata');
nanmask = get(hs, 'cdata');

% 设置滑块回调函数
slider.Callback = @(src, event) updatePlot(src, txt);

    function updatePlot(src, txt)
        % 更新图像并重新绘制
        idx = round(src.Value); % 获取滑块当前位置
        txt.String = num2str(idx); % 更新显示列号

        datamatrix = griddata(chanx, chany, parameter(:, idx), xdata, ydata, 'v4');
        set(hs, 'cdata',  datamatrix + nanmask);

        if isfield(data,'mask')
            try
                p.XData = chanx(mask(:,idx));
                p.YData = chany(mask(:,idx));
            catch
                p = plot(hf, chanx(mask(:,idx)), chany(mask(:,idx)), cfg.highlightsymbol, 'markersize', cfg.highlightsize, 'color', cfg.highlightcolor);
            end
        end
    end
end



