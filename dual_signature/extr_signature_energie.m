
% -------- Extraire la signature d'un bloc d'image ou d'une image
% -------- par la méthode de la norme L1 et l2 ----------

% L'input est un bloc image dont on calcule la norme L1 et L2
% qui sont des energies du signal
% La signature  est un vecteur à 2 composantes d'énergie 

function [signature] = extr_signature_energie(im, lig, col, taille_sign)

% im: image ou bloc de luminance en double
% lig, col: nombre de lignes et de colonnes de im
% taille de la signature désirée
% signature : vecteur de primitive formant la signature
imm=im(:)';  % transformer en vecteur colonne
m1= mean(abs(imm));  % norme L1
m2=sqrt(mean(imm.^2)); % norme L2

signature = [m1;m2]; % vecteur colonne;
end