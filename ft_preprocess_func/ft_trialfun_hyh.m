function [trl, event] = ft_trialfun_hyh(cfg)
% FT_TRIALFUN_HYH 
%
% Use this function by calling
%   [cfg] = ft_definetrial(cfg)
% where the configuration structure should contain
%   cfg.dataset               = string with the filename
%   cfg.trialdef.prestim      = number, in seconds
%   cfg.trialdef.poststim     = number, in seconds
%   cfg.trialdef.eventtype    = string
%   cfg.trialdef.eventvalue   = cell array or string (identified marker)
%
% If there was only one identified marker, it aligns to trial onset.
% If there were two identified markers, the first one aligns to trial onset
% and the second one aligns to trial offset.
%
% Written by Yiheng Hu (2023.9.1)
% Update compatibility to scalar marker by Yiheng Hu (2024.7.11)
% See also FT_DEFINETRIAL, FT_TRIALFUN_GENERAL

%% set defaults
cfg.trialdef              = ft_getopt(cfg, 'trialdef', struct());
cfg.trialdef.eventtype    = ft_getopt(cfg.trialdef, 'eventtype');
cfg.trialdef.eventvalue   = ft_getopt(cfg.trialdef, 'eventvalue');
cfg.trialdef.prestim      = ft_getopt(cfg.trialdef, 'prestim');
cfg.trialdef.poststim     = ft_getopt(cfg.trialdef, 'poststim');

% construct the low-level options as key-value pairs, these are passed to FT_READ_HEADER and FT_READ_DATA
headeropt = {};
headeropt  = ft_setopt(headeropt, 'headerformat',   ft_getopt(cfg, 'headerformat'));        % is passed to low-level function, empty implies autodetection
headeropt  = ft_setopt(headeropt, 'readbids',       ft_getopt(cfg, 'readbids'));            % is passed to low-level function
headeropt  = ft_setopt(headeropt, 'coordsys',       ft_getopt(cfg, 'coordsys', 'head'));    % is passed to low-level function
headeropt  = ft_setopt(headeropt, 'coilaccuracy',   ft_getopt(cfg, 'coilaccuracy'));        % is passed to low-level function
headeropt  = ft_setopt(headeropt, 'checkmaxfilter', ft_getopt(cfg, 'checkmaxfilter'));      % this allows to read non-maxfiltered neuromag data recorded with internal active shielding
headeropt  = ft_setopt(headeropt, 'chantype',       ft_getopt(cfg, 'chantype', {}));        % 2017.10.10 AB required for NeuroOmega files

% construct the low-level options as key-value pairs, these are passed to FT_READ_EVENT
eventopt = {};
eventopt = ft_setopt(eventopt, 'headerformat',  ft_getopt(cfg, 'headerformat'));        % is passed to low-level function, empty implies autodetection
eventopt = ft_setopt(eventopt, 'dataformat',    ft_getopt(cfg, 'dataformat'));          % is passed to low-level function, empty implies autodetection
eventopt = ft_setopt(eventopt, 'eventformat',   ft_getopt(cfg, 'eventformat'));         % is passed to low-level function, empty implies autodetection
eventopt = ft_setopt(eventopt, 'readbids',      ft_getopt(cfg, 'readbids'));
eventopt = ft_setopt(eventopt, 'detectflank',   ft_getopt(cfg.trialdef, 'detectflank'));
eventopt = ft_setopt(eventopt, 'trigshift',     ft_getopt(cfg.trialdef, 'trigshift'));
eventopt = ft_setopt(eventopt, 'chanindx',      ft_getopt(cfg.trialdef, 'chanindx'));
eventopt = ft_setopt(eventopt, 'threshold',     ft_getopt(cfg.trialdef, 'threshold'));
eventopt = ft_setopt(eventopt, 'tolerance',     ft_getopt(cfg.trialdef, 'tolerance'));
eventopt = ft_setopt(eventopt, 'combinebinary', ft_getopt(cfg.trialdef, 'combinebinary'));

%% read the header information and the events from the data
% get the header, this is among others for the sampling frequency
if isfield(cfg, 'hdr') && ~isempty(cfg.hdr)
  ft_info('using the header from the configuration structure\n');
  hdr = cfg.hdr;
else
  % read the header, contains the sampling frequency
  ft_info('reading the header from ''%s''\n', cfg.headerfile);
  hdr = ft_read_header(cfg.headerfile, headeropt{:});
end

% get the events
if isfield(cfg, 'event')
  ft_info('using the events from the configuration structure\n');
  event = cfg.event;
else
  ft_info('reading the events from ''%s''\n', cfg.headerfile);
  event = ft_read_event(cfg.headerfile, eventopt{:});
end

%% export event & select event type
eventtable = struct2table(event);
if strcmp(cfg.trialdef.eventtype,'?')
    fprintf('Event type as below:\n\n')
    disp(unique(eventtable.type)')
    disp('//////////////////////')
    disp(eventtable(1:20,"type"))
elseif strcmp(cfg.trialdef.eventvalue,'?')
    disp('Event value as below:')
    disp(unique(eventtable.value)')
    disp('//////////////////////')
    disp(eventtable(1:20,"value"))
end
event = event(strcmp(eventtable.type,cfg.trialdef.eventtype)); % export event
eventtable = eventtable(strcmp(eventtable.type,cfg.trialdef.eventtype),:); %select specific event type

%% define trials
% each point represent 1 ms in the past
if iscell(cfg.trialdef.eventvalue) || ischar(cfg.trialdef.eventvalue)
    if numel(cfg.trialdef.eventvalue)==1 || ischar(cfg.trialdef.eventvalue) % 1 marker
        eventsample = eventtable.sample(strcmp(eventtable.value,cfg.trialdef.eventvalue));
        eventvalue = eventtable.value(strcmp(eventtable.value,cfg.trialdef.eventvalue));

        % align to the end of trial
        begsample = eventsample - (cfg.trialdef.prestim*hdr.Fs-1);
        endsample = eventsample + cfg.trialdef.poststim*hdr.Fs;
        offset = round(1-cfg.trialdef.prestim*hdr.Fs).*ones(length(eventsample),1);
    elseif numel(cfg.trialdef.eventvalue)==2 % 2 markers
        eventsample_pre = eventtable.sample(strcmp(eventtable.value,cfg.trialdef.eventvalue{1}));
        eventsample_post = eventtable.sample(strcmp(eventtable.value,cfg.trialdef.eventvalue{2}));
        eventvalue = eventtable.value(strcmp(eventtable.value,cfg.trialdef.eventvalue{1}));

        % align to the end of trial
        begsample = eventsample_pre - (cfg.trialdef.prestim*hdr.Fs-1);
        endsample = eventsample_post + cfg.trialdef.poststim*hdr.Fs;
        offset = round(1-cfg.trialdef.prestim*hdr.Fs).*ones(length(eventsample_pre),1);
    else
        error('Defining a trial requires only one or two markers (begin & end marker)');
    end
elseif isnumeric(cfg.trialdef.eventvalue)
    if length(cfg.trialdef.eventvalue)==1 % 1 marker
        eventsample = eventtable.sample(eventtable.value==cfg.trialdef.eventvalue);
        eventvalue = eventtable.value(eventtable.value==cfg.trialdef.eventvalue);

        % align to the end of trial
        begsample = eventsample - (cfg.trialdef.prestim*hdr.Fs-1);
        endsample = eventsample + cfg.trialdef.poststim*hdr.Fs;
        offset = round(1-cfg.trialdef.prestim*hdr.Fs).*ones(length(eventsample),1);
    elseif numel(cfg.trialdef.eventvalue)==2 % 2 markers
        eventsample_pre = eventtable.sample(eventtable.value==cfg.trialdef.eventvalue(1));
        eventsample_post = eventtable.sample(eventtable.value==cfg.trialdef.eventvalue(2));
        eventvalue = eventtable.value(eventtable.value==cfg.trialdef.eventvalue(1));

        % align to the end of trial
        begsample = eventsample_pre - (cfg.trialdef.prestim*hdr.Fs-1);
        endsample = eventsample_post + cfg.trialdef.poststim*hdr.Fs;
        offset = round(1-cfg.trialdef.prestim*hdr.Fs).*ones(length(eventsample_pre),1);
    else
        error('Defining a trial requires only one or two markers (begin & end marker)');
    end
else
    error('Unknown event value');
end

% save the marker range for updating event after removing bad trials or others
if exist('eventsample_pre','var') && exist('eventsample_post','var')
    if length(endsample)-length(begsample)==1
        warning('Beginning sample point is one time point less than ending sample');
        warning('Guessing that the task program start first during experiment');
        warning('Guessing the first marker was not preserved');
        eventsample_post = eventsample_post(2:end);
        endsample = endsample(2:end);
    end
    if length(begsample)-length(endsample)==1
        warning('Ending sample point is one time point less than beginning sample');
        warning('Guessing that the recorder ended first during experiment');
        warning('Guessing the last marker was not preserved');
        eventsample_pre = eventsample_pre(1:end-1);
        begsample = begsample(1:end-1);
    end
    marker_range = [eventsample_pre, eventsample_post];
elseif exist('eventsample','var')
    marker_range = [eventsample-1 eventsample+1];% to be compatible with multi-marker
end

% sanity check
if any(begsample>endsample)
    error('Unmatched time point: begsample > endsample');
end

%table order: begsample, endsample, offset, marker, time point range of marker
trl = table(begsample, endsample, offset, eventvalue, marker_range,...
    'VariableNames',{'begsample', 'endsample', 'offset', 'eventvalue','marker_range'});


