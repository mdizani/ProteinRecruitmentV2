# ProteinRecruitmentV2
scripts used for the analysis pertaining to the DNA-based host condensates

## Fig3_FRAP.m 
was used to measure and plot fluorescence recovery after photo bleaching. This was done by fitting an exponential, determining the time constant. The code is set up to run on each aptamer design: Junction, Middle, and Tip, and outputs the FRAP curve for that design. In triplicate, it takes the average, normalizes, and calculates the standard error of the mean for with and without SA. 

## Fig4_annealingCurve.m 
plots the annealing curve of each aptamer design and determines the first melting temperature above 50 and the next below 50. It does so by calculating the steepest slope at both the higher and lower sections. 

## FigS9_meltingCurve.m 
plots the melting curve of each aptamer design and calculates at what temperature they each reach 0.5 absorbance, normalized from 0 to 1. The input is an excel file with time, junction, middle, and tip melting data.

## PC_fig3.m 
plots partition coefficient boxplots for each aptamer design with and without SA. It takes in partition coefficients already calculated for individual droplets and plots their average and standard deviation. 

## PC_fig5.m 
takes in the average partition coefficient and its standard deviation for two replicates and then plots the combined average and standard deviation. You must input the data in the order of 0x, 0.5x, 1x, and 2x. 

## Figure_S4_Growth_Curves.m 
graphs the growth of condensates over time and fits the data to the following power law: f = gt^alpha

## Figures_2_S5_Area_Boxplots.m and Figure_S6_Eccentricity_Boxplots.m 
create box-and-whisker plots of condensate areas and eccentricities, respectively.

## Figure_S7_CCDF.m 
pools data from three replicas and graphs the complementary cumulative distribution function (CCDF) of each.

## Figures_1_2_Cytoplots.m 
creates a scatterplot to show the Pearson’s Coefficient correlation between the intensities of the FAM (green) and Alexa 647 (red) channels. 

## Figures_S12_S13_S14_oxDNA_angles.m and Figures_S15_oxDNA_Psi.m 
trajectory files from oxDNA simulations across 4000 time points. At each time point, it creates vectors to represent each nanostar arm and calculates the angles between them. 
