function aug = updateaug(aug,varargin)
%UPDATEAUG 
% to update paired input augment
% read input parameters to STRUCTURE
% input augment restricted
if mod(length(varargin),2) == 1
	error('Please provide propertyName/propertyValue pairs')
end
augNames = fieldnames(aug);
for pair = reshape(varargin,2,[])    % pair is {propName; propValue}
	if any(strcmp(pair{1}, augNames))
        aug.(pair{1}) = pair{2};
    else
        error('%s is not a recognized parameter name', pair{1})
	end
end

