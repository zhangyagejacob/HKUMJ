Axial Distribution Analysis (Z-stack Analysis)
1. Run assi2DataAlignment.m for aligning each data slot in a standard format, such that CH3.txt contains its 3rd point as the point with highest intensity
2. Run z4CoreBKGratio.m to get BK-CHX.txt and BK-CHX-ratio.txt
2_1. Run z4CoreBKGratio_Amended.m to get BK-CHX-Amended.txt
3. Run z5mergeZ.m, merge all BK-CHX.txt and BK-CHX-ratio.txt into Z-CHX.txt and Z-CHX-ratio.txt
3_1. Run z5mergeZ_Amended.m, merge all BK-CHX-Amended.txt into Z-CHX-Amended.txt
4. Run z6RatioAvg.m to calculate the max and mean in Z-CHX-ratio.txt into Ratio-CHXAvg.txt and Ratio-CHXMax.txt
5. Run z7mergeZ_Ratio.m to merge all Ratio-CHXAvg.txt and Ratio-CHXMax.txt into Ratio-Avg.txt and Ratio-Max.txt respectivey
6. Run z9ParamP_1umCore_11frameReference.m to calculate parameter P for each protein (each sample in a line, recorded in the form of [P, Path to Podosome])
6_1. Run z11ParamP_2umCore_CytoBKG_Amended.m to calculate parameter P (PC Value) for each protein with a new algorithm

Membrane Analysis
1. Run m3subBKG.m to subtract background 
2. Run assis4Membrane_DataAlignment.m to do data alignment for each channel, as well as prepare data for plotting diagrmas
%3. Run m4merge.m to merge every single channel of each sample into one file, which would use in m5ParaM.m // this code is not useful
4. Run m5ParaM.m to calculate parameter M for each protein (each sample in a line, recorded in the form of [M, PM, CB])

FRAP Analysis
1. Run t5BKcorrectionZone1.m and t5BKcorrectionZone2.m to subtract the BKG noise from each data slot and form FRAP-BKC-CHX-zone1.txt and FRAP-BKC-CHX-zone2.txt
2. Run assis3FRAP_DataAlignment.m for aligning each data slot in a standard format, such that the 6th point would be the lowest point
3. Run t6mergeFRAPZone1.m and t6mergeFRAPZone2.m to merge all FRAP-BKC-CHX-zoneX_alignment.txt into FRAP-CHX-zoneX.txt
4. Run t7realign_Zone1.m and t7realign_Zone2.m to do re-alignment of FRAP-CHX-zoneX.txt by averaging the intensity of pre-bleaching points into 1, and derive a scaling factor which would be used to multiply every points after bleaching