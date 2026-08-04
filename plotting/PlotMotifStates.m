function PlotMotifStates(net,solstruct)

% get vessel states
try
    iClog = solstruct.iClog(:,end);
    iMax  = solstruct.iMax(:,end);
catch
    iClog = zeros(net.NumEdges,1);
    iMax  = zeros(net.NumEdges,1);
end

% plot vessels
hold on;
for ii=1:net.NumEdges
    PressInds = net.EdgePressInds(ii,:);
    if iClog(ii) == 1

        % clogged -> red
        p1 = [net.NodeCoordinates(PressInds(1),1) net.NodeCoordinates(PressInds(1),2)];
        p2 = [net.NodeCoordinates(PressInds(2),1) net.NodeCoordinates(PressInds(2),2)];
        dp = p2-p1;
        quiver(p1(1),p1(2),dp(1),dp(2),0,'Color','#ae2b2b','LineWidth',3)

    elseif iMax(ii) == 1

        % maximum -> orange
        p1 = [net.NodeCoordinates(PressInds(1),1) net.NodeCoordinates(PressInds(1),2)];
        p2 = [net.NodeCoordinates(PressInds(2),1) net.NodeCoordinates(PressInds(2),2)];
        dp = p2-p1;
        quiver(p1(1),p1(2),dp(1),dp(2),0,'Color','#dfb254','LineWidth',3)

    else

        % unclogged -> green
        p1 = [net.NodeCoordinates(PressInds(1),1) net.NodeCoordinates(PressInds(1),2)];
        p2 = [net.NodeCoordinates(PressInds(2),1) net.NodeCoordinates(PressInds(2),2)];
        dp = p2-p1;
        quiver(p1(1),p1(2),dp(1),dp(2),0,'Color','#a3e2b2','LineWidth',3)
    end
end

% plot nodes
scatter3(net.NodeCoordinates(:,1),net.NodeCoordinates(:,2),net.NodeCoordinates(:,3),'k','filled','SizeData',15)
axis equal;
set(gca,'FontSize',14)
axis off;
axis square;
% ylim([-4,1])

end
