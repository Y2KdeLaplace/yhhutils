function default_fig(varargin)
% default_fig(fs,lw,po)
% fs: font size
% lw: line width
% po: fig position on the screen with specific size
switch nargin
    case 0
        figure
        hold on
    case 3
        [fs,lw,po] = varargin{:};
        set(gca,'Fontsize',fs,'LineWidth',lw);
        set(gcf,'Position',po);
end

