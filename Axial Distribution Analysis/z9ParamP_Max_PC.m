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

            dir_file_CH1_Ppara = fullfile(dir_name_4, 'P-Parameter-CH1-Max-2015-12-09.txt');
            dir_file_CH2_Ppara = fullfile(dir_name_4, 'P-Parameter-CH2-Max-2015-12-09.txt');
%             dir_file_CH3_Ppara = fullfile(dir_name_4, 'P-Parameter-CH3-Max-2015-12-09.txt');
            
            CH1_Parameters = struct('p_value',{},'Path',{});
            CH2_Parameters = struct('p_value',{},'Path',{});
%             CH3_Parameters = struct('p_value',{},'Path',{});
            
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
                        dir_cytosol = fullfile(dir_name_5,dirs_6(m).name,'Results.txt');
                        CytosolRAW = importdata(dir_cytosol);
                    else
                    end
                end

                %nonCellBKG = nonCellBKG.data(:,3);
                nonCellBKG_CH1 = nonCellBKG.data(1,3);
                nonCellBKG_CH2 = nonCellBKG.data(2,3);
%                 nonCellBKG_CH3 = nonCellBKG.data(3,3);
                %CytosolRAW = CytosolRAW.data(:,3);
                CytosolRAW_CH1 = CytosolRAW.data(1,3);
                CytosolRAW_CH2 = CytosolRAW.data(2,3);
%                 CytosolRAW_CH3 = CytosolRAW.data(3,3);
                
                for m = 1:length(dirs_6)    % for PDXs
                    if (  isequal( dirs_6( m ).name, '.' )||... 
                          isequal( dirs_6( m ).name, '..')||... 
                          ~dirs_6( m ).isdir ||...
                          isequal( dirs_6( m ).name, 'bk')||...
                          isequal( dirs_6( m ).name, 'cytosol')||...
                          isequal( dirs_6( m).name, 'mbk')||...
                          isequal( dirs_6( m ).name, 'mscan'))
                          continue;
                    end

                    dirs_6(m).name      % testing PDXs
                    dir_name_6 = fullfile(dir_name_5, dirs_6(m).name);
                    
                    %CH1
                    if( exist( fullfile(dir_name_6, 'CH1_alignment.txt'),'file'))
                        ParaRaw = importdata(fullfile(dir_name_6, 'CH1_alignment.txt'));
                        
                        P_Max = max(ParaRaw.data(:,3));
                        %P_Bar = mean(P_xum);
                        P = (P_Max - CytosolRAW_CH1) / (P_Max - nonCellBKG_CH1);
                        CH1_Parameters(length(CH1_Parameters)+1).p_value = P;
                        CH1_Parameters(length(CH1_Parameters)).Path = dir_name_6;
                    end

                    %CH2
                    if( exist( fullfile(dir_name_6, 'CH2_alignment.txt'),'file'))
                        ParaRaw = importdata(fullfile(dir_name_6, 'CH2_alignment.txt'));

                        P_Max = max(ParaRaw.data(:,3));
                        %P_Bar = mean(P_xum);
                        P = (P_Max - CytosolRAW_CH2) / (P_Max - nonCellBKG_CH2);
                        CH2_Parameters(length(CH2_Parameters)+1).p_value = P;
                        CH2_Parameters(length(CH2_Parameters)).Path = dir_name_6;
                    end
                    
                    %CH3
%                     if( exist( fullfile(dir_name_6, 'CH3_alignment.txt'),'file'))
%                         ParaRaw = importdata(fullfile(dir_name_6, 'CH3_alignment.txt'));
%                         
%                         P_Max = max(ParaRaw.data(:,3));
%                         %P_Bar = mean(P_xum);
%                         P = (P_Max - CytosolRAW_CH3) / (P_Max - nonCellBKG_CH3);
%                         CH3_Parameters(length(CH3_Parameters)+1).p_value = P;
%                         CH3_Parameters(length(CH3_Parameters)).Path = dir_name_6;
%                     end                    
                end
            end

            %% Save struct to cell
            CH1_P_Value = struct2cell(CH1_Parameters);
            CH2_P_Value = struct2cell(CH2_Parameters);
%             CH3_P_Value = struct2cell(CH3_Parameters);
            %% 
            fid = fopen(dir_file_CH1_Ppara, 'wt');
            cellfun(@(x,y) fprintf(fid,'%12.9f\t%s\n',x,y), CH1_P_Value(1,:,:), CH1_P_Value(2,:,:));
            fclose(fid);
            fid = fopen(dir_file_CH2_Ppara, 'wt');
            cellfun(@(x,y) fprintf(fid,'%12.9f\t%s\n',x,y), CH2_P_Value(1,:,:), CH2_P_Value(2,:,:));
            fclose(fid);
%             fid = fopen(dir_file_CH3_Ppara, 'wt');
%             cellfun(@(x,y) fprintf(fid,'%12.9f\t%s\n',x,y), CH3_P_Value(1,:,:), CH3_P_Value(2,:,:));
%             fclose(fid);            
        end
    end      
end
