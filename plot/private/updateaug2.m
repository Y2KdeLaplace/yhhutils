function aug = updateaug2(aug,varargin)
%UPDATEAUG2 
% to update paired input augment to CELL array
% Written by Yiheng Hu (2024.2.5)
if mod(length(varargin),2) == 1
	error('Please provide propertyName/propertyValue pairs')
end
aug = reshape(aug,2,[]);
augNames = aug(1,:);
for pair = reshape(varargin,2,[])    % pair is {propName; propValue}
	if any(strcmp(pair{1}, augNames))
        aug{2,strcmp(pair{1}, augNames)} = pair{2};
    else
        aug = [aug,pair];
	end
end
aug = reshape(aug,1,[]);
