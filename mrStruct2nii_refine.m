function out = mrStruct2nii_refine(in,imgty,exportName)
    cdir = pwd;
    if nargin < 1
      error('An input mrStruct file path is required.')
    end
    if nargin < 3
      [dd, exportName] = fileparts(in);
      exportName = exportName + ".nii";
    end
    
    mrStruct = load(in).mrStruct;
    info = load("header.mat").header;

    % Setting the sform matrix to an identity matrix for visualization in
    % 3D Slicer.
    info.Transform.T = eye(4);

    % CEMRA edges typically have shear, causing alignment issues in 3D Slicer. 
    % Uncommenting the line below might work for CTA though
    %info.Transform.T = mrStruct.edges.';

    info.Filename = [cdir '/' exportName];
    info.Filesize = 0;
    info.Description = '';
    info.Filemoddate = datetime('now');
    %info.Datatype = 'single';
    info.raw = struct;
    %if ~isempty(mrStruct.te) && ~isempty(mrStruct.tr)
    %    info.Description = ['te=' mrStruct.te ',' 'tr=' mrStruct.tr];
    %end

    % The template header assumes int16 
    vol = permute(int16(mrStruct.dataAy),[3 2 1]);
    vol = flip(vol,3);
    vol = flip(vol,2);
    %on for image, off for mask
    if imgty == 1
        vol = flip(vol,1);
    end
    info.ImageSize = size(vol);
    

    info.PixelDimensions = [mrStruct.vox(3) mrStruct.vox(2) mrStruct.vox(1)];

    niftiwrite(vol,exportName,info);


end