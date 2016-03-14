% image signatures functions path
addpath(genpath('..'));

block_size = 32;    % taille d'un bloc image
overlap    = false; % recouvrement
normalize  = false;  % normaliser l'image ou pas
eta        = 1.5;   % TBD
sign_size  = 12;    % taille de la signature (1 to 64)

free_img = cut_image_v2('../textile_images/Free/1.TIF', block_size, overlap, normalize);

im = free_img{1,1};
% if(~normalize)
%     im = double(im)-128;
% end

s_ref    = extr_signature_Sign(im, block_size, block_size, sign_size);
defect_img_path = '../textile_images/Defect/';
defect_img_dir  = dir(defect_img_path);
storage_dir_path = strcat('../test_results/defect-sign-', num2str(block_size),'-', num2str(int8(overlap)), '-', num2str(int8(normalize)), '-', num2str(eta), '-', num2str(sign_size));
%mkdir(storage_dir_path);

[nb_image, ~] = size(defect_img_dir);
%sbp = figure;
for i=1:nb_image
    if(~defect_img_dir(i,1).isdir)
        figure;
        subplot(1, 2, 1);

        % decoupe image en bloc de taille block_size
        img_name = defect_img_dir(i,1).name;
        img_file = strcat(defect_img_path,img_name);

        test_img_blocks = cut_image_v2(img_file, block_size, overlap, normalize);
        imshow(uncut_image(test_img_blocks, block_size, overlap), []);

        marked_img = online_detection_sign(test_img_blocks, block_size, s_ref, eta, overlap, normalize);

        subplot(1, 2, 2);
        imshow(marked_img, []);
        %print(sbp, '-dtiff', strcat(storage_dir_path, '/',img_name));
        %break;
    end
end
disp('done!');