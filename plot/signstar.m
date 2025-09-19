function signstar(p,x,y,varargin)
%SIGNSTAR To mark the significance star
%   
%   signstar(p,x,y,varargin)
%   p,x,y --- three vectors of p_values, x position and y position
%   other parameters couble be changed as TEXT function
%
%   The default setting is bold star aligned to center with fontsize 28
%   Usage e.g.
%   signstar(p.abs_rela_err,1.5,14,'HorizontalAlignment','left')
%   signstar(p.rel_error,2.5,14)
%
%   Written by Yiheng Hu (2022.11.3)
%   ------------------------------log--------------------------------------
%   If p > 0.05, 'n.s.' fontsize will be enlarged 2 size in a n+2;
%   Updated by Yiheng Hu (2023.7.14)

Defaults = {'FontSize',28,'HorizontalAlignment','center'};
% update preset
for i = 1:length(varargin)/2
    if any(strcmp(Defaults,varargin{2*i-1}))
        Defaults{find(strcmp(Defaults,varargin{2*i-1}))+1} = varargin{2*i};
    else
        Defaults = [Defaults, varargin{2*i-1:2*i}]; %#ok<AGROW>
    end
end

for i = 1:length(p)
    if p(i) < 0.001
        txt = '***';
    elseif p(i) < 0.01
        txt = '**';
    elseif p(i) <0.05
        txt = '*';
    else
        txt = 'n.s.';
        Defaults{find(strcmp(Defaults,'FontSize'))+1} = Defaults{find(strcmp(Defaults,'FontSize'))+1}+2;
    end
    text(x(i),y(i),txt,Defaults{:});
end

end



