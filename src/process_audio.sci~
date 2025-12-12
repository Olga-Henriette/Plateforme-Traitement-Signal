// =========================================================================
// Nettoyage audio (Suppression de fréquences parasites)
// =========================================================================
function process_audio_module()
    global app_state;
    
    disp('Debut traitement Audio...');
    
    try
        // Récupérer les paramètres du module 'audio'
        module_config = app_state.modules.audio;
        parameters = module_config.default_params;
        
        // Configuration
        sampling_frequency = 44100; // fe (Haute qualité pour l'audio)
        sampling_period = 1/sampling_frequency; // Te
        
        // Vecteur temps
        time_vector = 0:sampling_period:(parameters.duration_s - sampling_period); // t
        N = length(time_vector);
        
        disp('Generation signal audio...');
        // Génération du signal propre (voix simulée)
        clean_audio = generate_speech_audio(time_vector);
        
        disp('Ajout des bruits...');
        // Ajout des bruits (ventilateur, sifflement, bruit blanc)
        noise_audio = generate_noise_audio(time_vector, N, parameters.fan_freq_hz, parameters.whistle_freq_hz, parameters.noise_level_factor);
        noisy_signal = clean_audio + noise_audio;
        
        disp('Filtrage des bruits (Notch filters)...');
        // Filtrage des bruits (Filtres coupe-bande pour chaque fréquence parasite)
        filtered_signal = filter_audio_noise(noisy_signal, sampling_frequency, parameters.fan_freq_hz, parameters.whistle_freq_hz);
        
        disp('Analyse frequentielle...');
        // Analyse Fréquentielle
        [freq_fft, fft_noisy] = calculate_fft_spectrum(noisy_signal, sampling_frequency);
        [freq_fft_filtered, fft_filtered] = calculate_fft_spectrum(filtered_signal, sampling_frequency);
        
        // Calcul de l'amélioration SNR
        snr_noisy = calculate_snr(clean_audio, noisy_signal);
        snr_filtered = calculate_snr(clean_audio, filtered_signal);
        snr_improvement = snr_filtered - snr_noisy;
        
        disp('Affichage resultats...');
        // Affichage
        show_audio_results(time_vector, clean_audio, noisy_signal, filtered_signal, freq_fft, fft_noisy, fft_filtered);
        
        // Interpretation
        interpretation_text = sprintf('Traitement reussi ! SNR bruite : %.1f dB. SNR filtre : %.1f dB. Gain de %.1f dB. Les filtres coupe-bande ont bien cible les frequences parasites (%.0f Hz et %.0f Hz).', ...
                        snr_noisy, snr_filtered, snr_improvement, parameters.fan_freq_hz, parameters.whistle_freq_hz);
        update_interpretation_zone(interpretation_text);
        
        disp('Traitement Audio termine.');
        
    catch
        disp('ERREUR dans process_audio_module');
        err = lasterror();
        disp('Message : ' + err.message);
        update_interpretation_zone('Erreur lors du traitement audio. Voir console.');
    end
endfunction

// --- Fonctions de support  ---

function clean_audio = generate_speech_audio(time_vector) // generer_audio_parole_simulee
    // Simule une voix modulée en amplitude
    frequency_base = 400; // Frequence de la voix (fixe)
    amplitudes = (0.5 + 0.5 * sin(2*%pi*1.5*time_vector)); // Modulateur lent
    clean_audio = amplitudes .* sin(2*%pi*frequency_base*time_vector);
    clean_audio = clean_audio * 0.8;
endfunction

function noise_audio = generate_noise_audio(time_vector, N, f_fan, f_whistle, noise_factor)
    // Bruit de ventilateur (signal sinusoïdal)
    fan_noise = 0.5 * cos(2*%pi*f_fan*time_vector); // bruit_ventilateur
    
    // Bruit de sifflement (haute fréquence)
    whistle_noise = 0.3 * sin(2*%pi*f_whistle*time_vector); // bruit_sifflement
    
    // Bruit blanc (aléatoire)
    white_noise = noise_factor * rand(1, N, 'normal');
    
    noise_audio = fan_noise + whistle_noise + white_noise;
endfunction

function filtered_signal = filter_audio_noise(input_signal, sampling_frequency, f_fan, f_whistle)
    // Application de filtres coupe-bande (Notch) pour f_fan et f_whistle
    
    // 1. Filtre Notch pour le ventilateur (f_fan)
    // Normalisation par la fréquence de Nyquist (fe/2)
    center_freq_norm_fan = f_fan / (sampling_frequency/2);
    bandwidth_norm = 50 / (sampling_frequency/2); // Bande passante autour de la coupure (ex: 50 Hz)
    
    [num_fan, den_fan] = iir(4, 'notch', 'butt', center_freq_norm_fan, bandwidth_norm);
    signal_step1 = flts(input_signal, num_fan, den_fan);
    
    // 2. Filtre Notch pour le sifflement (f_whistle)
    center_freq_norm_whistle = f_whistle / (sampling_frequency/2);
    
    [num_whistle, den_whistle] = iir(4, 'notch', 'butt', center_freq_norm_whistle, bandwidth_norm);
    filtered_signal = flts(signal_step1, num_whistle, den_whistle);
endfunction
