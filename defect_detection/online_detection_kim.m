function [ marked_img ] = online_detection_kim( blocks, block_size, s_ref, eta, overlap )
% online_detection_kim compare un ensemble de bloc image a une signature de
% reference et marque le bloc defectueux en l'encadrant d'un rectangle noir
% l'image marqu�e est ensuite restitu�e
% param�tres
% blocks     : un cell contenant les blocs image
% block      : la taille des blocs (N*N)
% s_ref      : signature du signe du bloc de r�f�rence
% eta        : 
% overlap    : (o/n) si les blocs de l'image contiennent du recouvrement
% marked_img : image reconstruite avec les blocs d�fectueux marqu�s d'un
%              cadre noir

% dimensions de la matrice d'indexation
[blocks_h, blocks_w] = size(blocks);

block_tmp(1:block_size, 1:block_size) = 0;
distance(1:blocks_h, 1:blocks_w)     = 0;

% pour chaque bloc, extraction de la signature de Kim et calcul de la
% distance avec la signature de r�f�rence
for i=1:blocks_h
    for j=1:blocks_w
        block_tmp = blocks{i,j};
        s_tmp     = extr_signature_Kim(block_tmp, block_size, block_size);
        
        % distance de Manhattan entre les deux signatures
        distance(i,j) = sum(abs(s_ref - s_tmp));
    end
end

% calcul du seuil
alpha = median(distance(:)) + (eta * iqr(distance(:)));

% matrice image finale, si on utilise le recouvrement, on retranche � la
% taille de l'image l'exc�dant cr�� par le nombre de bloc de recouvrement
if(overlap)
    img_h = ceil((blocks_h+1)/2)*block_size;
    img_w = ceil((blocks_w+1)/2)*block_size;
else
    img_h = blocks_h*block_size;
    img_w = blocks_w*block_size;
end

marked_img(1:img_h, 1:img_w) = 0;

i_img = 1;
j_img = 1; % iterateurs de l'image

for i=1:blocks_h
    for j=1:blocks_w
        block_tmp = blocks{i,j};
        % reconstruction de l'image a partir d'un block marqu� ou non
        if(distance(i,j) > alpha)
            marked_img(i_img:i_img+block_size-1, j_img:j_img+block_size-1) = block_tmp(1:block_size, 1:block_size);
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