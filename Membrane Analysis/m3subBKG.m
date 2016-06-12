%% this function is used to merge all the mscan.txt into one document

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
            if( ~isequal( dirs_4( k ).name, 'Membrane Analysis'))
                continue;
            end

            dirs_4(k).name    %testing    Membrane Analysis
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
                if ~(any(strcmp(dirs_6_cell, 'mbk')) && any(strcmp(dirs_6_cell, 'mscan')))
                    continue;
                end
                
                for m = 1:length(dirs_6)
                    if (isequal( dirs_6( m ).name, 'mbk'))
                        dir_mbk = fullfile(dir_name_5,dirs_6(m).name,'Results.txt');
                        nonCellBKG = importdata(dir_mbk);
                    end
                end
                
                for m = 1:length(dirs_6)    % mscan
                    if( ~isequal( dirs_6(m).name, 'mscan'))
                        continue;
                    end

                    dirs_6(m).name      % testing mscan
                    dir_name_6 = fullfile(dir_name_5, dirs_6(m).name);
                    
                    if( exist( fullfile(dir_name_6, 'CH1-mscan.txt'),'file'))
                        %CH1
                        dir_file_1 = fullfile(dir_name_6, 'CH1-mscan.txt')
                        CH1RAW = importdata(dir_file_1);
                        %cytoCH1 = importdata(fullfile(dir_name_5, './cytosol/cyto-CH1.txt'));
                        %x:         mCherry=1, GFP=2, BFP2-urtch=3,        (x,3)
                        CH1subBKG        = CH1RAW.data(:,2)-nonCellBKG.data(1,3); 
                        %cytoCH1subBKG   = cytoCH1.data(:,3)-nonCellBKG.data(1,3); 
                        %BleachCorrectionCH1 = times (CH1subBKG, rdivide(max(cytoCH1subBKG), cytoCH1subBKG));    % right array division
                        dlmwrite (fullfile(dir_name_5,dirs_6(m).name,'subBKG-CH1-mscan.txt'), CH1subBKG, 'precision', 15);
                    end

                    if ( exist( fullfile(dir_name_6, 'CH2-mscan.txt'),'file'))
                        %CH2
                        dir_file_2 = fullfile(dir_name_6,'CH2-mscan.txt');
                        CH2RAW = importdata(dir_file_2);
                        CH2subBKG        = CH2RAW.data(:,2)-nonCellBKG.data(2,3); 
                        dlmwrite (fullfile(dir_name_5,dirs_6(m).name,'subBKG-CH2-mscan.txt'), CH2subBKG, 'precision', 15);
                    end

%                     if ( exist( fullfile(dir_name_6, 'CH3-mscan.txt'),'file'))
%                         %CH3
%                         dir_file_3 = fullfile(dir_name_6,'CH3-mscan.txt');
%                         CH3RAW = importdata(dir_file_3);
%                         CH3subBKG        = CH3RAW.data(:,2)-nonCellBKG.data(3,3); 
%                         dlmwrite (fullfile(dir_name_5,dirs_6(m).name,'subBKG-CH3-mscan.txt'), CH3subBKG, 'precision', 15);
%                     end
                end
            end
        end
    end      
end
