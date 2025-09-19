function dat = ft_update_timing(dat,time_range,fsample,alignpoint)
% selecting a new epoch and update time locked dataset after preprocessing
%
% dat = ft_update_timing(dat,time_range,fsample,alignpoint)
%
% dat - FT structure
% time_range - time tick or time range of the new epoch
%
% Input about the tiny correction of timecourse:
% fsample - the sampling frequency of dat
% alignpoint - time point you want to align (will be as 0 after alignment)
%
% Written by Yiheng Hu (2024.8.9)
if nargin<4; alignpoint=0; end
if nargin<3; fsample=100; end

if iscell(dat.time)
    dat.time = cellfun(@(x) align2point(x,alignpoint,1/fsample), ...
        dat.time, 'UniformOutput', false);
else
    dat.time = align2point(dat.time, alignpoint, 1/fsample);
end
cfg = [];
cfg.latency = [time_range(1) time_range(end)];
dat = ft_selectdata(cfg, dat);

function timeseries = align2point(timeseries,alignpoint,laglimit)
% align timecourse to a specific time point
% Written by Yiheng Hu (2024.8.9)
% New version (2024.8.9)
ind = dsearchn(timeseries(:),alignpoint);
if abs(timeseries(ind)-alignpoint) > laglimit
    warning('The distances between aligned point and time series are beyond the limit')
end
timeseries = timeseries - timeseries(ind);
timeseries = round(timeseries,5); %less than 0.001

