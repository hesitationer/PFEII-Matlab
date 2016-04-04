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

for i = 1:bloc_h
    for j = 1:bloc_w
        img( (i-1)*n_block+1: i*n_block, (j-1)*n_block+1: j*n_block) = blocs{i,j};
    end
end

end