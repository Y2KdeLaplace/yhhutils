function outstr = num2fstr(num,digit_num)
% num2fstr(num,digit_num)
% 
% Input:
% num: input number variable
% digit_num: identify the lagest digit (Default: 2)
%
% Output:
% outstr: a converted string
%
% Usage:
%   outstr = num2fstr(3,2);
%   disp(outstr)
%
% Written by Yiheng Hu (2024.4.23)
if nargin < 2
    digit_num = 2;
end
if ceil(num)-num~=0
    error('Input number must be integer');
elseif num >= 10^digit_num
    error('Input number exceed the largest digit')
elseif ceil(digit_num)-digit_num~=0 || digit_num<2
    error('Invalid digital number');
end

outstr = num2str(num);
if digit_num < 9
    tmp = digit_num-length(outstr);
    for i = 1:tmp
        outstr = append('0',outstr);
    end
else
    for i = 1:digit_num-ceil(log10(num))
        outstr = append('0',outstr);
    end
end

