function frames = ft_topopmovie(cfg,data,param)
% frames = ft_topopmovie(cfg,data,param)
%
% Written by Yiheng Hu (2024.11.8)
% Update (2024.11.11)
% fast version (2024.12.7)

if size(data.avg,2)~=length(param.timecourse)
    error('time course unmatched!');
end

h = figure;
set(h,'Visible','off','Position',[100,100,800,600])
set(h,'Resize','off')
h.AutoResizeChildren = 'off';

%% initializing curve figure
[~,maxvar_ind] = max(var(data.avg,0,2));
h_curve1 = subplot(2,3,1);
plot(h_curve1,data.time,data.avg(maxvar_ind,:),'LineWidth',1.5)
xline(h_curve1,param.event(2:end-1),'k--','LineWidth',1)
xlim(h_curve1,[param.event(1) param.event(end)])
title(h_curve1,'the largest variance')

h_curve2 = subplot(2,3,4);
plot(h_curve2,data.time,mean(data.avg,1),'LineWidth',1.5)
xline(h_curve2,param.event(2:end-1),'k--','LineWidth',1)
xlim(h_curve2,[param.event(1) param.event(end)])
title(h_curve2,'average')

%% initializing topo figure
subplot(2,3,[2 3 5 6]);

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
[~, hs] = ft_plot_topo(chanx, chany, zeros(numel(chanx),1), 'mask', layout.mask, 'outline', layout.outline, ...
    'interpmethod', 'v4', 'interplim', 'mask', 'style', style, 'clim', cfg.zlim, 'gridscale', cfg.gridscale, ...
    'isolines', 6);
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
    p = plot(ancestor(hs,'axes'), chanx, chany, cfg.highlightsymbol, 'markersize', cfg.highlightsize, 'color', cfg.highlightcolor);
end
%%% debug layout plot
% text(chanx+0.005, chany+0.0075, data.label ,'horizontalalignment', 'center', 'verticalalignment', 'middle', 'fontsize', cfg.highlightfontsize, 'fontweight', 'normal');

%% draw movie
xdata   = get(hs, 'xdata');
ydata   = get(hs, 'ydata');
nanmask = get(hs, 'cdata');

frames = struct('cdata',[],'colormap',[]);
for itp = 1:length(data.time)

    if itp>1; delete(hl1); delete(hl2); end
    hl1 = xline(h_curve1,data.time(itp),'r','LineWidth',1);
    hl2 = xline(h_curve2,data.time(itp),'r','LineWidth',1);

    datamatrix = griddata(chanx, chany, parameter(:, itp), xdata, ydata, 'v4');
    set(hs, 'cdata',  datamatrix + nanmask);

    if isfield(data,'mask')
        p.XData = chanx(mask(:,itp));
        p.YData = chany(mask(:,itp));
    end

    drawnow;
    frames(itp) = getframe(h); % get the current frame and store it
end
close all




