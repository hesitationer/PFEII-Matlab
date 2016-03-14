
% -------- Extraire la signature d'un bloc d'image ou d'une image
% -------- par la méthode de ARNIA FITRI 2011 modifiée ----------

% L'image input est moyennée pour donner un bloc 8x8. Une DCT et un
% parcours zigzag sont appliqués et le signe est extrait.
% Un nombre (Taill_sign) de sigtnes est retenu comme
% signature du Signe ou ARNIA. 

function [signature] = extr_signature_Sign(im,lig,col,taille_sign)

% im: image ou bloc de luminance en double
% lig, col: nombre de lignes et de colonnes de im
% taille de la signature désirée
% signature : vecteur de primitive formant la signature

%Initialisation du parcours zigzag
zigzag=[1 3 4 10 11 21 22 36 2 5 9 12 20 23 35 37 6 8 13 19 24 34 38 49 7 14 18 25 33 39 48 50 15 17 26 32 40 47 51 58 16 27 31 41 46 52 57 59 28 30 42 45 53 56 60 63 29 43 44 54 55 61 62 64];

% Le nombre de blocs total doit être 8x8=64
% Bl, Bc: taille d'un bloc image en lignes et en colonnes
Bl = floor(lig / 8);  % Taille d'un bloc en lignes (doit être entier) 
Bc = floor(col / 8);  % Taille d'un bloc en colonnes (doit être entier) 
taille = Bl * Bc;
moy(1:8, 1:8) = 0;
% Pour chaque bloc de l'image, extraire sa valeur moyenne, on obtient 8x8
% moyennes 
for i=1:1:8                       
   for j=1:1:8
       nl = (i-1) * Bl + 1;  % début d'un bloc BlxBc de la matrice im
       nc = (j-1) * Bc + 1;
       bloc=im(nl:nl+Bl-1,nc:nc+Bc-1); 
       somme = sum (bloc(:)); 
       moy(i, j) = somme / double(taille);  
   end
end

%Effectuer la DCT
DCTim= dct2(moy);
% Utiliser le parcours en zigzag pour tranformer la DCT 8x8 en vecteur
% colonne de 64 signes (+1, -1 et 0)
m=0;
for i=1:1:8
    for j=1:1:8
        m = m+1;
        tmp(zigzag(m)) = sign(fix(DCTim(i, j)));
    end
end


signature = tmp(1:taille_sign);