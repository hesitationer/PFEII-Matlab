function [ dual_sign ] = extr_signature_dual( img, lig, col, taille_sign)
    % compute dual signature of a given image
    % ---- Input params
    % img : image to compute dual signature from, 
    % lig : not used - here for standard function signature
    % col : not used - here for standard function signature
    % taill_sgin : not used - here for standard function signature
    % ---- Output params
    % dual_sign : a cell of 2x1. First element is a 1:n line vector holding
    %             sign signature second element is a 2 rows column vector
    %             holding energie signature
    
    dual_sign = cell(1,2);
    % extract signatures
    ener_sign = extr_signature_energie(img, lig, col, taille_sign);
    sign_sign = extr_signature_Sign(img, lig, col, taille_sign);
    
    dual_sign{1,1} = ener_sign;
    dual_sign{1,2} = sign_sign;
end

