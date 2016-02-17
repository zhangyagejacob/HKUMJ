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
            dir_file_1_avg = fullfile(dir_name_4, 'Ratio-CH1Avg.txt');
            dir_file_1_max = fullfile(dir_name_4, 'Ratio-CH1Max.txt');
            dir_file_2_avg = fullfile(dir_name_4, 'Ratio-CH2Avg.txt');
            dir_file_2_max = fullfile(dir_name_4, 'Ratio-CH2Max.txt');
            dir_file_3_avg = fullfile(dir_name_4, 'Ratio-CH3Avg.txt');
            dir_file_3_max = fullfile(dir_name_4, 'Ratio-CH3Max.txt');

            for l = 1:length(dirs_5)
                if( isequal( dirs_5(l).name, '.')||...
                    isequal( dirs_5(l).name, '..')||...
                    dirs_5(l).isdir)
                    continue;
                end
                
                %x: mCherry=1, GFP=2, BFP2-urtch=3
                %CH1
                C1 = importdata(fullfile(dir_name_4,'Z-CH1-ratio.txt'));
                [a,b]= size (C1);

                for i=1:a
                    for j=1:b        
                        if C1(i,j) > 1
                            % disp(C1(i,j));
                            C1correct(i,j)=C1(i,j);
                        end
                    end
                end
                C1avg = sum(C1correct',2)./sum(C1correct'~=0,2);
                C1max = (max(C1correct))'
                dlmwrite (dir_file_1_avg, C1avg, 'precision', 15);
                dlmwrite (dir_file_1_max, C1max, 'precision', 15);

                %CH2
                C2 = importdata(fullfile(dir_name_4,'Z-CH2-ratio.txt'));
                [a,b]= size (C2);

                for i=1:a
                    for j=1:b        
                        if C2(i,j) > 1
                            % disp(C2(i,j));
                            C2correct(i,j)=C2(i,j);
                        end
                    end
                end
                C2avg = sum(C2correct',2)./sum(C2correct'~=0,2);
                C2max = (max(C2correct))'
                dlmwrite (dir_file_2_avg, C2avg, 'precision', 15);
                dlmwrite (dir_file_2_max, C2max, 'precision', 15);

                %CH3
                C3 = importdata(fullfile(dir_name_4,'Z-CH3-ratio.txt'));
                [a,b]= size (C3);

                for i=1:a
                    for j=1:b        
                        if C3(i,j) > 1
                            % disp(C3(i,j));
                            C3correct(i,j)=C3(i,j);
                        end
                    end
                end
                C3avg = sum(C3correct',2)./sum(C3correct'~=0,2);
                C3max = (max(C3correct))'
                dlmwrite (dir_file_3_avg, C3avg, 'precision', 15);
                dlmwrite (dir_file_3_max, C3max, 'precision', 15);
            end
        end
    end
end