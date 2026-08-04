function InitialChecksAlgorithm(net,prms)

%% setup

% unpack parameters
Q01     = prms.Q01;
Da      = prms.Da;
phm     = prms.phm;
phin    = prms.phin;
Pin     = prms.Pin;
Pout    = prms.Pout;
L       = net.L;
R       = net.R;

%% check parameter values

% check phm is less than or equal to 1
if phm > 1
    error('Maximum packing fraction cannot be greater than 1.');
end

% check phm is greater than phin
if phm <= phin
    error('Inlet particle volume fraction cannot be greater than maximum packing fraction.');
end

% check Pin
if ~isnan(Pin)
    error('For prescribed flow rate, Pin should initially be unknown (set to NaN).');
end

% check Pout
if isnan(Pout)
    error('Pout should be prescribed.');
end

% check Da
if Da > 1e-2
    warning('Darcy number too large. Typical values should be between [1e-2, 1e-10].');
end

%% check for correct non-dimensionalisation

% index of inlet edge
IndInlet = net.EdgePointIndices{net.IsInlet == 1};

% perform checks
if prms.Q01 ~=1
     error('Inlet Q should be 1 to set characteristic flow rate.');
elseif L(IndInlet) ~= 1
    error('Inlet L should be 1 to set characteristic length.');
elseif R(IndInlet) ~=1
    error('Inlet R should be 1 to set characteristic radius.');
end

%% check length of L and R

% perform checks
if length(L) ~= net.NumEdges
    error(['Length of L is ',num2str(length(L)),' but network has ', ...
        num2str(net.NumEdges),' edges.']);
elseif length(R) ~= net.NumEdges
    error(['Length of R is ',num2str(length(R)),' but network has ', ...
        num2str(net.NumEdges),' edges.']);
end

%% check phin is on lower branch

% calculate flux curve for inlet pipe
phv  = linspace(0,prms.phm,1e5);                   % vector for phi
etas = 1+phv.^2./((prms.phm-phv).^2);              % viscosity over phi
Fc   = Q01*phv./(1+8*Da*etas/(R(IndInlet)^2));   % flux curve

% calculate phi corresponding to max of the flux curve
[~,ind] = max(Fc);
ph_max  = phv(ind);

% perform check
if phin > ph_max
    error( 'Inlet phi on upper solution branch.');
end

end