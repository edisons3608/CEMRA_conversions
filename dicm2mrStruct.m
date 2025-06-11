function out = dicm2mrStruct(in)
    addpath("/Users/edisonsun/CTA-segmentation/matlab_nu2/matlab_nu2/tools")
    addpath("/Users/edisonsun/CTA-segmentation/matlab_nu2/matlab_nu2/io")
    oo = dir(fullfile(in,'*.dcm')); %Folder Name of dicoms
    for ii = 1:numel(oo)
        temp = dicomread([oo(ii).folder '/' oo(ii).name]);
        dd = dicominfo([oo(1).folder '/' oo(1).name]);
        pix = dd.PixelSpacing;
        st = dd.SliceThickness;
        pix = [pix; st];
        imagePosRaw = dd.ImagePositionPatient;
        imageOrienRaw = dd.ImageOrientationPatient;

        edges = diag(diag(ones(4,4)));
        imageOrien = [imageOrienRaw(1) imageOrienRaw(4) imageOrienRaw(2); imageOrienRaw(5) imageOrienRaw(3) imageOrienRaw(6)]';
        edges(1:3,1) = imageOrien(:,1).*pix(1);
        aa = edges(2,1);
        edges(2,1) = edges(3,1);
        edges(3,1) = aa;
        edges(1:3,2) = imageOrien(:,2).*pix(2);
        edges(1:3,3) = -1*cross(edges(1:3,1)/norm(edges(1:3,1)), edges(1:3,2)/norm(edges(1:3,2))*pix(3));
%             cross(ret.edges(1:3,1)/norm(ret.edges(1:3,1)), ...
%                              ret.edges(1:3,2)/norm(ret.edges(1:3,2)))*...
%                              sum(ret.vox(3:4));
        edges(1:3,4) = imagePosRaw;
        edges(:,1:2) = flip(edges(:,1:2),2);
        edges = dicom_read_singlefile([oo(1).folder '/' oo(1).name],1); %Need matlab_nu
%             edges(2,2) = pix(2);
%             edges(2,2) = 0;
%             edges(3,3) = -pix(3);
%             edges(:,1:2) = flip(edges(:,1:2),2);
        try
        jj(:,:,ii) = double(temp);
        catch
            h = size(jj,1);
            w = size(jj,2);
            h1 = (h-size(temp,1))/2;
            w1 = (w-size(temp,2))/2;
            jj(h1+1:h-h1,w1+1:w-w1,ii) = temp;
        end
    end
    try
        %Change this path to a mrStruct dataset to use
    mrStruct = mrstruct_init;
    
    catch
        mrStruct = load([mr(1).folder '/' mr(1).name]);
    end
    pix = dd.PixelSpacing;
    st = dd.SliceThickness;
    pix = [pix; st];
    % jj = flip(jj,3); %Flip in z-directions
    mrStruct.dataAy = jj;
    mrStruct.vox = pix';
    mrStruct.edges = edges.edges;
%         mrStruct.edges = edges;
    clear jj
%         load('CT_struct.mat')
    
    %testing orientation error.
    %dataAy_perm = permute(mrStruct.dataAy, [2 1 3]);
    %mrStruct.dataAy = dataAy_perm;
    
    %P = eye(4);
    %P(1,1)=0;  P(1,2)=1;
    %P(2,1)=1;  P(2,2)=0;
    % (rows/cols 3 and 4 stay the same)
    
    % update edges by post-multiplying
    %E = mrStruct.edges;        % your old 4×4 numeric affine
    %mrStruct.edges = E * P;
    %vox_new = permute(mrStruct.vox,[2 1 3]);
    %mrStruct.vox = vox_new;
    
    out = mrStruct;
    %[parent,~,~] = fileparts(in);
    %save(fullfile(parent,'original_mrstruct'),'mrStruct','-v7.3')

    %The next line can generate the segmentation from txt file but
    %requires populating the inputs--look at mimics_to_mrstruct
    %function in matlab_nu for more details
%        [FileName, FilePath, mrstruct_path, mrstruct_mask] = mimics_to_mrstruct(['Z:\Radiology\Markl\CVGroup\data_imaging\cv_mri\Aorta-4D_Flow\Results\David\Aorta_CEMRA\new_patients\PT2453-WJ\CEMRA\all_grayvalues.txt'],['Z:\Radiology\Markl\CVGroup\data_imaging\cv_mri\Aorta-4D_Flow\Results\David\Aorta_CEMRA\new_patients\PT2453-WJ\CEMRA\ao_grayvalues.txt'],['Z:\Radiology\Markl\CVGroup\data_imaging\cv_mri\Aorta-4D_Flow\Results\David\Aorta_CEMRA\new_patients\PT2453-WJ\CEMRA\CT_struct.mat'],1,0);

%     end
end