clearvars

dcmPath = 'D:\Zhen\Box Sync\Taeho_Shared\VR_Sim\PhilipsSimData\3DMRI_Vibe_201567885';

dcmT = dicomCollection(dcmPath);

md=dcmT.Modality;
 idx = find(contains(md,'mr','IgnoreCase',true));
 dcmMR = dcmT(idx, :);
 
 v = dicomreadVolume(dcmMR);
v = squeeze(v);

ffn =  dcmMR.Filenames{1}{1};
di = dicominfo(ffn);

data.v = v;
data.nRow = di.Rows;
data.cCol = di.Columns;
data.PS = di.PixelSpacing;
data.IPP = di.ImagePositionPatient;
data.SliceThickness = di.SliceThickness;

matPath = 'D:\Zhen\Box Sync\Taeho_Shared\VR_Sim\TestData_Philips_Cine';
matffn = fullfile(matPath, '3D');
save(matffn, 'data')