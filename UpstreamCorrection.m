function [F,iMax,iClog] = UpstreamCorrection(net,Q,FMax,IndInlet,Fin,iMax,iClog,PressOrderClogs)

% initialize new solid flux
F = NaN*ones(net.NumEdges,1);

% set F equal to FMax where needed
F(iMax == 1) = FMax(iMax == 1);

for kk=1:length(PressOrderClogs)

    % get pressure node index
    PressInd = net.InteriorNodeIndices(PressOrderClogs(kk));

    % incoming/outgoing edges
    IndsIn  = net.IndsInNode{PressInd};
    IndsOut = net.IndsOutNode{PressInd};

    % calculate F for clogs based on mass balance (or inverse splitting rule)
    if isscalar(IndsIn)

        % one incoming vessel

        if isscalar(IndsOut)
            % one outgoing vessel
            F(IndsIn) = F(IndsOut);

        elseif length(IndsOut) == 2
            % two outgoing vessels
            F(IndsIn) = F(IndsOut(1)) + F(IndsOut(2));
        end

    elseif length(IndsIn) == 2

        % two incoming vessels

        if isscalar(IndsOut)

            % one outgoing vessel

            FogInMax1    = FMax(IndsIn(1));
            FogInMax2 = FMax(IndsIn(2));

            % backwards splitting law
            [~,iSplit] = min([Q(IndsIn(1))/Q(IndsOut),FogInMax1/F(IndsOut)]);

            % transform indicator to 0 or 1
            iSplit     = iSplit - 1;

            if iSplit == 0

                % standard splitting law for F(IndsOut(1)), mass balance for F(IndsOut(2))
                F(IndsIn(1)) = F(IndsOut)*Q(IndsIn(1))/Q(IndsOut);
                F(IndsIn(2)) = F(IndsOut) - F(IndsIn(1));

                % check edge IndsOut(2) can accommodate prescribed flux
                if F(IndsIn(2)) >= FogInMax2

                    % flux too high -> set F to max
                    F(IndsIn(2))    = FogInMax2;

                    % recalculate F(IndsOut(1)) from mass balance
                    F(IndsIn(1))    =  F(IndsOut) - F(IndsIn(2));

                    % check edge IndsOut(1) can accommodate prescribed flux
                    if F(IndsIn(1)) >= FogInMax1

                        % flux too high -> set F to max
                        F(IndsIn(1))    = FogInMax1;
                    end
                end
            else

                % flux too high for edge IndsOut(1) -> set F to max
                F(IndsIn(1))    = FogInMax1;

                % recalculate F(IndsOut(2)) from mass balance
                F(IndsIn(2)) = F(IndsOut) - F(IndsIn(1));

                % check edge IndsOut(2) can accommodate prescribed flux
                if F(IndsIn(2)) >= FogInMax2

                    % flux too high -> set F to max
                    F(IndsIn(2))     = FogInMax2;
                end
            end
        end
    end
end

% set inlet F as Fin if not clogged
if isnan(F(IndInlet))
    F(IndInlet) = Fin;
end

end

