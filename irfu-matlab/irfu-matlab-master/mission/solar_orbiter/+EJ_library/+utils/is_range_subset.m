%
% If one regards a 1D vector of numeric values as defining a range (min to max), return whether is v1 a subset of
% v2.
%
%
% NOTE: Not necessarily proper subset, i.e. equality counts as subset.
%
%
% Author: Erik P G Johansson
% Initially created <2020-04-09.
%
function v1IsSubsetOfV2 = is_range_subset(v1, v2)
    
    EJ_library.assert.vector(v1)
    EJ_library.assert.vector(v2)
    
    v1IsSubsetOfV2 = (min(v2) <= min(v1)) && (max(v1) <= max(v2));   % NOTE: Equality counts as a subset.
end
