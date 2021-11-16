% Read raw BIAS standalone calibration table file (text file).
%
% Reads a file file on the format of the files generated by the actual BIAS
% standalone calibration campaign. It
% (1) reads the file's numeric table by disregarding comments, and labels the
% columns according to arguments.
% (2) interprets some of the comments as "registers" and extracts the values as
% strings together with associated comment strings.
%
% Example:
% """"""""
% mheader.reg1 0   : Unit ID
% mheader.reg5 D538,D535,D538,8022,801B,8016,03E7,8572,8572,8574,8590,1AE5,E987,04F0,0800,6A55   :HK data in hex 1 -16
% mheader.reg2 24.54   :Ambient temperature in C
% mheader.reg3 624.72   :Power status mW
% mheader.reg4 0   :Chamber status on/off_temp_set temp_deg/min
% mheader.reg6 0.001307   :Output offset at cal
% """"""""
%
%
% ARGUMENTS
% =========
% columnFieldNamesList
%       Cell array of strings, one per file table column (left to right).
%
%
% RETURN VALUE
% ============
% Data
%       Struct with one field per column and in addition the following fields.
%       X = any one of several numbers, depending on file contents.
%   .mheader.regX
%   .mheader.regX.valueStr
%   .mheader.regX.comment
%
%
% IMPLEMENTATION NOTE: Code needs to be able to handle files with different
% numbers of columns.
%
%
% Author: Erik P G Johansson, IRF, Uppsala, Sweden
% First created 2017-xx-xx (or possibly earlier)
%
function Data = read_BSACT_file(filePath, columnFieldNamesList)
    % PROPOSAL: Rewrite to read file once (not twice).
    % PROPOSAL: Assertion for not using column name "mheader".
    % PROPOSAL: Move columns to its own "sub-struct", e.g. ".columns".
    % PROPOSAL: Re-design to interpret list of row strings; add test code.
    
    
    %====================
    % Read numeric table
    %====================
    fId = fopen(filePath, 'r');
    % ASSERTION
    if fId == -1
        error(...
            'BICAS:read_BSACT_file:PathNotFound', ...
            'Can not open file "%s".', filePath)
    end
    % Format specification will read all numbers into one long 1D array.
    fileContents = textscan(fId, '%f', 'CommentStyle', 'mheader');
    fileContents = fileContents{1};
    fclose(fId);
    
    nColumns = length(columnFieldNamesList);
    
    % ASSERTION. Tries to check for the number of columns, but is not a perfect
    % test.
    if mod(length(fileContents), nColumns) ~= 0
        error(...
            'BICAS:read_BSACT_file:UnexpectedFileFormat', ...
            'Number of specificed columns does not match file contents.')
    end
    fileContents = reshape(fileContents, ...
        [nColumns, length(fileContents)/nColumns])';
    
    Data = struct;
    for iColumn = 1:nColumns
        fieldName = columnFieldNamesList{iColumn};
        Data.(fieldName) = fileContents(:, iColumn);
    end
    
    
    
    %===========================
    % Extract "register values"
    %===========================
    
    % Read file a second time(!)
    rowList = EJ_library.fs.read_text_file(filePath, '\r?\n');
    
    % Find relevant rows.
    temp = regexp(rowList, '^mheader\.reg[0-9]*');
    iRowList = find(~cellfun(@isempty, temp));
    
    % Extract values from relevant rows.
    mheader = [];
    for iRow = iRowList(:)'
        str = rowList{iRow};
        
        temp = regexp(str, 'reg[0-9]*', 'match');
        regName = temp{1};
        temp = regexp(str, ' [^:]*', 'match');
        valueStr = temp{1};
        temp = regexp(str, ':.*', 'match');
        temp = temp{1};
        comment = temp(2:end);
        
        s = [];
        s.valueStr = valueStr;
        s.comment  = comment;
        
        mheader.(regName) = s;
    end
    
    Data.mheader = mheader;
    
end
