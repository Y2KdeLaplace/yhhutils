function h_surf = drawsurf(activity_data,sourcemodel,cm,brainstructure)
%DRAWSURF draw suface activity
%
% view(-90,0) % left lateral brain
% view(90,0) % right leteral brain
% view(0,90) % dorsal view
% view(180,-90) % ventral view
% view(180,0) % anterior view
% view(0,0) % posterior view
%
% Written by Yiheng Hu (2024.11.27)

%% define variables
if contains(upper(brainstructure),{'BOTH','BH'})
    indx_vertices = true(size(sourcemodel.inside));
    tri = sourcemodel.tri; % 三角形网格的边
elseif contains(upper(brainstructure),{'LEFT','LH'})
    indx_vertices = sourcemodel.brainstructure==find(contains(sourcemodel.brainstructurelabel,'LEFT'));
    indx_tri = sourcemodel.brainstructure_tri==find(contains(sourcemodel.brainstructurelabel,'LEFT'));
    tri = sourcemodel.tri(indx_tri,:); % 三角形网格的边
elseif contains(upper(brainstructure),{'RIGHT','RH'})
    indx_vertices = sourcemodel.brainstructure==find(contains(sourcemodel.brainstructurelabel,'RIGHT'));
    indx_tri = sourcemodel.brainstructure_tri==find(contains(sourcemodel.brainstructurelabel,'RIGHT'));
    tri = sourcemodel.tri(indx_tri,:)-sum(sourcemodel.brainstructure==find(contains(sourcemodel.brainstructurelabel,'LEFT'))); % 三角形网格的边
end
activity_data = activity_data(indx_vertices);
pos = sourcemodel.pos(indx_vertices,:); % 每个顶点的x, y, z坐标
if isfield(sourcemodel,'sulc')
    sulc = 0.5*ones(size(sourcemodel.sulc,1),3);
    tmp = max_min_normalization(sourcemodel.sulc);
    sulc(sourcemodel.sulc<0,:) = tmp(sourcemodel.sulc<0,:).*ones(1,3);
    sulc(sourcemodel.sulc>0,:) = tmp(sourcemodel.sulc>0,:).*ones(1,3);
    sulc(~sourcemodel.inside,:) = 0.5;
%     tmp = 0.5 + sourcemodel.sulc/(2*max(abs(sourcemodel.sulc)));
%     sulc = tmp*ones(1,3);
    sulc = sulc(indx_vertices,:);
end

%% drawing
hold on;
if isfield(sourcemodel,'sulc')
    trisurf(tri, pos(:,1), pos(:,2), pos(:,3), 'FaceVertexCData', sulc, ...
        'EdgeColor', 'none', 'FaceColor', 'interp');
else
    trisurf(tri, pos(:,1), pos(:,2), pos(:,3), 'FaceColor', [0.65, 0.65, 0.65], 'EdgeColor', 'none');
end
if any(~isnan(activity_data))
    h_surf = trisurf(tri, pos(:,1), pos(:,2), pos(:,3), activity_data, ...
        'EdgeColor', 'none', 'FaceColor', 'interp');
    colormap(gcf,cm)
else
    h_surf = [];
end
axis equal;
axis manual;

% setup camera
set(gca, 'XLim', [min(pos(:,1)), max(pos(:,1))], ...
'YLim', [min(pos(:,2)), max(pos(:,2))], ...
'ZLim', [min(pos(:,3)), max(pos(:,3))]);
camproj('perspective'); % projection
camva(7); % fix visual angle
camtarget(mean(pos, 1)); % lock camera to the position center

% remove grid, background & axis
set(gca, 'Visible', 'off');
set(gcf, 'Color', 'white');
set(gcf, 'InvertHardcopy', 'off'); 
set(gca, 'XLim', [min(pos(:,1)), max(pos(:,1))], ...
    'YLim', [min(pos(:,2)), max(pos(:,2))], ...
    'ZLim', [min(pos(:,3)), max(pos(:,3))]);
view(90,0) % right leteral brain

