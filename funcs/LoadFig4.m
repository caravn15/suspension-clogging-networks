function  [sol,fnFull] = LoadFig4(DataLoad,NumDiv,fld,fn)

% keep original filename
fnOg = fn;

% generate filename to load
DataLoadOg = erase(DataLoad,fn);

% create grid points for R_4,8
R48_v = linspace(1,0.001,NumDiv);

% load across all R_4,8
for ii=1:length(R48_v)

    % generate filename to load
    DataLoad = [fnOg,'_sim_',num2str(ii),DataLoadOg];

    % load data
    load([fld,DataLoad,'_clogging.mat'],'SolClog');
    load([fld,DataLoad,'_newtonian.mat'],'SolNewt');

    if ii == 1
        % get filename
        fnFull = erase(DataLoad,'_sim_1');
    end
    
    % sort data to plot
    sol.QClog(:,ii)    = SolClog.Q;
    sol.QNewt(:,ii)    = SolNewt.Q;
    sol.FClog(:,ii)    = SolClog.F;
    sol.FMaxClog(:,ii) = SolClog.FMax;
    sol.PinClog(:,ii)  = SolClog.Pin;
    sol.PinNewt(:,ii)  = SolNewt.Pin;
end

end

