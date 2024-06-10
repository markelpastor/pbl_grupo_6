function [OD, OD_ConCaps, maskOD, bordesOD, Validez]=ODsegmentation(ROI, RGB)  %RGB tiene que ser ROI_SinCaps
    
    R=uint8(RGB(:,:,1));
    LAB=rgb2lab(RGB);
    L=LAB(:,:,1);
    L=round(L);
    L=uint8(L);
    
    if isscalar(unique(R))% Antes tenía length(unique(R)) == 1
        Validez=6;
        % nombre_archivo = cell2mat(fullfile(OD_segmentation_bordesOD_pathM, T{k,1})); 
        % imwrite(ErrorLaimagenestanegraasiquenosepuedesegmentar, nombre_archivo);
        % nombre_archivo = cell2mat(fullfile(OD_segmentation_maskOD_pathM, T{k,1})); 
        % imwrite(ErrorLaimagenestanegraasiquenosepuedesegmentar, nombre_archivo);
        % nombre_archivo = cell2mat(fullfile(OD_segmentation_segmentedOD_pathM, T{k,1})); 
        % imwrite(ErrorLaimagenestanegraasiquenosepuedesegmentar, nombre_archivo);
       % continue;
    end

    nivelDeBorrosidad=50;
    sigmaCanny=150;
    thresholdCanny=[];
    primeraDilatacion=20;
    sizeClosing=40;
    sizeOpening=20;

    [bordesOD, maskOD, OD, NumOfObjects, objects, Area]=boundariesOD(R, RGB, nivelDeBorrosidad, sigmaCanny, thresholdCanny, primeraDilatacion, sizeClosing, sizeOpening);

    if (NumOfObjects == 1 && Area > 125000) && (NumOfObjects == 1 && objects.Circularity < 0.95)
        [bordesOD, maskOD, OD, NumOfObjects, objects, Area]=corregirCircularidadBaja(bordesOD, RGB);
    end


    Rmal=0;
    if (NumOfObjects ~= 1) || (NumOfObjects == 1 && Area < 125000) || ((NumOfObjects == 1 && objects.Circularity < 0.8))
        [bordesOD, maskOD, OD, NumOfObjects, objects, Area]=boundariesOD(L, RGB, nivelDeBorrosidad, sigmaCanny, thresholdCanny, primeraDilatacion, sizeClosing, sizeOpening);
        bordesOD_L=bordesOD;
        maskOD_L=maskOD;
        OD_L=OD;
        if (NumOfObjects == 1 && Area > 125000) && (NumOfObjects == 1 && objects.Circularity < 0.95)
           [bordesOD, maskOD, OD, NumOfObjects, objects, Area]=corregirCircularidadBaja(bordesOD, RGB);
        end
        if (NumOfObjects == 1 && objects.Circularity < 0.9)
              bordesOD=imclose(bordesOD_L, strel('disk', 100));
              bordesOD=imclose(bordesOD, strel('disk', 100));
              maskOD = imfill(bordesOD,'holes');%y relleno la circunferencia, consiguiendo as� la m�scara
              maskOD = imopen(maskOD, strel('disk',20));
              OD=double(RGB).*maskOD;%y lo multiplico por RGB para conseguir el OD
            OD=uint8(OD);
            objects = regionprops(maskOD,'Circularity','Area');
            NumOfObjects=height(objects);
            Area=sum(maskOD(:));
            bordesOD11=bordesOD;
            maskOD11=maskOD;
            if (NumOfObjects == 1 && objects.Circularity < 0.8)%Lo que voy a hacer ahora sirve para quitarme el problema de los tentáculos
              Rmal=1;
              bordesOD = bwmorph(bordesOD,'skel',100);
              maskOD = imfill(bordesOD,'holes');%y relleno la circunferencia, consiguiendo as� la m�scara
              maskOD=bwmorph(maskOD, 'majority',20);
              maskOD = imdilate(maskOD, strel('disk',90));%Porque al hacer skel se adelgaza. He puesto este disk más o menos porque no se exacto cuanto adelagaza
              objects = regionprops(maskOD,'Circularity','Area');
              NumOfObjects=height(objects);
              Area=sum(maskOD(:));
              if (NumOfObjects~=1) || (NumOfObjects == 1 && Area < 125000) || (NumOfObjects == 1 && objects.Circularity < 0.8)
                Rmal=2;
                bordesOD = bwmorph(bordesOD,'skel',Inf);
                EndPoints = bwmorph(bordesOD,'endpoints');
                [row_indices, col_indices] = find(EndPoints == 1);
                RoiPoly = roipoly(EndPoints,col_indices,row_indices);
                bordesOD=bordesOD11|RoiPoly;
                maskOD = imfill(bordesOD,'holes');%y relleno la circunferencia, consiguiendo as� la m�scara
                maskOD = imdilate(maskOD, strel('disk', 60));
                maskOD = imfill(maskOD,'holes');%esta linea y la anterior sirve para cerrar unos huecos que se quedan abiertos antes
                maskOD = imerode(maskOD, strel('disk', 60));
                objects = regionprops(maskOD,'Circularity','Area');
                NumOfObjects=height(objects);
                Area=sum(maskOD(:));
              end
              OD=double(RGB).*maskOD;%y lo multiplico por RGB para conseguir el OD
              OD=uint8(OD);
            end
        end
    end



    if NumOfObjects ~= 1 || (NumOfObjects == 1 && Area < 125000) || (NumOfObjects == 1 && objects.Circularity < 0.8) || (NumOfObjects == 1 && objects.Area > 640000)

    if NumOfObjects ~= 1
        Validez=1;
    elseif (NumOfObjects == 1 && Area < 125000)
        Validez=2;
    elseif (NumOfObjects == 1 && objects.Circularity < 0.85)
        Validez=4;
    elseif (NumOfObjects == 1 && objects.Area > 640000)
        Validez=5;
    end

    else
    Validez=0;

    end

    OD_ConCaps=double(ROI).*maskOD;
    OD_ConCaps=uint8(OD_ConCaps);
end

    function [bordesOD, maskOD, OD, NumOfObjects, objects, Area]=boundariesOD(R, RGB, nivelDeBorrosidad, sigmaCanny, thresholdCanny, primeraDilatacion, sizeClosing, sizeOpening)
    w2 = ones(nivelDeBorrosidad);
    R=double(R);
    Borrosa = imfilter(R, w2);
    edgesR=edge(Borrosa,"canny",thresholdCanny,sqrt(sigmaCanny));
    edgesRdil=imdilate(edgesR,strel('disk',primeraDilatacion));
    objetos = bwlabel(edgesRdil,8);
    if max(objetos(:))==1
        secondLargestIndex=1;
    else

    numPix_objeto=zeros(1, max(objetos(:)));
    
    for i=1:max(objetos(:))-1
        objeto_i=objetos==i;
        numPix_objeto(i)=sum(objeto_i(:));
    end
    
    sortedArray = sort(numPix_objeto, 'descend');
    secondLargestIndex = find(numPix_objeto == sortedArray(2));%Cogemos el segudo objeto ms grande porque el primero es un marco que se contruye en los bordes de la imagen el fondo no se cuenta porque su valor de la matriz es 0 y eso no se coge en el for 
    end

    if length(secondLargestIndex) > 1
        bordesOD=uint8(zeros(size(R)));
        maskOD=uint8(zeros(size(R)));
        OD=uint8(zeros(size(R)));
        objects = [];
        NumOfObjects=0;
        Area=0;
    
    else
        bordesOD=objetos==secondLargestIndex;%Aqu� consigo los bordes del OD, como a veces no esta la circunferencia cerrada le hago una dilatation.
        bordesOD=imclose(bordesOD, strel('disk',sizeClosing));
        maskOD = imfill(bordesOD,'holes');%y relleno la circunferencia, consiguiendo as� la m�scara
        maskOD = imopen(maskOD, strel('disk',sizeOpening));
        % if sqrt(sum(maskOD(:)))>900
        %     secondLargestIndex = find(LO_sum == sortedArray(1));
        %     bordesOD=L==secondLargestIndex;
        %     bordesOD=imclose(bordesOD, strel('disk',40));
        %     maskOD = imfill(bordesOD,'holes');
        %     maskOD = imopen(maskOD, strel('disk',sizeOpening));
        % end
        OD=double(RGB).*maskOD;%y lo multiplico por RGB para conseguir el OD
        OD=uint8(OD);
        objects = regionprops(maskOD,'Circularity','Area');
        NumOfObjects=height(objects);
        Area=sum(maskOD(:));
    end
end


function  [bordesOD, maskOD,OD, NumOfObjects, objects, Area]=corregirCircularidadBaja(bordesOD,RGB)
    bordesODdilated=imdilate(bordesOD,strel('disk',2));
    objects=bordesODdilated-bordesOD;
    L = bwlabel(objects,8);
    object_circularity=zeros(1, max(L(:)));
    object_area=zeros(1, max(L(:)));

    for i=1:max(L(:))%porque no voy a hacer con el 0
        mask_iteration=L==i;
        mask_iteration = imfill(mask_iteration,'holes');
        mask_iteration_properties = regionprops(mask_iteration,'Circularity');
        object_circularity(i)=mask_iteration_properties.Circularity;
        object_area(i)=sum(mask_iteration(:));
    end

    object_circularity(object_area<100000)=0;
    [~, indexOfMaxCircularity] = max(object_circularity);
    [~, indexOfMaxArea] = max(object_area);
    
    bordesOD=L==indexOfMaxCircularity;
    maskOD=imfill(bordesOD,'holes');
    
    if indexOfMaxCircularity==indexOfMaxArea
        maskOD=imerode(maskOD,strel('disk',20));
    else
        maskOD=imdilate(maskOD,strel('disk',20));
    end

    OD=double(RGB).*maskOD;
    OD=uint8(OD);

    objects = regionprops(maskOD,'Circularity','Area');
    NumOfObjects=height(objects);
    Area=sum(maskOD(:));
end