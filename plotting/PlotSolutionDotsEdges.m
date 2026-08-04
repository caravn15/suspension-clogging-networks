function PlotSolutionDotsEdges(net,VessType,Sol,Lims,CbTicks,iCbLog,CbLabel,consInds,iCb)

% net       : network structure
% VessType  : 'all', 'veins', 'arteries' or 'capillaries'
% Sol       : solution to plot over network
% Lims      : colorbar limits vector
% CbTicks   : colorbar ticks
% iCbLog    : set to 1 if log scale required (0 otherwise)
% CbLabel   : label for colorbar
% consInds  : indicies of constriction
% iCb       : set to 1 to plot colorbar (0 otherwise)

% set VessType = 'all' if empty
if isempty(VessType)
    VessType = 'all';
end

% calculate midpoint of each edge to plot dot
midx = NaN*ones(net.NumEdges,1);
midy = NaN*ones(net.NumEdges,1);
midz = NaN*ones(net.NumEdges,1);
for ii=1:net.NumEdges
    PressInds = net.EdgePressInds(ii,:);
    switch VessType
        case 'all'
            midx(ii,1) = (net.NodeCoordinates(PressInds(1),1) + net.NodeCoordinates(PressInds(2),1))/2;
            midy(ii,1) = (net.NodeCoordinates(PressInds(1),2) + net.NodeCoordinates(PressInds(2),2))/2;
            midz(ii,1) = (net.NodeCoordinates(PressInds(1),3) + net.NodeCoordinates(PressInds(2),3))/2;
        case 'veins'
            if net.VesselType(ii) == 1
                midx(ii,1) = (net.NodeCoordinates(PressInds(1),1) + net.NodeCoordinates(PressInds(2),1))/2;
                midy(ii,1) = (net.NodeCoordinates(PressInds(1),2) + net.NodeCoordinates(PressInds(2),2))/2;
                midz(ii,1) = (net.NodeCoordinates(PressInds(1),3) + net.NodeCoordinates(PressInds(2),3))/2;
            end
        case 'arteries'
            if net.VesselType(ii) == 0
                midx(ii,1) = (net.NodeCoordinates(PressInds(1),1) + net.NodeCoordinates(PressInds(2),1))/2;
                midy(ii,1) = (net.NodeCoordinates(PressInds(1),2) + net.NodeCoordinates(PressInds(2),2))/2;
                midz(ii,1) = (net.NodeCoordinates(PressInds(1),3) + net.NodeCoordinates(PressInds(2),3))/2;
            end
        case 'capillaries'
            if net.VesselType(ii) == 2
                midx(ii,1) = (net.NodeCoordinates(PressInds(1),1) + net.NodeCoordinates(PressInds(2),1))/2;
                midy(ii,1) = (net.NodeCoordinates(PressInds(1),2) + net.NodeCoordinates(PressInds(2),2))/2;
                midz(ii,1) = (net.NodeCoordinates(PressInds(1),3) + net.NodeCoordinates(PressInds(2),3))/2;
            end
    end
end

% calculate midpoint of edges which are constricted
if ~isempty(consInds)
    midxinds = NaN*ones(length(consInds),1);
    midyinds = NaN*ones(length(consInds),1);
    midzinds = NaN*ones(length(consInds),1);
    for ii=1:length(consInds)
        PressInds = net.EdgePressInds(consInds(ii),:);
        midxinds(ii,1) = (net.NodeCoordinates(PressInds(1),1) + net.NodeCoordinates(PressInds(2),1))/2;
        midyinds(ii,1) = (net.NodeCoordinates(PressInds(1),2) + net.NodeCoordinates(PressInds(2),2))/2;
        midzinds(ii,1) = (net.NodeCoordinates(PressInds(1),3) + net.NodeCoordinates(PressInds(2),3))/2;
    end
end

% plot figure
hold on;
scatter(midx(~isnan(midx)),midy(~isnan(midx)),30*net.R(~isnan(midx)),Sol(~isnan(midx)),'filled');
if ~isempty(consInds)
    scatter(midxinds,midyinds,80*net.R(consInds),'k','filled');
    scatter(midxinds,midyinds,20*net.R(consInds),[240, 70, 231]./255,'filled');
end
axis equal;
set(gca,'FontSize',14)
axis off;
colormap turbo;
cb          = colorbar;
cb.Location = 'northoutside';
if isempty(Lims)
    clim([min(Sol),max(Sol)])
    cb.Limits = [min(Sol),max(Sol)];
else
    clim([Lims(1),Lims(2)])
    cb.Limits = [Lims(1),Lims(2)];
end
if iCbLog == 1
    set(gca,'ColorScale','log');
end
cb.Label.String = CbLabel;
cb.Label.Interpreter = 'latex';
if ~isempty(CbTicks)
    cb.Ticks = CbTicks;
end

if iCb == 0
colorbar('off')
end

end