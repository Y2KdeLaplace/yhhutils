function [shuffled_seq,sequence] = cue_balance_seqmaker(linenumber,stimulus2,condition,retrocue)
%CUE_BALANCE_SEQMAKER: Generate an extended sequence and scramble the sequence
% sequence: stimuli-1  stimuli-2  condition_tag  retrocue_tag
% sequence --- unshuffled sequence
sequence = 1:linenumber; % cue sequence
%% unit sequence formation of 'stimulius1*stimulius2'
% unit_sequence: stimuli-1  stimuli-2
sequence = repmat(sequence,1,stimulus2)';
for i=1:stimulus2
    sequence(linenumber*(i-1)+1:linenumber*i,2)=i.*ones(linenumber,1);
end

%% sequence formation of 'stimulius1*stimulius2*condition'
unit=size(sequence,1);
sequence = repmat(sequence,condition,1);
for i=1:condition
    sequence(unit*(i-1)+1:unit*i,3)=i.*ones(unit,1);
end

%% sequence formation of 'stimulius1*stimulius2*condition*retrocue'
unit=size(sequence,1);
sequence = repmat(sequence,retrocue,1);
for i=1:retrocue
    sequence(unit*(i-1)+1:unit*i,4)=i.*ones(unit,1);
end

%% shuffle the sequence
tmp = randperm(size(sequence,1));
shuffled_seq =nan(size(sequence));
for i = 1:length(tmp)
    shuffled_seq(i,:) = sequence(tmp(i),:);
end

end

