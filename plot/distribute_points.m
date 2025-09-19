function distribute_points(m,clr)
%DISTRIBUTE_POINT plot scatter points but distributed as a normal
%distribution
% m - take each colomn to draw the scatter points or each cell to draw when
% groups have different numbers of elements.
% clr - color matrix with each row as RGB color
% Written by Yiheng Hu (2024.5.28)

if iscell(m)
    tmp = m;
    m = nan(max(cellfun(@numel,tmp)),length(tmp));
    for i = 1:length(tmp)
        m(1:length(tmp{i}),i) = tmp{i};
    end
end

hold on
for i = 1:size(m,2)
    x = m(~isnan(m(:,i)),i);
    plot(i+randn(length(x),1)/10,x,'o','MarkerFaceColor',clr(i,:),'MarkerEdgeColor','none')
end
hold off


