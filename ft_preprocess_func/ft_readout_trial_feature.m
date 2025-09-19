function tbl = ft_readout_trial_feature(data,irun)
%FT_READOUT_TRIAL_FEATURE
% For those features that variate in different trials.
%
% tbl = ft_readout_trial_feature(data)
% data - behavioral data for each run or all runs
% tbl - behavioral trialwise data
%
% Written by Yiheng Hu (2023.8.31)

tbl = table;
f = fieldnames(data);
for k=1:length(f)
    if any(size(data.(f{k}),[1,2])==data.trialnumber) && isnumeric(data.(f{k}))
        tbl.(f{k}) = data.(f{k});
    end
end
tbl.runID = irun.*ones(height(tbl),1);
