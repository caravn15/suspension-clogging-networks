%% RUNS SIMULATIONS FOR AND PLOTS FIG. S1 OF THE SUPPLEMENTARY MATERIAL
% USES THE SAME DATA AS FIG. 3 OF THE MAIN MANUSCRIPT -
% YOU ONLY NEED TO RUN ONE SET OF SIMULATIONS (THIS SCRIPT OR
% sc_main_fig_3.m)

clear all;
close all;
clc; addpath(genpath('./'));

%% parameters

% fluid parameters
Da_v          = [0.5e-2,1e-3,0.5e-3,1e-4]; % Darcy number (line plots are performed for second value)
phm           = 0.85;                      % maximum packing fraction (must be <= 1)
phin_v        = [0.61,0.65];               % inlet particle volume fraction (must be < phim)
Qt            = 1;                         % total flow rate (scaled to 1 in non-dimensionalisation)
delP          = [NaN 0];                   % pressure drop (delP(1) = NaN as Qt prescribed)

% solution parameters
tol           = 1e-6;                      % tolerance for iterations (epsilon in manuscript)
maxit         = 50;                        % maximum number of iterations

% network information
Netfld        = 'motif-fig-S1/';           % folder where data is stored
NetType       = 'motif';                   % type of network: 'retinal-vasc' or 'motif'

% save options  
fld           = 'supp-mat-results/';       % folder to save data/figures
fn            = 'fig_S1';                  % filename for data
SqueezeData   = 1;                         % =0 to save all data (solutions at all iterations + diagnostic information)
                                           % =1 to only save final solutions (results in smaller file sizes)

% other options
NumDivLines   = 500;                       % number of grid points for R_2,4 in simulations/plots (set =500 for paper results)
NumDivSweeps  = 100;                       % number of grid points in each direction for phin/R_2,4 sweeps in simulations/plots (set =100 for paper results)
phinLim       = [0.55,0.7];                % range of phin in phin/R_2,4 sweeps
OutputCW      = 0;                         % output full solver details in the command window (set =0 if not required)
DataLoad      = 0;                         % set =0 to run solve + plot, or =1 to load previous simulation data (finds path automatically)

%% check motif network data exists (generate if not)

try
    load(['data/net/',Netfld,'data_net_motif.mat'],'net');
catch
    GenerateMotifFig3(); % same motif as fig. 3
end

%% solve (if required)

if DataLoad == 0

    % solve required - same solve as fig. 3
    [sol,nClogSweep]= SolveFig3(NumDivLines,NumDivSweeps,Netfld,NetType,Da_v,phm,phin_v,Qt,delP,phinLim,tol,maxit,fld,fn,SqueezeData,OutputCW);

else

    % load network data and get filename
    net    = LoadNetworkData(Netfld,NetType,[]);

    % load data
    try
        [sol,nClogSweep] = LoadFig3(NumDivLines,NumDivSweeps,Da_v,phm,phin_v,phinLim,fld,fn);
    catch
        error('Could not load data.');
    end
end

%% plot (and save) figures

% create grid points for R_4,8
R24_v = linspace(1,0.001,NumDivLines);

% plot figure
figSup = figure('Theme','light','Position',[365,194,1267,671]);
tiledlayout(2,3,'Padding','tight')
nexttile; PlotFig3LinesF(1,sol,R24_v,1,1,phm)
nexttile; PlotFig3LinesF(2,sol,R24_v,1,1,phm)
nexttile; PlotFig3LinesF(3,sol,R24_v,1,1,phm)
nexttile; PlotFig3LinesQ(1,sol,R24_v,1,1,phm)
nexttile; PlotFig3LinesQ(2,sol,R24_v,1,1,phm)
nexttile; PlotFig3LinesQ(3,sol,R24_v,1,1,phm)

% save panel (b)
try
    print(gcf, ['images/',fld,'image_',fn,'.png'],'-dpng','-r300');
catch
    mkdir(['images/',fld]);
    print(gcf, ['images/',fld,'image_',fn,'.png'],'-dpng','-r300');
end

