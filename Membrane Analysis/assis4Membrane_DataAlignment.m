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

            dirs_4(k).name    %testing    Axial Distribution
            dir_name_4 = fullfile(dir_name_3,dirs_4(k).name);
            
            dirs_5 = dir(dir_name_4);
            dir_file_1_alignment = fullfile(dir_name_4, 'M-Alignment-PlotGraph-CH1.txt');
            dir_file_2_alignment = fullfile(dir_name_4, 'M-Alignment-PlotGraph-CH2.txt');
%             dir_file_3_alignment = fullfile(dir_name_4, 'M-Alignment-PlotGraph-CH3.txt');
            fid_CH1_alignment = zeros(100,1);
            fid_CH2_alignment = zeros(100,1);
%             fid_CH3_alignment = zeros(100,1);

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
                    if( ~isequal( dirs_6(m).name, 'mscan'))
                        continue;
                    end

                    dirs_6(m).name      % testing mscan
                    dir_name_6 = fullfile(dir_name_5, dirs_6(m).name);

                    %CH1
                    if( exist( fullfile(dir_name_6, 'subBKG-CH1-mscan.txt'),'file'))
                        subBKG_CH1_mscan = importdata(fullfile(dir_name_6, 'subBKG-CH1-mscan.txt'));
                        [value_1, location_1] = max(subBKG_CH1_mscan(:));
                        %align_line_1 = location_1 - fix(location_1/10)*10;
                        align_line_1 = mod(location_1, 10);

                        if align_line_1 == 0
                            copyfile(fullfile( dir_name_6,'subBKG-CH1-mscan.txt'),fullfile( dir_name_6,'subBKG-CH1-mscan-Alignment.txt'));
                            A = zeros(100,1);
                            A(1:numel(subBKG_CH1_mscan),1) = subBKG_CH1_mscan;
                            fid_CH1_alignment = [fid_CH1_alignment,A];
                        elseif align_line_1 > 0
                            CH1 = importdata(fullfile(dir_name_6,'subBKG-CH1-mscan.txt'));
                            CH1_align_line = align_line_1;
                            while CH1_align_line > 0
                                CH1 = CH1([2:end]);
                                CH1_align_line = CH1_align_line - 1;
                            end
                            dlmwrite (fullfile(dir_name_6,'subBKG-CH1-mscan-Alignment.txt'), CH1, 'precision', 15);
                            A = zeros(100,1);
                            A(1:numel(CH1),1) = CH1;
                            fid_CH1_alignment = [fid_CH1_alignment,A];
                        else
                        end
                    end

                    %CH2
                    if( exist( fullfile(dir_name_6, 'subBKG-CH2-mscan.txt'),'file'))
                        subBKG_CH2_mscan = importdata(fullfile(dir_name_6, 'subBKG-CH2-mscan.txt'));
                        [value_2, location_2] = max(subBKG_CH2_mscan(:));
                        %align_line_2 = location_2 - fix(location_2/10)*10;
                        align_line_2 = mod(location_2, 10);

                        if align_line_2 == 0
                            copyfile(fullfile( dir_name_6,'subBKG-CH2-mscan.txt'),fullfile( dir_name_6,'subBKG-CH2-mscan-Alignment.txt'));
                            A = zeros(100,1);
                            A(1:numel(subBKG_CH2_mscan),1) = subBKG_CH2_mscan;
                            fid_CH2_alignment = [fid_CH2_alignment,A];
                        elseif align_line_2 > 0
                            CH2 = importdata(fullfile(dir_name_6,'subBKG-CH2-mscan.txt'));
                            CH2_align_line = align_line_2;
                            while CH2_align_line > 0
                                CH2 = CH2([2:end]);
                                CH2_align_line = CH2_align_line - 1;
                            end
                            dlmwrite (fullfile(dir_name_6,'subBKG-CH2-mscan-Alignment.txt'), CH2, 'precision', 15);
                            A = zeros(100,1);
                            A(1:numel(CH2),1) = CH2;
                            fid_CH2_alignment = [fid_CH2_alignment,A];
                        else
                        end
                    end

                    %CH3
%                     if( exist( fullfile(dir_name_6, 'subBKG-CH3-mscan.txt'),'file'))
%                         subBKG_CH3_mscan = importdata(fullfile(dir_name_6, 'subBKG-CH3-mscan.txt'));
%                         [value_3, location_3] = max(subBKG_CH3_mscan(:));
%                         %align_line_3 = location_3 - fix(location_3/10)*10;
%                         align_line_3 = mod(location_3, 10);

%                         if align_line_3 == 0
%                             copyfile(fullfile( dir_name_6,'subBKG-CH3-mscan.txt'),fullfile( dir_name_6,'subBKG-CH3-mscan-Alignment.txt'));
%                             A = zeros(100,1);
%                             A(1:numel(subBKG_CH3_mscan),1) = subBKG_CH3_mscan;
%                             fid_CH3_alignment = [fid_CH3_alignment,A];
%                         elseif align_line_3 > 0
%                             CH3 = importdata(fullfile(dir_name_6,'subBKG-CH3-mscan.txt'));
%                             CH3_align_line = align_line_3;
%                             while CH3_align_line > 0
%                                 CH3 = CH3([2:end]);
%                                 CH3_align_line = CH3_align_line - 1;
%                             end
%                             dlmwrite (fullfile(dir_name_6,'subBKG-CH3-mscan-Alignment.txt'), CH3, 'precision', 15);
%                             A = zeros(100,1);
%                             A(1:numel(CH3),1) = CH3;
%                             fid_CH3_alignment = [fid_CH3_alignment,A];
%                         else
%                         end
%                     end
                end
            end
            fid_CH1_alignment = fid_CH1_alignment(:,2:end);
            dlmwrite(dir_file_1_alignment, fid_CH1_alignment, 'delimiter', ' ', 'precision', 15);
            fid_CH2_alignment = fid_CH2_alignment(:,2:end);
            dlmwrite(dir_file_2_alignment, fid_CH2_alignment, 'delimiter', ' ', 'precision', 15);
%             fid_CH3_alignment = fid_CH3_alignment(:,2:end);
%             dlmwrite(dir_file_3_alignment, fid_CH3_alignment, 'delimiter', ' ', 'precision', 15);
        end
    end      
end