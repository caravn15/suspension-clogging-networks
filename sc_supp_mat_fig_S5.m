%% RUNS SIMULATIONS FOR AND PLOTS FIG. S5 OF THE SUPPLEMENTARY MATERIAL

clear all;
close all;
clc; addpath(genpath('./'));

%% parameters

% fluid parameters
Da            = 1e-3;                     % Darcy number
phm           = 0.65;                     % maximum packing fraction (must be <= 1)
phin          = 0.44;                     % inlet particle volume fraction (must be < phim)
Qt            = 1;                        % total flow rate (scaled to 1 in non-dimensionalisation)
delP          = [NaN 0];                  % pressure drop (delP(1) = NaN as Qt prescribed)

% solution parameters
tol           = 1e-6;                     % tolerance for iterations (epsilon in manuscript)
maxit         = 50;                       % maximum number of iterations

% network information
Netfld        = 'motif-fig-S5/';          % folder where data is stored
NetType       = 'motif';                  % type of network: 'retinal-vasc' or 'motif'

% save options
fld           = 'supp-mat-results/';      % folder to save data/figures
fn            = 'fig_S5';                 % filename for data
SqueezeData   = 1;                        % =0 to save all data (solutions at all iterations + diagnostic information)
% =1 to only save final solutions (results in smaller file sizes)

% other options
NumDiv        = 100;                      % number of R grid points for R_4,8 and R_9,10 in simulations/plot (=100 for paper results)
OutputCW      = 0;                        % output full solver details in the command window (set =0 if not required)
PlotMotifs    = 1;                        % if =1, plots motifs with green/orange/red vessel states (set =0 if not required)
DataLoad      = {};
% DataLoad      = {'fig_S5_Da_0.001_phin_0.44_phm_0.65'};

% For DataLoad, set as empty {} to run solve + plot, or provide path to sim. data in fld to skip solve
% Data format: cell e.g. {'fig_S5_Da_0.001_phin_0.44_phm_0.65'}
% Do NOT append _clogging/_initcond/_newtonian

%% check motif network data exists (generate if not)

try
    load(['data/net/',Netfld,'data_net_motif.mat'],'net');
catch
    GenerateMotifFigS5WithBypass();
end

%% solve (if required)

if isempty(DataLoad)

    % solve required
    [sol,fnFull] = SolveFig5(NumDiv,Netfld,NetType,Da,phm,phin,Qt,delP,tol,maxit,fld,fn,SqueezeData,OutputCW);

else

    % load network data and get filename
    net    = LoadNetworkData(Netfld,NetType,[]);
    fnFull = DataLoad{1};

    % load simulation data
    try
        sol = LoadFig5(DataLoad{1},NumDiv,fld,fn);
    catch
        error(['Could not load data from: ',fld,DataLoad{1}]);
    end
end

%% plot (and save) figures

% create meshgrid for R_4,8 and R_9,10
RDiv           = linspace(1,0.001,NumDiv);
[R48_M,R910_M] = meshgrid(RDiv,RDiv);
R48_v          = R48_M(:);
R910_v         = R910_M(:);

% sort solution to plot
SolNumConst    = reshape(sol.nMax(:)+sol.nClog(:),[NumDiv,NumDiv]);

% baseline case (technically when R_9,10=0.001 but this is exactly the same
% value as if R_9,10=0 without having to run extra simulations for the no-bypass case)
SolNumNoBypass = SolNumConst(end,:); 

% change in number of constrained vessels
SolChange      = SolNumConst-SolNumNoBypass;

% create colormap
rgb = [5 48 97; 126 148 172; 230 230 230; 230 200 200; 213 153 153; 196 106 106; 179 70 70; 141 35 35; 103 0 31] / 255;

% plot figure
figure('Theme','light','Position',[368 252 987 669]);
pcolor(R48_M,R910_M,SolChange,'EdgeColor','none')
cb = colorbar;
cb.Label.String = 'Change in # of constrained vessels';
cb.Location = 'southoutside';
set(gca,'FontSize',20)
xlabel('$R_{4,8}$','Interpreter','latex')
ylabel('$R_{9,10}$','Interpreter','latex')
colormap(parula(9))
colormap(rgb)
axis square;
box on;

% save figure
try
    print(gcf, ['images/',fld,'image_',fnFull,'.png'],'-dpng','-r300');
catch
    mkdir(['images/',fld]);
    print(gcf, ['images/',fld,'image_',fnFull,'.png'],'-dpng','-r300');
end

%% runs solves and plots motif states if requested (should be very quick)

if PlotMotifs == 1

    % run simulations with bypass vessel
    R48_v  = [0.1,0.6,0.1,0.6];
    R910_v = [0.8,0.8,0.48,0.48];

    figure('Theme','light','Position',[1 1 847 584]);
    for ii=1:length(R48_v)

        % constriction to change R_4,8
        consInds      = 9;
        consMultipler = R48_v(ii);

        % change radius R_9,10
        Rc     = NaN*ones(10,1);
        Rc(10) = R910_v(ii);

        % run solve
        [net,SolClog,~,~,~] = SolveFullNetworkClogging(Netfld,NetType,[],Da,phm,phin,...
            Qt,delP,consInds,consMultipler,tol,maxit,fld,fn,SqueezeData,0,Rc);

        % plot
        subplot(3,2,ii);
        if ii==1
            title({'Added vessel','decreases clogging'})
        elseif ii==2
            title({'Added vessel','increases clogging'})
        end
        PlotMotifStates(net,SolClog)
    end

    % load network data without bypass vessel
    NetfldBypass = [erase(Netfld,'/'),'-no-bypass/'];
    try
        load(['data/net/',NetfldBypass,'data_net_motif.mat'],'net');
    catch
        GenerateMotifFigS5NoBypass();
    end

    % run simulations without bypass vessel
    R48_v  = [0.1,0.6];

    for ii=1:length(R48_v)

        % constriction to change R_4,8
        consInds      = 9;
        consMultipler = R48_v(ii);

        % run solve
        [net,SolClog,~,~,~] = SolveFullNetworkClogging(NetfldBypass,NetType,[],Da,phm,phin,...
            Qt,delP,consInds,consMultipler,tol,maxit,fld,fn,SqueezeData,0);

        % plot
        subplot(3,2,4+ii);
        PlotMotifStates(net,SolClog)
    end

    % save figure
    try
        print(gcf, ['images/',fld,'image_',fnFull,'_motifs.png'],'-dpng','-r300');
    catch
        mkdir(['images/',fld]);
        print(gcf, ['images/',fld,'image_',fnFull,'_motifs.png'],'-dpng','-r300');
    end

end

