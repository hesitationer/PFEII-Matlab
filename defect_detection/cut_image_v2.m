function [blocks] = cut_image_v2(image, n_block, overlap, normalize)
% divise l'image donnee en blocs de taille n_block x n_block
% parametres
% image : le chemin du fichier image
% n_bloc : taille d'un bloc
% overlap : recouvrement (o/n), le recouvrement sera alors de n_block/2
% normalize : normalisation de l'image (o/n)
% retour
% blocks : un cell contenant chaque bloc image

img = double(imread(image));
if(normalize)
    norm_img = (img - mean(img(:))) / std(img(:));
    img = norm_img;
end

[img_height, img_width] = size(img); % dimensions de l'image

h_blocks = ceil(img_height/n_block); % dimensions du cell contenant les blocs
w_blocks = ceil(img_width/n_block);  % si recouvrement, on double la dimension -1

if(overlap)
    h_blocks = h_blocks + h_blocks - 1;
    w_blocks = w_blocks + w_blocks - 1;
end

% nous utilisons le cell comme une matrice index
% vers d'autres matrices (les blocs images)
blocks = cell(h_blocks, w_blocks); 

m = 1;
n = 1; %m et n sont les index de la matrice d'index

step = n_block;
if(overlap)
    step = ceil(n_block/2);
end

for i = 1:h_blocks
    for j =1:w_blocks
        blocks{i,j} = img( (i-1)*n_block+1: i*n_block, (j-1)*n_block+1: j*n_block);
    end
end

end