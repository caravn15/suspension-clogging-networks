function [iMax,F] = PropagateSolidFluxDownstream(net,iMax,F,Q,FMax,P)

% get order of pressure nodes (inlet -> outlet(s))
[~,PressOrderInds] = sort(P,'descend');

for ii=1:length(PressOrderInds)

    % get pressure node index
    PressInd = net.InteriorNodeIndices(PressOrderInds(ii));

    % indices of edges at this node
    EdgeInds = net.EdgePointIndices{PressInd};

    % number of edges
    nEdges = length(EdgeInds);

    % calculate downstream solid fluxes
    if nEdges == 2
        [iMax,F] = CalcDownstreamFluxesTwoEdge(net,iMax,F,EdgeInds,FMax,PressInd);
    elseif nEdges == 3
        [iMax,F] = CalcDownstreamFluxesThreeEdge(net,iMax,F,Q,EdgeInds,FMax,PressInd);
    end

end

end