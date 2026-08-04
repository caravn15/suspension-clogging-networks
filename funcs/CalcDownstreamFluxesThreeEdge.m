function [iMax,F] = CalcDownstreamFluxesThreeEdge(net,iMax,F,Q,EdgeInds,FMax,PressInd)

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

if isscalar(IndsIn) 

    % one known incoming edge

    if length(IndsOut) ~= 2
        error('Node must have exactly 3 associated edges.'); 
    end

    if length(intersect(IndsOut,IndsUnknown)) == 2

        % two unknown outgoing edges -> splitting law
        [~,iSplit] = min([Q(IndsOut(1))/Q(IndsIn),FMax(IndsOut(1))/F(IndsIn)]);

        % transform indicator to 0 or 1
        iSplit     = iSplit - 1;

        if iSplit == 0

            % standard splitting law for F(IndsOut(1)), mass balance for F(IndsOut(2))
            F(IndsOut(1)) = F(IndsIn)*Q(IndsOut(1))/Q(IndsIn);
            F(IndsOut(2)) = F(IndsIn) - F(IndsOut(1));

            % check edge IndsOut(2) can accommodate prescribed flux
            if F(IndsOut(2)) >= FMax(IndsOut(2))

                % flux too high -> set F to max
                F(IndsOut(2))    = FMax(IndsOut(2));
                iMax(IndsOut(2)) = 1;

                % recalculate F(IndsOut(1)) from mass balance
                F(IndsOut(1))    =  F(IndsIn) - F(IndsOut(2));

                % check edge IndsOut(1) can accommodate prescribed flux
                if F(IndsOut(1)) >= FMax(IndsOut(1))

                    % flux too high -> set F to max
                    F(IndsOut(1))    = FMax(IndsOut(1));
                    iMax(IndsOut(1)) = 1;
                end
            end
        else

            % flux too high for edge IndsOut(1) -> set F to max
            F(IndsOut(1))    = FMax(IndsOut(1));
            iMax(IndsOut(1)) = 1;

            % recalculate F(IndsOut(2)) from mass balance
            F(IndsOut(2)) = F(IndsIn) - F(IndsOut(1));

            % check edge IndsOut(2) can accommodate prescribed flux
            if F(IndsOut(2)) >= FMax(IndsOut(2))

                % flux too high -> set F to max
                F(IndsOut(2))     = FMax(IndsOut(2));
                iMax(IndsOut(2))  = 1;
            end
        end
    elseif isscalar(intersect(IndsOut,IndsUnknown))

        % F is unknown for exactly one outgoing edge -> mass balance
        F(intersect(IndsOut,IndsUnknown)) = F(IndsIn) - F(setdiff(IndsOut,IndsUnknown));

        % check edge can accommodate prescribed flux
        if F(intersect(IndsOut,IndsUnknown)) >= FMax(intersect(IndsOut,IndsUnknown))

            % flux too high -> set F to max
            F(intersect(IndsOut,IndsUnknown))    = FMax(intersect(IndsOut,IndsUnknown));
            iMax(intersect(IndsOut,IndsUnknown)) = 1;
        end

    elseif isempty(intersect(IndsOut,IndsUnknown))

        % F is already known for outgoing edges -> skip

    end

elseif length(IndsIn) == 2

    % two known incoming edges

    if length(IndsOut) ~= 1
        error('Node must have exactly 3 associated edges.'); 
    end

    if isscalar(intersect(IndsOut,IndsUnknown))

        % two incoming egdes, one unknown outgoing edge -> mass balance
        F(IndsOut) = F(IndsIn(1)) + F(IndsIn(2));

        % check edge can accommodate prescribed flux
        if F(IndsOut) >= FMax(IndsOut)

            % flux too high -> set F to max
            F(IndsOut)    = FMax(IndsOut);
            iMax(IndsOut) = 1;
        end

    elseif isempty(intersect(IndsOut,IndsUnknown))

        % F is already known for outgoing edges -> skip
    end

else
    error('Node cannot have greater than 2 incoming edges.');
end

end