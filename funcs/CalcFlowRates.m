function [Q,G] = CalcFlowRates(net,prms,InvRes,P,Pin)

% unpack parameters
Pout     = prms.Pout;
L        = net.L;
NumEdges = net.NumEdges;
NumNodes = net.NumNodes;

% edge connectivity matrix with edge 'weights' InvRes
edges = [net.EdgePressInds, InvRes];

% find inlet/oulet nodes
InletNodes  = find(net.IsInlet == 1);
OutletNodes = find(net.IsOutlet == 1);

% form full P vector (i.e. Pin, Pout and all internal pressures)
PFull                           = zeros(NumNodes,1);
PInds                           = 1:NumNodes;
PInds([InletNodes;OutletNodes]) = [];
PFull(PInds)                    = P(:);
PFull(InletNodes)               = Pin;
PFull(OutletNodes)              = Pout;

% calculate Q and G
Q = zeros(NumEdges,1);
G = zeros(NumEdges,1);
for ii = 1:NumEdges
    e1 = edges(ii,1);
    e2 = edges(ii,2);
    w  = edges(ii,3);

    Q(ii,1) = (PFull(e1) - PFull(e2)) * w;
    G(ii,1) = (PFull(e1) - PFull(e2))/L(ii);

end

end