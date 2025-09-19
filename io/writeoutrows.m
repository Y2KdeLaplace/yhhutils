function writeoutrows(filenames,cellarray)
%WRITEOUTROWS This function is to write out a cell array to a txt file with 
%different length rows.
%   filenames --- should be a '.txt' string.
%   cellarray --- n*1 or 1*n cell array.
%   In txt file,
%0	22.5	45	130.5	151.5	220.5	334.5
%0	55.5	99	120	141	208.5	339
%0	19.5	82.5	105	165	187.5	211.5	316.5
%21	45	93	114	135	154.5	177	207	268.5	315
%

fid = fopen(filenames,'wt');
for ilines = 1:length(cellarray)
    for iele = 1:length(cellarray{ilines})
        if iele==length(cellarray{ilines})
            fprintf(fid,'%g',cellarray{ilines}(iele));
        else
            fprintf(fid,'%g\t',cellarray{ilines}(iele));
        end
    end
    fprintf(fid,'\n');
end
fclose(fid);

end

