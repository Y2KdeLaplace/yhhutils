function surfbrowser(data,sourcemodel,cm,brainstructure,lightflag)
% browser for surface activity
% Written by Yiheng Hu (2024.12.5)

figure('Position', [100, 100, 800, 600]);

h_surf = drawsurf(data(:,1),sourcemodel,cm,brainstructure);
tmp = data(~isnan(data));
% tmp = prctile(tmp,99);
tmp = mean(tmp) + 3*std(tmp);% gen conn
caxis(gca,[-tmp, tmp]);
% caxis(gca,[-max(abs(data(:))), max(abs(data(:)))]);
if lightflag
    camlight(0, 0);
    camlight(180, 0);
    material dull
end

% 创建滑块
slider = uicontrol('Style', 'slider', ...
    'Min', 1, 'Max', size(data, 2), 'Value', 1, ...
    'SliderStep', [1/(size(data, 2)-1), 1/(size(data, 2)-1)], ...
    'Position', [100, 50, 600, 20]);

% 创建滑块旁边的文字
txt = uicontrol('Style', 'text', ...
    'Position', [700, 50, 50, 20], ...
    'String', '1');

% 设置滑块回调函数
slider.Callback = @(src, event) updatePlot(src, txt, h_surf, data);

end

function updatePlot(src, txt, h_surf, data)
% 更新图像并重新绘制
idx = round(src.Value); % 获取滑块当前位置
txt.String = num2str(idx); % 更新显示列号

set(h_surf,'FaceVertexCData',data(:,idx),'FaceColor','interp')
end


