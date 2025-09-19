function m = avg_1subj1poi(x,subjid)
% m = avg_1subj1poi(x,subjid)
% input:
% x: a matrix with each colomn as a variate, if input numer is 1, the last
% colomn will be taken as subject ID; size:[nsample*nvariate(+1)]
% subjid: a vector list subject ID
%         
% output:
%         m nSubject*nVariable matrix
% Written by Yiheng Hu (2024.5.8)
if istable(x); x=table2array(x); end
if nargin == 1
    subjid = x(:,end);
    unit_subjid = unique(subjid);
    m = nan(length(unit_subjid),size(x,2)-1);
    for s = 1:length(unit_subjid)
        for i = 1:size(x,2)-1
            m(s,i) = mean( x(subjid==unit_subjid(s),i) );
        end
    end
    return
end
if istable(subjid); subjid=table2array(subjid); end
unit_subjid = unique(subjid);
m = nan(length(unit_subjid),size(x,2));
for s = 1:length(unit_subjid)
    for i = 1:size(x,2)
        m(s,i) = mean( x(subjid==unit_subjid(s),i) );
    end
end


