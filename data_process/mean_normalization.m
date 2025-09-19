function outputArg = mean_normalization(X)
%Center the data to zero without changing distribution
%   X         --- an array that vectors have been stacked vertically or a
%                 vector.
%   outputArg --- return the result about all vectors with vstack()
if length(size(X))>2
    error('Error: input data should be a 2-dimension matrix with vectors stacked vertically!')
end
X_mean = mean(X);
outputArg = (X-X_mean)./(max(X)-min(X));
end