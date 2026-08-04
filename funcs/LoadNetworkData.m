function net = LoadNetworkData(Netfld,NetType,RetSec)

switch NetType
    case 'retinal-vasc'
        try
            if isempty(RetSec) || strcmp(RetSec,'all')
                load(['data/net/',Netfld,'data_net_retinal_vasc_all.mat'],'net');
            elseif strcmp(RetSec,'arteries')
                load(['data/net/',Netfld,'data_net_retinal_vasc_arteries.mat'],'net');
            elseif strcmp(RetSec,'veins')
                load(['data/net/',Netfld,'data_net_retinal_vasc_veins.mat'],'net');
            else
                error('Invalid EyeSec.\n');
            end
        catch
            % load data from txt files
            netLoad = GetArraysFromTxt(Netfld);

            % sort network info into suitable structure for sims
            net = SortNetworkStructure(netLoad);

            % reduce network if only arteries/veins requested
            net = GetRetSec(net,netLoad,RetSec);

            % save data for future simulations
            if isempty(RetSec) || strcmp(RetSec,'all')
                save(['data/net/',Netfld,'data_net_retinal_vasc_all.mat'],'net');
            elseif strcmp(RetSec,'arteries')
                save(['data/net/',Netfld,'data_net_retinal_vasc_arteries.mat'],'net');
            elseif strcmp(RetSec,'veins')
                save(['data/net/',Netfld,'data_net_retinal_vasc_veins.mat'],'net');
            else
                error('Invalid RetSec.\n');
            end
        end
    case 'motif'
        load(['data/net/',Netfld,'data_net_motif.mat'],'net');
    otherwise
        error('Network type not found.');
end

end