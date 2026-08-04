function  [sol,fnFull] = SolveFig5(NumDiv,Netfld,NetType,Da,phm,phin,Qt,delP,tol,maxit,fld,fn,SqueezeData,OutputCW)

% keep original filename
fnOg = fn;

% create meshgrid for R_4,8 and R_9,10
RDiv           = linspace(1,0.001,NumDiv);
[R48_M,R910_M] = meshgrid(RDiv,RDiv);
R48_v          = R48_M(:);
R910_v         = R910_M(:);

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

% run across all R_4,8 and R_9,10
for ii=1:length(R48_v)

    % filename for this simulation
    fn = [fnOg,'_sim_',num2str(ii)];

    % constriction to change R_4,8
    consInds      = 9;
    consMultipler = R48_v(ii);

    % change radius R_9,10
    Rc     = NaN*ones(10,1);
    Rc(10) = R910_v(ii);

    % run simulation
    [~,SolClog,~,~,fnSim] = SolveFullNetworkClogging(Netfld,NetType,[],Da,phm,phin,...
        Qt,delP,consInds,consMultipler,tol,maxit,fld,fn,SqueezeData,OutputCW,Rc);

    if ii == 1
        % get filename
        fnFull = erase(fnSim,'_sim_1');
    end

    % sort data to plot (number of clogs/vessels at max - not including bypass)
    sol.nClog(ii) = sum(SolClog.iClog(1:9));
    sol.nMax(ii)  = sum(SolClog.iMax(1:9));

    % print short command window update every 50 simulations
    if OutputCW == 0
        if mod(ii,50) == 0
            Msg = ['Simulation ',num2str(ii),' out of ',num2str(NumDiv^2),' complete'];
            fprintf(blanks(floor((Width - length(Msg))/2)));
            fprintf('%s\n', Msg);
        end
    end

end

end