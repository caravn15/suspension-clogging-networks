function PrintSolveStart(net,prms,tol,maxit)

CmdWinSize = get(0, 'CommandWindowSize');
Width     = CmdWinSize(1);

fprintf(repmat('-',[1,Width])); fprintf('\n');

Msg = 'Suspension clogging solver (c) Neal et al. 2026';
fprintf(blanks(floor((Width - length(Msg))/2)));
fprintf('%s\n', Msg);

fprintf(repmat('-',[1,Width])); fprintf('\n\n');

fprintf('Parameters:\n\n');
fprintf('<network>\n\n');
fprintf(['-NumEdges : number of vessels                 = ',...
    num2str(length(net.L)),'\n']);
fprintf(['-NumPress : number of unknown pressures       = ',...
    num2str(net.NumPress),'\n']);
fprintf(['-IsInlet  : number of inlets                  = ',...
    num2str(sum(net.IsInlet)),'\n']);
fprintf(['-IsOutlet : number of outlets                 = ',...
    num2str(sum(net.IsOutlet)),'\n\n']);

fprintf('<suspension>\n\n');
fprintf(['-Da       : Darcy number                      = ',...
    num2str(prms.Da),'\n']);
fprintf(['-Pin      : pressure at inlet node            = ',...
    num2str(prms.Pin),'\n']);
fprintf(['-Pout     : pressure at outlet node(s)        = ',...
    num2str(prms.Pout),'\n']);
fprintf(['-Q01      : flow rate in inlet vessel         = ',...
    num2str(prms.Q01),'\n']);
fprintf(['-phin     : particle volume fraction at inlet = ',...
    num2str(prms.phin),'\n']);
fprintf(['-phm      : maximum packing fraction          = ',...
    num2str(prms.phm(1)),'\n\n']);

fprintf('<numerics>\n\n');
fprintf(['-tol      : tolerance for iterative solver    = ',...
    num2str(tol),'\n']);
fprintf(['-maxit    : maximum number of iterations      = ',...
    num2str(maxit),'\n\n']);

fprintf(repmat('-',[1,Width])); fprintf('\n');

end