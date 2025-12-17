function clear_graphics_zone()
    global app_state;
    
    // Supprimer le placeholder
    h = findobj(app_state.figure_interface, 'tag', 'graphics_placeholder');
    if ~isempty(h) then
        try
            delete(h);
        catch
        end
    end
    
    // Supprimer tous les axes existants
    fig = app_state.figure_interface;
    all_children = fig.children;
    for i = length(all_children):-1:1
        try
            if all_children(i).type == 'Axes' then
                delete(all_children(i));
            end
        catch
        end
    end
    
    // Rendre le graphics_frame invisible
    graphics_frame = app_state.ui_elements.graphics_frame;
    if ~isempty(graphics_frame) then
        set(graphics_frame, 'visible', 'off');
    end
    
    // Définir axes_size = taille de la figure (PLEIN ÉCRAN)
    fig = app_state.figure_interface;
    fig_pos = get(fig, 'position');
    fig.axes_size = [fig_pos(3), fig_pos(4)];
    fig.background = [1 1 1];
endfunction

function axes_handle = create_subplot_in_zone(row, col, index, total_rows, total_cols)
    global app_state;
    
    fig = app_state.figure_interface;
    
    // Forcer axes_size = taille figure (plein écran)
    fig_pos = get(fig, 'position');
    fig.axes_size = [fig_pos(3), fig_pos(4)];
    
    // UTILISER la position du graphics_frame comme référence
    frame_pos = get(app_state.ui_elements.graphics_frame, 'position');
    frame_x_pix = frame_pos(1);
    frame_y_pix = frame_pos(2);
    frame_w_pix = frame_pos(3);
    frame_h_pix = frame_pos(4);
    
    // Dimensions de la figure
    fig_width_pix = fig_pos(3);
    fig_height_pix = fig_pos(4);
    
    // Marges intérieures et espacements 
    margin_h = 50;          // Marge horizontale 
    margin_v = 60;          
    spacing_h = 30;        
    spacing_v = 80;         
    title_space = 0;       
    
    // Espace disponible pour les graphiques
    available_width = frame_w_pix - 2*margin_h - (total_cols-1)*spacing_h;
    available_height = frame_h_pix - 2*margin_v - (total_rows-1)*spacing_v - title_space;
    
    // Dimensions d'un subplot
    subplot_width = available_width / total_cols;
    subplot_height = available_height / total_rows;
    
    // Position absolue du subplot EN PIXELS
    x_pixel = frame_x_pix + margin_h + (col-1)*(subplot_width + spacing_h);
    y_pixel = frame_y_pix + margin_v + (total_rows - row)*(subplot_height + spacing_v);
    
    // CONVERSION EN COORDONNÉES NORMALISÉES
    x_norm = x_pixel / fig_width_pix;
    y_norm = y_pixel / fig_height_pix;
    width_norm = subplot_width / fig_width_pix;
    height_norm = subplot_height / fig_height_pix;
    
    // Créer l'axe
    axes_handle = newaxes();
    axes_handle.parent = fig;
    axes_handle.axes_bounds = [x_norm, y_norm, width_norm, height_norm];
    
    // Configuration de l'axe avec fond transparent pour voir le blanc derrière
    axes_handle.background = -2;  // Transparent
    axes_handle.box = 'on';
    axes_handle.margins = [0.12, 0.12, 0.08, 0.12];
    axes_handle.visible = 'on';
    
    // Activer cet axe
    sca(axes_handle);
endfunction

function show_audio_results(time, original_signal, noisy_signal, filtered_signal, freq_fft, fft_noisy, fft_filtered)
    global app_state;
    
    fig = app_state.figure_interface;
    scf(fig);
    clear_graphics_zone();
    
    ax1 = create_subplot_in_zone(1, 1, 1, 2, 2);
    plot(time, noisy_signal, 'b', 'LineWidth', 1.5);
    xlabel('Temps (s)', 'fontsize', 3);
    ylabel('Amplitude', 'fontsize', 3);
    title('Signal Audio Bruité', 'fontsize', 5);
    xgrid();
    
    ax2 = create_subplot_in_zone(1, 2, 2, 2, 2);
    plot(freq_fft, fft_noisy, 'b', 'LineWidth', 1);
    plot(freq_fft, fft_filtered, 'r', 'LineWidth', 1.5);
    xlabel('Fréquence (Hz)', 'fontsize', 3);
    ylabel('Amplitude FFT', 'fontsize', 3);
    title('Spectre: Bruité vs Filtré', 'fontsize', 5);
    legend(['Bruité'; 'Filtré'], 'fontsize', 3);
    xgrid();
    
    ax3 = create_subplot_in_zone(2, 1, 3, 2, 2);
    plot(time, filtered_signal, 'r', 'LineWidth', 1.5);
    xlabel('Temps (s)', 'fontsize', 3);
    ylabel('Amplitude', 'fontsize', 3);
    title('Signal Audio Filtré', 'fontsize', 5);
    xgrid();
    
    ax4 = create_subplot_in_zone(2, 2, 4, 2, 2);
    plot(time, original_signal, 'g', 'LineWidth', 1);
    xlabel('Temps (s)', 'fontsize', 3);
    ylabel('Amplitude', 'fontsize', 3);
    title('Signal Original', 'fontsize', 5);
    xgrid();
    
    drawnow();
endfunction

function show_image_results(img_orig, img_noisy, img_denoised, img_sharpened)
    global app_state;
    
    fig = app_state.figure_interface;
    scf(fig);
    clear_graphics_zone();
    
    ax1 = create_subplot_in_zone(1, 1, 1, 2, 3);
    Matplot(img_orig');
    colormap(graycolormap(256));
    title('Image Originale', 'fontsize', 5);
    a = gca();
    a.isoview = 'on';
    a.tight_limits = 'on';
    
    ax2 = create_subplot_in_zone(1, 2, 2, 2, 3);
    Matplot(img_noisy');
    colormap(graycolormap(256));
    title('Image Floue et Bruitée', 'fontsize', 5);
    a = gca();
    a.isoview = 'on';
    a.tight_limits = 'on';
    
    ax3 = create_subplot_in_zone(1, 3, 3, 2, 3);
    histplot(256, double(img_noisy(:)));
    title('Histogramme Bruitée', 'fontsize', 5);
    xlabel('Niveau gris', 'fontsize', 3);
    
    ax4 = create_subplot_in_zone(2, 1, 4, 2, 3);
    Matplot(img_denoised');
    colormap(graycolormap(256));
    title('Après Filtre Médian', 'fontsize', 5);
    a = gca();
    a.isoview = 'on';
    a.tight_limits = 'on';
    
    ax5 = create_subplot_in_zone(2, 2, 5, 2, 3);
    Matplot(img_sharpened');
    colormap(graycolormap(256));
    title('Image Finale Accentuée', 'fontsize', 5);
    a = gca();
    a.isoview = 'on';
    a.tight_limits = 'on';
    
    ax6 = create_subplot_in_zone(2, 3, 6, 2, 3);
    histplot(256, double(img_sharpened(:)));
    title('Histogramme Traitée', 'fontsize', 5);
    xlabel('Niveau gris', 'fontsize', 3);
    
    drawnow();
endfunction

function show_ecg_results(time_vector, noisy_ecg, filtered_ecg, peak_times, peak_positions, mean_hr)
    global app_state;
    
    fig = app_state.figure_interface;
    scf(fig);
    clear_graphics_zone();
    
    ax1 = create_subplot_in_zone(1, 1, 1, 2, 1);
    plot(time_vector, noisy_ecg, 'b', 'LineWidth', 1);
    xlabel('Temps (s)', 'fontsize', 3);
    ylabel('Amplitude', 'fontsize', 3);
    title('ECG Bruité Original', 'fontsize', 5);
    xgrid();
    
    ax2 = create_subplot_in_zone(2, 1, 2, 2, 1);
    plot(time_vector, filtered_ecg, 'g', 'LineWidth', 1.5);
    if ~isempty(peak_positions) & length(peak_positions) <= length(filtered_ecg) then
        plot(peak_times, filtered_ecg(peak_positions), 'ro', 'MarkerSize', 7);
    end
    xlabel('Temps (s)', 'fontsize', 3);
    ylabel('Amplitude', 'fontsize', 3);
    title(sprintf('ECG Filtré avec R-Peaks - FC: %.1f BPM', mean_hr), 'fontsize', 5);
    xgrid();
    
    drawnow();
endfunction

function show_radar_results(time_vector, transmitted_signal, received_signal_noisy, lag_vector, correlation_vector, estimated_delay, estimated_distance)
    global app_state;
    
    fig = app_state.figure_interface;
    scf(fig);
    clear_graphics_zone();
    
    ax1 = create_subplot_in_zone(1, 1, 1, 3, 1);
    plot(time_vector, transmitted_signal, 'b', 'LineWidth', 1.5);
    xlabel('Temps (s)', 'fontsize', 3);
    ylabel('Amplitude', 'fontsize', 3);
    title('Signal Émis (Chirp)', 'fontsize', 5);
    xgrid();
    
    ax2 = create_subplot_in_zone(2, 1, 2, 3, 1);
    plot(time_vector, received_signal_noisy, 'r', 'LineWidth', 1);
    xlabel('Temps (s)', 'fontsize', 3);
    ylabel('Amplitude', 'fontsize', 3);
    title('Signal Reçu Bruité', 'fontsize', 5);
    xgrid();
    
    ax3 = create_subplot_in_zone(3, 1, 3, 3, 1);
    plot(lag_vector, correlation_vector, 'g', 'LineWidth', 1.5);
    
    [max_value_plot, idx_max] = find_maximum(correlation_vector);
    plot(estimated_delay, max_value_plot, 'ro', 'MarkerSize', 9);
    xlabel('Retard (s)', 'fontsize', 3);
    ylabel('Corrélation', 'fontsize', 3);
    title(sprintf('Intercorrélation - Distance: %.0f m', estimated_distance), 'fontsize', 5);
    xgrid();
    
    drawnow();
endfunction

function show_radio_results(transmitted_bits, received_bits, modulated_signal, filtered_signal, modulation_time, parameters, ber)
    global app_state;
    
    fig = app_state.figure_interface;
    scf(fig);
    clear_graphics_zone();
    
    ax1 = create_subplot_in_zone(1, 1, 1, 4, 1);
    plot(1:parameters.number_of_bits, transmitted_bits, 'b-o', 'LineWidth', 1.5, 'MarkerSize', 3);
    title('Bits Émis', 'fontsize', 5);
    xlabel('Index du bit', 'fontsize', 3);
    ylabel('Valeur', 'fontsize', 3);
    a = gca();
    a.data_bounds = [0, -0.2; parameters.number_of_bits+1, 1.2];
    xgrid();
    
    ax2 = create_subplot_in_zone(2, 1, 2, 4, 1);
    plot(modulation_time, modulated_signal, 'b', 'LineWidth', 1);
    xlabel('Temps (s)', 'fontsize', 3);
    ylabel('Amplitude', 'fontsize', 3);
    title('Signal Modulé (OOK)', 'fontsize', 5);
    xgrid();
    
    ax3 = create_subplot_in_zone(3, 1, 3, 4, 1);
    plot(modulation_time, filtered_signal, 'r', 'LineWidth', 1.5);
    xlabel('Temps (s)', 'fontsize', 3);
    ylabel('Amplitude', 'fontsize', 3);
    title('Signal Démodulé et Filtré', 'fontsize', 5);
    xgrid();
    
    ax4 = create_subplot_in_zone(4, 1, 4, 4, 1);
    plot(1:parameters.number_of_bits, received_bits, 'g-o', 'LineWidth', 1.5, 'MarkerSize', 3);
    
    error_indices = find(transmitted_bits ~= received_bits);
    if ~isempty(error_indices) then
        plot(error_indices, received_bits(error_indices), 'ro', 'MarkerSize', 5);
    end
    
    title(sprintf('Bits Reçus - BER: %.1f%%', ber*100), 'fontsize', 5);
    xlabel('Index du bit', 'fontsize', 3);
    ylabel('Valeur', 'fontsize', 3);
    a = gca();
    a.data_bounds = [0, -0.2; parameters.number_of_bits+1, 1.2];
    xgrid();
    
    drawnow();
endfunction
