function [final_od_roi, final_od_roi_SinCaps,maskOD]=OD_manual(ROI, ROI_SinCaps)
    figure;
    the_fig = imshow(ROI);
    title('Mueve y ajusta el tamaño de la elipse para cubrir el área del disco óptico. Después haz doble click.');
    % maximize figure for better visualization
    set(gcf, 'Position', get(0,'Screensize')); 

    % mark the ellipse
    h = imellipse;
    wait(h);
    % generate the binary mask
    maskOD = createMask(h, the_fig);
    % assign the mask to its real position in the image
    final_od_roi = maskOD.*double(ROI);
    final_od_roi = uint8(final_od_roi);
    final_od_roi_SinCaps = maskOD.*double(ROI_SinCaps);
    final_od_roi_SinCaps = uint8(final_od_roi_SinCaps);
    close all;
end