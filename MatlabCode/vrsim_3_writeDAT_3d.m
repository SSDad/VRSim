clearvars

% dataPath = fullfile(fileparts(pwd), 'Data');
dataPath = 'D:\Zhen\Box Sync\Taeho_Shared\VR_Sim\TestData_Philips_Cine';

%% cine mat
fn = '3D.mat';
ffn_mat = fullfile(dataPath, fn);
load(ffn_mat)

nRow = size(data.v, 1);
nCol = size(data.v, 2);
nSlice = size(data.v, 3);
dataSize = nRow*nCol*2; 
SliceThickness = data.SliceThickness;
IPP = data.IPP;

%% DAT
fn = '3DPhilips.dat';
ffn_DAT = fullfile(dataPath, fn);

%% ascii header
fid = fopen( ffn_DAT, 'wb' );
load('3DHeader');

% nRow, nCol
[newTag] = fun_replaceTagValue(str_header, 'DICOM.NoOfCols', nCol, 'DICOM.NoOfRows');
[newTag] = fun_replaceTagValue(newTag, 'DICOM.NoOfRows', nRow, 'DICOM.SliceThickness');

% SliceThickness
[newTag] = fun_replaceTagValue(newTag, 'DICOM.SliceThickness', SliceThickness, 'DICOM.SliceLocation');

% DICOM.PixelSpacing.0 = 2.430556
% DICOM.PixelSpacing.1 = 2.430556
% DICOM.ColVec.0 = -0.000000
PS1 = data.PS(1);
PS2 = data.PS(2);
str_PS1 = sprintf('%0.6f', PS1);
str_PS2 = sprintf('%0.6f', PS2);
[newTag] = fun_replaceTagValue(newTag, 'DICOM.PixelSpacing.0', str_PS1, 'DICOM.PixelSpacing.1');
[newTag] = fun_replaceTagValue(newTag, 'DICOM.PixelSpacing.1', str_PS2, 'DICOM.ColVec.0');

% DICOM.PosVec.0 = 32.799999
% DICOM.PosVec.1 = 0.284722
% DICOM.PosVec.2 = 1.215278
% DICOM.TablePosition.0 = 0.000000
valPV{1} = 'DICOM.PosVec.0';
valPV{2} = 'DICOM.PosVec.1';
valPV{3} = 'DICOM.PosVec.2';
for n = 1:2
    PV = data.IPP(n);
    str_PV = sprintf('%0.6f', PV);
    [newTag] = fun_replaceTagValue(newTag, valPV{n}, str_PV, valPV{n+1});
end    

for iSlice = 1:nSlice
    
    % CONTROL.ChronSliceNo = 0
    % DICOM.SliceNo = 0
    [newTag] = fun_replaceTagValue(newTag, 'CONTROL.ChronSliceNo', iSlice, 'DICOM.SliceNo');
    
    SL = data.IPP(3)+SliceThickness*(iSlice-1);
    % SliceLocation
    [newTag] = fun_replaceTagValue(newTag, 'DICOM.SliceLocation', SL, 'DICOM.PixelSpacing.0');
    % DICOM.PosVec.2 = 1.215278
    % DICOM.TablePosition.0 = 0.000000
    [newTag] = fun_replaceTagValue(newTag, 'DICOM.PosVec.2', SL, 'DICOM.TablePosition.0');
    
    headerSize = length(newTag);      % write headerSize
    fwrite(fid, headerSize, 'int32');
    
    fwrite(fid, dataSize, 'int32');     % writedataSize
    
    fwrite(fid, newTag, 'int8');     % write tag
    
    I = data.v(:,:,iSlice);
    I = I';
    fwrite(fid, I(:), 'int16');
    
end
fclose(fid);

function [newTag] = fun_replaceTagValue(oldTag, KeyWord, val, FollowingKeyWord)
    len_kw = length(KeyWord);
    idx1 = strfind(oldTag, KeyWord);
    str1 = [oldTag(1:idx1+len_kw-1), ' = '];
    
    if isstring(val)
        str2 = val;
    else
        str2 = num2str(val);
    end
    
    idx2 = strfind(oldTag, FollowingKeyWord);
    str_rest = oldTag(idx2:end);

    newTag = [str1 str2 char(10) str_rest];
end
