function outputArg = max_min_normalization(X,dim)
% Normalize data into [0,1] scale
% outputArg = max_min_normalization(X,dim)
%   X         --- a vector or a n-D matrix 
%   dim       --- operates along the dimension DIM
%   outputArg --- return the result with original size
% if DIM is empty, perform along all dimensions
% Written by Yiheng Hu (2024.10.23 - new version)
if nargin<2
    outputArg = (X-min(X,[],'all'))./(max(X,[],'all')-min(X,[],'all'));
else
    outputArg = (X-min(X,[],dim))./(max(X,[],dim)-min(X,[],dim));
end

