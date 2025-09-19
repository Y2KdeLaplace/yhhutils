function mapped = mapsec2ind(realsec,setaxis,len)
%MAPSEC2IND map real seconds to axis index in tpmatrix
% len - index of tpmatrix
% setaxis - real seconds area
mapped = ((len-1).*realsec+(setaxis(2)-setaxis(1)*len))/...
    (setaxis(2)-setaxis(1));
end

