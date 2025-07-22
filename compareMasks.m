function [figh,dice] = compareMasks(mask1,mask2,labels)
%COMPAREMASKS This function is used to compare two masks from the same scan
%(ie the coordinates are the same, this code does NOT register the two
%masks, and expects the matrix size to be the same), plotting a 3D view
%showing the differences between the two masks. Expects the masks to be in
%the standard mask_struct format. All arguments are optional. If no masks
%are specified, the code will prompt the user to select each mask in a GUI.
%Plot labels can be input as a structure.
%
% Inputs:
%   - mask1 / mask2: structs: (optional) two masks from the same subject
%   and scan. The structs must have fields 'dataAy' and 'vox', where
%   'dataAy' is a 3D binary or logical array that specifies the mask, and
%   vox is a vector specifying the voxel size. The dataAy matrix should the 
%   same dimensions between the subject and the voxel sizes should be the 
%   same. If these are not specified, then the user will be prompted to 
%   select the files in a GUI. Can also specify the path to the mask struct 
%   mat file and they will be loaded
%   - labels: struct: (optional)
%       labels.title: the title for the plot [default: no title]
%       labels.mask1name: name of mask1 (for legend) [default: Mask 1]
%       labels.mask2name: name of mask2 (for legend) [default: Mask 2]
%
% Outputs:
%   - figh: a handle to the plotted figure
%   - dice: double: the dice score comparing the two masks (value 0 to 1)
%
% Example usage:
%   compareMasks() [Manually select masks in a GUI]
%   compareMasks(mask1path, mask2path)
%   compareMasks(mask1struct, mask2struct)
%   compareMasks(mask1path, mask2struct)
%   figh = compareMasks(mask1, mask2, labels)
%
% Mike Scott, 2019
% Markl Lab, Northwestern Radiology, Chicago

%% Input checking
if nargin < 1 || ischar(mask1)
    if nargin < 1
        % Ask the user for the first mask
        [file,path] = uigetfile('.mat','Select the first mask .mat file');
        mask1path = [path filesep() file];
        clear file path
    else
        % Set the path to be the input path
        mask1path = mask1;
    end
    
    % Load mask 1
    temp = load(mask1path);
    fields = fieldnames(temp);
    mask1 = temp.(fields{1});
    clear temp fields
end

if nargin < 2 || ischar(mask2)
    if nargin < 2
        % Ask the user for the second mask
        [file,path] = uigetfile('.mat','Select the second mask .mat file');
        mask2path = [path filesep() file];
        clear file path
    else
        % Set the path to be the input path
        mask2path = mask2;
    end
    
    % Load mask 1
    temp = load(mask2path);
    fields = fieldnames(temp);
    mask2 = temp.(fields{1});
    clear temp fields
end

if nargin < 3
    labels.mask1name = 'Mask 1';
    labels.mask2name = 'Mask 2';
end

% Make sure the masks are valid
if sum(strcmp(fieldnames(mask1), 'dataAy')) == 0
  % dataAy does not exist. Mask may have one extra layer of structure
    fields = fieldnames(mask1);
    mask1 = mask1.(fields{1});
    clear fields
    if sum(strcmp(fieldnames(mask1), 'dataAy')) == 0
       % Still no dataAy field, return an error
       error('Mask1 does not have a dataAy field, check the struct.')
    end
end 
% Make sure the masks are valid
if sum(strcmp(fieldnames(mask2), 'dataAy')) == 0
  % dataAy does not exist. Mask may have one extra layer of structure
    fields = fieldnames(mask2);
    mask2 = mask2.(fields{1});
    clear fields
    if sum(strcmp(fieldnames(mask2), 'dataAy')) == 0
       % Still no dataAy field, return an error
       error('Mask2 does not have a dataAy field, check the struct.')
    end
end 

%% Mask preparation
m1mask = mask1.dataAy;
m1vox = mask1.vox(1:3);
m2mask = mask2.dataAy;
m2vox = mask2.vox(1:3);

% Put a top/bottom on the mask. This closes any surface holes that are due
% to the lumen leaving the FOV
top = false(size(m1mask,1),size(m1mask,2));
m1mask = cat(3,top,m1mask,top);
m2mask = cat(3,top,m2mask,top);

% Generate isosurfaces
m1patch = isosurface(m1mask,0.5);
m2patch = isosurface(m2mask,0.5);

% Scale the patch based on the voxel size
m1patch.vertices(:,1) = m1patch.vertices(:,1)*m1vox(2);
m1patch.vertices(:,2) = m1patch.vertices(:,2)*m1vox(1);
m1patch.vertices(:,3) = m1patch.vertices(:,3)*m1vox(3);
m2patch.vertices(:,1) = m2patch.vertices(:,1)*m2vox(2);
m2patch.vertices(:,2) = m2patch.vertices(:,2)*m2vox(1);
m2patch.vertices(:,3) = m2patch.vertices(:,3)*m2vox(3);

% %% Plot the two masks overlaid
% figure(1)
% mss = patch(m1patch);
% mss.FaceColor = colors(1,:);
% mss.EdgeColor = 'none';
% mss.FaceAlpha = 0.7;
% hold on
% mc = patch(m2patch);
% mc.FaceColor = colors(2,:);
% mc.EdgeColor = 'none';
% mc.FaceAlpha = 0.7;
% axis equal
% axis ij
% axis off
% camlight('right')
% legend('Mask 1','Mask 2')
% 
% % Plot the two masks side by side
% figure(2)
% hax(1) = subplot(1,2,1);
% mss2 = patch(m1patch);
% mss2.FaceColor = colors(1,:);
% mss2.EdgeColor = 'none';
% mss2.FaceAlpha = 0.7;
% axis equal
% axis ij
% axis off
% camlight('right')
% 
% hax(2) = subplot(1,2,2);
% mc2 = patch(m2patch);
% mc2.FaceColor = colors(2,:);
% mc2.EdgeColor = 'none';
% mc2.FaceAlpha = 0.7;
% axis equal
% axis ij
% axis off
% camlight('right')
% 
% linkprop(hax, 'CameraPosition');

%% Subtract the masks and plot the difference map
subtracted = m1mask - m2mask;
m1bigger = subtracted > 0;
m2bigger = subtracted < 0;
% Generate patches for the new regions
m1bpatch = isosurface(m1bigger,0.5);
m2bpatch = isosurface(m2bigger,0.5);


% Plot the regions
figh = figure();
% Plot mask1
m1plot = patch(m1patch);
m1plot.FaceColor = [0.85 0.85 0.85];
m1plot.EdgeColor = 'none';
m1plot.FaceAlpha = 0.5;
% Plot the regions mask 1 is bigger (if any)
if ~isempty(m1bpatch.vertices)
    % Scale the patch based on the voxel size
    m1bpatch.vertices(:,1) = m1bpatch.vertices(:,1)*m1vox(2);
    m1bpatch.vertices(:,2) = m1bpatch.vertices(:,2)*m1vox(1);
    m1bpatch.vertices(:,3) = m1bpatch.vertices(:,3)*m1vox(3);
    m1b = patch(m1bpatch);
    m1b.FaceColor = [1 0 0];
    m1b.EdgeColor = 'none';
    m1b.FaceAlpha = 0.95;
end
% Plot the regions mask 1 is smaller (if any)
if ~isempty(m2bpatch.vertices)
    m2bpatch.vertices(:,1) = m2bpatch.vertices(:,1)*m1vox(2);
    m2bpatch.vertices(:,2) = m2bpatch.vertices(:,2)*m1vox(1);
    m2bpatch.vertices(:,3) = m2bpatch.vertices(:,3)*m1vox(3);
    m2b = patch(m2bpatch);
    m2b.FaceColor = [0 0 1];
    m2b.EdgeColor = 'none';
    m2b.FaceAlpha = 0.95;
end
axis equal
axis ij
axis off
camlight('right')
% Make sure the legend is correct (assumes masks are not exactly the same)
if isempty(m1bpatch.vertices)
    legend(labels.mask1name,[labels.mask2name ' Larger'])
elseif isempty(m2bpatch.vertices)
    legend(labels.mask1name,[labels.mask1name ' Larger'])
else
    legend(labels.mask1name,[labels.mask1name ' Larger'],[labels.mask2name ' Larger'])
end
% Add a title if one was specified
if sum(strcmp(fieldnames(labels), 'title')) == 1
    title(labels.title)
end
cameratoolbar

% Calculate the dice score
d_dice = m1mask(:);
m_dice = m2mask(:);
inter = sum(d_dice.*m_dice);
union = sum(d_dice) + sum(m_dice);
dice = (2*inter)/union;
end