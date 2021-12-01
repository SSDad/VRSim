clearvars

%% read
dataPath = fullfile(fileparts(pwd), 'Data');
fn_org = 'Gating_scan_5_2D_rad_FOV350_8FPS_th7_sag.DAT';
ffn_DAT = fullfile(dataPath, fn_org);

fid = fopen( ffn_DAT, 'rb' );

maxSlice = 9999999;

% hF = figure(1); clf(hF);
% ax = axes('parent', hF);
for itime = 1:1:maxSlice
    
    % How big is the header.
    % This is many ascii strings of dicom data.
    % We will parse for rows and columns
    headerSize = fread( fid, 1, 'int32' );
    
    % File ends when they write a zero header size
%     if headerSize == 0
%         break
%     end
    % Or the header comes back with nothing in it.
    if isempty(headerSize)
        break
    end

    hdSize(itime) = headerSize;
    
    
    % How big is the data.
    dataSize = fread( fid, 1, 'int32' );
    dtSize(itime) = dataSize;
    
    % Read the ascii header data
    header = fread( fid, headerSize, 'int8' );
    [asciiDicomTags, count] = sscanf( char(header), '%s' );
    
    hds{itime} = header;
    tags{itime} = asciiDicomTags;
    
    % Find number of rows in the header
    rowStringLocation = strfind( asciiDicomTags, 'DICOM.NoOfRows' );
    rowStringLength = 15; % DICOM.NoOfRols=
    firstChar = rowStringLocation + rowStringLength;
    lastChar = firstChar + 5;
    if lastChar > length( asciiDicomTags )
        lastChar = length( asciiDicomTags );
    end
    ysizeChar = asciiDicomTags( firstChar: lastChar );
    ysize = sscanf( ysizeChar, '%d' );
    
    % Find number of columns in the header
    colStringLocation = strfind( asciiDicomTags, 'DICOM.NoOfCols' );
    colStringLength = 15; % DICOM.NoOfCols=
    firstChar = colStringLocation + colStringLength;
    lastChar = firstChar + 5;
    if lastChar > length( asciiDicomTags )
        lastChar = length( asciiDicomTags );
    end    
    xsizeChar = asciiDicomTags( firstChar: lastChar );
    xsize = sscanf( xsizeChar, '%d' );
    
    % DICOM.PosVec.0
    colStringLocation = strfind( asciiDicomTags, 'DICOM.PosVec.0' );
    colStringLength = 15; % length(DICOM.PosVec.0=)
    firstChar = colStringLocation + colStringLength;
    lastChar = firstChar + 5;
    if lastChar > length( asciiDicomTags )
        lastChar = length( asciiDicomTags );
    end    
%     keyboard    
    xsizeChar = asciiDicomTags( firstChar: lastChar );
    xloc(itime) = sscanf( xsizeChar, '%f' );

    % DICOM.PosVec.1
    colStringLocation = strfind( asciiDicomTags, 'DICOM.PosVec.1' );
    colStringLength = 15; % length(DICOM.PosVec.1=)
    firstChar = colStringLocation + colStringLength;
    lastChar = firstChar + 5;
    if lastChar > length( asciiDicomTags )
        lastChar = length( asciiDicomTags );
    end    
    xsizeChar = asciiDicomTags( firstChar: lastChar );
    yloc(itime) = sscanf( xsizeChar, '%f' );

    % DICOM.PosVec.2
    colStringLocation = strfind( asciiDicomTags, 'DICOM.PosVec.2' );
    colStringLength = 15; % length(DICOM.PosVec.2=)
    firstChar = colStringLocation + colStringLength;
    lastChar = firstChar + 5;
    if lastChar > length( asciiDicomTags )
        lastChar = length( asciiDicomTags );
    end    
    xsizeChar = asciiDicomTags( firstChar: lastChar );
    zloc(itime) = sscanf( xsizeChar, '%f' );
    
    % DICOM.SliceThickness = 5.000000 
    colStringLocation = strfind( asciiDicomTags, 'DICOM.SliceThickness' );
    colStringLength = 21; 
    firstChar = colStringLocation + colStringLength;
    lastChar = firstChar + 5;
    if lastChar > length( asciiDicomTags )
        lastChar = length( asciiDicomTags );
    end    
    xsizeChar = asciiDicomTags( firstChar: lastChar );
    sliceThick(itime) = sscanf( xsizeChar, '%f' );

    % DICOM.SliceLocation = 0.000000
    colStringLocation = strfind( asciiDicomTags, 'DICOM.SliceLocation' );
    colStringLength = 20; 
    firstChar = colStringLocation + colStringLength;
    lastChar = firstChar + 5;
    if lastChar > length( asciiDicomTags )
        lastChar = length( asciiDicomTags );
    end    
    xsizeChar = asciiDicomTags( firstChar: lastChar );
    sliceLocation(itime) = sscanf( xsizeChar, '%f' );

    % DICOM.PixelSpacing.0 = 3.515625
    colStringLocation = strfind( asciiDicomTags, 'DICOM.PixelSpacing.0' );
    colStringLength = 21; 
    firstChar = colStringLocation + colStringLength;
    lastChar = firstChar + 5;
    if lastChar > length( asciiDicomTags )
        lastChar = length( asciiDicomTags );
    end    
    xsizeChar = asciiDicomTags( firstChar: lastChar );
    pixelSpacing0(itime) = sscanf( xsizeChar, '%f' );
    
    % DICOM.PixelSpacing.1 = 3.515625
    colStringLocation = strfind( asciiDicomTags, 'DICOM.PixelSpacing.1' );
    colStringLength = 21; 
    firstChar = colStringLocation + colStringLength;
    lastChar = firstChar + 5;
    if lastChar > length( asciiDicomTags )
        lastChar = length( asciiDicomTags );
    end    
    xsizeChar = asciiDicomTags( firstChar: lastChar );
    pixelSpacing1(itime) = sscanf( xsizeChar, '%f' );
    
    fprintf( 'time=%05d position = %e %e %e %e %e %e\n', ...
        itime, xloc(itime), yloc(itime), zloc(itime),...
        sliceLocation(itime), pixelSpacing0(itime), pixelSpacing1(itime) );
    
    % If this is the first image, we must allocate the volume
%     if numberOfImages == 0
%         volume( 1:ysize, 1:xsize, 1 ) = 0;
%         numberOfImages = numberOfImages + 1;
%     else
%         numberOfImages = numberOfImages + 1;
%     end
    
    image = fread( fid, xsize*ysize, 'int16' );
    image = reshape( image, xsize, ysize );
    image = permute( image, [ 2 1 ] );
    
    v(:,:,itime) = image;
end
fclose(fid);

%% write back
nSlice = size(v, 3);
fn_wb = [fn_org(1:end-4), '_WriteBack.dat'];
ffn_wb = fullfile(dataPath, fn_wb);

fid = fopen( ffn_wb, 'wb' );

for iSlice = 1:nSlice
    
    % CONTROL.ChronSliceNo
    % CONTROL.ChronSliceNo=1DICOM.SliceNo
    fwrite(fid, hdSize(iSlice), 'int32');
    
    fwrite(fid, dtSize(iSlice), 'int32');     % writedataSize
    
    fwrite(fid, hds{iSlice}, 'int8');     % write tag
%     fwrite(fid, tags{iSlice}, 'int8');     % write tag
    
    data = v(:,:,iSlice);
    data = data';
    fwrite(fid, data(:), 'int16');
    
end
fclose(fid);
