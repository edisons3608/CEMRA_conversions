function out = nii2mrStruct_refine(in,imgty)

    [dd, fp] = fileparts(in);
    niiinf = niftiinfo(in);
    niiimg = niftiread(in);
    mrsi = struct;
    mrsi.mrStruct = mrstruct_init;
    %mrsi.mrStruct.dataAy = flip(flip(double(niiimg),1),2);


    vol = flip(niiimg,3);
    vol = flip(vol,2);

    %on for image, off for mask.
    %vol = flip(vol,1);
    if imgty == 1
        vol = flip(vol,1);
    end

    vol = permute(double(vol),[3 2 1]);

    mrsi.mrStruct.dataAy = vol;
    mrsi.mrStruct.vox = [niiinf.PixelDimensions(3) niiinf.PixelDimensions(2) niiinf.PixelDimensions(1)];

    mrsi.mrStruct.edges = eye(4);
    mrsi.mrStruct.user = struct; mrsi.mrStruct.user.modality = 'CEMRA';
    %save(fullfile(dd,'mask_mag_struct.mat'),'-struct','mrsi');
    
    mrStruct = mrsi.mrStruct;
    save(fp+"_ES",'mrStruct','-v7.3')


end