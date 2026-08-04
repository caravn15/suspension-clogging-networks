function  [iClog,iMax,PressOrderClogs] = MarkClogs(net,P,iClog,iMax)

% get order of pressure nodes (inlet -> outlet(s))
[~,PressOrderInds] = sort(P,'descend');

% sweep through each node and mark clogs for incoming edges if all outgoing
% vessels are clogged or at their maximum
kk                  = 1;
iClogIt(:,kk)       = iClog(:);
iMaxIt(:,kk)        = iMax(:);
PressChangeInterior = []; % tracks interior pressure inds associated with clogs
while true
    for ii=1:length(PressOrderInds)

        % get pressure node index
        PressInd = net.InteriorNodeIndices(PressOrderInds(ii));

        % incoming/outgoing edges
        IndsIn  = net.IndsInNode{PressInd};
        IndsOut = net.IndsOutNode{PressInd};

        % mark clogs if all outgoing vessels are clogged/at max
        if isscalar(IndsOut)

            % one outgoing vessel

            if iMax(IndsOut) == 1 || iClog(IndsOut) == 1
                if isscalar(IndsIn)

                    % one incoming vessel -> clog
                    iClog(IndsIn)       = ones(length(IndsIn),1);
                    PressChangeInterior = [PressChangeInterior; PressOrderInds(ii)];
                    if iMax(IndsIn) == 1
                        % replace max with clog
                        iMax(IndsIn) = 0;
                    end
                elseif length(IndsIn) == 2

                    % two incoming vessels -> clog
                    iClog(IndsIn(1))    = ones(length(IndsIn(1)),1);
                    PressChangeInterior = [PressChangeInterior; PressOrderInds(ii)];
                    if iMax(IndsIn(1)) == 1
                        % replace max with clog
                        iMax(IndsIn(1)) = 0;
                    end
                    iClog(IndsIn(2))    = ones(length(IndsIn(2)),1);
                    PressChangeInterior = [PressChangeInterior; PressOrderInds(ii)];
                    if iMax(IndsIn(2)) == 1
                        % replace max with clog
                        iMax(IndsIn(2)) = 0;
                    end
                end
            end
        elseif length(IndsOut) == 2

            % two outgoing vessels

            if iMax(IndsOut(1)) == 1 && iMax(IndsOut(2)) == 1

                % both downstream set to max -> clog upstream
                iClog(IndsIn)       = ones(length(IndsIn),1);
                PressChangeInterior = [PressChangeInterior; PressOrderInds(ii)];
                if iMax(IndsIn) == 1
                    % replace max with clog
                    iMax(IndsIn) = 0;
                end
            elseif iClog(IndsOut(1)) == 1 && iClog(IndsOut(2)) == 1

                % both downstream clogged -> clog upstream
                iClog(IndsIn)       = ones(length(IndsIn),1);
                PressChangeInterior = [PressChangeInterior; PressOrderInds(ii)];
                if iMax(IndsIn) == 1
                    % replace max with clog
                    iMax(IndsIn) = 0;
                end
            elseif iMax(IndsOut(1)) == 1 && iClog(IndsOut(2)) == 1

                % mixture of clogged/set to maximum flux downstream -> clog upstream
                iClog(IndsIn)       = ones(length(IndsIn),1);
                PressChangeInterior = [PressChangeInterior; PressOrderInds(ii)];
                if iMax(IndsIn) == 1
                    % replace max with clog
                    iMax(IndsIn) = 0;
                end
            elseif iClog(IndsOut(1)) == 1 && iMax(IndsOut(2)) == 1

                % mixture of clogged/set to maximum flux downstream -> clog upstream
                iClog(IndsIn)       = ones(length(IndsIn),1);
                PressChangeInterior = [PressChangeInterior; PressOrderInds(ii)];
                if iMax(IndsIn) == 1
                    % replace max with clog
                    iMax(IndsIn) = 0;
                end
            end
        else
            error('Must have 1 or 2 outgoing edges.');
        end
    end

    % update iClog and iMax at this iteration
    iClogIt(:,kk+1) = iClog;
    iMaxIt(:,kk+1)  = iMax;

    % check if any changes were made to iClog between iterations
    if isequal(iClogIt(:,kk+1),iClogIt(:,kk)) && isequal(iMaxIt(:,kk+1),iMaxIt(:,kk))
        % no changes -> break
        break;
    else
        kk = kk + 1;
    end

end

% get final value of iClog and iMax
iClog = iClogIt(:,end);
iMax  = iMaxIt(:,end);

% get order for upstream correction in clogged vessels based on pressure indices
PressChangeInterior = unique(PressChangeInterior);
[~,PressOrderClogs] = sort(abs(P(PressChangeInterior)),'ascend'); % outlet(s) -> inlet
PressOrderClogs     = PressChangeInterior(PressOrderClogs);

end