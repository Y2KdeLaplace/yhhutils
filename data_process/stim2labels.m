function [labels,N] = stim2labels(stim,binrange,marker)
%STIM2LABELS
%
%   [labels,N] = stim2labels(stim,binrange,unilabel)
%   
%   stim: a list or stimuli to be bined into several labels
%   binrange: value range of a bin with [min max]
%   unilabel: a list of labels which corresponsed to binrange
%   
%   e.g.
%       binrange = [1 3;
%                   3 8;
%                   8 10];
%       marker = [0 1 2];
%       stim = [2 7 9 4 3 6 4];
%       [labels,N] = stim2labels(stim,binrange,unilabel)
%       labels = [0 1 2 1 1 1];
%       N = [1 0
%            4 1
%            1 2];
%
%   Written by Yiheng Hu(2022.6.29)
%   debug at 2022.7.14
labels = nan(size(stim));
[unimarker, ind, ~] = unique(marker);
unimarker = unimarker(:);
checkpoint = binrange(ind,1);
N = zeros(numel(unimarker),1);
N = [N, unimarker];
for i = 1:length(stim)
    if sum(checkpoint==stim(i))
        labels(i) = unimarker(checkpoint==stim(i));
        N(labels(i)==N(:,2),1) = N(labels(i)==N(:,2),1)+1; % counter
        continue
    end
    tmp = stim(i)-binrange;
    check = find(tmp(:,1).*tmp(:,2)<=0);
    labels(i) = marker(check(1));
    N(labels(i)==N(:,2),1) = N(labels(i)==N(:,2),1)+1; % counter
end

end


