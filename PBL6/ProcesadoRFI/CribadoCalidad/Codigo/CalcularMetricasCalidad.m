function [y1, y2, y3, y4, y5, y6] = CalcularMetricasCalidad(x)
    x = rgb2gray(x); % Convertir imagen a escala de grises.
    % Parametros para cuantificar el bajo contraste:
    y1 = entropy(x); % Calcular la entropia de la imagen.
    y2 = max((x(:))) - min((x(:))); % Calcular el rango dinámico de la imagen.
    y3 = std2(double(x(:))); % Calcular el contraste de la imagen

    % Calcular el máximo, la media y la desviación estándar de la Laplaciana de la imagen:
    laplacian = imfilter(double(x), fspecial('laplacian')); 
    y4 = max(laplacian(:));
    y5 = mean(laplacian(:));
    y6 = std(laplacian(:));
end