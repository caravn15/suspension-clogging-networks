function [Fc,phv] = GetFluxCurveVessel(prms,pcf,R,Q)

Da   = prms.Da;
phv  = pcf.phv;
etas = pcf.etas;
Fc   = Q*phv./(1+8*Da*etas/(R^2));

end
