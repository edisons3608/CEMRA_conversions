function out = overlaymr(image,mask)
    addpath 'imtool3D'
    tool = imtool3D(double(image.dataAy));
    setMask(tool,double(mask.dataAy));
    
end