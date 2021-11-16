%
% Set of "production functions", functions for producing one specific output
% dataset PDV from the necessary input dataset PDVs.
%
%
% DEFINITION: PRODUCTION FUNCTION
% ===============================
% A function with interface
%   OutputsMap = produce_*(InputsMap, Cal)
% with arguments and return values:
% Cal
%       A bicas.calib object.
% InputsMap
%       containers.Map with
%       <keys>   : String defining a name of an input ("prodFuncInputKey" in
%                  swmode_defs).
%       <values> : A struct with data corresponding to a CDF file
%                  (zVariables+global attributes).
% OutputsMap
%       containers.Map with
%       <keys>   : String defining a name of an output ("prodFuncOutputKey" in
%                  swmode_defs).
%       <values> : A struct with data corresponding to a CDF file (zVariables).
% --
% NOTE: In practice, anonymous functions with the correct interface are used to
% wrap the actual implementing functions (with another interface).
% --
% Production functions should not assume/specify any particular
% input dataset version, but read it out from global attributes (part of the
% PDV).
%
%
% Author: Erik P G Johansson, IRF, Uppsala, Sweden
% First created 2019-07-30
%
classdef proc
    % PROPOSAL: Other name of class.
    %   PROPOSAL: production
    %   PROPOSAL: processing
    %       TODO-DECISION: Name relationship to proc_sub, proc_utils?
    %           PROPOSAL: Rename proc_sub
    %               processing_functions
    %               processing_subfunctions
    %           PROPOSAL: Rename proc_utils
    %               processing_utils

    
    
    methods(Static, Access=public)
        
        
        
        % ARGUMENTS
        % =========
        % inputSciDsi      : The science input dataset will be interpreted as
        %                    having this DATASET_ID.
        %                    RATIONALE: InputDatasetsMap should contain the same
        %                    as a CDF global attribute but
        %                    (1) it could be missing, or
        %                    (2) sometimes one may want to read an ROC-SGSE
        %                        dataset as if it was an RODP dataset or the
        %                        other way around.
        %
        function [OutputDatasetsMap] = produce_L2_LFR(...
                InputDatasetsMap, rctDir, NsoTable, inputSciDsi, outputDsi, ...
                SETTINGS, L)
            
            InputHkCdf  = InputDatasetsMap('HK_cdf');
            InputCurCdf = InputDatasetsMap('CUR_cdf');
            InputSciCdf = InputDatasetsMap('SCI_cdf');

            %==============================
            % Configure bicas.calib object
            %==============================
            C = EJ_library.so.adm.classify_BICAS_L1_L1R_to_L2_DATASET_ID(inputSciDsi);
            useCtRcts = SETTINGS.get_fv('PROCESSING.L1R.LFR.USE_GA_CALIBRATION_TABLE_RCTS')   && C.isL1r;
            useCti2   = SETTINGS.get_fv('PROCESSING.L1R.LFR.USE_ZV_CALIBRATION_TABLE_INDEX2') && C.isL1r;
            
            if useCtRcts
                NonBiasRctDataMap = bicas.calib.find_read_non_BIAS_RCTs_by_CALIBRATION_TABLE(...
                    rctDir, 'LFR', ...
                    InputSciCdf.Ga.CALIBRATION_TABLE, ...
                    InputSciCdf.Zv.CALIBRATION_TABLE_INDEX, ...
                    InputSciCdf.Zv.BW, ...
                    L);
            else
                NonBiasRctDataMap = bicas.calib.find_read_non_BIAS_RCTs_by_regexp(...
                    rctDir, SETTINGS, L);
            end
            Cal = bicas.calib(NonBiasRctDataMap, rctDir, useCtRcts, useCti2, SETTINGS, L);
            
            %==============
            % Process data
            %==============
            HkSciTimePd           = bicas.proc_sub.process_HK_CDF_to_HK_on_SCI_TIME(InputSciCdf, InputHkCdf,  SETTINGS, L);
            InputSciCdf           = bicas.proc_sub.process_LFR_CDF_normalize(       InputSciCdf, inputSciDsi, SETTINGS, L);
            SciPreDc              = bicas.proc_sub.process_LFR_CDF_to_PreDC(        InputSciCdf, inputSciDsi, HkSciTimePd, SETTINGS, L);
            SciPostDc             = bicas.proc_sub.process_calibrate_demux(         SciPreDc, InputCurCdf, Cal,    SETTINGS, L);
            [SciPreDc, SciPostDc] = bicas.proc_sub.process_quality_filter_L2(       SciPreDc, SciPostDc, NsoTable, SETTINGS, L);
            OutputSciCdf          = bicas.proc_sub.process_PostDC_to_LFR_CDF(       SciPreDc, SciPostDc, outputDsi, L);
            
            
            
            OutputDatasetsMap = containers.Map();
            OutputDatasetsMap('SCI_cdf') = OutputSciCdf;
        end



        function [OutputDatasetsMap] = produce_L2_TDS(...
                InputDatasetsMap, rctDir, NsoTable, inputSciDsi, outputDsi, ...
                SETTINGS, L)
            
            InputHkCdf  = InputDatasetsMap('HK_cdf');
            InputCurCdf = InputDatasetsMap('CUR_cdf');
            InputSciCdf = InputDatasetsMap('SCI_cdf');
            
            %==============================
            % Configure bicas.calib object
            %==============================
            % NOTE: TDS L1R never uses CALIBRATION_TABLE_INDEX2
            C = EJ_library.so.adm.classify_BICAS_L1_L1R_to_L2_DATASET_ID(inputSciDsi);
            if C.isTdsCwf
                settingUseCt = 'PROCESSING.L1R.TDS.CWF.USE_GA_CALIBRATION_TABLE_RCTS';
                rctTypeId    = 'TDS-CWF';
            else
                settingUseCt = 'PROCESSING.L1R.TDS.RSWF.USE_GA_CALIBRATION_TABLE_RCTS';
                rctTypeId    = 'TDS-RSWF';
            end
            useCtRcts = SETTINGS.get_fv(settingUseCt) && C.isL1r;
            useCti2   = false;    % Always false for TDS.
            
            if useCtRcts
                NonBiasRctDataMap = bicas.calib.find_read_non_BIAS_RCTs_by_CALIBRATION_TABLE(...
                    rctDir, rctTypeId, ...
                    InputSciCdf.Ga.CALIBRATION_TABLE, ...
                    InputSciCdf.Zv.CALIBRATION_TABLE_INDEX, ...
                    [], ...   % =zv_BW (only for LFR).
                    L);
            else
                NonBiasRctDataMap = bicas.calib.find_read_non_BIAS_RCTs_by_regexp(...
                    rctDir, SETTINGS, L);
            end
            Cal = bicas.calib(NonBiasRctDataMap, rctDir, useCtRcts, useCti2, SETTINGS, L);
            
            %==============
            % Process data
            %==============
            HkSciTimePd           = bicas.proc_sub.process_HK_CDF_to_HK_on_SCI_TIME(InputSciCdf, InputHkCdf,  SETTINGS, L);
            InputSciCdf           = bicas.proc_sub.process_TDS_CDF_normalize(       InputSciCdf, inputSciDsi, SETTINGS, L);
            SciPreDc              = bicas.proc_sub.process_TDS_CDF_to_PreDC(        InputSciCdf, inputSciDsi, HkSciTimePd, SETTINGS, L);
            SciPostDc             = bicas.proc_sub.process_calibrate_demux(         SciPreDc, InputCurCdf, Cal, SETTINGS, L);
            [SciPreDc, SciPostDc] = bicas.proc_sub.process_quality_filter_L2(       SciPreDc, SciPostDc, NsoTable, SETTINGS, L);
            OutputSciCdf          = bicas.proc_sub.process_PostDC_to_TDS_CDF(       SciPreDc, SciPostDc, outputDsi, L);

            
            
            OutputDatasetsMap = containers.Map();
            OutputDatasetsMap('SCI_cdf') = OutputSciCdf;
        end
        
        
        
        function [OutputDatasetsMap] = produce_L3(...
                InputDatasetsMap, NsoTable, ...
                SETTINGS, L)
            
            InputLfrCwfCdf = InputDatasetsMap('LFR-SURV-CWF-E_cdf');

            %==============
            % Process data
            %==============
            [EfieldCdf,  EfieldDwnsCdf, ...
             ScpotCdf,   ScpotDwnsCdf, ...
             DensityCdf, DensityDwnsCdf] = ...
                bicas.proc_sub.process_L2_to_L3(InputLfrCwfCdf, SETTINGS, L);

            OutputDatasetsMap = containers.Map();
            OutputDatasetsMap('EFIELD_cdf')       = EfieldCdf;
            OutputDatasetsMap('EFIELD_DWNS_cdf')  = EfieldDwnsCdf;
            OutputDatasetsMap('SCPOT_cdf')        = ScpotCdf;
            OutputDatasetsMap('SCPOT_DWNS_cdf')   = ScpotDwnsCdf;
            OutputDatasetsMap('DENSITY_cdf')      = DensityCdf;
            OutputDatasetsMap('DENSITY_DWNS_cdf') = DensityDwnsCdf;
        end
        
        
        
    end    % methods(Static, Access=public)
    
    
    
end    % classdef
