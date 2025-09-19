function dataTF = ft_decomp_tf(data,time_range,foi,chans,width,keeptrial)
% dataTF = ft_decomp_tf(data,time_range,freqs,chans,width,keeptrial)
% time_range - time range
% freqs - an array of frequency of interest
% chans - a cell array of channel names
% width - cfg.width
%   cycles,higher number, more precisive frequency, more uncertain in time
%   logspace(log10(3),log10(7),length(cfg.foi)) - low frequency (3-30Hz)
%   cfg.foi/2
%
% Written by Yiheng Hu (2024.7.22)
% Update a new version (2024.8.9)
if nargin<6; keeptrial = 'yes'; end
if ~iscell(data.time)
    % check timelock dataset
    data = ft_checkdata(data, 'datatype', 'raw');
end

% time frequency decomposition
cfg            = [];
cfg.method     = 'wavelet';
cfg.output     = 'pow';
cfg.channel    = chans;
cfg.trials     = 'all';
cfg.keeptrials = keeptrial;
cfg.foi        = foi;
cfg.toi        = 'all'; % Or you can input a vetor of interest time points
cfg.pad        = ceil(max(cellfun(@numel,data.time)/data.fsample)); % int for int frequency
cfg.width      = width;
cfg.gwidth     = 3; % half of wavelet duration (3sigma_t)
dataTF = ft_freqanalysis(cfg, data);
dataTF = ft_update_timing(dataTF,time_range,data.fsample);

