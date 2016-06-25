function c = getControls(primitives, pID)
% INPUTS
%   primitives:  k-by-3 array of controls where each row is [v, phi, t]
%   pID: index of desired primitive. If negative, negate velocity (drive in
%   reverse)

negate = sign(pID);
pID = abs(pID);

c = [negate*primitives(pID,1), primitives(pID,2), primitives(pID,3)];

end