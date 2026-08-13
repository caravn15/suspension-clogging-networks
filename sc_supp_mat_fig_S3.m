%% RUNS SIMULATIONS FOR AND PLOTS FIG. S3 OF THE SUPPLEMENTARY MATERIAL

clear all;
close all;
clc; addpath(genpath('./'));

%% parameters

% fluid parameters
Da_v          = [0.5e-2,1e-3,0.5e-3,1e-4]; % Darcy number (line plots are performed for second value)
phm           = 0.65;                      % maximum packing fraction (must be <= 1)
phin_v        = [0.46,0.5];                % inlet particle volume fraction (must be < phim)
Qt            = 1;                         % total flow rate (scaled to 1 in non-dimensionalisation)
delP          = [NaN 0];                   % pressure drop (delP(1) = NaN as Qt prescribed)

% solution parameters
tol           = 1e-6;                      % tolerance for iterations (epsilon in manuscript)
maxit         = 50;                        % maximum number of iterations

% network information
Netfld        = 'motif-fig-S3/';           % folder where data is stored
NetType       = 'motif';                   % type of network: 'retinal-vasc' or 'motif'

% save options
fld           = 'supp-mat-results/';       % folder to save data/figures
fn            = 'fig_S3';                  % filename for data
SqueezeData   = 1;                         % =0 to save all data (solutions at all iterations + diagnostic information)
                                           % =1 to only save final solutions (results in smaller file sizes)

% other options
NumDivLines   = 500;                       % number of grid points for R_2,4 in simulations/plots (set =500 for paper results)
NumDivSweeps  = 100;                       % number of grid points in each direction for phin/R_2,4 sweeps in simulations/plots (set =100 for paper results)
phinLim       = [0.4,0.55];                % range of phin in phin/R_2,4 sweeps
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

    % solve required
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

% lines in sweep
phinLines = phin_v;

% create grid points for R_2,4 and phin
phin_v         = linspace(phinLim(1),phinLim(2),NumDivSweeps);
R24_v          = linspace(1,0.001,NumDivSweeps);
[phin_M,R24_M] = meshgrid(phin_v,R24_v);

% create grid points for R_4,8
R24_v = linspace(1,0.001,NumDivLines);

% plot figure
figure('Theme','light','Position',[80 189 1407 749]);
tiledlayout(3,5,'Padding','tight')
nexttile; PlotFig3Sweeps(phinLim,nClogSweep{1},phin_M,R24_M,0,1,[]);
nexttile; PlotFig3Sweeps(phinLim,nClogSweep{2},phin_M,R24_M,0,0,phinLines);
nexttile; PlotFig3LinesFQ(1,sol,R24_v,0,1,phm)
nexttile; PlotFig3LinesFQ(2,sol,R24_v,0,1,phm)
nexttile; PlotFig3LinesFQ(3,sol,R24_v,0,1,phm)
nexttile; PlotFig3Sweeps(phinLim,nClogSweep{3},phin_M,R24_M,1,1,[]);
nexttile; PlotFig3Sweeps(phinLim,nClogSweep{4},phin_M,R24_M,1,0,[]);
nexttile; PlotFig3LinesPhi(1,sol,R24_v,1,1,[0.45,0.55],[0.45,0.5,0.55])
nexttile; PlotFig3LinesPhi(2,sol,R24_v,1,1,[0.45,0.53],[0.45,0.49,0.53])
nexttile; PlotFig3LinesPhi(3,sol,R24_v,1,1,[0.26,0.52],[0.26,0.39,0.52])
nexttile([1,2]); axis off;
nexttile([1,2]); PlotFig3Resistance(sol,R24_v);

% save panel (b)
try
    print(gcf, ['images/',fld,'image_',fn,'.png'],'-dpng','-r300');
catch
    mkdir(['images/',fld]);
    print(gcf, ['images/',fld,'image_',fn,'.png'],'-dpng','-r300');
end

