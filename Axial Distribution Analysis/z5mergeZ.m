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

            %dirs_4(k).name    %testing    Axial Distribution
            dir_name_4 = fullfile(dir_name_3,dirs_4(k).name);

            dirs_5 = dir(dir_name_4);
            dir_file_1 = fullfile(dir_name_4, 'Z-CH1.txt');
            dir_file_1_ratio = fullfile(dir_name_4, 'Z-CH1-ratio.txt');
            dir_file_2 = fullfile(dir_name_4, 'Z-CH2.txt');
            dir_file_2_ratio = fullfile(dir_name_4, 'Z-CH2-ratio.txt');
            dir_file_3 = fullfile(dir_name_4, 'Z-CH3.txt');
            dir_file_3_ratio = fullfile(dir_name_4, 'Z-CH3-ratio.txt');
            fid_CH1 = zeros(22,1);
            fid_CH1_ratio = zeros(22,1);
            fid_CH2 = zeros(22,1);
            fid_CH2_ratio = zeros(22,1);
            fid_CH3 = zeros(22,1);
            fid_CH3_ratio = zeros(22,1);

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
                        isequal( dirs_6(m).name, 'mbk')||...
                        isequal( dirs_6(m).name, 'mscan')||...
                        isequal( dirs_6(m).name, 'bk')||...
                        isequal( dirs_6(m).name, 'cytosol'))
                        continue;
                    end

                    dirs_6(m).name      % testing PDS1
                    dir_name_6 = fullfile(dir_name_5, dirs_6(m).name);

                    %%

                    %% CH1.txt
                    if( exist( fullfile(dir_name_6, 'BK-CH1.txt'),'file'))                  
                        A = zeros(22,1);
                        A_ratio = zeros(22,1);
                        % % open file BK-CH1.txt, read only
                        B = importdata(fullfile(dir_name_6, 'BK-CH1.txt'));   
                        B_ratio = importdata(fullfile(dir_name_6, 'BK-CH1-ratio.txt')); 
                        A(1:nnz(B),1) = B;
                        A_ratio(1:nnz(B_ratio),1) = B_ratio;
                        % combine B to the new column of fid, and called this new matrix C
                        fid_CH1 = [fid_CH1, A];
                        fid_CH1_ratio = [fid_CH1_ratio, A_ratio];
                    end

                    %% CH2.txt
                    if( exist( fullfile(dir_name_6, 'BK-CH2.txt'),'file'))                    
                        A = zeros(22,1);
                        A_ratio = zeros(22,1);
                        % % open file 00BK-CH1.txt, read only
                        B = importdata(fullfile(dir_name_6, 'BK-CH2.txt'));   
                        B_ratio = importdata(fullfile(dir_name_6, 'BK-CH2-ratio.txt')); 
                        A(1:nnz(B),1) = B;
                        A_ratio(1:nnz(B_ratio),1) = B_ratio;
                        % combine B to the new column of fid, and called this new matrix C
                        fid_CH2 = [fid_CH2, A];
                        fid_CH2_ratio = [fid_CH2_ratio, A_ratio];
                    end

                    %% CH3.txt
                    if( exist( fullfile(dir_name_6, 'BK-CH3.txt'),'file'))                    
                        A = zeros(22,1);
                        A_ratio = zeros(22,1);
                        % % open file 00BK-CH1.txt, read only
                        B = importdata(fullfile(dir_name_6, 'BK-CH3.txt'));   
                        B_ratio = importdata(fullfile(dir_name_6, 'BK-CH3-ratio.txt')); 
                        A(1:nnz(B),1) = B;
                        A_ratio(1:nnz(B_ratio),1) = B_ratio;
                        % combine B to the new column of fid, and called this new matrix C
                        fid_CH3 = [fid_CH3, A];
                        fid_CH3_ratio = [fid_CH3_ratio, A_ratio];
                    end
                end
            end
            fid_CH1 = fid_CH1(:,2:end);
            fid_CH1_ratio = fid_CH1_ratio(:,2:end);
            dlmwrite(dir_file_1, fid_CH1, 'delimiter', ' ', 'precision', 15);
            dlmwrite(dir_file_1_ratio, fid_CH1_ratio, 'delimiter', ' ', 'precision', 15);

            fid_CH2 = fid_CH2(:,2:end);
            fid_CH2_ratio = fid_CH2_ratio(:,2:end);
            dlmwrite(dir_file_2, fid_CH2, 'delimiter', ' ', 'precision', 15);
            dlmwrite(dir_file_2_ratio, fid_CH2_ratio, 'delimiter', ' ', 'precision', 15);

            fid_CH3 = fid_CH3(:,2:end);
            fid_CH3_ratio = fid_CH3_ratio(:,2:end);
            dlmwrite(dir_file_3, fid_CH3, 'delimiter', ' ', 'precision', 15);
            dlmwrite(dir_file_3_ratio, fid_CH3_ratio, 'delimiter', ' ', 'precision', 15);
        end
    end      
end
