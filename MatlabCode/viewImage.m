clearvars

dataPath = 'D:\Zhen\Box Sync\Taeho_Shared\VR_Sim\TestData_Philips_Cine';
ffn = fullfile(dataPath, 'sag');
load(ffn)

v = cineData.v;
% imshow(v(:,:,1), [])

%%
scale = 4;

for n = 1:size(v, 3)
    I = v(:,:,n);
    I2 = imresize(I, scale);
    v2(:,:,n) = I2;
end


PS = cineData.PS/scale;

cineData.v = v2;
cineData.PS = PS;

ffn = fullfile(dataPath, 'sag4');
save(ffn, 'cineData')
