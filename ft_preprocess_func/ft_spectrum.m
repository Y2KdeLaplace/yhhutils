function ft_spectrum(ALLDATA,freq_range,frames,dat_percent)
%FT_SPECTRUM To draw channel spectra and maps as EEGLAB
%
% ft_spectrum(ALLDATA,freq_range,frames,dat_percent)
% ALLDATA: fieldtrip data structure
% freq_range: frequency range of time frequency analysis e.g. [1 100] Hz
% frames: time range in (ms) e.g. [1000 286000]
% dat_percent: how many data to perform spectral analysis by doing resample
% output: 
% x: frequency
% y: 10 times log of amplitude
%
% Written by Yiheng Hu (2023.12.4)
% Update function that clicking curve will display channel name by Yiheng
% Hu (2023.12.20)
freqfac = 1;
overlap = 0;
if nargin == 4
    dat_percent = dat_percent/100;
    cfg = [];
    cfg.resamplefs = round(ALLDATA.fsample*dat_percent);
    ALLDATA = ft_resampledata(cfg,ALLDATA);
    ALLDATA.cfg = rmfield(ALLDATA.cfg,'origfs');
end

dat = cell2mat(ALLDATA.trial);
nchans = size(dat,1);
if nargin < 3
    frames = size(dat,2);
    tmp_range = 1:frames;
else
    tmp_range = frames;
    frames = length(tmp_range);
end
winlength = min(round(ALLDATA.fsample), frames);
fftlength = winlength*freqfac;

fprintf('\nEstimating Power Spectral Density via Welch''s method: No.')
fprintf(repmat(' ',1,floor(log10(nchans))+1))
for c = 1:nchans
    fprintf([repmat('\b',1,floor(log10(nchans))+1) '%' num2str(floor(log10(nchans))+1) '.0f'],c)
    tmpdata = dat(c,tmp_range); % channel activity
    [tmpspec,freqs] = pwelch(tmpdata,winlength,overlap,fftlength,ALLDATA.fsample);
    if c==1
        eegspec = zeros(nchans,length(freqs));
    end
    eegspec(c,:) = eegspec(c,:) + tmpspec';
end
fprintf('\n')

f = figure;
xrange = dsearchn(freqs,freq_range');
ind = xrange(1):xrange(end);
plt_freqs = freqs(ind);
plt_psd = 10*log10(eegspec(:,ind));
plot(plt_freqs,plt_psd,'LineWidth',1.5)

title('Amplitude Spectrum of signals')
xlabel('Frequency (Hz)');xlim([plt_freqs(1) plt_freqs(end)]);
ylabel('Log Power Spectral Density 10*log_1_0(\muV^2/Hz)')

while true
    [x,y,button] = ginput(1);
    if strcmp(char(button),'q') || button==3
        close(f)
        break
    end
    [~,ind] = min((plt_freqs-x).^2);
    [~,ind] = min((plt_psd(:,ind)-y).^2);
    fprintf(['\n' ALLDATA.label{ind} '\n']);
end


