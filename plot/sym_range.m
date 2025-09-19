function rout = sym_range(in,style)
%SYM_RANGE return a range of input matrix with zero as center
% absmax    -- -absmax absmax (default)
% 2std      -- -(mean+2std) mean+2std
if nargin < 2; style = 'absmax'; end
switch style
    case 'maxmin'
        rout = [min(in,[],'all') max(in,[],'all')];
    case 'absmax'
        extrm = max([abs(max(in,[],'all')) abs(min(in,[],'all'))]);
        rout = [-extrm extrm];
    case '2std'
        tmp = in(:);
        tmp = mean(tmp) + 2*std(tmp);
        rout = [-tmp tmp];
    case '3std'
        tmp = in(:);
        tmp = mean(tmp) + 3*std(tmp);
        rout = [-tmp tmp];
end

