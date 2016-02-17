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
            if( ~isequal( dirs_4( k ).name, 'Axial Distribution'))
                continue;
            end

            %dirs_4(k).name    %testing    Axial Distribution
            dir_name_4 = fullfile(dir_name_3,dirs_4(k).name);
            
            dirs_5 = dir(dir_name_4);
            dir_file_CH1_mscan = fullfile(dir_name_4, 'M-CH1.txt');
            dir_file_CH2_mscan = fullfile(dir_name_4, 'M-CH2.txt');
            dir_file_CH3_mscan = fullfile(dir_name_4, 'M-CH3.txt');
            fid_CH1_mscan = zeros(100,1);
            fid_CH2_mscan = zeros(100,1);
            fid_CH3_mscan = zeros(100,1);

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
                if ~(any(strcmp(dirs_6_cell, 'mbk')) && any(strcmp(dirs_6_cell, 'mscan')))
                    continue;
                end
                
                for m = 1:length(dirs_6)    % mscan
                    if( ~isequal( dirs_6(m).name, 'mscan'))
                        continue;
                    end

                    dirs_6(m).name      % testing mscan
                    dir_name_6 = fullfile(dir_name_5, dirs_6(m).name);
                    
                    %CH1
                    if( exist( fullfile(dir_name_6, 'subBKG-CH1-mscan.txt'),'file'))                  
                        A = zeros(100,1);
                        % % open file BK-CH1.txt, read only
                        B = importdata(fullfile(dir_name_6, 'subBKG-CH1-mscan.txt'));   
                        A(1:numel(B),1) = B;
                        % combine A to the new column of fid, and called this new matrix C
                        fid_CH1_mscan = [fid_CH1_mscan, A];
                    end

                    %CH2
                    if( exist( fullfile(dir_name_6, 'subBKG-CH2-mscan.txt'),'file'))                  
                        A = zeros(100,1);
                        B = importdata(fullfile(dir_name_6, 'subBKG-CH2-mscan.txt'));   
                        A(1:numel(B),1) = B;
                        % combine A to the new column of fid, and called this new matrix C
                        fid_CH2_mscan = [fid_CH2_mscan, A];
                    end

                    %CH3
                    if( exist( fullfile(dir_name_6, 'subBKG-CH3-mscan.txt'),'file'))                  
                        A = zeros(100,1);
                        B = importdata(fullfile(dir_name_6, 'subBKG-CH3-mscan.txt'));   
                        A(1:numel(B),1) = B;
                        % combine A to the new column of fid, and called this new matrix C
                        fid_CH3_mscan = [fid_CH3_mscan, A];
                    end
                end
            end
            fid_CH1_mscan = fid_CH1_mscan(:,2:end);
            dlmwrite(dir_file_CH1_mscan, fid_CH1_mscan, 'delimiter', ' ', 'precision', 15);

            fid_CH2_mscan = fid_CH2_mscan(:,2:end);
            dlmwrite(dir_file_CH2_mscan, fid_CH2_mscan, 'delimiter', ' ', 'precision', 15);

            fid_CH3_mscan = fid_CH3_mscan(:,2:end);
            dlmwrite(dir_file_CH3_mscan, fid_CH3_mscan, 'delimiter', ' ', 'precision', 15);
        end
    end      
end
