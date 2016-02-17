% Data Alignment. Aligning each data slot in a standard format, 
% to ensure CH3.txt contains its 3rd point as the point with highest intensity
% and other channels are aligned accordingly
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
            if( ~isequal( dirs_4( k ).name, 'Axial Distribution'))
                continue;
            end

            dirs_4(k).name    %testing    Axial Distribution
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
                    if (isequal( dirs_6( m ).name, 'bk'))
                        dir_bk = fullfile(dir_name_5,dirs_6(m).name,'Results.txt');
                        nonCellBKG = importdata(dir_bk);
                    elseif(isequal( dirs_6( m ).name, 'cytosol'))
                        %
                        dir_cytosol = fullfile(dir_name_5,dirs_6(m).name,'Results.txt');
                        CytosolRAW = importdata(dir_cytosol);
                    end
                end
                
                CytosolBKGsub = CytosolRAW.data(:,3)-nonCellBKG.data(:,3); 
                
                for m = 1:length(dirs_6)
                    if( isequal( dirs_6(m).name, '.' )||...
                        isequal( dirs_6(m).name, '..')||...
                        ~dirs_6( m ).isdir ||...
                        isequal( dirs_6(m).name, 'mbk')||...
                        isequal( dirs_6(m).name, 'mscan')||...
                        isequal( dirs_6(m).name, 'bk')||...
                        isequal( dirs_6(m).name, 'cytosol'))
                        continue;
                    end

                    dirs_6(m).name      % testing PDS1
                    dir_name_6 = fullfile(dir_name_5, dirs_6(m).name);

                    %%
                    % read CH3.txt into a matrix, read only column 'mean'
                    % find out the maximum value and location of 'mean' among 19-level of scanning
                    fidin = fopen(fullfile(dir_name_6,'CH3.txt'),'r');
                    bar = fgetl(fidin);
                    fclose(fidin);
                    M = dlmread(fullfile(dir_name_6,'CH3.txt'),'\t',[1 2 16 2]);
                    [value, location] = max(M(:));
                    %dir_name_6
                    align_line = location - 3
                    
                    % get the location, align other files accordingly
                    % if align_line == 0, no alignment is needed
                    % else if align_line > 0, delete the first 'align_line' lines of both three Channels
                    % else (align_line < 0), delete this sample
                    if align_line == 0
                        copyfile(fullfile( dir_name_6,'CH1.txt'),fullfile( dir_name_6,'CH1_alignment.txt'));
                        copyfile(fullfile( dir_name_6,'CH2.txt'),fullfile( dir_name_6,'CH2_alignment.txt'));
                        copyfile(fullfile( dir_name_6,'CH3.txt'),fullfile( dir_name_6,'CH3_alignment.txt'));
                    elseif align_line > 0
                        CH1 = fopen(fullfile(dir_name_6,'CH1.txt'), 'r');
                        CH1_align_line = align_line;
                        fgetl(CH1);
                        while CH1_align_line > 0
                            fgetl(CH1);
                            CH1_align_line = CH1_align_line - 1;
                        end
                        buffer1 = fread(CH1, Inf);
                        fclose(CH1);
                        CH1 = fopen(fullfile( dir_name_6,'CH1_alignment.txt'), 'w');
                        fprintf(CH1, '%s\n', bar);
                        fwrite(CH1, buffer1);
                        fclose(CH1);
                        
                        CH2 = fopen(fullfile( dir_name_6,'CH2.txt'), 'r');
                        CH2_align_line = align_line;
                        fgetl(CH2);
                        while CH2_align_line > 0
                            fgetl(CH2);
                            CH2_align_line = CH2_align_line - 1;
                        end
                        buffer2 = fread(CH2, Inf);
                        fclose(CH2);
                        CH2 = fopen(fullfile( dir_name_6,'CH2_alignment.txt'), 'w');
                        fprintf(CH2, '%s\n', bar);
                        fwrite(CH2, buffer2);
                        fclose(CH2);
                        
                        CH3 = fopen(fullfile( dir_name_6,'CH3.txt'), 'r');
                        CH3_align_line = align_line;
                        fgetl(CH3);
                        while CH3_align_line > 0
                            fgetl(CH3);
                            CH3_align_line = CH3_align_line - 1;
                        end
                        buffer3 = fread(CH3, Inf);
                        fclose(CH3);
                        CH3 = fopen(fullfile( dir_name_6,'CH3_alignment.txt'), 'w');
                        fprintf(CH3, '%s\n', bar);
                        fwrite(CH3, buffer3);
                        fclose(CH3);
                    else
                    end
                end
            end
        end
    end      
end
