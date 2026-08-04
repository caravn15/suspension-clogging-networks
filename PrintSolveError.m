function PrintSolveError(phErr,tol,it,iClog,iMax)

CmdWinSize = get(0, 'CommandWindowSize');
Width     = CmdWinSize(1);

if length(iClog) <= 50
    fprintf(repmat('-',[1,Width]));
end
fprintf('\n\n');

Msg1 = ['Iteration #',num2str(it),': error in volume fraction (phi) = ',num2str(phErr)];
fprintf(blanks(floor((Width - length(Msg1))/2)));
fprintf('%s\n', Msg1);

Msg3 = ['Iteration #',num2str(it),': number of clogs                = ',num2str(sum(iClog))];
fprintf(blanks(floor((Width - length(Msg1))/2)));
fprintf('%s\n', Msg3);

Msg4 = ['Iteration #',num2str(it),': number of pipes at max F       = ',num2str(sum(iMax))];
fprintf(blanks(floor((Width - length(Msg1))/2)));
fprintf('%s\n', Msg4);

if phErr < tol
    Msg = '############## converged ##############';
    fprintf(blanks(floor((Width - length(Msg))/2)));
    fprintf('%s\n', Msg);
else
    Msg = '############## did not converge ##############';
    fprintf(blanks(floor((Width - length(Msg))/2)));
    fprintf('%s\n', Msg);
end

fprintf('\n');
fprintf(repmat('-',[1,Width])); fprintf('\n');

end