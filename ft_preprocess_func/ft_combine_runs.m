function ALLDATA = ft_combine_runs(split_files)
% FT_COMBINE_RUNS append data and event & update event and trial timing 
% information & add BrainVision electrode layout & export channel impedences
% If there was only one identified marker, it aligns to trial onset.
% If there were two identified markers, the first one aligns to trial onset
% and the second one aligns to trial offset.
% Written by Yiheng Hu (2024.5.20)

%% append data
% due to changing from continuous data scroll to epoched data, sampleinfo
% needs to be updated to new dataset.
cfg = [];
cfg.keepsampleinfo = 'no'; % Do not generate the sampleinfo of the trial
ALLDATA = ft_appenddata(cfg,split_files{:});
ALLDATA = ft_checkdata(ALLDATA, 'datatype', {'raw+comp', 'raw'}, ...
    'hassampleinfo', 'yes', 'feedback', 'yes');
ALLDATA.trialinfo.trialID = (1:height(ALLDATA.trialinfo))';

%% update event
for irun = 1:length(split_files)
    split_files{irun} = ft_update_events(split_files{irun});
    evt = struct2table(split_files{irun}.cfg.event);
    if irun==1
        offset = 0;
        sampleinfo = split_files{irun}.sampleinfo;
        ALLDATA.cfg.event = evt;
    else
        % append tick to the last run
        offset = sampleinfo(end);
        evt.sample = evt.sample+offset; % first updating event time point
        sampleinfo = split_files{irun}.sampleinfo+offset;
        ALLDATA.cfg.event = [ALLDATA.cfg.event; evt];
    end

    % check time ticks updating & update run ID
    ind = ALLDATA.trialinfo.runID==irun;
    ALLDATA.trialinfo.marker_range(ind,:) = split_files{irun}.trialinfo.marker_range+offset;
    if sum(ALLDATA.sampleinfo(ind,:)~=sampleinfo,"all")~=0
        warning('Time ticks didn''t match.')
        ALLDATA.sampleinfo(ind,:) = sampleinfo;
    end
end
ALLDATA.cfg.event = table2struct(ALLDATA.cfg.event);

%% EEG info appending
if ~isfield(ALLDATA,'grad')
    % add bv layout
    load('bv_elec.mat','elec');
    ALLDATA.elec = elec;

    % preserve impedence to elec layout
    % to find impedence in ALLDATA, use command below:
    % impd = ft_findcfg(ALLDATA.cfg,'impedences');
    ALLDATA.cfg.impedences = export_impedance(split_files);
end


%% functions
function impedences = export_impedance(split_files)
%FT_EXPORT_IMPEDANCE export the impedence information in each run
% Written by Yiheng Hu (2024.5.18)
impedences = struct('channels',nan(split_files{1}.hdr.nChans,length(split_files)), ...
    'reference',[],'ground',[],'refChan',[]);
if ~isempty(split_files{1}.hdr.orig.impedances.reference)
    impedences.reference = nan(length(split_files),1);
end
if ~isempty(split_files{1}.hdr.orig.impedances.ground)
    impedences.ground = nan(length(split_files),1);
end
for i = 1:length(split_files)
    impedences.channels(:,i) = split_files{i}.hdr.orig.impedances.channels;
    if ~isempty(impedences.reference)
        impedences.reference(i) = split_files{i}.hdr.orig.impedances.reference;
    end
    if ~isempty(impedences.ground)
        impedences.ground(i) = split_files{i}.hdr.orig.impedances.ground;
    end
end


