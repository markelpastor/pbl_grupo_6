function [ROI,ROI_SinCaps]=ROI_manual(RGB, SinCaps)  
    source_coordinate = floor(size(RGB,1) / 3);
    initial_guess = [source_coordinate, source_coordinate, ...
    size(RGB,1) - 2 * source_coordinate, size(RGB,1) - 2 * source_coordinate];
    figure, imshow(RGB);
    title('Selecciona un rectángulo cerca del disco óptico y  haz doble click dentro de él');

    set(gcf, 'Position', get(0,'Screensize')); 
    h = imrect(gca, initial_guess);
    setFixedAspectRatioMode(h, 1);
    zoom = wait(h);
    
    [~, rect] = imcrop(RGB, zoom);
    rect = round(rect);
    ROI = RGB(rect(2) : rect(2) + rect(4), ...
        rect(1) : rect(1) + rect(3), :);
    ROI_SinCaps = SinCaps(rect(2) : rect(2) + rect(4), ...
        rect(1) : rect(1) + rect(3), :);

    close
end