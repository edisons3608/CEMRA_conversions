# CEMRA nifti <=> mrStruct conversions

This document details the file structure and use cases for each conversion function.

---

## Table of Contents

1. [cemra_mrstruct.m](cemra_mrstruct.m)  
2. [dicm2mrStruct.m](dicm2mrStruct.m)  
3. [nii2mrStruct.m](nii2mrStruct.m)  
4. [overlaymr.m](overlaymr.m)
5. Refining Masks
6. [mrStruct2nii_refine.m](mrStruct2nii_refine.m) 
7. [nii2mrStruct_refine.m](nii2mrStruct_refine.m) 
8. Contact
---


## cemra_mrstruct.m

Background: Through 3D Slicer, manual segmentations are generated and exported as NIFTI. 

For standarization between images and masks, mrStruct is chosen.

The input DICOM CEMRA image is converted via [dicm2mrStruct.m](dicm2mrStruct.m), which is essentially a wrapper for "make_cemra_mrStruct.m" (the conversion script that has also been used for Mimics)

The NIFTI mask exported from 3D Slicer is converted via [nii2mrStruct.m](nii2mrStruct.m)

The cemra_mrstruct.m script simply aims to combine these processes.

---

## dicm2mrStruct.m

Takes an input DICOM folder path and returns an mrStruct object as a return value.

---

## nii2mrStruct.m 

Takes an input NIFTI volume filepath and returns a mrStruct object.

Copies the volume, voxel size, and affine transform.

## overlaymr.m

Visualizes an mask mrStruct overlaid on an image mrStruct.

Relies on the "imtool3D" package from the [MATLAB File Exchange](https://www.mathworks.com/matlabcentral/fileexchange/40753-imtool3d).

Arguments:
- image: image mrStruct with an expected dataAy
- mask: mask mrStruct with an expected dataAy

Does not take the affine transformation into account.

## Refining Masks

Background: There existed a need to modify previous manual CEMRA segmentations. However, these segmentations were performed in Mimics, and we cannot directly edit the grayvalues.txt in 3D Slicer.

As a result, there is a need to convert the CEMRA image mrStruct and mask mrStruct into respective NIFTI volumes to be able to be visualized in 3D Slicer.


## mrStruct2nii_refine.m




## Contact

Email: edisonsun2028@u.northwestern.edu

