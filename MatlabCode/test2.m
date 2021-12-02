clearvars

fd = 'D:\Zhen\Box Sync\Taeho\Z_VR_Sim\DAT\data\Working';
% fn = 'PlanScanProt.dat';
fn = '1PlaneScanProt8FPS_sag.dat';

filename = fullfile(fd, fn);

fid = fopen( filename, 'rb' );
numberOfImages = 0;

maxSlice = 99999;
for itime = 1:1:maxSlice
    
    % How big is the header.
    % This is many ascii strings of dicom data.
    % We will parse for rows and columns
    headerSize = fread( fid, 1, 'int32' );
    
%     if headerSize == 0, break, end;
    % Or the header comes back with nothing in it.
    if isempty(headerSize), break, end;

     hdSize(itime) = headerSize;

    % How big is the data.
    dataSize = fread( fid, 1, 'int32' );
    dtSize(itime) = dataSize;
    
    % Read the ascii header data
    header = fread( fid, headerSize, 'int8' );
    [asciiDicomTags, count] = sscanf( char(header), '%s' );
    
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
    if numberOfImages == 0
        volume( 1:ysize, 1:xsize, 1 ) = 0;
        numberOfImages = numberOfImages + 1;
    else
        numberOfImages = numberOfImages + 1;
    end
    
    image = fread( fid, xsize*ysize, 'int16' );
    image = reshape( image, xsize, ysize );
    image = permute( image, [ 2 1 ] );
end
fclose(fid);

imshow(image, [])