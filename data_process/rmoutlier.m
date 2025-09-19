function [output,ind] = rmoutlier(input,n)
%RMOUTLIER remove outlier and return the index of outlier
%   [output,outlier_ind] = rmoutlier(input,n)
%   input       --   a vector
%   n           --   3 by default; miu-3*std<=x<=miu+3*std
%   output      --   results with outlier removed
%   outlier_ind --   outlier index in input
if ~isvector(input); error('input data must a vector'); end
if nargin==1; n=3; end
ind = abs(input-mean(input))>n*std(input);
output = input(~ind);
end

