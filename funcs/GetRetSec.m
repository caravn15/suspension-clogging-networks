function netNew = GetRetSec(net,netLoad,RetSec)

if ~isempty(RetSec)
    switch RetSec
        case 'all'
            netNew = net;
        case 'arteries'

            % find index of edges associated with arteries
            inds = find(net.VesselType == 0);

            % recalculate network details associated with edges
            netNew.R          = net.R(inds);
            netNew.L          = net.L(inds);
            netNew.NumEdges   = length(inds);
            EdgePressInds     = net.EdgePressInds(inds,:);
            netNew.VesselType = net.VesselType(inds);

            % get indices of all global pressure nodes
            PressInds = [];
            for ii=1:length(EdgePressInds)

                PI = EdgePressInds(ii,:)';

                if isempty(intersect(PressInds,PI(1)))
                    PressInds = [PressInds; PI(1)];
                end
                if isempty(intersect(PressInds,PI(2)))
                    PressInds = [PressInds; PI(2)];
                end
            end

            % sort new NodeCoordinates
            NodeCoordinates = net.NodeCoordinates(PressInds,:);
            PressMap        = [PressInds,(1:length(PressInds))'];
            IsOutlet        = zeros(size(NodeCoordinates,1),1);
            IsInlet         = zeros(size(NodeCoordinates,1),1);

            % find node connections
            EdgePointIndices = cell(size(NodeCoordinates,1),1);
            NumEdgePoints    = zeros(size(NodeCoordinates,1),1);
            for ii=1:length(PressInds)

                ind = PressInds(ii);
                i1  = EdgePressInds(:,1) == ind;
                i2  = EdgePressInds(:,2) == ind;

                EdgePointIndices{ii} = [find(i1 == 1); find(i2 == 1)];
                NumEdgePoints(ii)    = sum(i1)+sum(i2);

            end

            % find and mark outlet vessels
            Inds = find(NumEdgePoints == 1);
            for ii=1:length(Inds)
                IsOutlet(Inds(ii)) = 1;
            end

            % mark inlet vessel
            OldInd           = find(net.IsInlet == 1);
            NewInd           = find(PressMap(:,1) == OldInd);
            IsInlet(NewInd)  = 1;
            IsOutlet(NewInd) = 0;

            % calculate interior nodes
            InteriorNodeCoordinates = NodeCoordinates.*(-(IsOutlet-1));
            InteriorNodeCoordinates = InteriorNodeCoordinates.*(-(IsInlet-1));
            InteriorNodeCoordinates( ~any(InteriorNodeCoordinates,2), : ) = [];

            % calculate interior node indicies
            InteriorNodeIndices = (1:length(NodeCoordinates))'.*(-(IsOutlet-1));
            InteriorNodeIndices = InteriorNodeIndices.*(-(IsInlet-1));
            InteriorNodeIndices( ~any(InteriorNodeIndices,2), : ) = [];

            % get number of pressures/nodes
            netNew.NumPress = length(InteriorNodeIndices);
            netNew.NumNodes = length(NodeCoordinates);

            EdgeCoordsAll = netLoad.EdgePointCoordinates';
            EdgeCoordsAll = reshape(EdgeCoordsAll(:),[6,size(netLoad.EdgePointCoordinates,1)/2]);
            EdgeCoordsAll = EdgeCoordsAll';
            inds          = find(net.VesselType == 0);
            EdgeCoordsAll = EdgeCoordsAll(inds,:);

            % find pressure indices associated with each edge
            EdgePressInds         = zeros(size(EdgeCoordsAll,1),2);
            EdgeInteriorPressInds = zeros(size(EdgeCoordsAll,1),2);
            for ii=1:size(EdgeCoordsAll,1)

                EdgeCoords = EdgeCoordsAll(ii,:);

                i1         = NodeCoordinates(:,1) == EdgeCoords(1);
                i2         = NodeCoordinates(:,2) == EdgeCoords(2);
                i3         = NodeCoordinates(:,3) == EdgeCoords(3);
                isum       = i1 + i2 + i3;
                ind1       = find(isum == 3);

                i1         = NodeCoordinates(:,1) == EdgeCoords(4);
                i2         = NodeCoordinates(:,2) == EdgeCoords(5);
                i3         = NodeCoordinates(:,3) == EdgeCoords(6);
                isum       = i1 + i2 + i3;
                ind2       = find(isum == 3);

                EdgePressInds(ii,:) = [ind1,ind2];

                i1         = InteriorNodeCoordinates(:,1) == EdgeCoords(1);
                i2         = InteriorNodeCoordinates(:,2) == EdgeCoords(2);
                i3         = InteriorNodeCoordinates(:,3) == EdgeCoords(3);
                isum       = i1 + i2 + i3;
                ind1       = find(isum == 3);

                i1         = InteriorNodeCoordinates(:,1) == EdgeCoords(4);
                i2         = InteriorNodeCoordinates(:,2) == EdgeCoords(5);
                i3         = InteriorNodeCoordinates(:,3) == EdgeCoords(6);
                isum       = i1 + i2 + i3;
                ind2       = find(isum == 3);

                if isempty(ind1)
                    ind1 = NaN;
                end
                if isempty(ind2)
                    ind2 = NaN;
                end
                EdgeInteriorPressInds(ii,:) = [ind1,ind2];

            end

            netNew.NodeCoordinates = NodeCoordinates;
            netNew.EdgePointIndices        = EdgePointIndices;
            netNew.NumEdgePoints           = NumEdgePoints;
            netNew.IsOutlet                = IsOutlet;
            netNew.IsInlet                 = IsInlet;
            netNew.InteriorNodeCoordinates = InteriorNodeCoordinates;
            netNew.InteriorNodeIndices     = InteriorNodeIndices;
            netNew.EdgePressInds           = EdgePressInds;
            netNew.EdgeInteriorPressInds   = EdgeInteriorPressInds;

        case 'veins'
            error('Currently only arterial network can be extracted.')
    end

else
 netNew = net;
end

end