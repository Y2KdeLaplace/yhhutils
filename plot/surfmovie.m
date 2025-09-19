function frames = surfmovie(activity_data,sourcemodel,param,cm,clrange)
%SURFMOVIE(activity_data,sourcemodel,param,cm) draw surface movie
% Written by Yiheng Hu (2024.11.11)
% New version (2024.11.26-27)
if size(activity_data,2)~=length(param.timecourse)
    error('time course unmatched!');
end

views = [
    -90 90; % lh dorsal
    -90, 0; % lh lateral
    90, 0; % rh lateral
    90, 90; % rh dorsal
    -90, -90; % lh ventral
    90, 0; % lh medial
    -90, 0; % rh medial
    90, -90; % rh ventral
    ];
hemispheres = {'lh dorsal','lh lateral','rh lateral','rh dorsal','lh ventral','lh medial','rh medial','rh ventral'};
if nargin<5
    if isfield(sourcemodel,'mask')
        tmp = activity_data(~sourcemodel.mask);
        tmp = tmp(~isnan(tmp));
    else
        tmp = activity_data(~isnan(activity_data));
    end
    tmp = mean(tmp) + 2*std(tmp);
%     tmp = max(abs(tmp));
    clrange = [-tmp tmp];clear tmp
end

%% initialize figure
h = figure;
set(gcf,'Visible','off','Position',[0 0 1280 720])

% averaged activation time course
h_curve = subplot(3,4,[10 11 12]);
plot(h_curve, param.timecourse, mean(activity_data,1,'omitnan'), 'LineWidth', 1.5)
xline(h_curve, param.event(2:end-1), 'k--', 'LineWidth',1)
xlim(h_curve, [param.event(1) param.event(end)])
title(h_curve, 'average')

% surface
h_surfs = cell(1,length(hemispheres));
for iview = 1:size(views,1)
    subplot(3,4,iview);
    h_surfs{iview} = drawsurf(activity_data(:,1),sourcemodel,cm,hemispheres{iview});
    caxis(gca,clrange);
    view(views(iview,:))
end

subplot(3,4,9);
colormap(gcf,cm)
cb = colorbar;
cb.Label.String = 'Surface source';
cb.Label.FontSize = 12;
cb.Label.FontWeight = 'normal';
cb.Location = 'east';
caxis(gca,clrange);
set(gca, 'Visible', 'off');

%% setup activity
lh_idx = sourcemodel.brainstructure==find(contains(sourcemodel.brainstructurelabel,'LEFT'));
rh_idx = sourcemodel.brainstructure==find(contains(sourcemodel.brainstructurelabel,'RIGHT'));
if isfield(sourcemodel,'mask')
    activity_data(~sourcemodel.mask) = nan;
end

%% draw movie
frames = struct('cdata',[],'colormap',[]);
for itp = 1:size(activity_data, 2)
    if itp>1; delete(hl1); end
    hl1 = xline(h_curve,param.timecourse(itp),'r','LineWidth',1);
    tp_surf = activity_data(:,itp);
    
    cellfun(@(x) set(x,'FaceVertexCData',tp_surf(lh_idx),'FaceColor','interp'), ...
        h_surfs(contains(hemispheres,'lh')),'UniformOutput',false);
    cellfun(@(x) set(x,'FaceVertexCData',tp_surf(rh_idx),'FaceColor','interp'), ...
        h_surfs(contains(hemispheres,'rh')),'UniformOutput',false);
    
    frames(itp) = getframe(h); % get the current frame and store it
end
close all



