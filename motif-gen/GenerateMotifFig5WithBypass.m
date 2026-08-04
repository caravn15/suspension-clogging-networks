function GenerateMotifFig5WithBypass

% number of edges/nodes/unknown pressures
net.NumEdges = 10;
net.NumNodes = 10;
net.NumPress = 5;

% choose radii R
net.R = [1,1,1,1,0.9,0.6,0.6,0.9,1,1];

% choose lengths L
net.L = [1,1,0.5,0.5,1,0.5,0.5,1,1,1];

% NodeCoordinates
net.NodeCoordinates(1,:)  = [0,0,0];
net.NodeCoordinates(2,:)  = [0,-1,0];
net.NodeCoordinates(3,:)  = [-1,-2,0];
net.NodeCoordinates(4,:)  = [0.5,-1.5,0];
net.NodeCoordinates(5,:)  = [1,-2,0];
net.NodeCoordinates(6,:)  = [-0.75,-2.5,0];
net.NodeCoordinates(7,:)  = [-1.5,-3,0];
net.NodeCoordinates(8,:)  = [-0.5,-3,0];
net.NodeCoordinates(9,:)  = [0.5,-3,0];
net.NodeCoordinates(10,:) = [1.5,-3,0];

% InteriorNodeCoordinates
net.InteriorNodeCoordinates(1,:) = [0,-1,0];
net.InteriorNodeCoordinates(2,:) = [-1,-2,0];
net.InteriorNodeCoordinates(3,:) = [0.5,-1.5,0];
net.InteriorNodeCoordinates(4,:) = [1,-2,0];
net.InteriorNodeCoordinates(5,:) = [-0.75,-2.5,0];

% EdgePointIndices
net.EdgePointIndices{1}  = 1;
net.EdgePointIndices{2}  = [1,2,3]';
net.EdgePointIndices{3}  = [2,5,6]';
net.EdgePointIndices{4}  = [3,4,10]';
net.EdgePointIndices{5}  = [4,8,9]';
net.EdgePointIndices{6}  = [6,7,10]';
net.EdgePointIndices{7}  = 5;
net.EdgePointIndices{8}  = 7;
net.EdgePointIndices{9}  = 8;
net.EdgePointIndices{10} = 9;

% NumEdgePoints, IsOutlet, IsInlet
net.IsOutlet             = zeros(net.NumNodes,1);
net.IsInlet              = zeros(net.NumNodes,1);
net.IsOutlet([7,8,9,10]) = 1;
net.IsInlet(1)           = 1;
net.NumEdgePoints        = [1,3,3,3,3,3,1,1,1,1]';

% InteriorNodeIndices
net.InteriorNodeIndices = [2,3,4,5,6]';

% EdgePressInds
net.EdgePressInds(1,:)  = [1,2];
net.EdgePressInds(2,:)  = [2,3];
net.EdgePressInds(3,:)  = [2,4];
net.EdgePressInds(4,:)  = [4,5];
net.EdgePressInds(5,:)  = [3,7];
net.EdgePressInds(6,:)  = [3,6];
net.EdgePressInds(7,:)  = [6,8];
net.EdgePressInds(8,:)  = [5,9];
net.EdgePressInds(9,:)  = [5,10];
net.EdgePressInds(10,:) = [4,6];

% EdgeInteriorPressInds
net.EdgeInteriorPressInds(1,:)  = [NaN,1];
net.EdgeInteriorPressInds(2,:)  = [1,2];
net.EdgeInteriorPressInds(3,:)  = [1,3];
net.EdgeInteriorPressInds(4,:)  = [3,4];
net.EdgeInteriorPressInds(5,:)  = [NaN,2];
net.EdgeInteriorPressInds(6,:)  = [2,5];
net.EdgeInteriorPressInds(7,:)  = [NaN,5];
net.EdgeInteriorPressInds(8,:)  = [NaN,4];
net.EdgeInteriorPressInds(9,:)  = [NaN,4];
net.EdgeInteriorPressInds(10,:) = [3,5];

% save data
try
    save('data/net/motif-fig-5/data_net_motif.mat','net');
catch
    mkdir('data/net/motif-fig-5');
    save('data/net/motif-fig-5/data_net_motif.mat','net');
end

end