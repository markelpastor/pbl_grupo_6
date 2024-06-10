function [area, entropiaROIG, ratio95_Ig, media, energia_total_cD, mean_cD]=featuresfinal(OD, ROI, ODmask, ancho_original)
    
    G=double(OD); 
    %area_Resize3000 = nnz(G);
    factor_resizing=ancho_original/3000;
    ODmask_originalSize = imresize(ODmask, [NaN, size(ODmask,2)*factor_resizing], 'bicubic');
    area=sum(ODmask_originalSize(:));
    [L,N] = superpixels(G,700, "NumIterations",50,"Compactness",10000);
    outputImage = zeros(size(G),'like',G);
    idx = label2idx(L);
    for labelVal = 1:N
        redIdx = idx{labelVal};
        outputImage(redIdx) = mean(G(redIdx));
    end
    max95=outputImage>max(outputImage(:)).*0.95;
    ratio95_Ig = nnz(max95)/nnz(outputImage);
    
    G_ROI=double(ROI(:,:,2));
    entropiaROIG=entropy(G_ROI);

    B_OD_segmented=OD(:,:,3);%canal azul
    
    
    Suma = sum(B_OD_segmented, 'all');
    NotZeros = nnz(ODmask);
    media = Suma / NotZeros; % Media de intensidad superior
        
         
        %las propdiedades wavelet:
        LAB=rgb2lab(OD);
        L=LAB(:,:,1);
        [~,~,~,cD_db3] = dwt2(L,'db3');
        [~,~,~,cD_sym3] = dwt2(L,'sym3');
        [~,~,~,cD_haar] = dwt2(L,'haar');
        [~,~,~,cD_bior3] = dwt2(L,'bior3.3');
        [~,~,~,cD_bior5] = dwt2(L,'bior3.5');
        [~,~,~,cD_bior7] = dwt2(L,'bior3.7');
        meancD_db3 = mean(cD_db3(:));
        meancD_sym3 = mean(cD_sym3(:));
        meancD_haar = mean(cD_haar(:));
        meancD_bior3 = mean(cD_bior3(:));
        meancD_bior5 = mean(cD_bior5(:));
        meancD_bior7 = mean(cD_bior7(:));
        % Calcula la media de todas las medias de los coeficientes diagonales
        mean_cD = mean([meancD_db3, meancD_sym3, meancD_haar, meancD_bior3, meancD_bior5, meancD_bior7]);
        % Calcula la energía de los coeficientes de detalle diagonal
        energia_cD_db3 = sum(cD_db3(:).^2);
        energia_cD_sym3 = sum(cD_sym3(:).^2);
        energia_cD_haar = sum(cD_haar(:).^2);
        energia_cD_bior3 = sum(cD_bior3(:).^2);
        energia_cD_bior5 = sum(cD_bior5(:).^2);
        energia_cD_bior7 = sum(cD_bior7(:).^2);
        % Calcula la energía media de todas las energías de los coeficientes diagonales
        energia_total_cD = mean([energia_cD_db3, energia_cD_sym3, energia_cD_haar, energia_cD_bior3, energia_cD_bior5, energia_cD_bior7]);
end