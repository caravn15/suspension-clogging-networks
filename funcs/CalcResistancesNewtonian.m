function [Res,InvRes] = CalcResistancesNewtonian(net,prms)

% unpack parameters
L        = net.L;
R        = net.R;
NumEdges = net.NumEdges;
phm      = prms.phm;
phin     = prms.phin;

% calculate viscosity from phin
etas     = 1+phin.^2./((phm-phin).^2);

% calculate resistance Res for each edge (and InvRes=1/Res)
Res    = zeros(NumEdges,1);
InvRes = zeros(NumEdges,1);

for ii=1:NumEdges
    Res(ii)    = 8*etas*L(ii)/(pi*R(ii)^4);
    InvRes(ii) = 1/Res(ii);
end

end