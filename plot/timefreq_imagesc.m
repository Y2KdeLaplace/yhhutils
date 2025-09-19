function timefreq_imagesc(tf_matrix,freqs,param,titlestr,cm,varargin)
%TIME_FREQUENCY_IMAGESC: plot the frequency-time plot
%   tf_matrix --- frequency*tp matrix
%   freqs --- 't2b' means theta to beta band [3 30], which could be 'x2y'
%   param --- trial parameters (must include timecourse, event and eventlabel)
%   titlestr --- the title of plot
% Updated by Yiheng Hu (2025.2.19)
if nargin < 5; cm = flipud(rdbu); end
if nargin < 4; titlestr={'Time frequency plot',''}; end

freq_tick = [3 8 13 30 60 150];
freq_beg = [3 8 13 30 60 30];
freqs_end = [8 13 30 60 150 150];
freqkeys = {'t','a','b','lg','hg','g'};
freq_rang = [freq_beg(strcmp(freqkeys,freqs(1:find(freqs=='2')-1)));...
    freqs_end(strcmp(freqkeys,freqs(find(freqs=='2')+1:end)))];

ytick = freq_tick(find(freq_tick==freq_rang(1)):find(freq_tick==freq_rang(2)));
ytick_ind = ytick-ytick(1)+1;
Defaults = {'YTick',ytick_ind, ...
            'XTick',param.event, ...
            'YTickLabel',num2cell(ytick), ...
            'XTickLabel',param.eventlabel, ...
            'XLim',[param.event(1) param.event(end)], ...
            'YLim',[ytick_ind(1) ytick_ind(end)], ...
            'Colormap',cm,'CLim',sym_range(tf_matrix)};
if ~isempty(varargin)
    Defaults = updateaug2(Defaults,varargin{:});
end
if size(tf_matrix,1)~=ytick_ind(end)
    error('unmatched frequency tick of input matrix')
end

mapmatrix(tf_matrix,'setaxis',{param.timecourse,ytick_ind(1):ytick_ind(end)}, ...
    'setgca',Defaults,'title',titlestr,'setdash',{[0 0 0],1},...
    'dash_x',param.event(2:end-1),'dash_y',ytick_ind(2:end-1))




