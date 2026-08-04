%% RUNS SIMULATIONS FOR AND PLOTS FIG. 6 OF THE MAIN MANUSCRIPT

clear all;
close all;
clc; addpath(genpath('./'));

%% parameters

% fluid parameters
Da            = 1e-5;                     % Darcy number
phm           = 0.85;                     % maximum packing fraction (must be <= 1)
phin          = 0.36;                     % inlet particle volume fraction (must be < phim)
Qt            = 1;                        % total flow rate (scaled to 1 in non-dimensionalisation)
delP          = [NaN 0];                  % pressure drop (delP(1) = NaN as Qt prescribed)

% constriction options
consInds      = LoadConsIndsFig6();       % indices of vessels to reduce R
consMultipler = 1e-2;                     % multiplier for R in clogged vessels (must be <= 1)

% solution parameters
tol           = 1e-6;                     % tolerance for iterations (epsilon in manuscript)
maxit         = 50;                       % maximum number of iterations

% network information
Netfld        = 'Brown-et-al-retina/';    % folder where data is stored
NetType       = 'retinal-vasc';           % type of network: 'retinal-vasc' or 'motif'
RetSec        = 'arteries';               % section of eye network to load in 'retinal-vasc'

% save options
fld           = 'manuscript-results/';    % folder to save data/figures
fn            = 'fig_6';                  % filename for data
SqueezeData   = 1;                        % =0 to save all data (solutions at all iterations + diagnostic information)
                                          % =1 to only save final solutions (results in smaller file sizes)

% other options
OutputCW      = 1;                        % output full solver details in the command window (set =0 if not wanted)
DataLoad      = {};       
% DataLoad      = {'fig_6_Da_1e-05_phin_0.36_phm_0.85'};

% For DataLoad, set as empty {} to run solve + plot, or provide path to sim. data in fld to skip solve
% Data format: cell e.g. {'fig_6_Da_1e-05_phin_0.36_phm_0.85'}
% Do NOT append _clogging/_initcond/_newtonian

%% solve (if required)

if isempty(DataLoad)

    % solve required
    [net,SolClog,SolNewt,InitCond,fnFull] = SolveFullNetworkClogging(Netfld,NetType,RetSec,...
        Da,phm,phin,Qt,delP,consInds,consMultipler,tol,maxit,fld,fn,SqueezeData,OutputCW);
else

    % load network data and get filename
    net    = LoadNetworkData(Netfld,NetType,RetSec);
    fnFull = DataLoad{1};

    % load simulation data
    try
        load([fld,DataLoad{1},'_newtonian.mat'],'SolNewt');
        load([fld,DataLoad{1},'_initcond.mat'],'InitCond');
        load([fld,DataLoad{1},'_clogging.mat'],'SolClog');
    catch
        error(['Could not load data from: ',fld,DataLoad{1}]);
    end
end

%% plot (and save) figures

% plot suspension F figure
figure('Theme','light','Position',[1219, 198, 523, 491]);
PlotSolutionDotsEdges(net,'arteries',SolClog.F,[1e-8,1e-0],[1e-8,1e-6,1e-4,1e-2,1e-0],1,'Solid flux $F$',consInds,1);

% save suspension F figure
try
    print(gcf, ['images/',fld,'image_',fnFull,'_clogged.png'],'-dpng','-r300');
catch
    mkdir(['images/',fld]);
    print(gcf, ['images/',fld,'image_',fnFull,'_clogged.png'],'-dpng','-r300');
end

% plot newtonian F figure
figure('Theme','light','Position',[1219, 198, 523, 491]);
PlotSolutionDotsEdges(net,'arteries',SolNewt.F,[1e-8,1e-0],[1e-8,1e-6,1e-4,1e-2,1e-0],1,'Solid flux $F$',consInds,1);

% save newtonian F figure
try
    print(gcf, ['images/',fld,'image_',fnFull,'_newtonian.png'],'-dpng','-r300');
catch
    mkdir(['images/',fld]);
    print(gcf, ['images/',fld,'image_',fnFull,'_newtonian.png'],'-dpng','-r300');
end

% plot phi figure
figure('Theme','light','Position',[1219, 198, 523, 491]);
PlotSolutionDotsEdges(net,'arteries',SolClog.ph,[0,phm],[0,round(phm/4,2),round(2*phm/4,2),...
    round(3*phm/4,2),phm],0,'Particle volume fraction $\overline{\phi}$',consInds,1);

% save phi figure
try
    print(gcf, ['images/',fld,'image_',fnFull,'_phi.png'],'-dpng','-r300');
catch
    mkdir(['images/',fld]);
    print(gcf, ['images/',fld,'image_',fnFull,'_phi.png'],'-dpng','-r300');
end


