function  sol = LoadFig5(DataLoad,NumDiv,fld,fn)

% generate filename to load
DataLoadOg = erase(DataLoad,fn);

% create meshgrid for R_4,8 and R_9,10
RDiv      = linspace(1,0.001,NumDiv);
[R48_M,~] = meshgrid(RDiv,RDiv);
R48_v     = R48_M(:);

% load across all R_4,8 and R_9,10
for ii=1:length(R48_v)

    % generate filename to load
    DataLoad = [fn,'_sim_',num2str(ii),DataLoadOg];

    % load data
    load([fld,DataLoad,'_clogging.mat'],'SolClog');

    % sort data to plot (number of clogs/vessels at max - not including bypass)
    sol.nClog(ii) = sum(SolClog.iClog(1:9));
    sol.nMax(ii)  = sum(SolClog.iMax(1:9));

end

end