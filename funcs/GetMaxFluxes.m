function  [FMax,indMax,phMax] = GetMaxFluxes(net,prms,pcf,Q)

% unpack parameters
R        = net.R;
NumEdges = net.NumEdges;

% get max fluxes
FMax   = zeros(NumEdges,1);
indMax = zeros(NumEdges,1);
phMax  = zeros(NumEdges,1);
for ii=1:NumEdges
    [Fc,phv]              = GetFluxCurveVessel(prms,pcf,R(ii),Q(ii));
    [FMax(ii),indMax(ii)] = max(abs(Fc));
    phMax(ii)             = phv(indMax(ii));
end

end