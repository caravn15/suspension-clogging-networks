function [P,Pin] = CalcPressures(net,prms,InvRes)

%% setup

% unpack parameters
Pout     = prms.Pout;    
Q01      = prms.Q01;
NumEdges = net.NumEdges;
NumNodes = net.NumNodes;

%% construct linear system

% edge connectivity matrix with edge 'weights' InvRes
edges = [net.EdgePressInds, InvRes];

% find inlet/oulet nodes
InletNodes  = find(net.IsInlet == 1);
OutletNodes = find(net.IsOutlet == 1);

% initialize system (A * P = b)
A = sparse(NumNodes,NumNodes);
b = zeros(NumNodes, 1);

% assemble system matrix
for ii = 1:NumEdges
    e1 = edges(ii,1);
    e2 = edges(ii,2);
    w  = edges(ii,3);

    % symmetric contribution
    A(e1,e1) = A(e1,e1) + w;
    A(e1,e2) = A(e1,e2) - w;
    A(e2,e1) = A(e2,e1) - w;
    A(e2,e2) = A(e2,e2) + w;
end

% apply known pressure at outlet node(s)
for ii=1:length(OutletNodes)
    A(OutletNodes(ii),:)               = 0;
    A(OutletNodes(ii),OutletNodes(ii)) = 1;
    b(OutletNodes(ii))                 = Pout;
end

% apply inlet conditon
b(InletNodes) = Q01;

% solve linear system
P = A \ b;

% get internal pressures and pressure at inlet
Pin               = P(InletNodes);
P                 = P.*(-(net.IsOutlet-1));
P                 = P.*(-(net.IsInlet-1));
P( ~any(P,2), : ) = [];

end
