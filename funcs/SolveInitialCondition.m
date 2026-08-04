function InitCond = SolveInitialCondition(net,prms,tol,maxit,OutputCW)

%% initialize

% unpack parameters
phin     = prms.phin;
NumEdges = net.NumEdges;

% print initial command window message
if OutputCW == 1
    PrintSolveInitialCondition();
end

% pre-calculations for efficiency (i.e. information fixed across all
% iterations)
pcf = PreCalcsFlux(prms);

%% solve for initial condition

% initialize iterations
ii = 1; phit(:,ii) = phin*ones(NumEdges,1);

% start timer for solve
tic

while true

    % calculate resistances ResS, ResD and InvRes (1/ResS+1/ResD) given value of phit
    [ResS,ResD,InvRes] = CalcResistances(net,prms,pcf,phit(:,ii));

    % calculate pressures Pit (via linear solve given value of phit)
    [Pit(:,ii),Pin] = CalcPressures(net,prms,InvRes);

    % calculate flow rates Q  (and pressure drops for each edge)
    [Q,G] = CalcFlowRates(net,prms,InvRes,Pit(:,ii),Pin);

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
    InitCond.it.ph                 = phit;
    InitCond.it.P                  = Pit;
    InitCond.it.F(:,ii)            = F;
    InitCond.it.Q(:,ii)            = Q;
    InitCond.it.G(:,ii)            = G;
    InitCond.it.Pin(1,ii)          = Pin;
    InitCond.it.ResS(:,ii)         = ResS;
    InitCond.it.ResD(:,ii)         = ResD;
    InitCond.it.InvRes(:,ii)       = InvRes;
    InitCond.it.iMax(:,ii)         = iMax;
    InitCond.it.s(:,ii)            = s;
    InitCond.it.iClog(:,ii)        = iClog;
    InitCond.it.QBal(:,ii)         = QBal;
    InitCond.it.FBal(:,ii)         = FBal;
    InitCond.it.FMax(:,ii)         = FMax;
    InitCond.it.phMax(:,ii)        = phMax;
    InitCond.it.NodeCond(:,ii)     = NodeCond;
    InitCond.it.ErrSplit(:,ii)     = ErrSplit;
    InitCond.it.ErrMassBal(:,ii)   = ErrMassBal;
    InitCond.it.ErrBackSplit(:,ii) = ErrBackSplit;

    if OutputCW == 1
        % print command window messages at this iteration
        PrintSolveIteration(net,F,Q,G,phit(:,ii+1),iClog,iMax,QBal,FBal,ii);
    end

    % check for convergence
    phErr = norm(phit(:,ii+1)-phit(:,ii));
    if OutputCW == 1
        PrintSolveErrorInitialCondition(phErr,tol,ii,iClog,iMax);
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