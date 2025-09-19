function circle_region(h,n,m,varargin)
%CIRCLE_REGION This function can mark regions on the figure plotted by
%imagesc() function. Make sure you have use imagesc() function and not
%close the window of figure.
%
%   circle_region(h,n,'-')
%
%   h -- a one-hot matrix where the elements to be circle were marked as 1
%   n -- the smoothing parameter of circle path < 4(default) or 8 >
%        Recommandation of n:
%        for square figure, n = 8; non-square figure, n = 4
%   m -- '--','-'
%   
%   optional input
%       'Color','black','LineWidth',1
%
% Written by Yiheng Hu (2022.3.2)
% Updated by Yiheng Hu (2023.5.26)
% Update input augment by Yiheng Hu (2024.2.5)

edge_positions = bwboundaries(h,8);
Defaults = {'Color','black','LineWidth',1};
if nargin == 1
    n = 4;
    m = '-';
elseif nargin == 2
    m = '-';
end
if isempty(n); n = 4; end
if isempty(m); m = '-'; end
Defaults = updateaug2(Defaults,varargin{:});

% plot
hold on
for i = 1:length(edge_positions)
    edge_points = embedding(edge_positions{i},n);
    tmp=boundary(edge_points(:,2),edge_points(:,1),1);
    plot(edge_points(tmp,2),edge_points(tmp,1),m,Defaults{:})
end
hold off

end

% switch n
%     case 4
%         for i = 1:length(edge_positions)
%             [y,x] = find(label==i);
%             embedded_edge_points = embedding([x,y],n); % [column row] - [x y]
%             
%             tmp=boundary(embedded_edge_points(:,1),embedded_edge_points(:,2),1);
%             plot(embedded_edge_points(tmp,1),embedded_edge_points(tmp,2),'-',Defaults{:})
%         end
%     case 8
%         for i = 1:length(edge_positions)
%             edge_points = embedding(edge_positions{i},n);
%             tmp=boundary(edge_points(:,2),edge_points(:,1),1);
%             plot(edge_points(tmp,2),edge_points(tmp,1),'-',Defaults{:})
%         end
% end


function points = embedding(position,n)
% edge_points = embedding(position,n)
% position - a n*2 matrix containing cluster edges position, 
%            where [row_index column_index] 
%
% Written by Yiheng Hu (2023.5.26)
if nargin == 1; n = 8; end
switch n
    case 4
        kernel = [1     0;
                  0     1;
                  -1    0;
                  0     -1]*0.5;
    case 8
        kernel = [1     0;
                  0     1;
                  1     1;
                  1     -1;
                  -1    0;
                  0     -1;
                  -1    -1;
                  -1    1]*0.5;
end

points = nan(size(position,1)*n,2);
for i = 1:size(position,1)
    points(n*(i-1)+1:i*n,:) = position(i,:)+kernel;
end

end

