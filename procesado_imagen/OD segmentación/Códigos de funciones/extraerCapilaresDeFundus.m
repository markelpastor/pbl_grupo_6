function [SinCaps, BW_opened]=extraerCapilaresDeFundus(RGB, histogram_capilares)
    G=RGB(:,:,2);
    G=double(G);
    G_in=G./255;
    G_contrasted = adapthisteq(G_in,'NumTiles',[64 64],'ClipLimit',0.01, 'Range','full');
    G_contrasted=medfilt2(G_contrasted,[15 15], 'symmetric');
    se = strel('disk',30);%35 pixeles es más o menos el diametro más grande de los capilares
    %tras hacer pruebas pillar 30 era mejor porque 35 cogía tb otras
    %estructuras (pillaba sombras y cosas, para coger todos los capilares me
    %interesarí, pero como solo quiero los principales con 25 voy que chuta)
    G_closed = imclose(G_contrasted,se);
    G_opened = imopen(G_closed,se);
    TopHat=G_contrasted-G_opened;
    
    TopHat_norm=(TopHat+1)/2;%para que este en el rango 0-1
    TopHat_norm=medfilt2(TopHat_norm);
    TopHat_norm=histeq(TopHat_norm,histogram_capilares);%le pongo esto para que su histograma se asemeje al de una imagen de la cual se ha podido extraer facilmente la vasculatura
    [counts, ~] = imhist(TopHat_norm,100);
    
    Umbral = otsuthresh(counts);
    BW=imbinarize(TopHat_norm, Umbral);
    
    se=strel("disk",7);
    BW_opened=imopen(BW,se);
    BW_opened=imclose(BW_opened,se);
    
    RGB=double(RGB);
    SinCaps=RGB.*BW_opened;
    
    [alto, ancho, ~]=size(SinCaps);
    margen=20;
    for x=margen+1:ancho-margen
        for y=margen+1:alto-margen
            if BW_opened(y,x)==0
                for i=1:3%pa los 3 color layers
                    muestra=SinCaps(y-margen:y+margen,x-margen:x+margen,i);
                    muestra(muestra==0)=[];
                    media=round(mean(muestra));
                    SinCaps(y,x,i) = media;
                end
            end
        end
    end
    
    SinCaps=uint8(SinCaps);
end