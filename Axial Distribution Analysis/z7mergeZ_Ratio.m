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
            dir_file_ratio_avg = fullfile(dir_name_4, 'Ratio-Avg.txt');
            dir_file_ratio_max = fullfile(dir_name_4, 'Ratio-Max.txt');

            % % open file 00BK-CH1.txt, read only
            CH1_avg = importdata(fullfile(dir_name_4, 'Ratio-CH1Avg.txt'));   
            CH2_avg = importdata(fullfile(dir_name_4, 'Ratio-CH2Avg.txt'));
            CH3_avg = importdata(fullfile(dir_name_4, 'Ratio-CH3Avg.txt'));
            max_num_avg = max([nnz(CH1_avg), nnz(CH2_avg), nnz(CH3_avg)]);

            CH1_max = importdata(fullfile(dir_name_4, 'Ratio-CH1Max.txt'));   
            CH2_max = importdata(fullfile(dir_name_4, 'Ratio-CH2Max.txt'));   
            CH3_max = importdata(fullfile(dir_name_4, 'Ratio-CH3Max.txt'));
            max_num_max = max([nnz(CH1_max), nnz(CH2_max), nnz(CH3_max)]);

            %x: mCherry=1, GFP=2, BFP2-urtch=3
            
            fid_AVG = zeros(max_num_avg, 3);
            fid_AVG(1:numel(CH1_avg),1) = CH1_avg;
            fid_AVG(1:numel(CH2_avg),2) = CH2_avg;
            fid_AVG(1:numel(CH3_avg),3) = CH3_avg;

            fid_MAX = zeros(max_num_max, 3);
            fid_MAX(1:numel(CH1_max),1) = CH1_max;
            fid_MAX(1:numel(CH2_max),2) = CH2_max;
            fid_MAX(1:numel(CH3_max),3) = CH3_max;

            dlmwrite(dir_file_ratio_avg, fid_AVG, 'delimiter', ' ', 'precision', 15);
            dlmwrite(dir_file_ratio_max, fid_MAX, 'delimiter', ' ', 'precision', 15);
        end
    end
end