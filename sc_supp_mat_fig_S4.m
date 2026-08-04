%% RUNS SIMULATIONS FOR AND PLOTS FIG. S4 OF THE SUPPLEMENTARY MATERIAL
% USES THE SAME DATA AS FIG. S7 OF THE SUPPLEMENTARY MATERIAL - 
% YOU ONLY NEED TO RUN ONE SET OF SIMULATIONS (THIS SCRIPT OR 
% sc_supp_mat_fig_S7.m)

clear all;
close all;
clc; addpath(genpath('./'));

%% parameters

% fluid parameters
Da            = 1e-3;                     % Darcy number
phm           = 0.65;                     % maximum packing fraction (must be <= 1)
phin_v        = [0.43,0.44,0.45];         % inlet particle volume fraction (must be < phim)
Qt            = 1;                        % total flow rate (scaled to 1 in non-dimensionalisation)
delP          = [NaN 0];                  % pressure drop (delP(1) = NaN as Qt prescribed)

% solution parameters
tol           = 1e-6;                     % tolerance for iterations (epsilon in manuscript)
maxit         = 50;                       % maximum number of iterations

% network information
Netfld        = 'motif-fig-S4/';          % folder where data is stored
NetType       = 'motif';                  % type of network: 'retinal-vasc' or 'motif'

% save options
fld           = 'supp-mat-results/';      % folder to save data/figures
fn            = 'fig_S4';                 % filename for data
SqueezeData   = 1;                        % =0 to save all data (solutions at all iterations + diagnostic information)
                                          % =1 to only save final solutions (results in smaller file sizes)

% other options
NumDiv        = 500;                      % number of grid points for R_4,8 in simulations/plots (should be divisible by 100. Set =500 for paper results)
OutputCW      = 0;                        % output full solver details in the command window (set =0 if not required)
PlotMotifs    = 1;                        % if =1, plots motifs with green/orange/red vessel states (set =0 if not required)
DataLoad      = {};
% DataLoad      = {'fig_S4_Da_0.001_phin_0.43_phm_0.65','fig_S4_Da_0.001_phin_0.44_phm_0.65','fig_S4_Da_0.001_phin_0.45_phm_0.65'};

% For DataLoad, set as empty {} to run solve + plot, or provide path to sim. data in fld to skip solve
% Data format: cell e.g. {'fig_S4_Da_0.001_phin_0.43_phm_0.65',...}
% Do NOT append _clogging/_initcond/_newtonian

%% check motif network data exists (generate if not)

try
    load(['data/net/',Netfld,'data_net_motif.mat'],'net');
catch
    GenerateMotifFigS4();
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

% vector of indices to plot motifs + markers
IndMotif     = [5,30,39,52,93]*NumDiv/100;
MotifScatter = {'ko','k^','diamond','square','pentagram'};

% panel (b)
figure('Theme','light','Position',[626 500 566 338]);
hold on;
plot(R48_v,sol{1}.PinClog./abs(sol{1}.QClog(1,:)),'-','Color',[0 0.4470 0.7410 1],'LineWidth',2.5);
plot(R48_v,sol{2}.PinClog./abs(sol{2}.QClog(1,:)),'-','Color',[0.9290 0.6940 0.1250 1],'LineWidth',2.5);
plot(R48_v,sol{3}.PinClog./abs(sol{3}.QClog(1,:)),'-','Color',[0.8500 0.3250 0.0980 1],'LineWidth',2.5);
plot(R48_v,sol{1}.PinNewt./abs(sol{1}.QNewt(1,:)),'--','Color',[0 0.4470 0.7410 1],'LineWidth',3);
plot(R48_v,sol{2}.PinNewt./abs(sol{2}.QNewt(1,:)),'--','Color',[0.9290 0.6940 0.1250 1],'LineWidth',3);
plot(R48_v,sol{3}.PinNewt./abs(sol{3}.QNewt(1,:)),'--','Color',[0.8500 0.3250 0.0980 1],'LineWidth',3);
for ii=1:length(MotifScatter)
    scatter(R48_v(IndMotif(ii)),sol{2}.PinClog(IndMotif(ii))./abs(sol{2}.QClog(1,IndMotif(ii))),...
        MotifScatter{ii},'SizeData',80,'LineWidth',1.5,'MarkerFaceColor',[185 136 17]./255,...
        'MarkerEdgeColor',[185 136 17]./255);
end
xlabel('$R_{4,8}$','Interpreter','latex')
ylabel('Network resistance','Interpreter','latex');
xlim([0,1])
ylim([20,170])
set(gca,'YTick',[20,70,120,170])
set(gca,'XTick',[0,0.2,0.4,0.6,0.8,1])
set(gca,'FontSize',20);
ax           = gca;
ax.LineWidth = 1.5;
box on;

% save panel (b)
try
    print(gcf, ['images/',fld,'image_',erase(fnFull{1},['_phin_',num2str(phin_v(1))]),'_b.png'],'-dpng','-r300');
catch
    mkdir(['images/',fld]);
    print(gcf, ['images/',fld,'image_',erase(fnFull{1},['_phin_',num2str(phin_v(1))]),'_b.png'],'-dpng','-r300');
end

% panel (c) - F/Q plots
figure('Theme','light','Position',[882 22 1059 314]);
subaxis(1,3,1,'Spacing',0.06);
hold on;
plot(R48_v,sol{1}.FClog(4,:)./abs(sol{1}.QClog(4,:)),'-','Color',[0 0.4470 0.7410 1],'LineWidth',2.5);
plot(R48_v,sol{2}.FClog(4,:)./abs(sol{2}.QClog(4,:)),'-','Color',[0.9290 0.6940 0.1250 1],'LineWidth',2.5);
plot(R48_v,sol{3}.FClog(4,:)./abs(sol{3}.QClog(4,:)),'-','Color',[0.8500 0.3250 0.0980 1],'LineWidth',2.5);
plot(R48_v,sol{3}.FMaxClog(4,:)./abs(sol{3}.QClog(4,:)), ':', 'Color', [0 0 0 1],'LineWidth', 3.5);
xlabel('$R_{4,8}$','Interpreter','latex')
% ylabel('$F_{3,5}/Q_{3,5}$','Interpreter','latex');
ylim([0.4,0.44])
set(gca,'YTick',[0.4,0.42,0.44])
set(gca,'YTick',[0.55,0.57,0.59])
set(gca,'XTick',[0,0.5,1])
set(gca,'FontSize',20);
ax           = gca;
ax.LineWidth = 1.5;
box on;
axis square;

subaxis(1,3,2,'Spacing',0.06);
hold on;
plot(R48_v,sol{1}.FClog(6,:)./abs(sol{1}.QClog(6,:)),'-','Color',[0 0.4470 0.7410 1],'LineWidth',2.5);
plot(R48_v,sol{2}.FClog(6,:)./abs(sol{2}.QClog(6,:)),'-','Color',[0.9290 0.6940 0.1250 1],'LineWidth',2.5);
plot(R48_v,sol{3}.FClog(6,:)./abs(sol{3}.QClog(6,:)),'-','Color',[0.8500 0.3250 0.0980 1],'LineWidth',2.5);
plot(R48_v,sol{3}.FMaxClog(6,:)./abs(sol{3}.QClog(6,:)), ':', 'Color', [0 0 0 1],'LineWidth', 3.5);
xlabel('$R_{4,8}$','Interpreter','latex')
% ylabel('$F_{4,7}/Q_{4,7}$','Interpreter','latex');
xlim([0,1])
ylim([0.4,0.44])
set(gca,'YTick',[0.4,0.42,0.44])
set(gca,'XTick',[0,0.5,1])
set(gca,'FontSize',20);
ax           = gca;
ax.LineWidth = 1.5;
box on;
axis square;

subaxis(1,3,3,'Spacing',0.06);
hold on;
plot(R48_v,sol{1}.FClog(7,:)./abs(sol{1}.QClog(7,:)),'-','Color',[0 0.4470 0.7410 1],'LineWidth',2.5);
plot(R48_v,sol{2}.FClog(7,:)./abs(sol{2}.QClog(7,:)),'-','Color',[0.9290 0.6940 0.1250 1],'LineWidth',2.5);
plot(R48_v,sol{3}.FClog(7,:)./abs(sol{3}.QClog(7,:)),'-','Color',[0.8500 0.3250 0.0980 1],'LineWidth',2.5);
plot(R48_v,sol{3}.FMaxClog(7,:)./abs(sol{3}.QClog(7,:)), ':', 'Color', [0 0 0 1],'LineWidth', 3.5);
xlabel('$R_{4,8}$','Interpreter','latex')
% ylabel('$F_{4,8}/Q_{4,8}$','Interpreter','latex');
xlim([0,1])
ylim([0.2,0.46])
set(gca,'YTick',[0.2,0.33,0.46])
set(gca,'XTick',[0,0.5,1])
set(gca,'FontSize',20);
ax           = gca;
ax.LineWidth = 1.5;
box on;
axis square;

% save panel (c) - F/Q plots
try
    print(gcf, ['images/',fld,'image_',erase(fnFull{1},['_phin_',num2str(phin_v(1))]),'_c_FQ.png'],'-dpng','-r300');
catch
    mkdir(['images/',fld]);
    print(gcf, ['images/',fld,'image_',erase(fnFull{1},['_phin_',num2str(phin_v(1))]),'_c_FQ.png'],'-dpng','-r300');
end

% panel (c) - Q plot
figure('Theme','light','Position',[882 22 1059 314]);
subaxis(1,3,1,'Spacing',0.06);
hold on;
plot(R48_v,abs(sol{1}.QClog(2,:)),'-','Color',[0 0.4470 0.7410 1],'LineWidth',2.5);
plot(R48_v,abs(sol{2}.QClog(2,:)),'-','Color',[0.9290 0.6940 0.1250 1],'LineWidth',2.5);
plot(R48_v,abs(sol{3}.QClog(2,:)),'-','Color',[0.8500 0.3250 0.0980 1],'LineWidth',2.5);
scatter(R48_v(IndMotif(1)),abs(sol{2}.QClog(2,IndMotif(1))),'ko','SizeData',80,...
    'LineWidth',1.5,'MarkerFaceColor',[185 136 17]./255,'MarkerEdgeColor',[185 136 17]./255);
scatter(R48_v(IndMotif(2)),abs(sol{2}.QClog(2,IndMotif(2))),'k^','SizeData',80,...
    'LineWidth',1.5,'MarkerFaceColor',[185 136 17]./255,'MarkerEdgeColor',[185 136 17]./255);
scatter(R48_v(IndMotif(3)),abs(sol{2}.QClog(2,IndMotif(3))),'diamond','SizeData',80,...
    'LineWidth',1.5,'MarkerFaceColor',[185 136 17]./255,'MarkerEdgeColor',[185 136 17]./255);
scatter(R48_v(IndMotif(4)),abs(sol{2}.QClog(2,IndMotif(4))),'square','SizeData',80,...
    'LineWidth',1.5,'MarkerFaceColor',[185 136 17]./255,'MarkerEdgeColor',[185 136 17]./255);
scatter(R48_v(IndMotif(5)),abs(sol{2}.QClog(2,IndMotif(5))),'pentagram','SizeData',80,...
    'LineWidth',1.5,'MarkerFaceColor',[185 136 17]./255,'MarkerEdgeColor',[185 136 17]./255);
xlabel('$R_{4,8}$','Interpreter','latex')
% ylabel('$Q_{2,3}$','Interpreter','latex');
xlim([0,1])
ylim([0.1,0.7])
set(gca,'YTick',[0.1,0.4,0.7])
set(gca,'XTick',[0,0.5,1])
set(gca,'FontSize',20);
ax           = gca;
ax.LineWidth = 1.5;
box on;
axis square;

% save panel (c) - Q plot
try
    print(gcf, ['images/',fld,'image_',erase(fnFull{1},['_phin_',num2str(phin_v(1))]),'_c_Q.png'],'-dpng','-r300');
catch
    mkdir(['images/',fld]);
    print(gcf, ['images/',fld,'image_',erase(fnFull{1},['_phin_',num2str(phin_v(1))]),'_c-Q.png'],'-dpng','-r300');
end

%% runs solves and plots motif states if requested (should be very quick)

if PlotMotifs == 1

    % run simulations and plot
    fnOg         = fn;
    R48Motif_v   = fliplr(R48_v(IndMotif));

    figure('Theme','light','Position',[1 1 847 237]);
    for ii=1:length(R48Motif_v)

        % constriction to change R_4,8
        consInds      = 7;
        consMultipler = R48Motif_v(ii);

        % filename
        fn = [fnOg,'_motifs_R48_',num2str(consMultipler)];

        % run solve
        [net,SolClog,~,~,~] = SolveFullNetworkClogging(Netfld,NetType,[],Da,phm,phin_v(2),...
            Qt,delP,consInds,consMultipler,tol,maxit,fld,fn,SqueezeData,0);

        % plot
        subplot(1,5,ii);
        PlotMotifStates(net,SolClog)
        scatter(0,1,MotifScatter{end-ii+1},'SizeData',80,'LineWidth',1.5,'MarkerFaceColor',...
            [185 136 17]./255,'MarkerEdgeColor',[185 136 17]./255);
    end

    % save figure
    try
        print(gcf, ['images/',fld,'image_',erase(fnFull{1},['_phin_',num2str(phin_v(1))]),'_motifs.png'],'-dpng','-r300');
    catch
        mkdir(['images/',fld]);
        print(gcf, ['images/',fld,'image_',erase(fnFull{1},['_phin_',num2str(phin_v(1))]),'_motifs.png'],'-dpng','-r300');
    end


end