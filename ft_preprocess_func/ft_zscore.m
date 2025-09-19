function data = ft_zscore(data,style)
% data = ft_zscore(data,dim,style)
% Perform zscore to a fieldtrip dataset (EEG:voltage/MEG:magnet field)
% style:
%     run - nchan*ntp*ntrial for each run
%     all - nchan*ntp*ntrial for all data
%
% Written by Yiheng Hu (2024.7.24)
% Update a new version (2024.8.10)

if isfield(data,'trial')
    if iscell(data.trial)
        if strcmp(style,'run')% zscore for each run
            for irun = 1:max(data.trialinfo.runID)
                ind = data.trialinfo.runID==irun;
                data = zscore_cell_data(data,ind);
            end
        elseif strcmp(style,'all')
            data = zscore_cell_data(data,true(length(data.trial)));
        end
    else
        if strcmp(style,'run')
            for irun = 1:max(data.trialinfo.runID)
                ind = data.trialinfo.runID==irun;
                data.trial(ind,:,:) = zscore(data.trial(ind,:,:),[],1);
            end
        elseif strcmp(style,'all')
            data.trial = zscore(data.trial,[],1);
        end
    end
elseif isfield(data,'powspctrm')
    if strcmp(style,'run')
        for irun = 1:max(data.trialinfo.runID)
            ind = data.trialinfo.runID==irun;
            data.powspctrm(ind,:,:,:) = zscore(data.powspctrm(ind,:,:,:),[],1);
        end
    elseif strcmp(style,'all')
        data.powspctrm = zscore(data.powspctrm,[],1);
    end
end

function data = zscore_cell_data(data,ind)
dat = reshape( zscore( reshape( cell2mat(data.trial(ind)) ...
    ,length(data.label),length(data.time{1}),[]) ,[], 3) ,length(data.label),[]);
data.trial(ind) = mat2cell(dat,length(data.label),cellfun('length',data.time(ind)));




