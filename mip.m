function mip(vol)
    
    if strcmp(class(vol),'struct')
        A = max(vol.dataAy,[],2);
        A = squeeze(A);
        vox = vol.vox;

        y = (0:size(A,1)-1) * vox(1);
        x = (0:size(A,2)-1) * vox(3);
        imagesc(x, y, A);
        axis image;
    elseif strcmp(class(vol),'string') || strcmp(class(vol),'char')
        info = niftiinfo(vol);
        A = double(niftiread(vol));
        A = max(A,[],2);
        A = squeeze(A);
        vox = info.PixelDimensions;

        y = (0:size(A,1)-1) * vox(1);
        x = (0:size(A,2)-1) * vox(3);
        imagesc(x, y, A);
        axis image;
    end