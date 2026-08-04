function pcf = PreCalcsFlux(prms)
    
phv      = linspace(0,prms.phm,1e5);         % vector for phi
etas     = 1+phv.^2./((prms.phm-phv).^2);    % viscosity over phi
pcf.phv  = phv;
pcf.etas = etas;

end
