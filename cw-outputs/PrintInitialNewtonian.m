function PrintInitialNewtonian()

CmdWinSize = get(0, 'CommandWindowSize');
Width     = CmdWinSize(1);

Msg = 'Running Newtonian solve';
fprintf(blanks(floor((Width - length(Msg))/2)));
fprintf('%s\n', Msg);

fprintf(repmat('-',[1,Width])); fprintf('\n');

end