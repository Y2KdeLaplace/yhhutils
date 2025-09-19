function [q1,q2,q3,q4] = quarter_array(in1,in2)
%QUARTER_ARRAY Combine N*1 array and N*M array into a matrix [in1,in2], and
%then divide them into 4 parts according to the sorted data 'in1' from 
%small to large.
%   [q1,q2,q3,q4] = quarter_array(in1,in2)
%   in1 --- data to be sorted with increasing order (N*1 or 1*N array)
%   in2 --- data follow in1 to change (N*M array)
%   q1,q2,q3,q4 --- data from small in1 to large in1
if nargin < 2
    in2 = in1;
end

%% control input
if length(in1)~=size(in2,1)
    error('Input array must be in the same length.')
end
if length(in1)<4
    error('Input array length should be at least 4 rows')
end

%% sorting
[s_in1,index] = sort(in1(:));
s_in2 = in2(index,:);
unit = floor(length(s_in1)/4);

%% dividing
switch mod(length(s_in2),4)
    case 1
        q1 = [s_in1(1:unit+1),s_in2(1:unit+1,:)];
        q2 = [s_in1(unit+2:2*unit+1),s_in2(unit+2:2*unit+1,:)];
        q3 = [s_in1(2*unit+2:3*unit+1),s_in2(2*unit+2:3*unit+1,:)];
        q4 = [s_in1(3*unit+2:4*unit+1),s_in2(3*unit+2:4*unit+1,:)];
    case 2
        q1 = [s_in1(1:unit+1),s_in2(1:unit+1,:)];
        q2 = [s_in1(unit+2:2*unit+2),s_in2(unit+2:2*unit+2,:)];
        q3 = [s_in1(2*unit+3:3*unit+2),s_in2(2*unit+3:3*unit+2,:)];
        q4 = [s_in1(3*unit+3:4*unit+2),s_in2(3*unit+3:4*unit+2,:)];
    case 3
        q1 = [s_in1(1:unit+1),s_in2(1:unit+1,:)];
        q2 = [s_in1(unit+2:2*unit+2),s_in2(unit+2:2*unit+2,:)];
        q3 = [s_in1(2*unit+3:3*unit+3),s_in2(2*unit+3:3*unit+3,:)];
        q4 = [s_in1(3*unit+4:4*unit+3),s_in2(3*unit+4:4*unit+3,:)];
    case 0
        q1 = [s_in1(1:unit),s_in2(1:unit,:)];
        q2 = [s_in1(unit+1:2*unit),s_in2(unit+1:2*unit,:)];
        q3 = [s_in1(2*unit+1:3*unit),s_in2(2*unit+1:3*unit,:)];
        q4 = [s_in1(3*unit+1:4*unit),s_in2(3*unit+1:4*unit,:)];
end

if nargin < 2
    q1 = mean(q1,2);
    q2 = mean(q2,2);
    q3 = mean(q3,2);
    q4 = mean(q4,2);
end

end
