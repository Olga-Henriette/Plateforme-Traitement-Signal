// =========================================================================
// Fonctions d'affichage des graphiques et des messages
// =========================================================================

function create_results_figure(title_string, figure_number)
    global app_state;
    
    // Fermer l'ancienne figure de résultats si elle existe
    if ~isempty(app_state.figure_results) then
        try
            close(app_state.figure_results);
        catch
        end
    end
    
    // Créer la nouvelle figure
    figure_handle = figure(figure_number, 'figure_name', title_string, ...
                            'position', [50, 50, 1000, 700], ...
                            'background', [0.95 0.95 0.95]);
                            
    app_state.figure_results = figure_handle;
    
    // Forcer le rafraîchissement de l'interface
    // Ceci s'assure que la fenêtre de résultats est bien ouverte avant que les
    // calculs lourds ne bloquent l'UI principale.
    drawnow(); 
endfunction

function show_audio_results(time, original_signal, noisy_signal, filtered_signal, freq_fft, fft_noisy, fft_filtered)
    // fonction d'affichage pour le module Audio 
    create_results_figure('Theme 1 : Audio - Resultats du Filtrage', 1);

    subplot(3, 2, [1, 3]);
    plot(time, noisy_signal, 'b');
    xlabel('Temps (s)');
    ylabel('Amplitude');
    title('Signal Audio Bruite (Temporel)');
    xgrid();

    subplot(3, 2, [2, 4]);
    plot(freq_fft, fft_noisy, 'b');
    plot(freq_fft, fft_filtered, 'r');
    xlabel('Frequence (Hz)');
    ylabel('Amplitude FFT');
    title('Spectre - Bruite (Bleu) vs. Filtre (Rouge)');
    legend('Bruite', 'Filtre');
    xgrid();

    subplot(3, 2, [5, 6]);
    plot(time, filtered_signal, 'r');
    xlabel('Temps (s)');
    ylabel('Amplitude');
    title('Signal Audio Filtre (Temporel)');
    xgrid();
endfunction

function show_image_results(img_orig, img_noisy, img_denoised, img_sharpened) 
    // fonction d'affichage pour le module Image 
    create_results_figure('Theme 2 : Image Medicale - Amelioration', 2);
    
    // Les fonctions de base Scilab pour l'image sont 'imshow' ou 'xset("colormap",...) + grayplot'
    
    // Image 1: Originale
    subplot(2, 3, 1);
    imshow(img_orig);
    title('1. Image originale (Cible)');
    
    // Image 2: Floue et Bruitee
    subplot(2, 3, 2);
    imshow(img_noisy);
    title('2. Image floue et bruitee');
    
    // Image 3: Histogramme Bruitee
    subplot(2, 3, 3);
    histplot(0:255, img_noisy(:));
    title('Histogramme - Bruitee');
    
    // Image 4: Apres filtre median
    subplot(2, 3, 4);
    imshow(img_denoised);
    title('3. Apres filtre median');
    
    // Image 5: Image finale accentuee
    subplot(2, 3, 5);
    imshow(img_sharpened);
    title('4. Image finale accentuee');
    
    // Image 6: Histogramme Traitee
    subplot(2, 3, 6);
    histplot(0:255, img_sharpened(:));
    title('Histogramme - Traitee');

    // Il faut s'assurer que les images sont au bon format (e.g., uint8) pour imshow.
endfunction

function show_ecg_results(time_vector, noisy_ecg, filtered_ecg, peak_times, peak_positions, mean_hr) // afficher_resultats_ecg
    // fonction d'affichage pour le module ECG (process_ecg.sci)
    create_results_figure('Theme 3 : ECG - Detection R-Peaks', 3);
    
    subplot(2,1,1);
    plot(time_vector, noisy_ecg, 'b');
    xlabel('Temps (s)');
    ylabel('Amplitude');
    title('ECG bruite original');
    xgrid();
    
    subplot(2,1,2);
    plot(time_vector, filtered_ecg, 'g');
    if ~isempty(peak_positions) then
        // Ajouter les cercles aux positions des pics
        plot(peak_times, filtered_ecg(peak_positions), 'ro', 'MarkerSize', 8);
    end
    xlabel('Temps (s)');
    ylabel('Amplitude');
    title(sprintf('ECG filtre avec R-peaks detectes - FC : %.1f BPM', mean_hr));
    xgrid();
endfunction

function show_radar_results(time_vector, transmitted_signal, received_signal_noisy, lag_vector, correlation_vector, estimated_delay, estimated_distance)
    create_results_figure('Theme 4 : Radar - Estimation de Distance', 4);
    
    subplot(3,1,1);
    plot(time_vector, transmitted_signal, 'b');
    xlabel('Temps (s)');
    ylabel('Amplitude');
    title('Signal emis (Chirp)');
    xgrid();
    
    subplot(3,1,2);
    plot(time_vector, received_signal_noisy, 'r');
    xlabel('Temps (s)');
    ylabel('Amplitude');
    title('Signal recu bruite');
    xgrid();
    
    subplot(3,1,3);
    plot(lag_vector, correlation_vector, 'g');
    
    // CORRECTION: En Scilab, ne pas utiliser ~ pour ignorer des valeurs
    // Option 1: Récupérer toutes les valeurs
    [max_value_plot, idx_max] = trouver_maximum(correlation_vector);
    
    // Ou Option 2 (plus simple): Utiliser directement max()
    // max_value_plot = max(correlation_vector);
    
    plot(estimated_delay, max_value_plot, 'ro', 'MarkerSize', 8);
    
    xlabel('Retard (s)');
    ylabel('Correlation');
    title(sprintf('Intercorrelation - Distance estimee : %.0f m', estimated_distance));
    xgrid();
endfunction

function show_radio_results(transmitted_bits, received_bits, modulated_signal, filtered_signal, modulation_time, parameters, ber) // afficher_graphiques_radio
    // fonction d'affichage pour le module Radio (process_radio.sci)
    create_results_figure('Theme 5 : Liaison Radio - Demodulation OOK', 5);

    subplot(3, 1, 1);
    stem(1:parameters.number_of_bits, transmitted_bits, 'b');
    title('Bits emis');
    xlabel('Index du bit');
    ylabel('Valeur');
    ylim([-0.2, 1.2]);

    subplot(3, 1, 2);
    plot(modulation_time, modulated_signal, 'b');
    plot(modulation_time, filtered_signal, 'r');
    xlabel('Temps (s)');
    ylabel('Amplitude');
    title('Signal Module (Bleu) et Signal Filtre Demodule (Rouge)');
    xgrid();

    subplot(3, 1, 3);
    stem(1:parameters.number_of_bits, received_bits, 'g');
    // Mettre en rouge les bits erronés
    error_indices = find(transmitted_bits ~= received_bits);
    stem(error_indices, received_bits(error_indices), 'r', 'MarkerStyle', 'o');
    title(sprintf('Bits recus (BER : %.1f%%)', ber*100));
    xlabel('Index du bit');
    ylabel('Valeur');
    ylim([-0.2, 1.2]);
    legend('Recus corrects', 'Recus errones');
endfunction
