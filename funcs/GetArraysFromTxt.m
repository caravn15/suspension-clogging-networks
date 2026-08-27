function net = GetArraysFromTxt(Netfld)

% VertexCoordinates
try
    fileID                = fopen(['data/net/',Netfld,'data_VertexCoordinates.txt'],'r');
    formatSpec            = '%f %f %f';
    sizeA                 = [3 Inf];
    net.VertexCoordinates = fscanf(fileID,formatSpec,sizeA);
    net.VertexCoordinates = net.VertexCoordinates';
    fclose(fileID);
catch
    error('VertexCoordinates data not found.')
end

% EdgeConnectivity
try
    fileID               = fopen(['data/net/',Netfld,'data_EdgeConnectivity.txt'],'r');
    formatSpec           = '%d %d';
    sizeA                = [2 Inf];
    net.EdgeConnectivity = fscanf(fileID,formatSpec,sizeA);
    net.EdgeConnectivity = net.EdgeConnectivity';
    fclose(fileID);
catch
    error('EdgeConnectivity data not found.')
end

% EdgePointCoordinates
try
    fileID                   = fopen(['data/net/',Netfld,'data_EdgePointCoordinates.txt'],'r');
    formatSpec               = '%f %f %f';
    sizeA                    = [3 Inf];
    net.EdgePointCoordinates = fscanf(fileID,formatSpec,sizeA);
    net.EdgePointCoordinates = net.EdgePointCoordinates';
    fclose(fileID);
catch
    error('EdgePointCoordinates data not found.')
end

% Radii
try
    fileID     = fopen(['data/net/',Netfld,'data_Radii.txt'],'r');
    formatSpec = '%f';
    sizeA      = [1 Inf];
    net.Radii  = fscanf(fileID,formatSpec,sizeA);
    net.Radii  = net.Radii';
    fclose(fileID);
catch
    error('Radii data not found.')
end

% VesselType
try
    fileID        = fopen(['data/net/',Netfld,'data_VesselType.txt'],'r');
    formatSpec     = '%f';
    sizeA          = [1 Inf];
    net.VesselType = fscanf(fileID,formatSpec,sizeA);
    net.VesselType = net.VesselType';
    fclose(fileID);
catch
    error('VesselType data not found.')
end

end