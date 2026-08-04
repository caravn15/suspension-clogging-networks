function SolNewt = SolveNewtonianProblem(net,prms,cons,OutputCW)

%% initilise

% print initial command window message
if OutputCW == 1
    PrintInitialNewtonian();
end

% constrict vessel(s)
[net,prms] = ApplyNetworkConstriction(net,prms,cons);

%% solve newtonian problem

% start timer for solve
tic

% calculate resistance Res and InvRes (1/Res)
[Res,InvRes] = CalcResistancesNewtonian(net,prms);

% calculate pressures (via linear solve)
[P,Pin] = CalcPressures(net,prms,InvRes);

% calculate flow rates Q  (and pressure drops for each edge)
[Q,G] = CalcFlowRates(net,prms,InvRes,P,Pin);

% update net with info about edges in/out of each node
net = GetEdgesInOutNetwork(net,Q);

% throw error if cycles are present in the solution
CheckNetworkForCycles(net,Q);

% calculate estimated F (see Eq. (B4) in main manuscript)
F = prms.phin*abs(Q);

% check mass balance Q across network
[QBal,~] = CheckGlobalMassBalance(net,[],Q);

% store data in structure
SolNewt.P      = P;
SolNewt.Q      = Q;
SolNewt.F      = F;
SolNewt.G      = G;
SolNewt.Pin    = Pin;
SolNewt.Res    = Res;
SolNewt.InvRes = InvRes;
SolNewt.QBal   = QBal;

if OutputCW == 1

    % print command window message
    PrintSolveNewtonian(net,Q,G,QBal);

    % print solve time
    tSolve     = toc;
    CmdWinSize = get(0, 'CommandWindowSize');
    Width      = CmdWinSize(1);
    fprintf(repmat('-',[1,Width])); fprintf('\n');
    Msg        = ['Time to solve Newtonian = ',num2str(tSolve),' seconds'];
    fprintf(blanks(floor((Width - length(Msg))/2)));
    fprintf('%s\n', Msg);
    fprintf(repmat('-',[1,Width])); fprintf('\n');
end

end