function stat = correlation_scatter_line(x, y, varargin)
%CORRELATION_SCATTER_LINE performs linear regression on two input vectors
%and plots a scatter figure with fitted regression line attached. Also, the
%regression parameters and the correlation coefficient will be returned.
%
% stat = correlation_scatter_line(x, y, varargin)
% 
% Input:
% 
% x and y - the input data points for linear regression
% 
% stat = correlation_scatter_line(x, y, 'PARAM1',val1, 'PARAM2',val2, ...)
% 
% 'LineColor'           - a 1*3 vector ranging within [0 1], whose elemnts
% were the RGB values. Black color by default.
% 
% 'LineWidth'           - line width. 1.8 by default.
%
% 'PointSize'           - To plot all markers with the same size, specify 
% SZ as a scalar. To plot each marker with a different size, specify SZ as 
% a vector or matrix. If SZ is an empty vector, the default size is used.
%      
% 'PointColor'          - specifies the marker colors. To plot all markers
% with the same color, specify C as a color name or an RGB triplet. To
% specify different colors for each scatter plot, specify C as an m-by-3 
% matrix of RGB triplets with one color per scatter object. To specify 
% different colors for each scatter point when a single scatter plot is 
% created, specify C as an m-by-1 vector with one value per scatter point 
% or an m-by-3 matrix of RGB triplets with one color per scatter point.
%
% 'xname'               - variate name of x
% 
% 'yname'               - variate name of y
%
% 'note'                - supplement infomation to preserve
%
% 'FontSize'            - the size of rho text and significance mark
%
% 'TxtAlign'            - alignment of text (left, right or center)
%
% 'square_fig'          - plot square fig
%
% Output:
% 
% stat - regression parameters and the correlation coefficient
%
% To perform better drawing, we prefer to 'use default_fig(20,
% 0.5,[300 300 800 400])' function at the same time
% Written by Yiheng Hu (2023.4.15)

% read input parameters
options = struct('LineColor',   [0 0 0], ...
                 'LineWidth',   1.8, ...
                 'PointSize',   36, ...
                 'PointColor',  [0 0 0], ...
                 'xname',       '', ...
                 'yname',       '', ...
                 'note',        '', ...
                 'FontSize',    18, ...
                 'txtPosition', [0.98 0.06; 0.98 0.03], ...
                 'square_fig',  true);
options = updateaug(options,varargin{:});


% fit linear regression and calculate correlation
lm = fitlm(x,y);
[rho,p] = corr(x,y);

% plot results
hold on
plot([min(x),max(x)],[min(x),max(x)].*lm.Coefficients.Estimate(2)+lm.Coefficients.Estimate(1), ...
    'Color',options.LineColor,'LineWidth',options.LineWidth)
scatter(x,y,options.PointSize,options.PointColor,'filled');

parameters = {'FontSize',[],'units','normalized','Position',[], ...
    'HorizontalAlignment','Right','VerticalAlignment','Bottom'};
if p < 0.05
    parameters{2} = options.FontSize+4;
else
    parameters{2} = options.FontSize;
end
parameters{6} = options.txtPosition(1,:);
signstar(p,0,0,parameters{:});
parameters{6} = options.txtPosition(2,:);
text(0,0,['\it r=' num2str(round(rho,2))],parameters{:});

% set fig
xlabel(options.xname)
ylabel(options.yname)
box off
hold off
if options.square_fig
    axis square
end

% export statistical parameters
stat.p = lm.Coefficients.pValue(2);
stat.r = rho;
stat.beta = lm.Coefficients.Estimate(2);
stat.who = [options.yname '_@_' options.xname];
stat.note = options.note;

end

