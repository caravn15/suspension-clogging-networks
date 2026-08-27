function [NodeCond,ErrSplit,ErrMassBal,ErrBackSplit] = CheckNodeSolidFluxConditions(net,F,Q,iMax,iClog)

% initilize vectors
NodeCond     = NaN*ones(net.NumPress,1);
ErrSplit     = NaN*ones(net.NumPress,1);
ErrMassBal   = NaN*ones(net.NumPress,1);
ErrBackSplit = NaN*ones(net.NumPress,1);

% check conditions at each (interior) node
for ii=1:net.NumPress

    % global pressure index
    PressInd = net.InteriorNodeIndices(ii);

    % get indices of incoming/outgoing edges
    IndsIn  = net.IndsInNode{PressInd};
    IndsOut = net.IndsOutNode{PressInd};

    % check conditions
    if isscalar(IndsOut)
        if isscalar(IndsIn)
            % one edge in, one edge out -> mass balance (regardless of
            % clogs)
            NodeCond(ii)   = 0;
            ErrMassBal(ii) = F(IndsIn) - F(IndsOut);
        elseif length(IndsIn) == 2
            % two edges in, one edge out
            if sum([iMax(IndsIn);iMax(IndsOut);iClog(IndsIn);iClog(IndsOut)]) == 0
                % mass balance
                NodeCond(ii)   = 0;
                ErrMassBal(ii) = F(IndsIn(1)) + F(IndsIn(2)) - F(IndsOut);
            else
                if iClog(IndsOut) == 1 || iMax(IndsOut) == 1
                    % backwards splitting
                    NodeCond(ii)     = 2;
                    ErrBackSplit(ii) = F(IndsIn(1)) + F(IndsIn(2)) - F(IndsOut);
                else
                    % mass balance
                    NodeCond(ii)   = 0;
                    ErrMassBal(ii) = F(IndsIn(1)) + F(IndsIn(2)) - F(IndsOut);
                end
            end
        else
            error('Must have 1 or 2 incoming edges.');
        end
    elseif length(IndsOut) == 2
        if isscalar(IndsIn)
            if sum([iMax(IndsIn);iMax(IndsOut);iClog(IndsIn);iClog(IndsOut)]) == 0
                % splitting law
                NodeCond(ii)   = 1;
                ErrSplit(ii)   = F(IndsIn) - F(IndsOut(1)) - F(IndsOut(2));
            else
                % mass balance
                NodeCond(ii)   = 0;
                ErrMassBal(ii) = F(IndsIn) - F(IndsOut(1)) - F(IndsOut(2));
            end
        else
            error('error.')
        end
    else
        error('Must have 1 or 2 outgoing edges.');
    end

end

end