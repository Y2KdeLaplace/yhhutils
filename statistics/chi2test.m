function [p,stat] = chi2test(x,e)
%CHI2TEST Chi-square test
%
% chi2test(x,e)
% x -- histogramed data
% e -- expected histogram data
% return [p, stat]
% 
% e.g.
% h = histogram(x,edges);
% [p,stat] = chi2test(h,ones(numel(h),1)*sum(h)/numel(h))
stat.chistat = sum(((x-e).^2)./e);
stat.df = length(x)-1; % degree of freedom
p = 1-chi2cdf(stat.chistat, stat.df);

end

