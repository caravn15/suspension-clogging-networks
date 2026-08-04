function  [sol,nClogSweep] = LoadFig3(NumDivLines,NumDivSweeps,Da_v,phm,phinLines_v,phinLim,fld,fn)

% keep original filename
fnOg = fn;

%% load phin/R_2,4 parameter sweeps

% create grid points for R_2,4 and phin
phin_v     = linspace(phinLim(1),phinLim(2),NumDivSweeps);
R24_v      = linspace(1,0.001,NumDivSweeps);
[phin_M,~] = meshgrid(phin_v,R24_v);
phin_V     = phin_M(:);

for ii=1:length(Da_v)
    for jj=1:length(phin_V)

        % parameters
        Da    = Da_v(ii);
        phin  = phin_V(jj);

        % filename
        fn = [fnOg,'_consMultipler_',num2str(jj),'_Da_',num2str(Da),'_phin_',num2str(phin),'_phm_',num2str(phm)];
        
        % load file
        try
            load([fld,fn,'_clogging.mat'],'SolClog');
            nClogSweep{ii}(jj) = sum(SolClog.iClog)+sum(SolClog.iMax);
        catch
            nClogSweep{ii}(jj) = 3;
        end
    end
end

%% load data for line plots (F/Q etc.)

% parameters
Da = Da_v(2);

% create grid points for R_2,4
R24_v = linspace(1,0.001,NumDivLines);

for ii=1:length(phinLines_v)

    % parameters
    phin = phinLines_v(ii);

    for jj=1:length(R24_v)

        % filename for this simulation
        fn = [fnOg,'_sim_',num2str(jj),'_Da_',num2str(Da),'_phin_',num2str(phin),'_phm_',num2str(phm)];

        % load data
        load([fld,fn,'_clogging.mat'],'SolClog');
        load([fld,fn,'_newtonian.mat'],'SolNewt');

        % sort data to plot
        sol{ii}.QClog(:,jj)     = SolClog.Q;
        sol{ii}.QNewt(:,jj)     = SolNewt.Q;
        sol{ii}.FClog(:,jj)     = SolClog.F;
        sol{ii}.FMaxClog(:,jj)  = SolClog.FMax;
        sol{ii}.PhClog(:,jj)    = SolClog.ph;
        sol{ii}.PhMaxClog(:,jj) = SolClog.phMax;
        sol{ii}.PinClog(:,jj)   = SolClog.Pin;
        sol{ii}.PinNewt(:,jj)   = SolNewt.Pin;

    end
end

end

