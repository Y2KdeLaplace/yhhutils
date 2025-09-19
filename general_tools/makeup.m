function in = makeup(in)
%MAKEUP Change the IN into a column, then remove NaN from IN. If there is 
%no NaN in IN, it only goes on with "in = in(:);"
%   in --- an array or matrix
in=in(:);
in(isnan(in))=[];
end

