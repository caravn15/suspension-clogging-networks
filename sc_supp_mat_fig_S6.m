%% RUNS SIMULATIONS FOR AND PLOTS FIG. S6 OF THE SUPPLEMENTARY MATERIAL

clear all;
close all;
clc; addpath(genpath('./'));

%% parameters

% fluid parameters
Da            = 1e-5;                     % Darcy number
phm_v         = [0.65,1];                 % maximum packing fraction vector (values must be <= 1)
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
fld           = 'supp-mat-results/';      % folder to save data/figures
fn            = 'fig_S6';                 % filename for data
SqueezeData   = 1;                        % =0 to save all data (solutions at all iterations + diagnostic information)
                                          % =1 to only save final solutions (results in smaller file sizes)

% other options
OutputCW      = 1;                        % output full solver details in the command window (set =0 if not wanted)
DataLoad      = {};         
% DataLoad      = {'fig_S6_Da_1e-05_phin_0.36_phm_0.65','fig_S6_Da_1e-05_phin_0.36_phm_1'};

% For DataLoad, set as empty {} to run solve + plot, or provide path to sim. data in fld to skip solve
% Data format: cell e.g. {'fig_S6_Da_1e-05_phin_0.36_phm_0.65','fig_S6_Da_1e-05_phin_0.36_phm_1'}
% Do NOT append _clogging/_initcond/_newtonian

%% solve for each phm (if required)

if isempty(DataLoad)

    % solve required
    for ii=1:length(phm_v)
        [net,SolClog_v{ii},SolNewt_v{ii},InitCond_v{ii},fnFull_v{ii}] = SolveFullNetworkClogging(Netfld,NetType,RetSec,...
            Da,phm_v(ii),phin,Qt,delP,consInds,consMultipler,tol,maxit,fld,fn,SqueezeData,OutputCW);
    end
else

    % simulation data provided - check format
    if length(DataLoad) ~= length(phm_v) || ~iscell(DataLoad)
        error(['Must provide path to ',num2str(length(phm_v)),' data files in cell format.']);
    else

        % load data
        for ii=1:length(phm_v)

            % load network data and get filename
            net          = LoadNetworkData(Netfld,NetType,RetSec);
            fnFull_v{ii} = DataLoad{ii};

            % load simulation data
            try
                load([fld,DataLoad{ii},'_newtonian.mat'],'SolNewt');
                load([fld,DataLoad{ii},'_initcond.mat'],'InitCond');
                load([fld,DataLoad{ii},'_clogging.mat'],'SolClog'); 

                SolNewt_v{ii}  = SolNewt;
                InitCond_v{ii} = InitCond;
                SolClog_v{ii}  = SolClog;
            catch
                error(['Could not load data from: ',fld,DataLoad{ii}]);
            end
        end
    end
end

%% plot (and save) figures for each phm

for ii=1:length(phm_v)

    % plot suspension F figure
    figure('Theme','light','Position',[1219, 198, 523, 491]);
    PlotSolutionDotsEdges(net,'arteries',SolClog_v{ii}.F,[1e-8,1e-0],[1e-8,1e-6,1e-4,1e-2,1e-0],1,'Solid flux $F$',consInds,1);

    % save suspension F figure
    try
        print(gcf, ['images/',fld,'image_',fnFull_v{ii},'_clogged.png'],'-dpng','-r300');
    catch
        mkdir(['images/',fld]);
        print(gcf, ['images/',fld,'image_',fnFull_v{ii},'_clogged.png'],'-dpng','-r300');
    end

    % plot newtonian F figure
    figure('Theme','light','Position',[1219, 198, 523, 491]);
    PlotSolutionDotsEdges(net,'arteries',SolNewt_v{ii}.F,[1e-8,1e-0],[1e-8,1e-6,1e-4,1e-2,1e-0],1,'Solid flux $F$',consInds,1);

    % save newtonian F figure
    try
        print(gcf, ['images/',fld,'image_',fnFull_v{ii},'_newtonian.png'],'-dpng','-r300');
    catch
        mkdir(['images/',fld]);
        print(gcf, ['images/',fld,'image_',fnFull_v{ii},'_newtonian.png'],'-dpng','-r300');
    end

    % plot phi figure
    figure('Theme','light','Position',[1219, 198, 523, 491]);
    PlotSolutionDotsEdges(net,'arteries',SolClog_v{ii}.ph,[0,phm_v(ii)],[0,round(phm_v(ii)/4,2),round(2*phm_v(ii)/4,2),...
        round(3*phm_v(ii)/4,2),phm_v(ii)],0,'Particle volume fraction $\overline{\phi}$',consInds,1);

    % save phi figure
    try
        print(gcf, ['images/',fld,'image_',fnFull_v{ii},'_phi.png'],'-dpng','-r300');
    catch
        mkdir(['images/',fld]);
        print(gcf, ['images/',fld,'image_',fnFull_v{ii},'_phi.png'],'-dpng','-r300');
    end

end

