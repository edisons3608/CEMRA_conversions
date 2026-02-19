

function volshowMR(mrStruct)
    
    sx = mrStruct.vox(1);
    sy= mrStruct.vox(2);
    sz = mrStruct.vox(3);
    A = [sx 0 0 0; 0 sy 0 0; 0 0 sz 0; 0 0 0 1];

    tform = affinetform3d(A);

    volshow(mrStruct.dataAy,Transformation=tform);



end