function out = rmmean(mat,dim)
%RMMEAN: remove mean value/center data to zero without changing distribution
%   out = rmmean(mat,dim)
%   mat -- data to be remove mean value
%   dim -- the dimension of mean; all elements by default
if nargin<2; dim = 'all'; end
out = mat - mean(mat,dim);
end

