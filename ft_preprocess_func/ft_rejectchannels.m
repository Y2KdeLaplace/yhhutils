function ALLDATA = ft_rejectchannels(ALLDATA,reject_chan,missing_chan,neighbours)
% ALLDATA = ft_rejectchannels(ALLDATA,reject_chan,missing_chan,neighbours)
% To reject bad channels after run ft_combine_runs function
% Written by Yiheng Hu (2024.5.20)
% Update compatibility for MEG by Yiheng Hu (2024.7.17)
if nargin<4; neighbours=[]; end
if nargin<3; missing_chan={}; end

cfg = [];
if isfield(ALLDATA,'elec')
    % For EEG, we use spherical spline interpolation
    % (see Perrin et al., 1989)
    cfg.method         = 'spline';
    cfg.badchannel     = reject_chan;
    cfg.missingchannel = missing_chan;
    cfg.neighbours     = []; % we don't do interpolation by averaging neigbour channels
    cfg.senstype       = 'eeg';
elseif isfield(ALLDATA,'grad')
    % For MEG, the averaging weights should be fine-tuned by distance to 
    % interpolated channels
    cfg.method         = 'weighted';
    cfg.badchannel     = reject_chan;
    cfg.missingchannel = missing_chan;
    cfg.neighbours     = neighbours;
    cfg.senstype       = 'meg';
else
    error('Unknown sensor type');
end
ALLDATA = ft_channelrepair(cfg, ALLDATA);
