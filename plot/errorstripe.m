function errorstripe(errors, x, y, colors, face)
%ERRORSTRIPE This function is to draw errorbar with a stripe.
%   errorstripe(errors, x, y, colors, face)
%   errors: each point error --- vector
%           a cell array with two vectors, 1st down, 2nd up --- cell
%   x: x data --- vector
%   y: y data --- vector
%   colors: the color of errorbar
%   face: contrast of errorbar, 0.4 by default.
if ~(isvector(x)||isvector(y))
    error('x or y must be a vector!');
elseif length(x)~=length(y)
    error('the length of x and y are not matched')
end
if nargin<5; face = 0.4; end
xi_err = cat(find(size(x)~=1),x,x(end:-1:1));
if iscell(errors)
    yi_do = errors{1}(:);
    yi_up = errors{2}(:);
    yi_err = [yi_do; yi_up(end:-1:1)];
elseif isvector(errors)
    yi_do = y(:)-errors(:);
    yi_up = y(:)+errors(:);
    yi_err = [yi_do; yi_up(end:-1:1)];
else
    error('errors input must be a vector or cell.')
end

hold on
fill(xi_err,yi_err,colors,'LineStyle','none','facealpha',face,'HandleVisibility','off');


