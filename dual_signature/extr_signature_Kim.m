
% -------- Extraire la signature d'un bloc d'image ou d'une image
% -------- par la m�thode de Kim 2003 modifi�e ----------

% L'image ou bloc input est moyenn�e pour donner un bloc 8x8. 
% Une DCT est appliqu�e et la partie 6x6 est retenue.
% Les 35 valeurs r�elles |Ac| sont ordonn�es
% par ordre d�croissant pour donner la signature ordinale
% ou signature de Kim. 

function [signature] = extr_signature_Kim(im,lig,col)

% im: image ou bloc de luminance en double
% lig, col: nombre de lignes et de colonnes de im
% signature : vecteur de primitive formant la signature.Sa taille sera de
% 35 valeurs r�elles.


% Le nombre de blocs total doit �tre 8x8=64
% Bl, Bc: taille d'un bloc image en lignes et en colonnes
Bl = floor(lig / 8);  % Taille d'un bloc en lignes (doit �tre entier) 
Bc = floor(col / 8);  % Taille d'un bloc en colonnes (doit �tre entier) 
taille = Bl * Bc;

% Pour chaque bloc de l'image, extraire sa valeur moyenne, on obtient 8x8
% moyennes 
for i=1:1:8                       
   for j=1:1:8
       nl = (i-1) * Bl + 1;  % d�but d'un bloc BlxBc de la matrice im
       nc = (j-1) * Bc + 1;
       bloc=im(nl:nl+Bl-1,nc:nc+Bc-1); 
       somme = sum (bloc(:)); 
       moy(i, j) = somme / double(taille);  
   end
end

%Effectuer la DCT et garder la partie 6x6
DCTim= dct2(moy);
DCTim = DCTim(1:6,1:6);
% R�cup�rer la matrice DCTim sous forme de vecteur en ligne et en valeurs
% absolues
tmp = abs(DCTim(:)');
%tmp= round(tmp); % si on veut une signature � valeurs enti�res 

%R�cup�rer la signature priv�e du
%coefficient DC et tri� dans l'ordre d�croissant
signature = sort(tmp(2:end), 'descend');