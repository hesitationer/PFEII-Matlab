% ce script a pour but de prouver que bien que deux matrices aient des
% valeurs identiques, leur type uint8 ou double, influe sur la façon dont
% matlab affiche l'image avec la fonction imshow(). Dans le cas d'une
% matrice de double, l'appel à imshow(image, []) fait afficher une image
% normalisée alors que ses valeurs ne le sont pas.

% 1.imshow sur image brute
a = imread('1.TIF');
imshow(a);
title('image uint8');

% 2.imshow sur image convertie en double, résultat visuellement identique à
% une normalisation, mais les valeurs de la matrice sont identiques
figure;
b = double(imread('1.TIF'));
imshow(b, []);
title('image double');

% 3.normalisation de a, qui ne peut se faire qu'avec un "cast" en double 
% car la fonction mean() n'accepte pas les uint8 (ce qui revient au meme
% que la lecture d'image précédente
figure;
c = (double(a) - double(mean(a(:))))/std(double(a(:)));
imshow(c, []);
title('image uint8 cast en double et normalisee');