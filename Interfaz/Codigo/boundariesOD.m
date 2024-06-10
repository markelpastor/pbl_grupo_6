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