function CheckNetworkForCycles(net,Q)

% extract edge indices and reverse their order based on Q values (required
% for digraph function)
edges         = net.EdgePressInds;
inds          = find(Q < 0);
NewPress      = fliplr(net.EdgePressInds(inds,:));
edges(inds,:) = NewPress;

% create a directed graph and check for cycles
G      = digraph(edges(:,1),edges(:,2));
cycles = allcycles(G);

% throw error if cycles exists 
if ~isempty(cycles)
    error('This network contains a cycle which is currently not supported.');
end

end