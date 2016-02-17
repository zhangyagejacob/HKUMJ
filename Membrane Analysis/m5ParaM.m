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
            if( ~isequal( dirs_4( k ).name, 'Membrane Analysis'))
                continue;
            end

            %dirs_4(k).name    %testing    Axial Distribution
            dir_name_4 = fullfile(dir_name_3,dirs_4(k).name);
            
            dirs_5 = dir(dir_name_4);
            dir_file_CH1_mpara = fullfile(dir_name_4, 'M-Parameter-CH1.txt');
            dir_file_CH2_mpara = fullfile(dir_name_4, 'M-Parameter-CH2.txt');
%             dir_file_CH3_mpara = fullfile(dir_name_4, 'M-Parameter-CH3.txt');
            fid_CH1_mpara = zeros(100,1);
            fid_CH2_mpara = zeros(100,1);
%             fid_CH3_mpara = zeros(100,1);
            CH1_Parameters = [];
            CH2_Parameters = [];
%             CH3_Parameters = [];

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
                
                for m = 1:length(dirs_6)
                    if (isequal( dirs_6( m ).name, 'mbk'))
                        dir_mbk = fullfile(dir_name_5,dirs_6(m).name,'Results.txt');
                        nonCellBKG = importdata(dir_mbk);
                    end
                    if (isequal( dirs_6( m ).name, 'mcytosol'))
                        dir_cytosol = fullfile(dir_name_5,dirs_6(m).name,'Results.txt');
                        CytosolRAW = importdata(dir_cytosol);
                    end                    
                end
                
                %nonCellBKG = nonCellBKG.data(:,3);
                nonCellBKG_CH1 = nonCellBKG.data(1,3);
                nonCellBKG_CH2 = nonCellBKG.data(2,3);
                %CytosolRAW = CytosolRAW.data(:,3);
                CytosolRAW_CH1 = CytosolRAW.data(1,3);
                CytosolRAW_CH2 = CytosolRAW.data(2,3);                
                
                for m = 1:length(dirs_6)    % mscan
                    if( ~isequal( dirs_6(m).name, 'mscan'))
                        continue;
                    end

                    dirs_6(m).name      % testing mscan
                    dir_name_6 = fullfile(dir_name_5, dirs_6(m).name);
                    
                    %CH1
                    if( exist( fullfile(dir_name_6, 'subBKG-CH1-mscan.txt'),'file'))                  
                        A = zeros(100,1);
                        B = importdata(fullfile(dir_name_6, 'subBKG-CH1-mscan.txt'));   
                        A(1:numel(B),1) = B;
                        C = B(numel(B)-15:numel(B),1);
                        subBKG_CH1_PM = max(A);
                        subBKG_CH1_CB = mean(C);
                        M = (subBKG_CH1_PM - subBKG_CH1_CB)/subBKG_CH1_PM;
                        M_prime = (subBKG_CH1_PM - (CytosolRAW_CH1-nonCellBKG_CH1))/subBKG_CH1_PM;
                        % combine A to the new column of fid, and called this new matrix C
                        D = [M, subBKG_CH1_PM, subBKG_CH1_CB, M_prime, CytosolRAW_CH1-nonCellBKG_CH1];
                        CH1_Parameters = [CH1_Parameters;D];
                    end

                    %CH2
                    if( exist( fullfile(dir_name_6, 'subBKG-CH2-mscan.txt'),'file'))                  
                        A = zeros(100,1);
                        B = importdata(fullfile(dir_name_6, 'subBKG-CH2-mscan.txt'));   
                        A(1:numel(B),1) = B;
                        C = B(numel(B)-15:numel(B),1);
                        subBKG_CH2_PM = max(A);
                        subBKG_CH2_CB = mean(C);
                        M = (subBKG_CH2_PM - subBKG_CH2_CB)/subBKG_CH2_PM;
                        M_prime = (subBKG_CH2_PM - (CytosolRAW_CH2-nonCellBKG_CH2))/subBKG_CH2_PM;
                        D = [M, subBKG_CH2_PM, subBKG_CH2_CB, M_prime, CytosolRAW_CH2-nonCellBKG_CH1];
                        CH2_Parameters = [CH2_Parameters;D];
                    end

                    %CH3
%                     if( exist( fullfile(dir_name_6, 'subBKG-CH3-mscan.txt'),'file'))                  
%                         A = zeros(100,1);
%                         B = importdata(fullfile(dir_name_6, 'subBKG-CH3-mscan.txt'));   
%                         A(1:numel(B),1) = B;
%                         C = B(numel(B)-15:numel(B),1);
%                         subBKG_CH3_PM = max(A);
%                         subBKG_CH3_CB = mean(C);
%                         M = (subBKG_CH3_PM - subBKG_CH3_CB)/subBKG_CH3_PM;
%                         D = [M, subBKG_CH3_PM, subBKG_CH3_CB];
%                         CH3_Parameters = [CH3_Parameters;D];
%                     end
                end
            end
            dlmwrite(dir_file_CH1_mpara, CH1_Parameters, 'delimiter', ' ', 'precision', 15);
            dlmwrite(dir_file_CH2_mpara, CH2_Parameters, 'delimiter', ' ', 'precision', 15);
%             dlmwrite(dir_file_CH3_mpara, CH3_Parameters, 'delimiter', ' ', 'precision', 15);
        end
    end      
end
