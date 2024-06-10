function [OD_zoom1,OD_zoom2, Validez]=extraerROI(IgT_cleaned,modo,RGB,SinCaps)%modo=1 si quieres el ROI con capilares, modo=2 si quieres el ROI sin capilares o vacío si solo quieres saber los centroides originales y la validez
margen_zoomed=500;    

cc3 = bwconncomp(IgT_cleaned);
    
    if cc3.NumObjects==1
        Validez=1;%el ROI es localizable 99,98% de las ocasiones

        stats = regionprops(IgT_cleaned,"Centroid");
        centroideY=round(stats.Centroid(2));
        centroideX=round(stats.Centroid(1));

        %Para que el ROI entre en el marco de la imagen
        if centroideY+margen_zoomed>height(RGB)
            centroideY=height(RGB)-margen_zoomed;
        elseif centroideY-margen_zoomed<1
            centroideY=margen_zoomed+1;
        end
    
        if centroideX+margen_zoomed>width(RGB)
            centroideX=width(RGB)-margen_zoomed;
        elseif centroideX-margen_zoomed<1
            centroideX=margen_zoomed+1;
        end
    
        
        if exist('modo', 'var')
            if modo==1
            OD_zoom1=RGB(centroideY-margen_zoomed:centroideY+margen_zoomed,centroideX-margen_zoomed:centroideX+margen_zoomed,:);%conCaps
            OD_zoom2=[];%sinCaps
            OD_zoom1=uint8(OD_zoom1);
            elseif modo==2
            OD_zoom1=[];%conCaps
            OD_zoom2=SinCaps(centroideY-margen_zoomed:centroideY+margen_zoomed,centroideX-margen_zoomed:centroideX+margen_zoomed,:);%sinCaps
            OD_zoom2=uint8(OD_zoom2);
            
            elseif modo==3
            OD_zoom1=RGB(centroideY-margen_zoomed:centroideY+margen_zoomed,centroideX-margen_zoomed:centroideX+margen_zoomed,:);%conCaps
            OD_zoom2=SinCaps(centroideY-margen_zoomed:centroideY+margen_zoomed,centroideX-margen_zoomed:centroideX+margen_zoomed,:);%sinCaps
            OD_zoom1=uint8(OD_zoom1);
            OD_zoom2=uint8(OD_zoom2);
            end
        else
            OD_zoom1=uint8(zeros(1001,1001,3));
            OD_zoom2=uint8(zeros(1001,1001,3));
        end

    else
        OD_zoom1=uint8(zeros(1001,1001,3));
        OD_zoom2=OD_zoom1;
        Validez=0;%el ROI no es localizable 0,01% de las ocasiones
    end
end