function uni = uniqueVar(tbl)
% uni = uniqueVar(tbl) do unique function to column
% tbl - a table or a matrix
% uni - a cell array of the tbl vatiable
% Written by Yiheng Hu (2024.6.27)
if istable(tbl)
    varnames = tbl.Properties.VariableNames;
    uni = cell(1,length(varnames));
    for i = 1:width(tbl)
        uni{i} = unique(tbl.(varnames{i}));
    end
else
    uni = cell(1,size(tbl,2));
    for i = 1:size(tbl,2)
        uni{i} = unique(tbl(:,i));
    end
end

