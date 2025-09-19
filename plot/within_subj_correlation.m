function stat = within_subj_correlation(y,x,subjects,varargin)
% WITHIN_SUBJ_CORRELATION 
% Analysis of covariance (ANCOVA) method is used to evaluate the correlated
% sensitivity to trial type or condition across pairs of task-related 
% variables (i.e., BOLD activity versus behavioral parameter, decoding 
% accuracy versus behavioral parameter). Unlike simple correlations, ANCOVA
% accommodates the fact that each subject contributes a value for each 
% level of trial type. It removes between-subject differences and assesses 
% evidence for "within-subject correlation" between the 2 task-related
% variables.
%
% Mathematically, within-subject correlations were implemented as linear 
% regression models and were calculated for behavioral parameter, where 
% subject is a dummy variable for trial types of each subject.
%
%               Y ~ X + subjects + ε 
%
% The within-subject correlation r was calculated as follows:
%
%               r = sqrt(SS(behavior)/(SS(behavior)+SSE))
% 
% ,where SS stands for sum of squares.
%
% #######################################################################
%
% stat = within_subj_correlation(y,x,subjects,varargin)
%
% y,x - nsubj*ncondition matrix
% subjects - a list of subjects ID corresponding to Y and X
%
% Written by Yiheng Hu (2023.5.10)

% default input parameters & read input parameters
options = struct('LineColor',   jet, ...
                 'LineWidth',   1, ...
                 'PointSize',   32, ...
                 'PointColor',  jet, ...
                 'xname',       '', ...
                 'yname',       '', ...
                 'note',        '', ...
                 'FontSize',    18, ...
                 'txtPosition', [0.98 0.09; 0.98 0.03], ...
                 'square_fig',  true, ...
                 'plot_scatter', false);
options = updateaug(options,varargin{:});

% linear regression
tbl = table(reshape(y,[],1),reshape(x,[],1),categorical([subjects,subjects]'), ...
    'VariableNames',{'slope','behavior','subjid'});
lm = fitlm(tbl,'slope~behavior+subjid');
anova_para = anova(lm);
stat.r = sqrt(anova_para.SumSq('behavior')/(anova_para.SumSq('behavior')+anova_para.SumSq('Error')));
stat.p = anova_para.pValue('behavior');

% plot results
ind = round(linspace(1,size(options.LineColor,1),length(subjects)));
figure;hold on;
for s = 1:length(subjects)
    if options.plot_scatter
        scatter(x(s,:),y(s,:),options.PointSize,options.PointColor(ind(s),:),'filled');
    end
    if s == 1
        plot(x(s,:),x(s,:)*lm.Coefficients.Estimate(2)+lm.Coefficients.Estimate(1), ...
            'Color',options.LineColor(ind(s),:),'LineWidth',options.LineWidth)
    else
        plot(x(s,:),x(s,:)*lm.Coefficients.Estimate(2)+lm.Coefficients.Estimate(1)+lm.Coefficients.Estimate(s+1), ...
            'Color',options.LineColor(ind(s),:),'LineWidth',options.LineWidth)
    end
end
hold off

parameters = {'FontSize',[],'units','normalized','Position',[], ...
    'HorizontalAlignment','Right','VerticalAlignment','Bottom'};
if stat.p < 0.05
    parameters{2} = options.FontSize+4;
else
    parameters{2} = options.FontSize;
end
parameters{6} = options.txtPosition(1,:);
signstar(stat.p,0,0,parameters{:});
parameters{6} = options.txtPosition(2,:);
text(0,0,['\it r=' num2str(round(stat.r,2))],parameters{:});

% set fig
xlabel(options.xname)
ylabel(options.yname)
box off
hold off
if options.square_fig
    axis square
end

% export statistical parameters
stat.lm = lm;
stat.anova = anova_para;
stat.note = options.note;
disp(['Correlation coefficient: ' num2str(stat.r)]);
disp(['p value: ' num2str(stat.p)]);

end