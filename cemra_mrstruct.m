% Edison Sun
% edisonsun2028@u.northwestern.edu
% Composes mrStructs for an input dicom CEMRA and input nifti (exported
% from 3D Slicer

id = 'PT1768-SB';
dicmfolder = '24_LAO_CEMRA';
in_orig = ['/Users/edisonsun/Documents/CEMRA Segmentation/' id '/' dicmfolder];
[parent,~,~] = fileparts(in_orig);

in_mask = ['/Users/edisonsun/Documents/CEMRA Segmentation/' id '/Segmentation.nii'];

orig = dicm2mrStruct(in_orig);
% assumes mask is in the parent directory of dicom folder.
mask = nii2mrStruct(in_mask);

orient = permute(mask.dataAy,[2 1 3]);
new_mask = flip(orient,3);

mask.edges = orig.edges;
mask.dataAy = new_mask;

mrStruct = orig;
save(fullfile(parent,'CEMRA_struct'),'mrStruct','-v7.3')
mrStruct = mask;
save(fullfile(parent,'CEMRA_aorta_grayvalues_mask_struct'),'mrStruct','-v7.3')


