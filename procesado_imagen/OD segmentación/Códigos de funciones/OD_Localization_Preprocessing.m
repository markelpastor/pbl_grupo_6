function [RGB, alto_original, ancho_original]=OD_Localization_Preprocessing(RGB)
[alto_original, ancho_original, ~] = size(RGB);
RGB = imresize(RGB, [NaN, 3000], 'bicubic'); %Las imágenes tienen distinto tamaño, por lo que aquí igualo el ancho de todas

% Quito los artefactos que hay a veces
RGB_g=rgb2gray(RGB);
loNOnegro=RGB_g>10;
loNOnegro=imerode(loNOnegro, strel('disk',30));
loNOnegro=imdilate(loNOnegro, strel('disk',30));
RGB=double(RGB);
RGB=RGB.*loNOnegro;
RGB=uint8(RGB);

% Le paso un filtro para quitarle el ruido
RGB(:,:,1)=medfilt2(RGB(:,:,1),[3 3],"symmetric");
RGB(:,:,2)=medfilt2(RGB(:,:,2),[3 3],"symmetric");
RGB(:,:,3)=medfilt2(RGB(:,:,3),[3 3],"symmetric");
end