function perm = tperm_feature(perm,alldata,m,sides,alpha)
% perm = tperm_feature(perm,alldata,m,sides,alpha)
%
% perform permutation and t-test to obtain t, p & h
% Update by Yiheng Hu (2022.12.9)

htmp = nan([perm.iterperm,size(alldata,[2,3])]);
ptmp = nan([perm.iterperm,size(alldata,[2,3])]);
ttmp = nan([perm.iterperm,size(alldata,[2,3])]);
parfor i = 1:perm.iterperm
    tmpalldata = m + (alldata-m).*sign(randn(size(alldata,1),1));
%     tmpalldata = m + (alldata-m).*(-1).^round(rand(size(alldata)));
    [htmp(i,:,:),ptmp(i,:,:),ttmp(i,:,:)] = tcheck(tmpalldata,m,sides,alpha);
end
perm.h = htmp;
perm.p = ptmp;
perm.dist = ttmp;



