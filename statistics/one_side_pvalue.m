function p = one_side_pvalue(population,checkpoint,which_side)
%ONE_SIDE_PVALUE: To obtain the proportion of sample on one side population
% p = one_side_pvalue(population,checkpoint,which_side)
%   population --- include all data
%   checkpoint --- compare population with checkpoint
%   which_side --- 'left' or 'right'
%   left:  the proportion of population<checkpoint
%   right: the proportion of population>checkpoint
% Written by Yiheng Hu
% Debug by Dongping Shi (2023.10.17)
num_all=length(population);
population(isnan(population))=[];
left = sum(population < checkpoint)/num_all;
right = sum(population > checkpoint)/num_all;
if strcmp(which_side,'left') 
    p = left;
else
    p = right;
end


