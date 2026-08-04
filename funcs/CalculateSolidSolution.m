function [F,FMax,ph,phMax,s,iMax,iClog] = CalculateSolidSolution(net,prms,pcf,Q,P)

%% initialize

% unpack parameters
phin     = prms.phin;
R        = net.R;
NumEdges = net.NumEdges;

% work with absolute value of Q and P for solid flux calculations
Q = abs(Q);
P = abs(P);

% initialize vectors
s          = zeros(NumEdges,1); % state variable (s=0: unclogged, s=1: set to maximum, s=2: clogged)
iClog      = zeros(NumEdges,1); % similar to above, but 1 if clogged and 0 otherwise
iMax       = zeros(NumEdges,1); % similar to above, but 1 if set to maximum and 0 otherwise

% get maximum solid flux in each vessel (as well as associated index and value of phi)
[FMax,indMax,phMax] = GetMaxFluxes(net,prms,pcf,Q);

% get inlet solid flux
IndInlet = net.EdgePointIndices{net.IsInlet == 1};
Fin      = GetFluxGivenPhi(prms,R(IndInlet),Q(IndInlet),phin);

% initialize solid flux
F           = NaN*ones(NumEdges,1);
F(IndInlet) = Fin;

%% calculate solid flux F

% initialize iterations
ii            = 1;
iMaxIt(:,ii)  = iMax;
iClogIt(:,ii) = iClog;

while true

    % propagate solid fluxes downstream and mark vessels at their maximum solid flux (steps A and B in algorithm)
    [iMaxIt(:,ii+1),F] = PropagateSolidFluxDownstream(net,iMaxIt(:,ii),F,Q,FMax,P);

    % check whether any new vessels were marked as attaining their maximum solid flux
    if isequal(iMaxIt(:,ii),iMaxIt(:,ii+1)) || (sum(iClogIt(:,ii)) + sum(iMaxIt(:,ii))) == NumEdges
        % iMax hasn't changed between iterations (or everything is clogged) -> break
        break;
    else

        % iMax has changed between iterations -> mark new clogs (step C in algorithm)
        [iClogIt(:,ii+1),iMaxIt(:,ii+1),PressOrderClogs] = MarkClogs(net,P,iClogIt(:,ii),iMaxIt(:,ii+1));

        % perform upstream correction in clogged vessels with ordering of
        % nodes/junctions considered given by PressOrderClogs (step D in algorithm)
        [F,iMaxIt(:,ii+1),iClogIt(:,ii+1)] = UpstreamCorrection(net,Q,FMax,IndInlet,Fin,F,iMaxIt(:,ii+1),iClogIt(:,ii+1),PressOrderClogs);

        % increase iteration counter
        ii = ii + 1;
        
    end
end

% get final iMax and iClog
iMax  = iMaxIt(:,end);
iClog = iClogIt(:,end);

%% update particle volume fraction

ph = CalculatePhiFromFlux(net,prms,pcf,iClog,indMax,F,R,Q);

%% update state variable vector

s(iMax == 1)  = 1;
s(iClog == 1) = 2;

end