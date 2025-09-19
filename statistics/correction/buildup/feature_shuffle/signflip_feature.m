function perm = signflip_feature(perm,alldata,mu,iteration)
%SIGNFLIP 
% do permutation by multiplying data with -1 randomly in a
% binary distribution
% perm_mu = randopposite_mu(obj,times)
% perm_mu: iter*para1*para2

data_size = size(alldata);
perm_mu = nan([iteration,size(alldata,[2,3])]);
parfor i = 1:iteration
    perm_mu(i,:,:) = mean(mu+(alldata-mu).*((-1).^round(rand(data_size))),1);
end
perm.dist = perm_mu;
end

