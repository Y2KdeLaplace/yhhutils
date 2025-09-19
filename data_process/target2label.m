function labels = target2label(targets)
%TARGET2LABEL change targets like degree into label numbers
%   Input variables should be a vector.
% Written by Yiheng Hu (2023.10.26)
targets = targets(:);
u = unique(targets);
n_classes = length(u);

labels = nan(numel(targets), 1);
for i = 1:n_classes
    labels(targets==u(i)) = i; % set to 1:nth classes
end

