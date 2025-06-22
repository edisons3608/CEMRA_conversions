function out = overlaymr(image,mask)
    addpath(fullfile(fileparts(mfilename('fullpath')), 'imtool3D'));
    
    tool = imtool3D(double(image.dataAy));
    setMask(tool,double(mask.dataAy));
    
end