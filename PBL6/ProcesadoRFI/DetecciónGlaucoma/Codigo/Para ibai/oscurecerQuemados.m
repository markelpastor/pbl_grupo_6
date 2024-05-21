function [RGB_sinQuemado]=oscurecerQuemados(RGB, vignette)
RGB=double(RGB);
[alto_original, ancho_original, ~] = size(RGB);
vignette_redimensioned = imresize(vignette, [alto_original, ancho_original]);
vignette_redimensioned=vignette_redimensioned./max(vignette_redimensioned(:));
vignette_redimensioned=vignette_redimensioned.^0.2;%segun la berreketa que pongas aquí se va a oscurecer más. Elije un valor entre 0 y 1
vignette_redimensioned=vignette_redimensioned./max(vignette_redimensioned(:));
RGB_sinQuemado=RGB.*vignette_redimensioned;
RGB_sinQuemado=uint8(RGB_sinQuemado);
end