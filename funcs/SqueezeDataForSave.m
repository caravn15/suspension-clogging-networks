function SolStrucNew = SqueezeDataForSave(SolStruc)

SolStrucNew.ph        = SolStruc.it.ph(:,end);
SolStrucNew.P         = SolStruc.it.P(:,end);
SolStrucNew.F         = SolStruc.it.F(:,end);
SolStrucNew.Q         = SolStruc.it.Q(:,end);
SolStrucNew.G         = SolStruc.it.G(:,end);
SolStrucNew.Pin       = SolStruc.it.Pin(:,end);
SolStrucNew.ResS      = SolStruc.it.ResS(:,end);
SolStrucNew.ResD      = SolStruc.it.ResD(:,end);
SolStrucNew.InvRes    = SolStruc.it.InvRes(:,end);
SolStrucNew.iMax      = SolStruc.it.iMax(:,end);
SolStrucNew.s         = SolStruc.it.s(:,end);
SolStrucNew.iClog     = SolStruc.it.iClog(:,end);
SolStrucNew.FMax      = SolStruc.it.FMax(:,end);
SolStrucNew.phMax     = SolStruc.it.phMax(:,end);

end

