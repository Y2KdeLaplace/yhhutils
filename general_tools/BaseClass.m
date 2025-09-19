classdef BaseClass
    %BASECLASS make instance for the class that usually used
    % Written by Yiheng Hu (2025.1.6)

    methods (Access=public)
        function obj = updateaug(obj,varargin)
            %UPDATEAUG
            % to update paired input augment
            % read input parameters to STRUCTURE
            % input augment restricted
            if mod(length(varargin),2) == 1
                error('Please provide propertyName/propertyValue pairs')
            end
            augNames = fieldnames(obj);
            for pair = reshape(varargin,2,[])    % pair is {propName; propValue}
                if any(strcmp(pair{1}, augNames))
                    obj.(pair{1}) = pair{2};
                else
                    error('%s is not a recognized parameter name', pair{1})
                end
            end
        end

        function xx = show(obj,hiddenVarName)
            xx = obj.(hiddenVarName);
        end
    end
end

