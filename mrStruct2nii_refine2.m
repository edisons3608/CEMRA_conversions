function out = mrStruct2nii_refine2(in,exportName)
    cdir = pwd;
    if nargin < 1
      error('An input mrStruct file path is required.')
    end
    if nargin < 2
      [dd, exportName] = fileparts(in);
      exportName = exportName + ".nii";
    end
    
    mrStruct = load(in).mrStruct;
    info = load("header.mat").header;

    % Setting the sform matrix to an identity matrix for visualization in
    % 3D Slicer.
    rot = [0,0,-1;0,-1,0;1,0,0];
    trans = eye(4);
    trans(1:3,1:3) = rot;
    info.Transform.T = trans;

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
    vol = int16(mrStruct.dataAy);
    %on for image, off for mask
    %vol = flip(vol,1);
    info.ImageSize = size(vol);

    info.PixelDimensions = [mrStruct.vox(1) mrStruct.vox(2) mrStruct.vox(3)];

    niftiwrite(vol,exportName,info);


end