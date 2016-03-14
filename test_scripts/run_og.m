% image signatures functions path
addpath(genpath('..'));

% img in Free path are all considred defect free. Just take the first block
% of the first image for initialize reference signature
block_size = 32;    % image will be cut in blocks of block_size x block_size
overlap    = 0;     % each block can overlap (+/-)
eta        = 0.5;   %TBD
nb_compo   = 1;     % ?
W          = 1;     % ?     
[aStruct, nBlocs, hBlocs, wBlocs] = cut_image('../textile_images/Free/1.TIF', block_size, overlap);

s_ref = extr_signature_Kim(aStruct.mat, block_size, block_size);
defect_img_path = '../textile_images/Free/Defect/';
defect_img_dir  = dir(defect_img_path);

[nb_image, gna] = size(defect_img_dir);

for i=1:nb_image
    figure;
    subplot(1, 2, 1);
    
    % cut image
    img_name = defect_img_dir(i,1).name;
    img_file = strcat(defect_img_path,img_name);
    
    [aStructest, anIm_rec, anImage, aSI, aD, anAlpha, aMap] = OnLine_Detection(img_file, block_size, overlap, W, S_mean, eta, nb_compo );
    % update plot position to show scanned image next to original image
    subplot(1, 2, 2);
    imshow(marked_img);
    break;
end