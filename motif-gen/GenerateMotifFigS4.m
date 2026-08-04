function GenerateMotifFigS4

% number of edges/nodes/unknown pressures
net.NumEdges = 7;
net.NumNodes = 8;
net.NumPress = 3;

% choose radii R
net.R = [1,1,1,0.8,0.5,0.8,1];

% choose lengths L
net.L = [1,1,1,1,1,1,1];

% NodeCoordinates
net.NodeCoordinates(1,:)  = [0,0,0];
net.NodeCoordinates(2,:)  = [0,-1,0];
net.NodeCoordinates(3,:)  = [-1,-2,0];
net.NodeCoordinates(4,:)  = [1,-2,0];
net.NodeCoordinates(5,:)  = [-1.5,-3,0];
net.NodeCoordinates(6,:)  = [-0.5,-3,0];
net.NodeCoordinates(7,:)  = [0.5,-3,0];
net.NodeCoordinates(8,:)  = [1.5,-3,0];

% InteriorNodeCoordinates
net.InteriorNodeCoordinates(1,:)  = [0,-1,0];
net.InteriorNodeCoordinates(2,:)  = [-1,-2,0];
net.InteriorNodeCoordinates(3,:)  = [1,-2,0];

% EdgePointIndices
net.EdgePointIndices{1}  = 1;
net.EdgePointIndices{2}  = [1,2,3]';
net.EdgePointIndices{3}  = [2,4,5]';
net.EdgePointIndices{4}  = [3,6,7]';
net.EdgePointIndices{5}  = 4;
net.EdgePointIndices{6}  = 5;
net.EdgePointIndices{7}  = 6;
net.EdgePointIndices{8}  = 7;   

% NumEdgePoints, IsOutlet, IsInlet
net.IsOutlet             = zeros(net.NumNodes,1);
net.IsInlet              = zeros(net.NumNodes,1);
net.IsOutlet([5,6,7,8])  = 1;
net.IsInlet(1)           = 1;
net.NumEdgePoints        = [1,3,3,3,1,1,1,1]';

% InteriorNodeIndices
net.InteriorNodeIndices = [2,3,4]';

% EdgePressInds
net.EdgePressInds(1,:)  = [1,2];
net.EdgePressInds(2,:)  = [2,3];
net.EdgePressInds(3,:)  = [2,4];
net.EdgePressInds(4,:)  = [5,3];
net.EdgePressInds(5,:)  = [6,3];
net.EdgePressInds(6,:)  = [7,4];
net.EdgePressInds(7,:)  = [8,4];

% EdgeInteriorPressInds
net.EdgeInteriorPressInds(1,:)  = [NaN,1];
net.EdgeInteriorPressInds(2,:)  = [1,2];
net.EdgeInteriorPressInds(3,:)  = [1,3];
net.EdgeInteriorPressInds(4,:)  = [NaN,2];
net.EdgeInteriorPressInds(5,:)  = [NaN,2];
net.EdgeInteriorPressInds(6,:)  = [NaN,3];
net.EdgeInteriorPressInds(7,:)  = [NaN,3];

% save data
try
    save('data/net/motif-fig-S4/data_net_motif.mat','net');
catch
    mkdir('data/net/motif-fig-S4');
    save('data/net/motif-fig-S4/data_net_motif.mat','net');
end

try
    save('data/net/motif-fig-S7/data_net_motif.mat','net');
catch
    mkdir('data/net/motif-fig-S7');
    save('data/net/motif-fig-S7/data_net_motif.mat','net');
end

end