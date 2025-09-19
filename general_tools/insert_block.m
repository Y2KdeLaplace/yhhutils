function out = insert_block(raw,index,block,dim)
%INSERT_BLOCK to insert the same block with index to raw data along specific 
%dimension.
% Written by Yiheng Hu(2021.10.25)
% raw --- array or matrix in 1*a or a*1 or a*b
% insert --- array in 1*a or a*1
% index --- index array of raw matrix or array
% dim --- dimension to concatenate the input data
index = sort(index);
if dim == 1
    %out = nan(size(raw)+[size(insert,dim), 0]);
    for i = 1:length(index)
        if i==1
            out = [raw(1:index(i)-1,:); block];
        else
            out = [out; raw(index(i-1):index(i)-1,:); block];
        end
    end
    out = [out; raw(index(end):end,:)];
elseif dim == 2
    %out = nan(size(raw)+[0, size(insert,dim)]);
    for i = 1:length(index)
        if i==1
            out = [raw(:,1:index(i)-1), block];
        else
            out = [out, raw(:,index(i-1):index(i)-1), block];
        end
    end
    out = [out, raw(:,index(end):end)];
else
    error('this function only works in 2 dimension matrix')
end

end