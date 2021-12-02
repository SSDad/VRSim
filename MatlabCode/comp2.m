clearvars

% fd = 'D:\Zhen\Box Sync\Taeho\Z_VR_Sim\DAT\data\Working';
fd = 'D:\Zhen\Box Sync\Taeho_Shared\VR_Sim\TestData_VR_WriteBack';

%% read
% fn = 'PlanScanProt.dat';
fn1 = 'PlanScanProt.dat';
fn2 = 'PlanScanProt_WriteBack.dat';
fn2 = 'PlanScanProt_Working.dat';
% fn1 = 'Gating_scan_5_2D_rad_FOV350_8FPS_th7_sag.dat';
% fn2 = 'Gating_scan_5_2D_rad_FOV350_8FPS_th7_sag_WriteBack2.dat';

ffn1 = fullfile(fd, fn1);
ffn2 = fullfile(fd, fn2);

visdiff(ffn1, ffn2, 'binary')

