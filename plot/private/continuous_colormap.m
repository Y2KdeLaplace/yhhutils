function map = continuous_colormap(c,poi)
%CONTINUOUS_COLORMAP Change the step colormap into a continuous colormap.
%   c --- a N*3 array with the elements value range in [0,255]
%   poi --- how many points to be intercepted into C. (100, by default)
if height(c) > 100
    warning('This colormap might already be a continuous colormap.')
end
if nargin == 1; poi=100; end
x = 1:height(c);
xq = linspace(1,height(c),poi);
map = interp1(x,c,xq);
end

