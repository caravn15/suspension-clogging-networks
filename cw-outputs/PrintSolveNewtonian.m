function PrintSolveNewtonian(net,Q,G,QBal)

if length(net.R) > 50
    CmdWinSize = get(0, 'CommandWindowSize');
    Width      = CmdWinSize(1);
    Msg        = 'Finished!';
    fprintf(blanks(floor((Width - length(Msg))/2)));
    fprintf('%s\n', Msg);
else
    fprintf('Junction properties:\n\n');
    TableJunc = table(QBal(:),net.NumEdgePoints(net.InteriorNodeIndices),'VariableNames',...
        {'Q balance',' # vessels'},'RowName',string(1:net.NumPress));
    disp(TableJunc)

    fprintf('Pipe solutions:\n\n');

    TablePipes = table(round(Q,4),round(G,4),'VariableNames',...
        {'Q','G'},'RowName',string(1:length(net.L)));
    disp(TablePipes)
end

end