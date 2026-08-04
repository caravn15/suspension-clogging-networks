function ph = CalculatePhiFromFlux(net,prms,pcf,iClog,indMax,F,R,Q)

phin = prms.phin;
ph   = zeros(net.NumEdges,1);
for ii=1:net.NumEdges

    % get flux curve
    [Fc,phv] = GetFluxCurveVessel(prms,pcf,R(ii),Q(ii));
    Fc       = abs(Fc);

    % calculate phi
    if iClog(ii) == 0
        if ii == 1
            ph(ii) = phin;
        else
            F_lower  = Fc(1:indMax(ii));
            ph_lower = phv(1:indMax(ii));
            [~,ind]  = min(abs(F_lower-F(ii)));
            ph(ii)   = ph_lower(ind);

        end
    else
        F_upper  = Fc(indMax(ii):end);
        ph_upper = phv(indMax(ii):end);
        [~,ind]  = min(abs(F_upper-F(ii)));
        ph(ii)   = ph_upper(ind);

    end
end

end