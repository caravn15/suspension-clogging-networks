function   [sol,nClogSweep] = SolveFig3(NumDivLines,NumDivSweeps,Netfld,NetType,Da_v,phm,phinLines_v,Qt,delP,phinLim,tol,maxit,fld,fn,SqueezeData,OutputCW)

% keep original filename
fnOg = fn;

%% phin/R_2,4 parameter sweeps

% create grid points for R_2,4 and phin
phin_v         = linspace(phinLim(1),phinLim(2),NumDivSweeps);
R24_v          = linspace(1,0.001,NumDivSweeps);
[phin_M,R24_M] = meshgrid(phin_v,R24_v);
phin_V         = phin_M(:);
R24_V          = R24_M(:);

for ii=1:length(Da_v)

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


    for jj=1:length(phin_V)

        % parameters
        Da    = Da_v(ii);
        phin  = phin_V(jj);

        % constriction to change R_2,4
        consInds      = 3;
        consMultipler = R24_V(jj);

        % filename for this simulation
        fn = [fnOg,'_consMultipler_',num2str(jj)];

        try
            [~,SolClog,~,~,~] = SolveFullNetworkClogging(Netfld,NetType,[],Da,phm,phin,...
                Qt,delP,consInds,consMultipler,tol,maxit,fld,fn,SqueezeData,OutputCW);
            nClogSweep{ii}(jj) = sum(SolClog.iClog)+sum(SolClog.iMax);
        catch
            nClogSweep{ii}(jj) = 3;
        end

        % print short command window update every 50 simulations
        if OutputCW == 0
            if mod(jj,50) == 0
                Msg = ['Simulation ',num2str(jj),' out of ',num2str(NumDivSweeps^2),' complete for Da = ',num2str(Da)];
                fprintf(blanks(floor((Width - length(Msg))/2)));
                fprintf('%s\n', Msg);
            end
        end
    end

    if OutputCW == 0
        fprintf('\n');
    end
end

%% simulations for line plots (F/Q etc.)

% parameters
Da = Da_v(2);

% create grid points for R_4,8
R24_v = linspace(1,0.001,NumDivLines);

for ii=1:length(phinLines_v)

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

    % parameters
    phin = phinLines_v(ii);

    for jj=1:length(R24_v)

        % filename for this simulation
        fn = [fnOg,'_sim_',num2str(jj)];

        % constriction to change R_4,8
        consInds      = 3;
        consMultipler = R24_v(jj);

        % run simulation
        [~,SolClog,SolNewt,~,~] = SolveFullNetworkClogging(Netfld,NetType,[],Da,phm,phin,...
            Qt,delP,consInds,consMultipler,tol,maxit,fld,fn,SqueezeData,OutputCW);

        % sort data to plot
        sol{ii}.QClog(:,jj)     = SolClog.Q;
        sol{ii}.QNewt(:,jj)     = SolNewt.Q;
        sol{ii}.FClog(:,jj)     = SolClog.F;
        sol{ii}.PhClog(:,jj)    = SolClog.ph;
        sol{ii}.PhMaxClog(:,jj) = SolClog.phMax;
        sol{ii}.FMaxClog(:,jj)  = SolClog.FMax;
        sol{ii}.PinClog(:,jj)   = SolClog.Pin;
        sol{ii}.PinNewt(:,jj)   = SolNewt.Pin;

        % print short command window update every 50 simulations
        if OutputCW == 0
            if mod(jj,50) == 0
                Msg = ['Simulation ',num2str(jj),' out of ',num2str(NumDivLines),' complete for phin = ',num2str(phin)];
                fprintf(blanks(floor((Width - length(Msg))/2)));
                fprintf('%s\n', Msg);
            end
        end

    end

    if OutputCW == 0
        fprintf('\n');
    end
end

%% same data for fig. 3 and fig. S1 - copy for ease of access

if strcmp(fnOg,'fig_3')

    sourceDir = 'data/sims/manuscript-results';
    destDir   = 'data/sims/supp-mat-results';

    oldPrefix = 'fig_3';
    newPrefix = 'fig_S1';

elseif strcmp(fnOg,'fig_S1')

    sourceDir = 'data/sims/supp-mat-results';
    destDir   = 'data/sims/manuscript-results';

    oldPrefix = 'fig_S1';
    newPrefix = 'fig_3';

else
end

try
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
catch
end

end