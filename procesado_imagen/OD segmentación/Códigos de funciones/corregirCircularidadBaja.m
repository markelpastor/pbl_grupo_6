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