function [iMax,F] = CalcDownstreamFluxesTwoEdge(net,iMax,F,EdgeInds,FMax,PressInd)

%% get known/unknown edges and incoming/outgoing edges

% known/unknown edges
IndsKnown   = EdgeInds(~isnan(F(EdgeInds)));
IndsUnknown = EdgeInds(isnan(F(EdgeInds)));
IndsIn      = net.IndsInNode{PressInd};
IndsOut     = net.IndsOutNode{PressInd};

%% pre-calc checks

% check whether F is known for incoming edges
if length(intersect(IndsIn,IndsKnown)) ~= length(IndsIn)
    error('Value of F at incoming edges is unknown.');
end

%% calculate F for outgoing edges

if isscalar(intersect(IndsOut,IndsUnknown))

    % one unknown outgoing edge

    if isscalar(IndsIn)

        % one known incoming edge

        if length(IndsOut) ~= 1
            error('Node must have exactly 1 outgoing edge.'); % for this function where there are exactly 2 edges at this node
        end

        % flux is given by mass balance
        F(IndsOut) = F(IndsIn);

        % check edge IndsOut can accommodate prescribed flux
        if F(IndsOut) >= FMax(IndsOut)

            % flux too high -> set F to max
            F(IndsOut)    = FMax(IndsOut);
            iMax(IndsOut) = 1;
        end

        % check to propagate max
        if FMax(IndsIn) == FMax(IndsOut) && iMax(IndsIn) == 1
            F(IndsOut)    =  FMax(IndsOut);
            iMax(IndsOut) = 1;
        end

    else
        error('Node must have exactly 1 incoming edge.'); % for this function where there are exactly 2 edges at this node
    end

elseif isempty(intersect(IndsOut,IndsUnknown))

    % F is already known for outgoing edge -> skip

end

end