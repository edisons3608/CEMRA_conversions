
function mip(vol)
    
    if strcmp(class(vol),'struct')
        A = max(mrStruct.dataAy,[],2);
        A = squeeze(A);
    
        image(A);
    elseif strcmp(class(vol),'string')
        A = double(niftiread(vol));
        A = max(A,[],2);
        A = squeeze(A);
        image(A);
    end




end