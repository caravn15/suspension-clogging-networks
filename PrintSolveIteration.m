function PrintSolveIteration(net,F,Q,G,ph,iClog,iMax,QBal,FBal,it)

CmdWinSize = get(0, 'CommandWindowSize');
Width     = CmdWinSize(1);

if length(iClog) > 50

else
    Msg = ['Iteration #',num2str(it)];
    fprintf(blanks(floor((Width - length(Msg))/2)));
    fprintf('%s\n', Msg);

    fprintf(repmat('-',[1,Width])); fprintf('\n\n');

    fprintf('Junction properties:\n\n');
    TableJunc = table(FBal(:),QBal(:),net.NumEdgePoints(net.InteriorNodeIndices),'VariableNames',...
        {'F balance','Q balance',' # vessels'},'RowName',string(1:net.NumPress));
    disp(TableJunc)

    fprintf('Pipe solutions:\n\n');

    TablePipes = table(round(F,4),round(Q,4),round(G,4),round(ph,4),iMax,iClog,'VariableNames',...
        {'F','Q','G','ph','iMax','iClog'},'RowName',string(1:length(net.L)));
    disp(TablePipes)
end

end