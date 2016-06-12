% Copyright by yage zhang, zhangyg@hku.hk
clear all
close all
clc

dir_name_1 = uigetdir(matlabroot);       %default path at MATLAB root folder

dirs_2 = dir(dir_name_1);

for i = 1 : length( dirs_2 )
    
    if( isequal( dirs_2( i ).name, '.' )||... 
        isequal( dirs_2( i ).name, '..')||... 
        ~dirs_2( i ).isdir )
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
            if(~isequal( dirs_4( k ).name, 'Zone Analysis'))
                continue;
            end

            dirs_4(k).name    %testing    Zone Analysis
            dir_name_4 = fullfile(dir_name_3,dirs_4(k).name);
            
            dirs_5 = dir(dir_name_4);

            for l = 1:length(dirs_5)
                if( isequal( dirs_5( l ).name, '.' )||... 
                    isequal( dirs_5( l ).name, '..')||...
                    isequal( dirs_5( l ).name,'test')||...
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
                    end
                end
                
                Ibkg = nonCellBKG.data(:,3);
                Icyb = CytosolRAW.data(:,3);
                sdCyb = CytosolRAW.data(:,4);
                
                for m = 1:length(dirs_6)
                    if( ~isequal( dirs_6(m).name, 'mscan'))
                        continue;
                    end
                    dirs_6(m).name      % testing mscan
                    dir_name_6 = fullfile(dir_name_5, dirs_6(m).name);
                                        
                    Z4zone_CH1 = dlmread(fullfile(dir_name_6,'CH1-mscan.txt'),'\t', 1, 0);
                    Z4zone_CH2 = dlmread(fullfile(dir_name_6,'CH2-mscan.txt'),'\t', 1, 0);
                    dir_CH1 = fullfile(dir_name_6, 'CH1_Zone_Analysis.txt');
                    dir_CH2 = fullfile(dir_name_6, 'CH2_Zone_Analysis.txt');
                    
                    %% Fatch Zone 2 from F-actin Channel 3 by determining Xf and Xr
                    [Ip2,Xp2] = max(Z4zone_CH2(:,2));
                    Ic2 = Icyb(2) + 3*sdCyb(2);         % use statistical methods to find Podosome region
                    Xf = min(find(Z4zone_CH2(:,2)>Ic2 & Z4zone_CH2(:,1)<Xp2));
                    Xr = max(find(Z4zone_CH2(:,2)>Ic2 & Z4zone_CH2(:,1)>Xp2));
                    
                    %% Get [Ip1, Xp1] & [Ip2, Xp2]
                    % find local maximum alpha
                    if (sum(Z4zone_CH1(Xf:Xp2,2)>Z4zone_CH1(Xp2,2))>0)
                        [Ip1,Xp1] = max(Z4zone_CH1(Xf:Xp2,2));
                        Xp1 = Xp1+Xf-1;
                        if sum(Z4zone_CH1(Xp1-2:Xp1+2))/5 <= Z4zone_CH1(Xp2,2)
                            [Ip1,Xp1] = max(Z4zone_CH1(:,2));
                        else
                        end
                    else   % find global maximum beta
                        [Ip1,Xp1] = max(Z4zone_CH1(:,2));
                    end
                    
                    %% Normalized Position (NP)
                    NP1 = (Xp1-Xf) / (Xr-Xf);
                    NP2 = (Xp2-Xf) / (Xr-Xf);
%                     NP3 = (Xp3-Xf) / (Xr-Xf);                    
                    
                    %% Peak Intensity Ratio (PIR)
                    PIR1 = (Ip1-Icyb(1)) / (Z4zone_CH1(Xp2,2)-Icyb(1));
                    PIR2 = (Ip2-Icyb(2)) / (Z4zone_CH2(Xp2,2)-Icyb(2));
%                     PIR3 = 1;
                    
                    %% Store NP & PIR
                    fid = fopen(dir_CH1, 'wt');
                    %fprintf(fid,'%8s %11s\n','Normalized Position','Peak Intensity Ratio');
                    fprintf(fid,'%f\t%f\n',NP1, PIR1);
                    fclose(fid);
                    
                    fid = fopen(dir_CH2, 'wt');
                    fprintf(fid,'%f\t%f\n',NP2, PIR2);
                    fclose(fid);               
                end
            end
        end
    end      
end
