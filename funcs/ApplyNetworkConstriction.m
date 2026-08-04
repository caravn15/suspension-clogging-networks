function [net,prms] = ApplyNetworkConstriction(net,prms,cons)

consMultipler   = cons.clogMultipler;
consInds        = cons.clogInds;
net.R(consInds) = consMultipler*net.R(consInds);

end