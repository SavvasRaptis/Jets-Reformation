%
% Return the value for the BIAS demultiplexer latching relay which, together
% with the demultiplexer mode, determines how BLTS channels and ASR signals are
% related.
%
% The latching relay state should ideally be obtained from telecommanding just
% like the bias currents, but this has not been implemented into the ROC
% pipeline and is not planned to be since the latching relay state is not
% expected to be changed unless a hardware failure (probe failure) occurs
% (2019-11-19). Therefore, the latching relay state is hard-coded until further
% notice
%
% NOTE: BIAS HK contains the value in HK_BIA_MODE_DIFF_PROBE (presumably). See
% BIAS specification, section "3.4.4.14 MODE", "Data D3 = Diff probe 1&2(0),
% Diff probe 1&3(1)"
%
%
% ARGUMENTS AND RETURN VALUE
% ==========================
% Epoch 
% dlrUsing12 : 0/1, false/true. Array same size as Epoch.
%               False=0 = Using diffs V13_DC, V13_AC
%               True =1 = Using diffs V12_DC, V12_AC
%               NOTE: The meaning of values follow the opposite convention
%               compared to BIAS specification.
%
%
% DEFINITIONS
% ===========
% DLR : Demultiplexer Latching Relay
% See bicas.calib.
%
%
% Author: Erik P G Johansson, IRF, Uppsala, Sweden
% First created 2019-11-18
%
function dlrUsing12 = demultiplexer_latching_relay(Epoch)
% PROPOSAL: SETTING for overriding.

    bicas.proc_utils.assert_zv_Epoch(Epoch)
    
    dlrUsing12 = ones(size(Epoch));
    
end
