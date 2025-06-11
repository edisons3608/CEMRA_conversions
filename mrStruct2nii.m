function out = mrStruct2nii(in,exportName)
    % Must be in the parent directory of the input mrStruct. Function will
    % write the respective output nifti in the parent directory.
    cdir = pwd;
    if nargin < 1
      error('An input mrStruct file path is required.')
    end
    if nargin < 2
      % If the export nifti filename is not specified, name the output
      % nifti the same as the input mrStruct filename
      [dd, exportName] = fileparts(in);
      exportName = exportName + ".nii";
    end
    
    mrStruct = load(in).mrStruct;
    info = load("header.mat").header;
    info.PixelDimensions = mrStruct.vox(1:3);

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
    vol = int16(mrStruct.dataAy);

    info.ImageSize = size(vol);
    niftiwrite(vol,exportName,info);


end