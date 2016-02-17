clear; 
%x: mCherry=1, GFP=2, BFP2-urtch=3
nonCellBKG = importdata('./bk/Results.txt');

% zone 1, fast recovering

%CH1
CH1RAW = importdata('./zone1/CH1-zone1.txt');
cytoCH1 = importdata('./cytosol/cyto-CH1.txt');
%x:         mCherry=1, GFP=2, BFP2-urtch=3,        (x,3)  
CH1subBKG        = CH1RAW.data(:,2)-nonCellBKG.data(1,3); 
cytoCH1subBKG   = cytoCH1.data(:,3)-nonCellBKG.data(1,3); 
BleachCorrectionCH1 = times (CH1subBKG, rdivide(max(cytoCH1subBKG), cytoCH1subBKG));
dlmwrite ('./zone1/0FRAP-BKC-CH1-zone1.txt', BleachCorrectionCH1, 'precision', 15);



%CH2
CH2RAW = importdata('./zone1/CH2-zone1.txt');
cytoCH2 = importdata('./cytosol/cyto-CH2.txt');
%x:         mCherry=1, GFP=2, BFP2-urtch=3,        (x,3)  
CH2subBKG        = CH2RAW.data(:,2)-nonCellBKG.data(2,3); 
cytoCH2subBKG   = cytoCH2.data(:,3)-nonCellBKG.data(2,3); 
BleachCorrectionCH2 = times (CH2subBKG, rdivide(max(cytoCH2subBKG), cytoCH2subBKG));
dlmwrite ('./zone1/0FRAP-BKC-CH2-zone1.txt', BleachCorrectionCH2, 'precision', 15);


%CH3
CH3RAW = importdata('./zone1/CH3-zone1.txt');
cytoCH3 = importdata('./cytosol/cyto-CH3.txt');
%x:         mCherry=1, GFP=2, BFP2-urtch=3,        (x,3)  
CH3subBKG        = CH3RAW.data(:,2)-nonCellBKG.data(3,3); 
cytoCH3subBKG   = cytoCH3.data(:,3)-nonCellBKG.data(3,3); 
BleachCorrectionCH3 = times (CH3subBKG, rdivide(max(cytoCH3subBKG), cytoCH3subBKG));
dlmwrite ('./zone1/0FRAP-BKC-CH3-zone1.txt', BleachCorrectionCH3, 'precision', 15);

