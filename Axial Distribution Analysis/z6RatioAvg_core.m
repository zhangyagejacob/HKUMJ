clear; 
%x: mCherry=1, GFP=2, BFP2-urtch=3


%CH1
C1 = importdata('Z-CH1-ratio.txt');
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
dlmwrite ('Ratio-CH1Avg.txt', C1avg, 'precision', 15);
dlmwrite ('Ratio-CH1Max.txt', C1max, 'precision', 15);


clear;
%CH2
C1 = importdata('Z-CH2-ratio.txt');
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
dlmwrite ('Ratio-CH2Avg.txt', C1avg, 'precision', 15);
dlmwrite ('Ratio-CH2Max.txt', C1max, 'precision', 15);

clear;
%CH3
C1 = importdata('Z-CH3-ratio.txt');
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
dlmwrite ('Ratio-CH3Avg.txt', C1avg, 'precision', 15);
dlmwrite ('Ratio-CH3Max.txt', C1max, 'precision', 15);


