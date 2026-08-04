function  [net,SolClog,SolNewt,InitCond,fn] = SolveFullNetworkClogging(Netfld,NetType,RetSec,Da,phm,phin,Qt,delP,...
    consInds,consMultipler,tol,maxit,fld,fn,SqueezeData,OutputCW,varargin)


%% setup

% sort model parameters
prms.Da            = Da;      % Darcy number
prms.Pin           = delP(1); % pressure at inlet
prms.Pout          = delP(2); % pressure at outlet(s)
prms.Q01           = Qt;      % total flow rate/flow rate in inlet vessel
prms.phin          = phin;    % inlet particle volume fraction
prms.phm           = phm;     % maximum packing fraction

% sort clog parameters
cons.clogInds      = consInds;
cons.clogMultipler = consMultipler;

% load network data
net = LoadNetworkData(Netfld,NetType,RetSec);

% alter network radii (if required)
if ~isempty(varargin)
    net.R(~isnan(varargin{1})) = varargin{1}(~isnan(varargin{1})).*net.R(~isnan(varargin{1}));
end

% pre-solve checks
InitialChecksAlgorithm(net,prms)

% filename
fn = [fn,'_Da_',num2str(Da),'_phin_',num2str(phin),'_phm_',num2str(phm)];

%% run solvers (Newtonian, initial condition, clogging)

% print initial command window messages
if OutputCW == 1
    PrintSolveStart(net,prms,tol,maxit);
end

% newtonian solve
SolNewt  = SolveNewtonianProblem(net,prms,cons,OutputCW);
try
    save(['data/sims/',fld,fn,'_newtonian.mat'],'SolNewt','prms','cons');
catch
    mkdir(['data/sims/',fld]);
    save(['data/sims/',fld,fn,'_newtonian.mat'],'SolNewt','prms','cons');
end

% initial condition solve (i.e. pre-solve without constriction)
InitCond = SolveInitialCondition(net,prms,tol,maxit,OutputCW);
if SqueezeData == 1
    InitCond = SqueezeDataForSave(InitCond);
end
try
    save(['data/sims/',fld,fn,'_initcond.mat'],'InitCond','prms','tol','maxit');
catch
    mkdir(['data/sims/',fld]);
    save(['data/sims/',fld,fn,'_initcond.mat'],'InitCond','prms','tol','maxit');
end

% clogging solve
SolClog    = SolveCloggingProblem(InitCond,net,prms,cons,tol,maxit,OutputCW);
if SqueezeData == 1
    SolClog = SqueezeDataForSave(SolClog);
end
try
    save(['data/sims/',fld,fn,'_clogging.mat'],'SolClog','prms','cons','tol','maxit');
catch
    mkdir(['data/sims/',fld]);
    save(['data/sims/',fld,fn,'_clogging.mat'],'SolClog','prms','cons','tol','maxit');
end

end