%Lymphocyte_DVH calculation - Zach Diamond
%Assume CERR is operating and CT is onscreen

global planC

%List of structures
%slist = 1:21; Whole CT scan
% slist = [3 4]; Test structures

slist = [3 4 5 8 10 11 14 19 20 21];

%slist corresponds to the structures: [r_kidney, small_bowel, r_kidney, spinal_cord, liver, large_bowel
%chest_wall, spleen, abdom aorta, inf vena cava]

%Densities of corresponding structures:

%%rho obtained from Excel spreadsheet with name my_file:

my_file = 'Lymphocyte_DVH.xlsx';
rholoc = 'C70:C79';
sheet = 1;
rho = xlsread(my_file,sheet,rholoc)';

%%rho = [0 1]; Test densities
%%rho = [5.19e7 1.67e6 5.19e7 4.51e8 2.27e7 1.13e6 5e8 6.36e8 7.68e6
%3.79e7]; Explicit values over spreadsheet.

%Display warning if strucutres list and density list are not the same
%length:

if length(rho) ~= length(slist)
    warning('Density and structure lists are not the same length!');
end

%Select total cumulative dose (41.8 Gy):
doseToUse = 1;

%Find dose vectors for each structure (saved as cell):

for i = 1:length(rho)
    doses{i} = getDVH(slist(i),doseToUse,planC);
    maxdose(i) = max(doses{i});
end

globalmax = max(maxdose);

%Produce histograms (cumulative), # = rho * volume;histcounts fcn takes
%care of this easily;avoids tedious algebra

nbins = 60;
edges = linspace(0,globalmax,nbins);

for i = 1:length(rho)
    n(i,:) = histcounts(doses{i},edges)*rho(i);
end

totn = sum(n,1);

%Plot Lymphocyte DVH:
csum = cumsum(totn);
lymphocyteDVH = max(csum) - csum;
binCenters = (edges(2)-edges(1))/2 + edges(1:end-1);
figure;
plot(binCenters,lymphocyteDVH);
title('Lymphocyte DVH of Liver Tumor');
ylabel('Number of Lymphocytes');
xlabel('Dose [Gy]');

%Plot Normalized/Relative Lymphocyte DVH as percentage (0%-100%):
rel_lymphocyteDVH = (lymphocyteDVH/max(lymphocyteDVH))*100;
figure;
plot(binCenters,rel_lymphocyteDVH);
title('Lymphocyte DVH of Liver Tumor');
ylabel('% of Total Lymphocytes');
xlabel('Dose [Gy]');



