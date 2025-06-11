function out = nii2mrStruct(in)

    [dd, fp] = fileparts(in);
    niiinf = niftiinfo(in);
    niiimg = niftiread(in);
    mrsi = struct;
    mrsi.mrStruct = mrstruct_init;
    %mrsi.mrStruct.dataAy = flip(flip(double(niiimg),1),2);
    mrsi.mrStruct.dataAy = double(niiimg);
    mrsi.mrStruct.vox = niiinf.PixelDimensions;
    mrsi.mrStruct.edges = niiinf.Transform.T.'; % from memory --correct ?
    mrsi.mrStruct.user = struct; mrsi.mrStruct.user.modality = 'CEMRA';
    %save(fullfile(dd,'mask_mag_struct.mat'),'-struct','mrsi');
    
    out = mrsi.mrStruct;

end