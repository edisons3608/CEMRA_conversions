function out = overlaymr(image,mask)
    addpath(fullfile(fileparts(mfilename('fullpath')), 'imtool3D'));
    if nargin < 1
        error("Please provide at least an input volume.")
      
    end
    if nargin < 2
        %tool = imtool3D(double(image.dataAy));
        tool = imtool3D(double(image.dataAy));
    else
        %tool = imtool3D(double(image.dataAy));
        tool = imtool3D(double(image.dataAy));

        %setMask(tool,double(mask.dataAy));
        setMask(tool,double(mask.dataAy));
        
      
    end
    
end