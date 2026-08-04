function SolClog = SolveCloggingProblem(InitCond,net,prms,cons,tol,maxit,OutputCW)

%% initialize

% unpack parameters
phin     = prms.phin;
NumEdges = net.NumEdges;

% print initial command window message
if OutputCW == 1
    PrintInitialClogging();
end

% pre-calculations for efficiency (i.e. information fixed across all
% iterations)
pcf = PreCalcsFlux(prms);

% constrict vessel(s)
[net,prms] = ApplyNetworkConstriction(net,prms,cons);

%% solve for initial condition

% initialize iterations
ii = 1;
if isempty(InitCond)
    % no initial data -> initialize with phin everywhere
    phit(:,ii) = phin*ones(NumEdges,1);
else
    try
        % load from squeezed data
        phit(:,ii) = InitCond.ph;
    catch
        % load from original data
        phit(:,ii) = InitCond.it.ph(:,end);
    end
end

% start timer for solve
tic

while true

    if ii == 1 && ~isempty(InitCond)
        % load data from initial condition
        try
            % load from squeezed data
            Q         = InitCond.Q;
            G         = InitCond.G;
            ResS      = InitCond.ResS;
            ResD      = InitCond.ResD;
            InvRes    = InitCond.InvRes;
            Pin       = InitCond.Pin;
            Pit(:,ii) = InitCond.P;
        catch
            % load from original data
            Q         = InitCond.it.Q(:,end);
            G         = InitCond.it.G(:,end);
            ResS      = InitCond.it.ResS(:,end);
            ResD      = InitCond.it.ResD(:,end);
            InvRes    = InitCond.it.InvRes(:,end);
            Pin       = InitCond.it.Pin(:,end);
            Pit(:,ii) = InitCond.it.P(:,end);
        end
    else

        % calculate resistances ResS, ResD and InvRes (1/ResS+1/ResD) given value of phit
        [ResS,ResD,InvRes] = CalcResistances(net,prms,pcf,phit(:,ii));

        % calculate pressures Pit (via linear solve given value of phit)
        [Pit(:,ii),Pin] = CalcPressures(net,prms,InvRes);

        % calculate flow rates Q  (and pressure drops for each edge)
        [Q,G] = CalcFlowRates(net,prms,InvRes,Pit(:,ii),Pin);

    end

    % update net with info about edges in/out of each node
    net = GetEdgesInOutNetwork(net,Q);

    % throw error if cycles are present in the solution
    CheckNetworkForCycles(net,Q);

    % compute solid flux F, state variables, and updated particle volume fraction phit(:,ii+1)
    [F,FMax,phit(:,ii+1),phMax,s,iMax,iClog] = CalculateSolidSolution(net,prms,pcf,Q,Pit(:,ii));

    % check mass balance Q across network
    [QBal,FBal] = CheckGlobalMassBalance(net,F,Q);

    % check type of node equation applied for F at each junction (splitting, backwards splitting, mass
    % balance) and calculate errors
    [NodeCond,ErrSplit,ErrMassBal,ErrBackSplit] = CheckNodeSolidFluxConditions(net,F,Q,iMax,iClog);

    % store iteration information in structure
    SolClog.it.ph                 = phit;
    SolClog.it.P                  = Pit;
    SolClog.it.F(:,ii)            = F;
    SolClog.it.Q(:,ii)            = Q;
    SolClog.it.G(:,ii)            = G;
    SolClog.it.Pin(1,ii)          = Pin;
    SolClog.it.ResS(:,ii)         = ResS;
    SolClog.it.ResD(:,ii)         = ResD;
    SolClog.it.InvRes(:,ii)       = InvRes;
    SolClog.it.iMax(:,ii)         = iMax;
    SolClog.it.s(:,ii)            = s;
    SolClog.it.iClog(:,ii)        = iClog;
    SolClog.it.QBal(:,ii)         = QBal;
    SolClog.it.FBal(:,ii)         = FBal;
    SolClog.it.FMax(:,ii)         = FMax;
    SolClog.it.phMax(:,ii)        = phMax;
    SolClog.it.NodeCond(:,ii)     = NodeCond;
    SolClog.it.ErrSplit(:,ii)     = ErrSplit;
    SolClog.it.ErrMassBal(:,ii)   = ErrMassBal;
    SolClog.it.ErrBackSplit(:,ii) = ErrBackSplit;

    if OutputCW == 1
        % print command window messages at this iteration
        PrintSolveIteration(net,F,Q,G,phit(:,ii+1),iClog,iMax,QBal,FBal,ii);
    end

    % check for convergence
    phErr = norm(phit(:,ii+1)-phit(:,ii));
    if OutputCW == 1
        PrintSolveError(phErr,tol,ii,iClog,iMax);
    end
    if phErr < tol
        break;
    end

    % check if over max number of iterations
    if ii > maxit
        break;
    end

    % increase iteration counter
    ii = ii + 1;

end

% print solve time
if OutputCW == 1
    tSolve     = toc;
    CmdWinSize = get(0, 'CommandWindowSize');
    Width      = CmdWinSize(1);
    Msg        = ['Time to solve = ',num2str(tSolve),' seconds'];
    fprintf(blanks(floor((Width - length(Msg))/2)));
    fprintf('%s\n', Msg);
    fprintf(repmat('-',[1,Width])); fprintf('\n');
end

end