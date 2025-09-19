function dat = ft_update_events(dat)
%FT_UPDATE_EVENT 
% After modifying trials info (using ft_selectdata, ft_rejectartifact, or 
% epoching data), we need to update the event structure and sampleinfo 
% in fieldtrip dataset.
% This function generate new data tick sampleinfo for each EPOCH (align to 
% the first time point) and the shifted event tick evt with tp distortion
% NOTICE: event and sampleinfo in input dataset must be in the same time course.
% Written by Yiheng Hu (2024.6.18)
if length(dat.trial)~=size(dat.sampleinfo,1)
    error('sampleinfo doesn''t match trial data!');
end

% export events & range of markers
event = struct2table(ft_findcfg(dat.cfg,'event'));
eventold = event; % backup old event

% align tick to the first tp
offset = dat.sampleinfo(1)-1;
sampleinfo = dat.sampleinfo-offset;
marker_range = dat.trialinfo.marker_range-offset;
event.sample = event.sample-offset;

for itrial = 1:length(dat.trial)
    ind = eventold.sample>=dat.trialinfo.marker_range(itrial,1) & ...
        eventold.sample<=dat.trialinfo.marker_range(itrial,2); % marker tick in each epoch

    if itrial == 1
        evt = event(ind,:);
    else
        offset = sampleinfo(itrial,1)-sampleinfo(itrial-1,2)-1; % gap between epoch
        sampleinfo(itrial,:) = sampleinfo(itrial,:)-offset;
        marker_range(itrial,:) = marker_range(itrial,:)-offset;
        tmp = event(ind,:);
        tmp.sample = tmp.sample-offset;
        evt = [evt;tmp]; %#ok<AGROW>
    end
end
dat.cfg.event = table2struct(evt);
dat.sampleinfo = sampleinfo;
dat.trialinfo.marker_range = marker_range;


