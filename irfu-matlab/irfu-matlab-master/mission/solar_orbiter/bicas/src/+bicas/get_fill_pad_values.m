%
%
% ARGUMENTS
% =========
% Do        : dataobj object.
%
%
%
% RETURN VALUES
% =============
% fillValue : Empty if there is no fill value.
%
%
% Author: Erik P G Johansson, Uppsala, Sweden
% First created 2020-06-24 as a separate file, moved from bicas.executed_sw_mode.
%
function [fillValue, padValue] = get_fill_pad_values(Do, zVariableName)
    % NOTE: Uncertain how it handles the absence of a fill value. (Or is fill value mandatory?)
    % PROPOSAL: Remake into general-purpose function.
    % PROPOSAL: Remake into just using the do.Variables array?
    %    NOTE: Has to derive CDF variable type from do.Variables too.
    % PROPOSAL: Incorporate into dataobj?! Isn't there a buggy function/method there already?
    
    fillValue = getfillval(Do, zVariableName);        % NOTE: Special function for dataobj.
    % NOTE: For unknown reasons, the fill value for tt2000 zVariables (or at least "Epoch") is stored as a UTC(?) string.
    if strcmp(Do.data.(zVariableName).type, 'tt2000')
        fillValue = spdfparsett2000(fillValue);   % NOTE: Uncertain if this is the correct conversion function.
    end
    
    iZVariable = strcmp(Do.Variables(:,1), zVariableName);
    padValue   = Do.Variables{iZVariable, 9};
    % Comments in "spdfcdfinfo.m" should indirectly imply that column 9 is pad values since the structure/array
    % commented on should be identical.
end
