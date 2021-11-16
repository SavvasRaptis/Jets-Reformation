function res = mms_is_error(input)
%MMS_IS_ERROR  Check if functions returned error
%
% RES = MMS_IS_ERROR(INP)

% ----------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <yuri@irfu.se> wrote this file.  As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return.   Yuri Khotyaintsev
% ----------------------------------------------------------------------------

global MMS_CONST; if isempty(MMS_CONST), MMS_CONST = mms_constants(); end

if isnumeric(input) && numel(input)==1 && input==MMS_CONST.Error
  res = true;
else, res = false;
end