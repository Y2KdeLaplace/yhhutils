function X = abs_normalization(X,dim)
%ABS_NORMALIZATION 
% norm/sum(norm)
% Written by Yiheng Hu (2024.11.14)
if nargin<2; dim = 1; end
X = abs(X)./sum(abs(X),dim);

