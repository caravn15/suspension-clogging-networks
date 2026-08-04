function  [sol,fnFull] = SolveFig4(NumDiv,Netfld,NetType,Da,phm,phin,Qt,delP,tol,maxit,fld,fn,SqueezeData,OutputCW)

% keep original filename
fnOg = fn;

% create grid points for R_4,8
R48_v = linspace(1,0.001,NumDiv);

% print starting message in command window
if OutputCW == 0
    CmdWinSize = get(0, 'CommandWindowSize');
    Width     = CmdWinSize(1);

    fprintf(repmat('-',[1,Width])); fprintf('\n');

    Msg = 'Suspension clogging solver (c) Neal et al. 2026';
    fprintf(blanks(floor((Width - length(Msg))/2)));
    fprintf('%s\n', Msg);

    fprintf(repmat('-',[1,Width])); fprintf('\n\n');
end

% run across all R_4,8
for ii=1:length(R48_v)

    % filename for this simulation
    fn = [fnOg,'_sim_',num2str(ii)];

    % constriction to change R_4,8
    consInds      = 7;
    consMultipler = R48_v(ii);

    % run simulation
    [~,SolClog,SolNewt,~,fnSim] = SolveFullNetworkClogging(Netfld,NetType,[],Da,phm,phin,...
        Qt,delP,consInds,consMultipler,tol,maxit,fld,fn,SqueezeData,OutputCW);

    if ii == 1
        % get filename
        fnFull = erase(fnSim,'_sim_1');
    end

    % sort data to plot
    sol.QClog(:,ii)    = SolClog.Q;
    sol.QNewt(:,ii)    = SolNewt.Q;
    sol.FClog(:,ii)    = SolClog.F;
    sol.FMaxClog(:,ii) = SolClog.FMax;
    sol.PinClog(:,ii)  = SolClog.Pin;
    sol.PinNewt(:,ii)  = SolNewt.Pin;

    % print short command window update every 50 simulations
    if OutputCW == 0
        if mod(ii,50) == 0
            Msg = ['Simulation ',num2str(ii),' out of ',num2str(NumDiv),' complete for phin = ',num2str(phin)];
            fprintf(blanks(floor((Width - length(Msg))/2)));
            fprintf('%s\n', Msg);
        end
    end

end

if OutputCW == 0
    fprintf('\n');
end

%% same data for fig. 4 and fig. S2 - copy for ease of access

if strcmp(fnOg,'fig_4')

    sourceDir = 'data/sims/manuscript-results';
    destDir   = 'data/sims/supp-mat-results';

    oldPrefix = 'fig_4_sim_';
    newPrefix = 'fig_S2_sim_';

elseif strcmp(fnOg,'fig_S2')

    sourceDir = 'data/sims/supp-mat-results';
    destDir   = 'data/sims/manuscript-results';

    oldPrefix = 'fig_S2_sim_';
    newPrefix = 'fig_4_sim_';

elseif strcmp(fnOg,'fig_S4')

    sourceDir = 'data/sims/supp-mat-results';
    destDir   = 'data/sims/supp-mat-results';

    oldPrefix = 'fig_S4_sim_';
    newPrefix = 'fig_S7_sim_';

elseif strcmp(fnOg,'fig_S7')

    sourceDir = 'data/sims/supp-mat-results';
    destDir   = 'data/sims/supp-mat-results';

    oldPrefix = 'fig_S7_sim_';
    newPrefix = 'fig_S4_sim_';

else
    error('Unknown value of fn: %s', fnOg);
end

% create destination folder if it doesn't exist
if ~exist(destDir, 'dir')
    mkdir(destDir);
end

% find relevant files
files = dir(fullfile(sourceDir, [oldPrefix '*']));
files = files(~[files.isdir]);

% copy and rename
for k = 1:numel(files)
    oldName = files(k).name;
    newName = strrep(oldName, oldPrefix, newPrefix);

    copyfile(fullfile(sourceDir, oldName), ...
        fullfile(destDir, newName));
end

end