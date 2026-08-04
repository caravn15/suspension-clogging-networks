function  net = GetEdgesInOutNetwork(net,Q)

for ii=1:net.NumNodes

    % indices of edges at this node
    EdgeInds = net.EdgePointIndices{ii};

    % number of edges at this node
    nEdges = length(EdgeInds);

    % calculate indicies of edges in/out of this node
    IsIn  = zeros(nEdges,1);
    IsOut = zeros(nEdges,1);
    for jj=1:nEdges
        PressIndsEdge = net.EdgePressInds(EdgeInds(jj),:);
        NodePos       = find(PressIndsEdge == ii);
        switch NodePos
            case 1
                if Q(EdgeInds(jj)) > 0
                    IsOut(jj) = 1;
                elseif Q(EdgeInds(jj)) < 0
                    IsIn(jj) = 1;
                end
            case 2
                if Q(EdgeInds(jj)) > 0
                    IsIn(jj) = 1;
                elseif Q(EdgeInds(jj)) < 0
                    IsOut(jj) = 1;
                end
        end
    end
    net.IndsInNode{ii}  = EdgeInds(IsIn == 1);
    net.IndsOutNode{ii} = EdgeInds(IsOut == 1);
end

end