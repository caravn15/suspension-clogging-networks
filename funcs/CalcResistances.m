function [ResS,ResD,InvRes] = CalcResistances(net,prms,pcf,ph)

% unpack parameters
L        = net.L;
R        = net.R;
Da       = prms.Da;
phm      = prms.phm;
NumEdges = net.NumEdges;

% calculate resistances for each edge (and InvRes=1/ResS+1/ResD)
ResS   = zeros(NumEdges,1);
ResD   = zeros(NumEdges,1);
InvRes = zeros(NumEdges,1);

for ii=1:NumEdges
    etas         = 1+ph(ii).^2./((phm-ph(ii)).^2);
    ResS(ii,1)   = (8*etas*L(ii))/(pi*R(ii)^4);
    ResD(ii,1)   = (L(ii))./(pi*Da*R(ii)^2);
    InvRes(ii,1) = 1/ResS(ii) + 1/ResD(ii);
end

end