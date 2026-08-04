function [QBal,FBal] = CheckGlobalMassBalance(net,F,Q)

if isempty(F)

    % FBal not requested
    QBal = zeros(net.NumPress,1);
    for jj=1:net.NumPress

        % get interior pressure index
        PressInd = net.InteriorNodeIndices(jj);

        % incoming/outgoing edges
        IndsIn  = net.IndsInNode{PressInd};
        IndsOut = net.IndsOutNode{PressInd};

        % calculate FBal and QBal
        QBal(jj,1) = sum(abs(Q(IndsIn))) - sum(abs(Q(IndsOut)));

    end
    FBal = [];
else

    % FBal requested
    QBal = zeros(net.NumPress,1);
    FBal = zeros(net.NumPress,1);
    for jj=1:net.NumPress

        % get interior pressure index
        PressInd = net.InteriorNodeIndices(jj);

        % incoming/outgoing edges
        IndsIn  = net.IndsInNode{PressInd};
        IndsOut = net.IndsOutNode{PressInd};

        % calculate FBal and QBal
        FBal(jj,1) = sum(F(IndsIn)) - sum(F(IndsOut));
        QBal(jj,1) = sum(abs(Q(IndsIn))) - sum(abs(Q(IndsOut)));

    end
end

end