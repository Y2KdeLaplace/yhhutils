function [h,p,ci,miu] = bootstrp_test(dat,m,tail,alpha,iter,opt)
%BOOTSTRP_TEST 
% bootstrapping test
%
% [h,p,ci,stats] = bootstrp_test(dat,m,tail,alpha,iter)
% dat: a vector
% m: mean value to compare
% tail: 'left' & 'right' or 'both'
% alpha: citerion of test
% iter: repeating times
% opt: using parrallel or not
%
% h: 1 - significant; 0 - n.s.
% p: p value
% ci: confidence interval
% miu: mean value of distribution
%
% Rewritten by Yiheng Hu (2024.1.3)
if nargin < 6; opt = false; end
par_opt = statset('UseParallel',opt);

dat = dat(:);
sampled_dist = bootstrp(iter,@mean,dat,'Options',par_opt);
miu = mean(sampled_dist);

p = 1-one_side_pvalue(sampled_dist,m,tail);
if strcmp(tail,'both')
    p = 2*p;
    ci = prctile(sampled_dist,100*[alpha/2 1-alpha/2]);
elseif strcmp(tail,'right')
    ci = [prctile(sampled_dist,100*alpha) Inf];
elseif strcmp(tail,'left')
    ci = [Inf prctile(sampled_dist,100*(1-alpha))];
end

h = p<alpha;


