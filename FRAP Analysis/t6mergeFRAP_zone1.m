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
    
    %dirs_2(i).name    %testing    20140309MEFsrc530F-FNglass-gfpMyo1eD3-mcheGelsolin-bfp2Utrch
    dir_name_2 = fullfile(dir_name_1,dirs_2(i).name);

    dirs_3 = dir(dir_name_2);
    for j = 1 : length( dirs_3 )
        if( ~isequal( dirs_3( j ).name, 'Volocity Image'))
            continue;
        end
        
        %dirs_3(j).name    %testing   Volocity Image
        dir_name_3 = fullfile(dir_name_2,dirs_3(j).name);       
        dirs_4 = dir(dir_name_3);
        
        for k = 1:length(dirs_4)
            if( ~isequal( dirs_4( k ).name, 'FRAP Analysis'))
                continue;
            end
            
            %dirs_4(k).name    %testing   FRAP Analysis
            dir_name_4 = fullfile(dir_name_3,dirs_4(k).name);

            dirs_5 = dir(dir_name_4);
            dir_file_CH1_zone1 = fullfile(dir_name_4, 'FRAP_CH1_zone1.txt');
            dir_file_CH2_zone1 = fullfile(dir_name_4, 'FRAP_CH2_zone1.txt');
            fid_CH1_zone1 = zeros(100,1);
            fid_CH2_zone1 = zeros(100,1);
            for l = 1:length(dirs_5)
                if( isequal( dirs_5( l ).name, '.' )||... 
                    isequal( dirs_5( l ).name, '..')||...
                    ~dirs_5( l ).isdir)
                    continue;
                end

                %dirs_5(l).name       %testing   Each sample folder
                dir_name_5 = fullfile(dir_name_4, dirs_5(l).name);
                dirs_6 = dir(dir_name_5);
                dirs_6_cell = struct2cell(dirs_6);
                dirs_6_cell = dirs_6_cell(1,:);
                if ~(any(strcmp(dirs_6_cell, 'bk')) && any(strcmp(dirs_6_cell, 'cytosol')))
                    continue;
                end

                for m = 1:length(dirs_6)
                    if (~isequal( dirs_6( m ).name, 'zone1'))
                        continue;
                    end
                    %x: mCherry=1, GFP=2, BFP2-urtch=3
                    
                    if( exist( fullfile(dir_name_5,'./zone1/FRAP-BKC-CH1-zone1_alignment.txt'),'file'))
                        A_CH1 = zeros(100,1);
                        B_CH1 = importdata(fullfile(dir_name_5, './zone1/FRAP-BKC-CH1-zone1_alignment.txt'));
                        A_CH1(1:numel(B_CH1),1) = B_CH1;
                        fid_CH1_zone1 = [fid_CH1_zone1, A_CH1]
                    end
                    if( exist( fullfile(dir_name_5,'./zone1/FRAP-BKC-CH2-zone1_alignment.txt'),'file'))
                        A_CH2 = zeros(100,1);
                        B_CH2 = importdata(fullfile(dir_name_5, './zone1/FRAP-BKC-CH2-zone1_alignment.txt'));
                        A_CH2(1:numel(B_CH2),1) = B_CH2;
                        fid_CH2_zone1 = [fid_CH2_zone1, A_CH2];
                    end
                end
            end
            fid_CH1_zone1 = fid_CH1_zone1(:,2:end);
            fid_CH2_zone1 = fid_CH2_zone1(:,2:end);
            dlmwrite(dir_file_CH1_zone1, fid_CH1_zone1, 'delimiter', ' ', 'precision', 15);
            dlmwrite(dir_file_CH2_zone1, fid_CH2_zone1, 'delimiter', ' ', 'precision', 15);
        end
    end
end