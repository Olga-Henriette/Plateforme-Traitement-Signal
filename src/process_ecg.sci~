// =========================================================================
// Detection de R-peaks dans un ECG
// =========================================================================
function process_ecg_module() 
    global app_state;
    
    disp('Debut traitement ECG...');
    
    try
        // Récupérer les paramètres du module 'ecg'
        module_config = app_state.modules.ecg;
        parameters = module_config.default_params; // p
        
        // Configuration
        sampling_frequency = 1000; // fe
        sampling_period = 1/sampling_frequency; // Te
        
        // Vecteur temps
        time_vector = 0:sampling_period:(parameters.duration_s - sampling_period); // t
        N = length(time_vector);
        
        disp('Generation ECG...');
        // Generation ECG
        clean_ecg = generate_ecg_signal(time_vector, N, parameters.heart_rate_bpm);
        noisy_ecg = add_noise_to_ecg(clean_ecg, time_vector, N, parameters.noise_level_factor);
        
        disp('Filtrage ECG...');
        // Filtrage
        filtered_ecg = filter_ecg_signal(noisy_ecg, sampling_frequency);
        
        disp('Detection R-peaks...');
        // Detection R-peaks
        peak_positions = detect_r_peaks(filtered_ecg, sampling_frequency, parameters.detection_threshold); // positions_pics
        peak_times = peak_positions / sampling_frequency;
        
        disp('Calcul frequence cardiaque...');
        // Frequence cardiaque
        mean_heart_rate = calculate_mean_hr(peak_times); // fc_moyenne
        
        disp('Affichage resultats...');
        // Affichage
        show_ecg_results(time_vector, noisy_ecg, filtered_ecg, peak_times, peak_positions, mean_heart_rate);
        
        disp('Calcul interpretation...');
        // Interpretation
        if length(peak_times) >= 2 then
            intervals_rr = diff(peak_times);
            mean_rr_interval_ms = mean(intervals_rr) * 1000;
            
            interpretation_text = sprintf('Detection reussie ! %d battements detectes sur %.1f s. Frequence cardiaque : %.1f BPM (cible : %d BPM). Intervalle RR moyen : %.0f ms.', ...
                            length(peak_positions), parameters.duration_s, mean_heart_rate, parameters.heart_rate_bpm, mean_rr_interval_ms);
        else
            interpretation_text = 'Detection insuffisante. Ajustez le seuil ou reduisez le bruit.';
        end
        update_interpretation_zone(interpretation_text);
        
        disp('Traitement ECG termine.');
        
    catch
        disp('ERREUR dans process_ecg_module');
        err = lasterror();
        disp('Message : ' + err.message);
        update_interpretation_zone('Erreur lors du traitement ECG. Voir console.');
    end
endfunction

// --- Fonctions de support (Renommage en Anglais) ---

function ecg_signal = generate_ecg_signal(time_vector, N, heart_rate_bpm)
    ecg_signal = zeros(1, N);
    period_s = 60 / heart_rate_bpm;
    
    for i = 1:N
        phase = modulo(time_vector(i), period_s) / period_s;
        
        // Simulation d'une forme d'onde ECG simplifiée (PQRST)
        if phase < 0.2 then // P wave
            ecg_signal(i) = 0.2 * exp(-((phase - 0.1)/0.02)^2);
        elseif phase < 0.3 then // QRS complex (R-peak)
            ecg_signal(i) = 1.5 * exp(-((phase - 0.25)/0.01)^2);
        elseif phase < 0.4 then // S wave
            ecg_signal(i) = -0.5 * exp(-((phase - 0.35)/0.015)^2);
        elseif phase < 0.6 then // T wave
            ecg_signal(i) = 0.4 * exp(-((phase - 0.5)/0.08)^2);
        end
    end
endfunction

function noisy_ecg = add_noise_to_ecg(ecg_signal, time_vector, N, noise_factor)
    // Dérive de la ligne de base (respiration basse fréquence)
    baseline_drift = 0.3 * sin(2*%pi*0.2*time_vector); // derive
    // Bruit blanc gaussien
    random_noise = noise_factor * rand(1, N, 'normal'); // bruit
    noisy_ecg = ecg_signal + baseline_drift + random_noise;
endfunction

function filtered_ecg = filter_ecg_signal(ecg_signal, sampling_frequency)
    try
        // Filtre passe-bande (5 Hz à 15 Hz) pour isoler les complexes QRS
        // Normalisation par la fréquence de Nyquist (fe/2)
        [num_bp, den_bp] = iir(4, 'bp', 'butt', [5, 15]/(sampling_frequency/2), [0.1, 0.1]); 
        filtered_ecg = flts(ecg_signal, num_bp, den_bp);
        
        // Normalisation (mise à l'échelle)
        filtered_ecg = filtered_ecg - mean(filtered_ecg);
        filtered_ecg = filtered_ecg / max(abs(filtered_ecg));
    catch
        disp('Erreur dans filtrage ECG, retour signal original');
        filtered_ecg = ecg_signal;
    end
endfunction

function positions = detect_r_peaks(signal, sampling_frequency, threshold_factor)
    N = length(signal);
    threshold = threshold_factor * max(signal); // seuil
    positions = [];
    i = 1;
    
    // Durée minimale entre deux pics (refractory period) ~300 ms à 500 ms
    min_peak_distance_samples = round(0.3 * sampling_frequency); 
    
    while i < N
        if signal(i) > threshold then
            // Début du pic potentiel
            j = i;
            // Chercher la fin du segment au-dessus du seuil (max 100ms)
            while j < min(N, i + round(0.1*sampling_frequency)) & signal(j) > threshold
                j = j + 1;
            end
            
            // Trouver le maximum local dans ce segment
            segment = signal(i:j);
            [max_val, relative_index] = find_maximum(segment);
            
            positions = [positions, i + relative_index - 1];
            
            // Avancer l'index d'une période réfractaire pour éviter la double détection
            i = j + min_peak_distance_samples;
        else
            i = i + 1;
        end
    end
endfunction

function mean_hr = calculate_mean_hr(peak_times) // calculer_fc_moyenne
    if length(peak_times) >= 2 then
        intervals = diff(peak_times);
        mean_hr = mean(60 ./ intervals);
    else
        mean_hr = 0;
    end
endfunction
