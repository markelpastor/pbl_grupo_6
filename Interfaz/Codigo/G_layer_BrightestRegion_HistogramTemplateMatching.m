function [IgT_cleaned, cc2]=G_layer_BrightestRegion_HistogramTemplateMatching(RGB,umbralBrightnessG,meanHistRGB,IrTE)
G=RGB(:,:,2);
BrightestReg = G>umbralBrightnessG*max(G(:));%Se ha decidido utilizar un umbral del 86% mediante una examinación experimental.
%En el segundo caso se utiliza un umbral de 60%
BrightestReg = imclose(BrightestReg, strel('disk', 100));
BrightestReg = imerode(BrightestReg, strel('disk', 10));

cc1 = bwconncomp(BrightestReg);

IgT_touched = false(size(BrightestReg));
for j = 1:cc1.NumObjects
% Comprobamos si alguno de los píxeles de los objetos tocan el borde del
% fundus
if any(IrTE(cc1.PixelIdxList{j}))
IgT_touched(cc1.PixelIdxList{j}) = true; % Marcamos como tocando
end
end
% Eliminamos los objetos qeu tocan la máscara. En algunos casos este paso
% va a conllevar una nula localización de la cabeza del nervio óptico (un
% 0,01% de las veces)
IgT_cleaned = BrightestReg - IgT_touched;

cc2 = bwconncomp(IgT_cleaned);
correlacion=zeros(1,cc2.NumObjects);
% En el caso de que se encuentres dos objetos, se hace tempalte
% matching para ver cual pertenece al OD

if cc2.NumObjects>1

L = bwlabel(IgT_cleaned,4);%se enumeran los objetos

for i=1:cc2.NumObjects %En este for voy a crear ventanas que capturen cada uno de los objetos y voy a analizar la correlación de cada uno de ellos.
objektua=L==i;
stats = regionprops(objektua,"Centroid","MajorAxisLength");

if stats.MajorAxisLength>1000
correlacion(i)=0;
else
centroideX=floor(stats.Centroid(1));
centroideY=floor(stats.Centroid(2));

margen_zoom=250;
if centroideY+margen_zoom>height(objektua)
centroideY=height(objektua)-margen_zoom;
elseif centroideY-margen_zoom<1
centroideY=margen_zoom+1;
end
if centroideX+margen_zoom>width(objektua)
centroideX=width(objektua)-margen_zoom;
elseif centroideX-margen_zoom<1
centroideX=margen_zoom+1;
end

margen_zoom=190;
dif=zeros(1,3);
for s=1:3
layer_zoom=RGB(centroideY-margen_zoom:centroideY+margen_zoom, centroideX-margen_zoom:centroideX+margen_zoom, s);
[hist_layer, ~] = imhist(layer_zoom);
dif(s)=sum(bsxfun(@minus, hist_layer, meanHistRGB(:,s)).^2);
end
c=1./(1+dif);
correlacion(i) = c(1).*tR + c(2).*tG + c(3);

end
end
[~, indx_max] = max(correlacion);
IgT_cleaned=L==indx_max;%Solo nos quedamos con el objeto con mayor correlación con el histograma de la plantilla guardada.
end
end