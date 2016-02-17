clear all
close all
clc

dir_name_1 = uigetdir(matlabroot);       %default path at MATLAB root folder

dirs_2 = dir(dir_name_1);

for i = 1 : length( dirs_2 )
    
    if( isequal( dirs_2( i ).name, '.' )||... 
        isequal( dirs_2( i ).name, '..')||... 
        ~dirs_2( i ).isdir ||...
        isequal( dirs_2( i ).name, 'Matlab-imagej-macro'))
        continue;
    end  
    
    dirs_2(i).name    %testing    20140309MEFsrc530F-FNglass-gfpMyo1eD3-mcheGelsolin-bfp2Utrch
    dir_name_2 = fullfile(dir_name_1,dirs_2(i).name);

    dirs_3 = dir(dir_name_2);
    for j = 1 : length( dirs_3 )
        if( ~isequal( dirs_3( j ).name, 'Volocity Image'))
            continue;
        end
        dirs_3(j).name    %testing   Volocity Image
        dir_name_3 = fullfile(dir_name_2,dirs_3(j).name);       
        dirs_4 = dir(dir_name_3);
        
        for k = 1:length(dirs_4)
            if( ~isequal( dirs_4( k ).name, 'FRAP Analysis'))
                continue;
            end

            dirs_4(k).name    %testing    FRAP Analysis
            dir_name_4 = fullfile(dir_name_3,dirs_4(k).name);
            
            dirs_5 = dir(dir_name_4);

            for l = 1:length(dirs_5)
                if( isequal( dirs_5( l ).name, '.' )||... 
                    isequal( dirs_5( l ).name, '..')||...
                    ~dirs_5( l ).isdir)
                    continue;
                end

                dirs_5(l).name       %testing   Each sample folder
                dir_name_5 = fullfile(dir_name_4, dirs_5(l).name);
                dirs_6 = dir(dir_name_5);
                dirs_6_cell = struct2cell(dirs_6);
                dirs_6_cell = dirs_6_cell(1,:);

                if ~(any(strcmp(dirs_6_cell, 'bk')) && any(strcmp(dirs_6_cell, 'cytosol')))
                    continue;
                end
                
                for m = 1:length(dirs_6)
                    if( isequal( dirs_6(m).name, '.' )||...
                        isequal( dirs_6(m).name, '..')||...
                        ~dirs_6( m ).isdir ||...
                        isequal( dirs_6(m).name, 'bk')||...
                        isequal( dirs_6(m).name, 'cytosol'))
                        continue;
                    end

                    dirs_6(m).name      % testing zone1 or zone2
                    dir_name_6 = fullfile(dir_name_5, dirs_6(m).name);

                    if (isequal( dirs_6(m).name, 'zone1'))
                        % CH1
                        % read FRAP-BKC-CH1-zone1.txt into a matrix, since it has already been corrected
                        % do not have to delete line or do other extra alignment
                        % find out the minimum value and location of 'minimum' among 100-level of scanning
                        subBKG_CH1_zone1 = importdata(fullfile(dir_name_6,'FRAP-BKC-CH1-zone1.txt'));
                        [value, location] = min(subBKG_CH1_zone1(:));
                        align_line = location - 6;
                        
                        % get the location, align other files accordingly
                        % if align_line == 0, no alignment is needed, copy file
                        % else if align_line > 0, delete the first 'align_line' lines
                        % else (align_line < 0), delete this sample
                        if align_line == 0
                            copyfile(fullfile( dir_name_6,'FRAP-BKC-CH1-zone1.txt'),fullfile( dir_name_6,'FRAP-BKC-CH1-zone1_alignment.txt'));
                        elseif align_line > 0
                            CH1 = importdata(fullfile(dir_name_6,'FRAP-BKC-CH1-zone1.txt'));
                            CH1_align_line = align_line;
                            while CH1_align_line > 0
                                CH1 = CH1([2:end]);
                                CH1_align_line = CH1_align_line - 1;
                            end
                            dlmwrite (fullfile(dir_name_6,'FRAP-BKC-CH1-zone1_alignment.txt'), CH1, 'precision', 15);
                        else
                        end

                        subBKG_CH2_zone1 = importdata(fullfile(dir_name_6,'FRAP-BKC-CH2-zone1.txt'));
                        [value, location] = min(subBKG_CH2_zone1(:));
                        align_line = location - 6;
                        if align_line == 0
                            copyfile(fullfile( dir_name_6,'FRAP-BKC-CH2-zone1.txt'),fullfile( dir_name_6,'FRAP-BKC-CH2-zone1_alignment.txt'));
                        elseif align_line > 0
                            CH2 = importdata(fullfile(dir_name_6, 'FRAP-BKC-CH2-zone1.txt'));
                            CH2_align_line = align_line;
                            while CH2_align_line > 0
                                CH2 = CH2([2:end]);
                                CH2_align_line = CH2_align_line - 1;
                            end
                            dlmwrite(fullfile(dir_name_6,'FRAP-BKC-CH2-zone1_alignment.txt'), CH2, 'precision', 15);
                        else
                        end
                        
                    elseif (isequal( dirs_6(m).name, 'zone2'))
                        % CH1
                        subBKG_CH1_zone2 = importdata(fullfile(dir_name_6,'FRAP-BKC-CH1-zone2.txt'));
                        [value, location] = min(subBKG_CH1_zone2(:));
                        align_line = location - 6;
                        
                        if align_line == 0
                            copyfile(fullfile( dir_name_6,'FRAP-BKC-CH1-zone2.txt'),fullfile( dir_name_6,'FRAP-BKC-CH1-zone2_alignment.txt'));
                        elseif align_line > 0
                            CH1 = importdata(fullfile(dir_name_6,'FRAP-BKC-CH1-zone2.txt'));
                            CH1_align_line = align_line;
                            while CH1_align_line > 0
                                CH1 = CH1([2:end]);
                                CH1_align_line = CH1_align_line - 1;
                            end
                            dlmwrite (fullfile(dir_name_6,'FRAP-BKC-CH1-zone2_alignment.txt'), CH1, 'precision', 15);
                        else
                        end

                        subBKG_CH2_zone2 = importdata(fullfile(dir_name_6,'FRAP-BKC-CH2-zone2.txt'));
                        [value, location] = min(subBKG_CH2_zone2(:));
                        align_line = location - 6;
                        if align_line == 0
                            copyfile(fullfile( dir_name_6,'FRAP-BKC-CH2-zone2.txt'),fullfile( dir_name_6,'FRAP-BKC-CH2-zone2_alignment.txt'))
                        elseif align_line > 0
                            CH2 = importdata(fullfile(dir_name_6, 'FRAP-BKC-CH2-zone2.txt'));
                            CH2_align_line = align_line;
                            while CH2_align_line > 0
                                CH2 = CH2([2:end]);
                                CH2_align_line = CH2_align_line - 1;
                            end
                            dlmwrite(fullfile(dir_name_6,'FRAP-BKC-CH2-zone2_alignment.txt'), CH2, 'precision', 15);
                        else
                        end
                    end
                end
            end
        end
    end      
end
