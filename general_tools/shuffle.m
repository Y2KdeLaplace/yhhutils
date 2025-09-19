function [v,ind] = shuffle(v)
%SHUFFLE To shuffle a vector
% [v,ind] = shuffle(v)
if isvector(v)
    ind = randperm(length(v));
    v = v(ind);
end
