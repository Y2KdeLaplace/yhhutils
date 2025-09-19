function hf = cluster2D_outsideEdge(h)

[a, b] = size(h);
h = double(h);
for i = 1:a
    for j = 1:b
        if h(i,j) == 0
            h = leftcheck(h,i,j);
            h = rightcheck(h,i,j);
            h = upcheck(h,i,j);
            h = downcheck(h,i,j);
        end
    end
end
hf = h==-1;
end

function h = leftcheck(h,i,j)
try %#ok<TRYNC>
    if h(i,j-1) == 1
        h(i,j) = -1;
    end
end
end

function h = rightcheck(h,i,j)
try %#ok<TRYNC>
    if h(i,j+1) == 1
        h(i,j) = -1;
    end
end
end

function h = upcheck(h,i,j)
try %#ok<TRYNC>
    if h(i+1,j) == 1
        h(i,j) = -1;
    end
end
end

function h = downcheck(h,i,j)
try %#ok<TRYNC>
    if h(i-1,j) == 1
        h(i,j) = -1;
    end
end
end

