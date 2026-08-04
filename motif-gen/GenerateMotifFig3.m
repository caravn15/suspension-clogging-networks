function GenerateMotifFig3

% number of edges/nodes/unknown pressures
net.NumEdges = 3;
net.NumNodes = 4;
net.NumPress = 1;

% choose radii R
net.R = [1,1,1];

% choose lengths L
net.L = [1,1,1];

% NodeCoordinates
net.NodeCoordinates(1,:)  = [0,0,0];
net.NodeCoordinates(2,:)  = [0,-1,0];
net.NodeCoordinates(3,:)  = [-1,-2,0];
net.NodeCoordinates(4,:)  = [1,-2,0];

% InteriorNodeCoordinates
net.InteriorNodeCoordinates(1,:)  = [0,-1,0];

% EdgePointIndices
net.EdgePointIndices{1}  = 1;
net.EdgePointIndices{2}  = [1,2,3]';
net.EdgePointIndices{3}  = 2;
net.EdgePointIndices{4}  = 3;

% NumEdgePoints, IsOutlet, IsInlet
net.IsOutlet             = zeros(net.NumNodes,1);
net.IsInlet              = zeros(net.NumNodes,1);
net.IsOutlet([3,4])      = 1;
net.IsInlet(1)           = 1;
net.NumEdgePoints        = [1,3,1,1]';

% InteriorNodeIndices
net.InteriorNodeIndices = 2;

% EdgePressInds
net.EdgePressInds(1,:)  = [1,2];
net.EdgePressInds(2,:)  = [3,2];
net.EdgePressInds(3,:)  = [4,2];

% EdgeInteriorPressInds
net.EdgeInteriorPressInds(1,:)  = [NaN,1];
net.EdgeInteriorPressInds(2,:)  = [NaN,2];
net.EdgeInteriorPressInds(3,:)  = [NaN,2];

% save data
try
    save('data/net/motif-fig-3/data_net_motif.mat','net');
catch
    mkdir('data/net/motif-fig-3');
    save('data/net/motif-fig-3/data_net_motif.mat','net');
end

try
    save('data/net/motif-fig-S1/data_net_motif.mat','net');
catch
    mkdir('data/net/motif-fig-S1');
    save('data/net/motif-fig-S1/data_net_motif.mat','net');
end

try
    save('data/net/motif-fig-S3/data_net_motif.mat','net');
catch
    mkdir('data/net/motif-fig-S3');
    save('data/net/motif-fig-S3/data_net_motif.mat','net');
end

try
    save('data/net/motif-fig-S6/data_net_motif.mat','net');
catch
    mkdir('data/net/motif-fig-S6');
    save('data/net/motif-fig-S6/data_net_motif.mat','net');
end


end