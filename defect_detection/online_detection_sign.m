function [ marked_img ] = online_detection_sign( blocks, block_size, s_ref, eta, overlap, normalize)
% online_detection_sign compare un ensemble de bloc image a une signature de
% reference et marque le bloc defectueux en l'encadrant d'un rectangle noir
% l'image marquée est ensuite restituée
% paramètres
% blocks     : un cell contenant les blocs image
% block      : la taille des blocs (N*N)
% s_ref      : signature du signe du bloc de référence
% eta        : 
% overlap    : (o/n) si les blocs de l'image contiennent du recouvrement
% normalize  : (o/n) si la signature n'a pas été normalisée, on va 
%              recentrer les valeurs de l'image autour de 0 (retranche de
%              128)
% marked_img : image reconstruite avec les blocs défectueux marqués d'un
%              cadre noir

% dimension de la matrice d'index des blocs
[blocks_h, blocks_w] = size(blocks);

% taille de la signature du signe de reference
[~, sign_size] = size(s_ref);

% matrice temporaire pour contenir un bloc image et la distance entre
% la signature de reference et la signature du bloc temporaire
block_tmp(1:block_size, 1:block_size) = 0;
distance(1:blocks_h, 1:blocks_w) = 0; %

% garde en mémoire la valeur minimale de l'image pour l'encadrement en noir
block_min_value = 255;

% pour chaque bloc, extraction de sa signature de signe et calcul de la
% distance avec la signature de référence
for i=1:blocks_h
    for j=1:blocks_w
        block_tmp = blocks{i,j};
        
%         if(~normalize)
%             block_tmp = double(block_tmp) - 128;
%         end
        
        s_tmp = extr_signature_Sign(block_tmp, block_size, block_size, sign_size);
        distance(i,j) = sum( (s_ref-s_tmp)~= 0)/double(sign_size);
        
        if(block_min_value > min(block_tmp(:)))
            block_min_value = min(block_tmp(:));
        end
    end
end

% calcul du seuil alpha
alpha = median(distance(:)) + (eta * iqr(distance(:)));

% un bloc défectueux est encadré d'un carré noir
block_defect(1:block_size, 1:block_size) = block_min_value;

% matrice pour reconstituer l'image finale
% si on a utilisé le recouvrement, il faut retrancher l'excédant généré
% par les blocs supplémentaires
if(overlap)
    img_h = ceil((blocks_h+1)/2)*block_size;
    img_w = ceil((blocks_w+1)/2)*block_size;
else
    img_h = blocks_h*block_size;
    img_w = blocks_w*block_size;
end

marked_img(1:img_h, 1:img_w) = 0;

i_img = 1;
j_img = 1; % iterateurs pour l'image

% mark defected blocks
for i=1:blocks_h
    for j=1:blocks_w
        block_tmp = blocks{i,j};
        % rebuild image from block or from defectious block
        if(distance(i,j) > alpha)
            block_defect(2:block_size-1, 2:block_size-1) = block_tmp(2:block_size-1, 2:block_size-1);
            marked_img(i_img:i_img+block_size-1, j_img:j_img+block_size-1) = block_defect;
        end
        
        if(overlap)
            j_img = j_img + ceil(block_size/2);
        else
            j_img = j_img + block_size;
        end
    end
    
    if(overlap)
        i_img = i_img + ceil(block_size/2);
    else
        i_img = i_img + block_size;
    end
    j_img = 1;
end
end