% Copyright by yage zhang, zhangyg@hku.hk

clear all
close all
clc

dir_name_1 = uigetdir(matlabroot);       %default path at MATLAB root folder

dirs_2 = dir(dir_name_1);

for i = 1 : length( dirs_2 )
    
    if( isequal( dirs_2( i ).name, '.' )||... 
        isequal( dirs_2( i ).name, '..')||... 
        ~dirs_2( i ).isdir )
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
            if( ~isequal( dirs_4( k ).name, 'Zone Analysis'))
                continue;
            end

            dirs_4(k).name    %testing    Zone Analysis
            dir_name_4 = fullfile(dir_name_3,dirs_4(k).name);
            
            dirs_5 = dir(dir_name_4);
            dir_file_CH1_zone = fullfile(dir_name_4, 'Zone_Analysis_Channel1.txt');
            dir_file_CH2_zone = fullfile(dir_name_4, 'Zone_Analysis_Channel2.txt');
            zone_CH1 = [];
            zone_CH2 = [];
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
                    if( ~isequal( dirs_6(m).name, 'mscan'))
                        continue;
                    end
                    dirs_6(m).name      % testing mscan
                    dir_name_6 = fullfile(dir_name_5, dirs_6(m).name);
                    
                    Z4zone_CH1 = importdata(fullfile(dir_name_6,'CH1_Zone_Analysis.txt'));
                    Z4zone_CH2 = importdata(fullfile(dir_name_6,'CH2_Zone_Analysis.txt'));
                    zone_CH1 = [zone_CH1;Z4zone_CH1];
                    zone_CH2 = [zone_CH2;Z4zone_CH2];
                end
            end
            fid = fopen(dir_file_CH1_zone, 'wt');
            fprintf(fid,'%8s %8s\n','NP','PIR');
            fclose(fid);
            dlmwrite(dir_file_CH1_zone, zone_CH1, '-append', 'delimiter', ' ', 'precision', 10);
            
            fid = fopen(dir_file_CH2_zone, 'wt');
            fprintf(fid,'%8s %8s\n','NP','PIR');
            fclose(fid);
            dlmwrite(dir_file_CH2_zone, zone_CH2, '-append', 'delimiter', ' ', 'precision', 10);
        end
    end      
end
