function ou = categorize(checklist,ranges)
%To label the a vector or matrix into range bins
%   ou = iswithin(checklist,ranges)
%   checklist - m*n matrix or vector
%   ranges - N X 2 or 2 X N matrix where 2 indicates the up limit and down
%   limit.
%   ou - a cell array with a shape of input checklist, each cell is an
%   array of labels.
%
% Written by Yiheng Hu (2023.3.26)
org = size(checklist);
checklist = reshape(checklist,[],1);
sz = size(ranges);
if any(sz==2)
    try
        switch find(sz==2)
            case 1
                disp(['The input has ' num2str(sz(2)) ' ranges.'])
            case 2
                ranges = ranges';
                disp(['The input has ' num2str(sz(1)) ' ranges.'])
        end
    catch
        warning('Input ranges will not be reshaped, which are regarded as a n X 2 matrix.')
    end
else
    error('Input ranges are not N X 2 or 2 X N matrix')
end
tmp = checklist >= ranges(1,:) & checklist < ranges(2,:);
ou = cell(size(checklist));
for i = 1:length(checklist)
    ou{i} = find(tmp(i,:));
end
ou = reshape(ou,org);
end

