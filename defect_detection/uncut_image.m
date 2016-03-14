function [ img ] = uncut_image( blocs, n_block, overlap )
% reconstitue un cell de blocs d'image en une image
% coupee avec cut_image_v2
% parametres
% blocs   : un cell de blocs.
% n_block : la taille des blocs
% overlap : (o/n) vrai si l'image a ete coupee avec recouvrement

[bloc_h bloc_w] = size(blocs); % taille de la matrice d'index

% calcul de la taille de l'image originale
% si le recouvrement à été utilisé, il faut enlever à la taille de l'image
% l'excédant ajouté 
if(overlap)
    img_h = ceil((bloc_h+1)/2)* n_block;
    img_w = ceil((bloc_w+1)/2)* n_block;
else
    img_h = bloc_h*n_block;
    img_w = bloc_w*n_block;
end

img(1:img_h, 1:img_w) = 0; % initiation de l'image rapide

i_img = 1;
j_img = 1; % image iterators - growing by n_bloc at each step

% si on a utilise le recouvrement, on ignore les blocs de recouvrement
% lors de la reconstruction
step = 1;
if(overlap)
    step = 2;
end

for i=1:step:bloc_h
    for j=1:step:bloc_w
        img(i_img: i_img-1+n_block, j_img: j_img-1+n_block) = blocs{i,j};
        j_img = j_img + n_block;
    end
    i_img = i_img + n_block;
    j_img = 1;
end
end