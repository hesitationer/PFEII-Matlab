function [ marked_img ] = online_detection_ener( blocks, block_size, s_ref, eta, overlap )
% online_detection_ener compare un ensemble de bloc image a une signature
% de reference et marque le bloc defectueux en l'encadrant d'un rectangle
% noir l'image marquée est ensuite restituée
% paramètres
% blocks     : un cell contenant les blocs image
% block      : la taille des blocs (N*N)
% s_ref      : signature du signe du bloc de référence
% eta        : 
% overlap    : (o/n) si les blocs de l'image contiennent du recouvrement
% marked_img : image reconstruite avec les blocs défectueux marqués d'un
%              cadre noir

% dimension du cell des blocs images
[blocks_h, blocks_w] = size(blocks);

block_tmp(1:block_size, 1:block_size) = 0;
distance(1:blocks_h, 1:blocks_w) = 0;

% garde en mémoire la valeur minimale de l'image pour l'encadrement en noir
block_min_value = 255;

% for each block, extract energie signature and compute euclidian space
for i=1:blocks_h
    for j=1:blocks_w
        % block energie signature
        block_tmp = blocks{i,j};
        s_tmp     = extr_signature_energie(block_tmp, block_size, block_size, 0);
        
        % distance de manhattan
        distance(i,j) = sum( abs(s_ref - s_tmp) );
        
        if(block_min_value > min(block_tmp(:)))
            block_min_value = min(block_tmp(:));
        end
    end
end

% calcul du seuil
alpha = median(distance(:)) + (eta * iqr(distance(:)));

% motif d'un bloc défectueu
block_defect(1:block_size, 1:block_size) = block_min_value;

% matrice image finale, si on utilise le recouvrement, on retranche à la
% taille de l'image l'excédant créé par le nombre de bloc de recouvrement
if(overlap)
    img_h = ceil((blocks_h+1)/2)*block_size;
    img_w = ceil((blocks_w+1)/2)*block_size;
else
    img_h = blocks_h*block_size;
    img_w = blocks_w*block_size;
end

marked_img(1:img_h, 1:img_w) = 0;

i_img = 1;
j_img = 1; % image iterators - growing by n_bloc at each step

% mark defected blocks
for i=1:blocks_h
    for j=1:blocks_w
        block_tmp = blocks{i,j};
        
        % rebuild image from block or from defectious block
        if(distance(i,j) > alpha)
            block_defect(2:block_size-1, 2:block_size-1) = block_tmp(2:block_size-1, 2:block_size-1);
            marked_img(i_img:i_img-1+block_size, j_img: j_img-1+block_size) = block_defect;
        else
            marked_img(i_img:i_img-1+block_size, j_img: j_img-1+block_size) = block_tmp;
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