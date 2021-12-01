clearvars

dataPath = fullfile(fileparts(pwd), 'Data');
fn = 'Gating_scan_5_2D_rad_FOV350_8FPS_th7_sag.DAT';
ffn = fullfile(dataPath, fn);

fid = fopen( ffn, 'rb' );

for itime = 1
    
    % How big is the header.
    % This is many ascii strings of dicom data.
    % We will parse for rows and columns
    headerSize = fread( fid, 1, 'int32' );
    
    % How big is the data.
    dataSize = fread( fid, 1, 'int32' );
    
    % Read the ascii header data
    header = fread( fid, headerSize, 'int8' );
    [asciiDicomTags, count1] = sscanf( char(header), '%s' );
    
    [str_header, count2] = sscanf( char(header), '%c' );
    
%     tags{itime} = asciiDicomTags;
%     hds{itime} = header;
    
end
fclose(fid);

save('asciiDicomTags', 'asciiDicomTags', 'str_header');