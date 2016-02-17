clear all
close all
clc

dir_name_1 = uigetdir(matlabroot);       %default path at MATLAB root folder

%dirs_2 = dir(dir_name_1);

%   dir_name_2 = fullfile(dir_name_1,dirs_2(i).name);

    dirs_3 = dir(dir_name_1);
    for j = 1 : length( dirs_3 )
        if( ~isequal( dirs_3( j ).name, 'Volocity Image'))
            continue;
        end
        dirs_3(j).name    %testing   Volocity Image
        dir_name_3 = fullfile(dir_name_1,dirs_3(j).name);       
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
                    if (isequal( dirs_6( m ).name, 'bk'))
                        dir_bk = fullfile(dir_name_5,dirs_6(m).name,'Results.txt');
                        nonCellBKG = importdata(dir_bk);
                    end
                end
                
                for m = 1:length(dirs_6)
                    if( ~isequal( dirs_6(m).name, 'zone1'))
                        continue;
                    end

                    dirs_6(m).name      % testing zone1
                    dir_name_6 = fullfile(dir_name_5, dirs_6(m).name);
                    
                    %CH1
                    dir_file_1 = fullfile(dir_name_6, 'CH1-zone1.txt')
                    CH1RAW = importdata(dir_file_1);
                    cytoCH1 = importdata(fullfile(dir_name_5, './cytosol/cyto-CH1.txt'));
                    if(numel(CH1RAW) < numel(cytoCH1))
                        cytoCH1 = cytoCH1(numel(CytoCH1)-numel(CH1RAW):end,:);
                    end
                    %x:         mCherry=1, GFP=2, BFP2-urtch=3,        (x,3)  
                    CH1subBKG        = CH1RAW.data(:,2)-nonCellBKG.data(1,3); 
                    cytoCH1subBKG   = cytoCH1.data(:,3)-nonCellBKG.data(1,3); 
                    BleachCorrectionCH1 = times (CH1subBKG, rdivide(max(cytoCH1subBKG), cytoCH1subBKG));    % right array division
                    dlmwrite (fullfile(dir_name_5,dirs_6(m).name,'FRAP-BKC-CH1-zone1.txt'), BleachCorrectionCH1, 'precision', 15);
                    
                    %CH2
                    dir_file_2 = fullfile(dir_name_6,'CH2-zone1.txt');
                    CH2RAW = importdata(dir_file_2);
                    cytoCH2 = importdata(fullfile(dir_name_5,'./cytosol/cyto-CH2.txt'));
                    if(numel(CH2RAW) < numel(cytoCH2))
                        cytoCH2 = cytoCH2(numel(CytoCH2)-numel(CH2RAW):end,:);
                    end
                    %x:         mCherry=1, GFP=2, BFP2-urtch=3,        (x,3) 
                    CH2subBKG        = CH2RAW.data(:,2)-nonCellBKG.data(2,3); 
                    cytoCH2subBKG   = cytoCH2.data(:,3)-nonCellBKG.data(2,3); 
                    BleachCorrectionCH2 = times (CH2subBKG, rdivide(max(cytoCH2subBKG), cytoCH2subBKG));
                    dlmwrite (fullfile(dir_name_5,dirs_6(m).name,'FRAP-BKC-CH2-zone1.txt'), BleachCorrectionCH2, 'precision', 15);
                end
            end
        end
    end