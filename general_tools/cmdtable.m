function cmdtable(tbl_title,tbl_dat,decimal_len)
%CMDTABLE export table to command line
%   Written by Yiheng Hu (2025.3.6)
if size(tbl_dat,2)~=size(tbl_title,2)
    error('Unmatched title and table')
end

vector_str = arrayfun(@(x) sprintf(['%.' num2str(decimal_len) 'f'], x), ...
    tbl_dat, 'UniformOutput', false);
tbl_data = [tbl_title; vector_str];

column_widths = max(cellfun(@length, tbl_data), [], 'all').*ones(1,length(tbl_title));
format_str = ['|', sprintf(' %%-%ds |', column_widths), '\n'];
border = ['+', strjoin(arrayfun(@(w) repmat('-', 1, w + 2), column_widths, 'UniformOutput', false), '+'), '+'];

fprintf('%s\n', border); % 上边框
fprintf(format_str, tbl_data{1, :}); % 第一行：cell 数组
for i = 1:size(tbl_dat,1)
    fprintf('%s\n', border); % 分隔线
    fprintf(format_str, tbl_data{i+1, :}); % 第二行：数字字符串
end
fprintf('%s\n', border); % 下边框

