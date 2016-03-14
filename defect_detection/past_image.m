function [ Im_rec, map ] = past_image(image,Struct, Hblocs, Wblocs)
%cette fonction permet de calculer la map finale de défauts et la colle sur
%l'image correspondante.
[h, w]= size(image);
map=zeros(h, w);

for i=1:Hblocs
    for j=1:Wblocs
        map(Struct(i,j).startH:Struct(i,j).endH,Struct(i,j).startW:Struct(i,j).endW)=map(Struct(i,j).startH:Struct(i,j).endH,Struct(i,j).startW:Struct(i,j).endW)+ Struct(i,j).map;
    end
end
map= (map>0);
map=double(map);

Im_rec=(map.*image);

end






