function [bt,bc] = ft_std_summary(ALLDATA,target)
% [bt,bc] = ft_std_summary(ALLDATA,target)
% ALLDATA - FIELDTRIP DATA STRUCTURE
% target - 'trial','channel','both'; determining what to mark
% bc - bad channel ID
% bt - bad trials ID
% Written by Yiheng Hu (2024.7.16)
std_mat = nan(length(ALLDATA.trial),length(ALLDATA.label));
for i = 1:length(ALLDATA.trial)
    std_mat(i,:) = std(ALLDATA.trial{i},[],2);
end
std_mat = zscore(std_mat)';

f = figure;
imagesc(std_mat);
ylabel('Channel');xlabel('Trial ID');
screensize = get(0,'ScreenSize');
set(gcf,'Position',screensize);%[300 300 1200 600] window

marked_trial_ind = ones(length(ALLDATA.trial),1);
marked_chan_ind = ones(length(ALLDATA.label),1);
while true
    [x,y,button] = ginput(1);
    [~,iTrial] = min(abs((1:length(ALLDATA.trial))-x));
    [~,iChannel] = min(abs((1:length(ALLDATA.label))-y));

    imagesc(std_mat);
    if button==1
        if strcmp(target,'trial')
            marked_trial_ind(iTrial) = -1*marked_trial_ind(iTrial);
        elseif strcmp(target,'channel')
            marked_chan_ind(iChannel) = -1*marked_chan_ind(iChannel);
        elseif strcmp(target,'both')
            marked_trial_ind(iTrial) = -1*marked_trial_ind(iTrial);
            marked_chan_ind(iChannel) = -1*marked_chan_ind(iChannel);
        else
            error('Unknown mark target!!!')
        end
    elseif strcmp(char(button),'q') || button==3
        close(f)
        break
    end
    h = zeros(size(std_mat));
    h(marked_chan_ind==-1,:) = 1;
    h(:,marked_trial_ind==-1) = 1;
    circle_region(h,[],[],'Color','red','LineWidth',1)
end
bt = find(marked_trial_ind==-1);
bc = find(marked_chan_ind==-1);

