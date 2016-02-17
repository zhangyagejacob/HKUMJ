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
                   
                    %CH1
                    if( exist( fullfile(dir_name_6, 'CH1_alignment.txt'),'file'))
                        dir_file_1 = fullfile(dir_name_6,'CH1_alignment.txt');
                        CH1RAW = importdata(dir_file_1);
                        %x:         mCherry=1, GFP=2, BFP2-urtch=3,        (x,3)
                        CH1subBKG        = CH1RAW.data(:,3)-nonCellBKG.data(1,3);
                        CH1CoreCytoRatio =          CH1subBKG/CytosolBKGsub(1);
                        dlmwrite (fullfile(dir_name_5,dirs_6(m).name,'BK-CH1.txt'), CH1subBKG, 'precision', 15);
                        dlmwrite (fullfile(dir_name_5,dirs_6(m).name,'BK-CH1-ratio.txt'), CH1CoreCytoRatio, 'precision', 15);
                    end
                    %CH2
                    if( exist( fullfile(dir_name_6, 'CH2_alignment.txt'),'file'))
                        dir_file_2 = fullfile(dir_name_6,'CH2_alignment.txt');
                        CH2RAW = importdata(dir_file_2);
                        %x:         mCherry=1, GFP=2, BFP2-urtch=3,        (x,3)
                        CH2subBKG        = CH2RAW.data(:,3)-nonCellBKG.data(2,3);
                        CH2CoreCytoRatio =          CH2subBKG/CytosolBKGsub(2);
                        dlmwrite (fullfile(dir_name_5,dirs_6(m).name,'BK-CH2.txt'), CH2subBKG, 'precision', 15);
                        dlmwrite (fullfile(dir_name_5,dirs_6(m).name,'BK-CH2-ratio.txt'), CH2CoreCytoRatio, 'precision', 15);
                    end
                    %CH3
                    if( exist( fullfile(dir_name_6, 'CH3_alignment.txt'),'file'))
                        dir_file_3 = fullfile(dir_name_6,'CH3_alignment.txt');
                        CH3RAW = importdata(dir_file_3);
                        %x:         mCherry=1, GFP=2, BFP2-urtch=3,        (x,3)
                        CH3subBKG        = CH3RAW.data(:,3)-nonCellBKG.data(3,3);
                        CH3CoreCytoRatio =          CH3subBKG/CytosolBKGsub(3);
                        dlmwrite (fullfile(dir_name_5,dirs_6(m).name,'BK-CH3.txt'), CH3subBKG, 'precision', 15);
                        dlmwrite (fullfile(dir_name_5,dirs_6(m).name,'BK-CH3-ratio.txt'), CH3CoreCytoRatio, 'precision', 15);
                    end
                end
            end
        end
    end      
end
