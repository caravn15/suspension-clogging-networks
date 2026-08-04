function F = GetFluxGivenPhi(prms,R,Q,ph)

phm  = prms.phm;
Da   = prms.Da;
etas = 1+ph.^2./((phm-ph).^2);
F    = Q*ph./((1+8*Da*etas/(R^2)));

end