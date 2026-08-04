function net = SortNetworkStructure(net)

% store and clear old network ready to reorganise
netsort = net; clear net;

% get coordinates of pressure nodes
NodeCoordinates = netsort.VertexCoordinates;

% find number of edges at each node and their indices
EdgePointIndices = cell(size(NodeCoordinates,1),1);
NumEdgePoints    = zeros(size(NodeCoordinates,1),1);
EdgeConnectivity = netsort.EdgeConnectivity + 1;
IsOutlet         = zeros(size(NodeCoordinates,1),1);
IsInlet          = zeros(size(NodeCoordinates,1),1);
for ii=1:size(NodeCoordinates,1)

    i1                   = EdgeConnectivity(:,1) == ii;
    i2                   = EdgeConnectivity(:,2) == ii;

    EdgePointIndices{ii} = [find(i1 == 1); find(i2 == 1)];
    NumEdgePoints(ii)    = sum(i1)+sum(i2);
end

% find and mark inlet + outlet vessel
VesselType = netsort.VesselType(1:2:end);
Inds       = find(NumEdgePoints == 1);
for ii=1:length(Inds)
    InOutVT    = VesselType(EdgePointIndices{Inds(ii)});
    if InOutVT == 0
        IsInlet(Inds(ii)) = 1;
    elseif InOutVT == 1
        IsOutlet(Inds(ii)) = 1;
    elseif InOutVT == 2
        error('Capillary cannot be an inlet/outlet. Check network data.');
    end
end

indIn = EdgePointIndices{IsInlet == 1};

% vessel radii
net.R = netsort.Radii(1:2:end);
net.R = net.R/net.R(indIn);

% vessel lengths
m = 1;
for ii=1:2:length(netsort.EdgePointCoordinates)
    net.L(m) = sqrt((netsort.EdgePointCoordinates(ii+1,1)-netsort.EdgePointCoordinates(ii,1)).^2 + ...
        (netsort.EdgePointCoordinates(ii+1,2)-netsort.EdgePointCoordinates(ii,2)).^2 + ...
        (netsort.EdgePointCoordinates(ii+1,3)-netsort.EdgePointCoordinates(ii,3)).^2);
    m = m + 1;
end
net.L = net.L(:)/net.L(indIn);

% find pressure nodes that are not an inlet/outlet (interior nodes)
InteriorNodeCoordinates = NodeCoordinates.*(-(IsOutlet-1));
InteriorNodeCoordinates = InteriorNodeCoordinates.*(-(IsInlet-1));
InteriorNodeCoordinates( ~any(InteriorNodeCoordinates,2), : ) = [];

% find pressure nodes that are not an inlet/outlet (interior nodes)
InteriorNodeIndices = (1:length(NodeCoordinates))'.*(-(IsOutlet-1));
InteriorNodeIndices = InteriorNodeIndices.*(-(IsInlet-1));
InteriorNodeIndices( ~any(InteriorNodeIndices,2), : ) = [];

EdgeCoordsAll = netsort.EdgePointCoordinates';
EdgeCoordsAll = reshape(EdgeCoordsAll(:),[6,size(netsort.EdgePointCoordinates,1)/2]);
EdgeCoordsAll = EdgeCoordsAll';

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

% sort outputs into network structure
net.NodeCoordinates         = NodeCoordinates;
net.EdgePointIndices        = EdgePointIndices;
net.NumEdgePoints           = NumEdgePoints;
net.IsOutlet                = IsOutlet;
net.IsInlet                 = IsInlet;
net.InteriorNodeCoordinates = InteriorNodeCoordinates;
net.NumEdges                = length(net.L);
net.NumPress                = length(InteriorNodeCoordinates);
net.NumNodes                = length(NodeCoordinates);
net.InteriorNodeIndices     = InteriorNodeIndices;
net.EdgePressInds           = EdgePressInds;
net.EdgeInteriorPressInds   = EdgeInteriorPressInds;
net.VesselType              = netsort.VesselType(1:2:end);

end