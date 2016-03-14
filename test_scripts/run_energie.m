% image signatures functions path
addpath(genpath('..'));

block_size = 64;    % taille des blocs image
overlap    = true; % recouvrement entre les blocs image (de moitié)
normalize  = true;  % normalisation
eta        = 0.4;   %

% répertoires des images
free_img = cut_image_v2('../textile_images/Free/1.TIF', block_size, overlap, normalize);
s_ref    = extr_signature_energie(free_img{1,1}, 0, 0, 0);
defect_img_path = '../textile_images/Free/Defect/';
defect_img_dir  = dir(defect_img_path);
storage_dir_path = strcat('../test_results/defect-energie-', num2str(block_size),'-', num2str(int8(overlap)), '-', num2str(int8(normalize)), '-', num2str(eta));
mkdir(storage_dir_path);

[nb_image, gna] = size(defect_img_dir);
sbp = figure;    
for i=1:nb_image
    subplot(1, 2, 1);
    
    % decoupe image en bloc de taille block_size
    img_name = defect_img_dir(i,1).name;
    img_file = strcat(defect_img_path,img_name);
    
    test_img_blocks = cut_image_v2(img_file, block_size, overlap, normalize);
    imshow(uncut_image(test_img_blocks, block_size, overlap), []);
    
    marked_img = online_detection_ener(test_img_blocks, block_size, s_ref, eta, overlap);
    
    subplot(1, 2, 2);
    imshow(marked_img, []);
    print(sbp, '-dtiff', strcat(storage_dir_path, '/',img_name));
end
disp('done!');