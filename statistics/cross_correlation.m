function [ccr,lag] = cross_correlation(x,y,lag_length)
%CROSS_CORRELATION This function calculate the cross correlation between
%two vectors with the same length
% 
% [ccr,lag] = cross_correlation(x,y,lag_length)
% x - y same length or x longer than y
% k lag window of two vectors
%
% Written by Yiheng Hu (2023.4.7)
if nargin == 2; lag_length = length(x)-1; end

% vectorized
x=x(:);
y=y(:);

% content
n = length(x); % numbers of observation
lag = -lag_length:lag_length; % generating lag window
miu_x = mean(x); % mean of x
miu_y = mean(y); % mean of y
s_x = sqrt(sum((x-miu_x).^2)); % std*sqrt(n-1) or root of sum square of x
s_y = sqrt(sum((y-miu_y).^2)); % std*sqrt(n-1) or root of sum square of y

ccr = nan(2*lag_length+1,1);
for k = 0:lag_length
    ccr(lag==k) = sum( (x(1:n-k) - miu_x).*(y((1:n-k)+k) - miu_y) )/(s_x*s_y);
end
for k = 1:lag_length
    ccr(lag==-k) = sum( (y(1:n-k) - miu_y).*(x((1:n-k)+k) - miu_x) )/(s_x*s_y);
end

end
