function [mu,sample] = bootstraping_mean(input, n, samplesize, replacement)
%BOOTSTRAPING_MEAN This function is to resampling the input data with
%bootstraping. Resampled data will be return as variable 'sample'. We can
%also obtain the mean value of each sample's mean value which is a Gaussian
%distribution.
%
%   [mu,sample] = bootstraping_mean(input, n, samplesize, replacement)
%
%   input --- the unput data should be a vector
%   n --- how many times to resample
%   samplesize --- sample size in each time resampling; same length as
%   input by default
%   replacement --- whether resample the data with replacement; 1 by default
%   mu --- mean of bootstraped samples
% Written by Yiheng Hu at 17/8/2021

if min(size(input)) ~= 1
    error('Error: data for bootstraping must be a vector!')
end
if ~exist('samplesize','var'), samplesize=max(size(input)); end
if nargin < 4
    replacement = true;
end

sample = nan(samplesize,n);
for i = 1:n
    sample(:,i) = randsample(input,samplesize,replacement)';
end
mu = mean(sample);

end
