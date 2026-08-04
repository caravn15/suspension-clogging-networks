%% RUNS SIMULATIONS FOR AND PLOTS FIG. S2 OF THE SUPPLEMENTARY MATERIAL
% USES THE SAME DATA AS FIG. 4 OF THE MAIN MANUSCRIPT - YOU ONLY NEED
% TO RUN ONE SET OF SIMULATIONS (THIS SCRIPT OR sc_main_fig_4.m)

clear all;
close all;
clc; addpath(genpath('./'));

%% parameters

% fluid parameters
Da            = 1e-3;                     % Darcy number
phm           = 0.85;                     % maximum packing fraction (must be <= 1)
phin_v        = [0.58,0.6,0.62];          % inlet particle volume fraction (must be < phim)
Qt            = 1;                        % total flow rate (scaled to 1 in non-dimensionalisation)
delP          = [NaN 0];                  % pressure drop (delP(1) = NaN as Qt prescribed)

% solution parameters
tol           = 1e-6;                     % tolerance for iterations (epsilon in manuscript)
maxit         = 50;                       % maximum number of iterations

% network information
Netfld        = 'motif-fig-S2/';          % folder where data is stored
NetType       = 'motif';                  % type of network: 'retinal-vasc' or 'motif'

% save options
fld           = 'supp-mat-results/';      % folder to save data/figures
fn            = 'fig_S2';                 % filename for data
SqueezeData   = 1;                        % =0 to save all data (solutions at all iterations + diagnostic information)
                                          % =1 to only save final solutions (results in smaller file sizes)

% other options
NumDiv        = 500;                      % number of grid points for R_4,8 in simulations/plots (should be divisible by 100. Set =500 for paper results)
OutputCW      = 0;                        % output full solver details in the command window (set =0 if not required)
PlotMotifs    = 1;                        % if =1, plots motifs with green/orange/red vessel states (set =0 if not required)
DataLoad      = {};
% DataLoad      = {'fig_S2_Da_0.001_phin_0.58_phm_0.85','fig_S2_Da_0.001_phin_0.6_phm_0.85','fig_S2_Da_0.001_phin_0.62_phm_0.85'};

% For DataLoad, set as empty {} to run solve + plot, or provide path to sim. data in fld to skip solve
% Data format: cell e.g. {'fig_S2_Da_0.001_phin_0.58_phm_0.85',...}
% Do NOT append _clogging/_initcond/_newtonian

%% check motif network data exists (generate if not)

try
    load(['data/net/',Netfld,'data_net_motif.mat'],'net');
catch
    GenerateMotifFig4(); % same motif as fig. 4
end

%% solve (if required)

if isempty(DataLoad)

    % solve required - same solve as fig. 4
    for ii=1:length(phin_v)
        [sol{ii},fnFull{ii}] = SolveFig4(NumDiv,Netfld,NetType,Da,phm,phin_v(ii),Qt,delP,tol,maxit,fld,fn,SqueezeData,OutputCW);
    end

else

    % simulation data provided - check format
    if length(DataLoad) ~= length(phin_v) || ~iscell(DataLoad)
        error(['Must provide path to ',num2str(length(phin_v)),' data files in cell format.']);
    else

        % load network data and get filename
        net    = LoadNetworkData(Netfld,NetType,[]);

        % load data
        for ii=1:length(phin_v)
            try
                [sol{ii},fnFull{ii}] = LoadFig4(DataLoad{ii},NumDiv,fld,fn);
            catch
                error(['Could not load data from: ',fld,DataLoad{ii}]);
            end
        end
    end
end

%% plot (and save) figures

% create grid points for R_4,8
R48_v = linspace(1,0.001,NumDiv);

% plot F
figure('Theme','light','Position',[24 393 1789 457]);
tiledlayout(2,7,'Padding','tight')
for ii=1:7
    nexttile
    hold on;
    plot(R48_v,sol{1}.FClog(ii,:),'LineWidth',2.5, 'Color',[0 0.4470 0.7410 1]);
    plot(R48_v,sol{1}.FMaxClog(ii,:),':','LineWidth',3.5, 'Color',[0 0.4470 0.7410 0.7]);
    plot(R48_v,sol{2}.FClog(ii,:),'LineWidth',2.5, 'Color',[0.9290 0.6940 0.1250 1]);
    plot(R48_v,sol{2}.FMaxClog(ii,:),':','LineWidth',3.5, 'Color',[0.9290 0.6940 0.1250 0.7]);
    plot(R48_v,sol{3}.FClog(ii,:),'LineWidth',2.5, 'Color',[0.8500 0.3250 0.0980 1]);
    plot(R48_v,sol{3}.FMaxClog(ii,:),':','LineWidth',3.5, 'Color',[0.8500 0.3250 0.0980 0.7]);
    xlim([0,1])
    set(gca,'XTick',[0,0.5,1])
    switch ii
        case 1
            ylim([0.52,0.62])
            set(gca,'YTick',[0.52,0.57,0.62])
        case 2
            ylim([0.15,0.35])
            set(gca,'YTick',[0.15,0.25,0.35])
        case 3
            ylim([0.2,0.5])
            set(gca,'YTick',[0.2,0.35,0.5])
        case 4
            ylim([0.1,0.3])
            set(gca,'YTick',[0.1,0.2,0.3])
        case 5
            ylim([0.03,0.07])
            set(gca,'YTick',[0.03,0.05,0.07])
        case 6
            ylim([0.1,0.5])
            set(gca,'YTick',[0.1,0.3,0.5])
        case 7
            ylim([0,0.3])
            set(gca,'YTick',[0,0.15,0.3])
    end
    set(gca,'FontSize',20);
    ax = gca;
    ax.LineWidth = 1.5;
    box on;
    axis square;
end

% plot Q
for ii=1:7
    nexttile
    hold on;
    plot(R48_v,abs(sol{1}.QClog(ii,:)),'LineWidth',2.5, 'Color',[0 0.4470 0.7410 1]);
    plot(R48_v,abs(sol{2}.QClog(ii,:)),'LineWidth',2.5, 'Color',[0.9290 0.6940 0.1250 1]);
    plot(R48_v,abs(sol{3}.QClog(ii,:)),'LineWidth',2.5, 'Color',[0.8500 0.3250 0.0980 1]);
    xlim([0,1])
    set(gca,'XTick',[0,0.5,1])
    switch ii
        case 1
            ylim([0,1.02])
            set(gca,'YTick',[0,0.5,1])
        case 2
            ylim([0.2,0.6])
            set(gca,'YTick',[0.2,0.4,0.6])
        case 3
            ylim([0.4,0.8])
            set(gca,'YTick',[0.4,0.6,0.8])
        case 4
            ylim([0.2,0.5])
            set(gca,'YTick',[0.2,0.35,0.5])
        case 5
            ylim([0.06,0.16])
            set(gca,'YTick',[0.06,0.11,0.16])
        case 6
            ylim([0.2,0.8])
            set(gca,'YTick',[0.2,0.5,0.8])
        case 7
            ylim([0,0.6])
            set(gca,'YTick',[0,0.3,0.6])
    end
    set(gca,'FontSize',20);
    ax = gca;
    ax.LineWidth = 1.5;
    box on;
    axis square;
end

% save
try
    print(gcf, ['images/',fld,'image_',erase(fnFull{1},['_phin_',num2str(phin_v(1))]),'.png'],'-dpng','-r300');
catch
    mkdir(['images/',fld]);
    print(gcf, ['images/',fld,'image_',erase(fnFull{1},['_phin_',num2str(phin_v(1))]),'.png'],'-dpng','-r300');
end
