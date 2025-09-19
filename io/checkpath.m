function checkpath(xpath)
%checkpath(xpath) check pathway
% if not exist, mkdir
if ~exist(xpath,'dir')
    mkdir(xpath);
end
end

