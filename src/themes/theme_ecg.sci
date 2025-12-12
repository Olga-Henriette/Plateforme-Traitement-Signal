// =========================================================================
// Detection de R-peaks dans un ECG
// =========================================================================

function traitement_ecg()
    global app_state;
    p = app_state.params.theme3;
    
    disp('Debut traitement ECG...');
    
    // Configuration
    fe = 1000;
    Te = 1/fe;
    t = 0:Te:(p.duree - Te);
    N = length(t);
    
    disp('Generation ECG...');
    // Generation ECG
    ecg_propre = generer_ecg(t, N, p.freq_cardiaque);
    ecg_bruite = ajouter_bruits_ecg_signal(ecg_propre, t, N, p.niveau_bruit);
    
    disp('Filtrage ECG...');
    // Filtrage
    ecg_filtre = filtrer_ecg_signal(ecg_bruite, fe);
    
    disp('Detection R-peaks...');
    // Detection R-peaks
    positions_pics = detecter_r_peaks_ecg(ecg_filtre, fe, p.seuil_detection);
    temps_pics = positions_pics / fe;
    
    disp('Calcul frequence cardiaque...');
    // Frequence cardiaque
    fc_moyenne = calculer_fc_moyenne(temps_pics);
    
    disp('Affichage resultats...');
    // Affichage
    afficher_resultats_ecg(t, ecg_bruite, ecg_filtre, temps_pics, positions_pics, fc_moyenne);
    
    disp('Calcul interpretation...');
    // Interpretation
    if length(temps_pics) >= 2 then
        intervalle_rr = mean(diff(temps_pics)) * 1000;
        texte = sprintf('Detection reussie ! %d battements detectes sur %.1f s. Frequence cardiaque : %.1f BPM (cible : %d BPM). Intervalle RR moyen : %.0f ms.', ...
                        length(positions_pics), p.duree, fc_moyenne, p.freq_cardiaque, intervalle_rr);
    else
        texte = 'Detection insuffisante. Ajustez le seuil ou reduisez le bruit.';
    end
    mettre_a_jour_interpretation(texte);
    
    disp('Traitement ECG termine.');
endfunction

function ecg = generer_ecg(t, N, freq_card)
    ecg = zeros(1, N);
    periode = 60 / freq_card;
    
    for i = 1:N
        phase = modulo(t(i), periode) / periode;
        if phase < 0.2 then
            ecg(i) = 1.5 * exp(-((phase - 0.1)/0.02)^2);
        elseif phase < 0.4 then
            ecg(i) = -0.3 * exp(-((phase - 0.3)/0.05)^2);
        elseif phase < 0.6 then
            ecg(i) = 0.4 * exp(-((phase - 0.5)/0.08)^2);
        end
    end
endfunction

function ecg_bruite = ajouter_bruits_ecg_signal(ecg, t, N, niveau)
    derive = 0.3 * sin(2*%pi*0.2*t);
    bruit = niveau * rand(1, N, 'normal');
    ecg_bruite = ecg + derive + bruit;
endfunction

function ecg_filtre = filtrer_ecg_signal(ecg, fe)
    try
        [num_bp, den_bp] = iir(4, 'bp', 'butt', [5, 15]/fe, [0.1, 0.1]);
        ecg_filtre = filter(num_bp, den_bp, ecg);
        ecg_filtre = ecg_filtre - mean(ecg_filtre);
        ecg_filtre = ecg_filtre / max(abs(ecg_filtre));
    catch
        disp('Erreur dans filtrage ECG, retour signal original');
        ecg_filtre = ecg;
    end
endfunction

function positions = detecter_r_peaks_ecg(signal, fe, seuil_factor)
    N = length(signal);
    seuil = seuil_factor * max(signal);
    positions = [];
    i = 1;
    
    while i < N
        if signal(i) > seuil then
            j = i;
            while j < min(N, i+round(0.1*fe)) & signal(j) > seuil
                j = j + 1;
            end
            // Trouver le maximum local (compatible Scilab)
            segment = signal(i:j);
            [val_max, idx_rel] = trouver_maximum(segment);
            positions = [positions, i+idx_rel-1];
            i = j + round(0.3*fe);
        else
            i = i + 1;
        end
    end
endfunction

function fc = calculer_fc_moyenne(temps_pics)
    if length(temps_pics) >= 2 then
        intervals = diff(temps_pics);
        fc = mean(60 ./ intervals);
    else
        fc = 0;
    end
endfunction

function afficher_resultats_ecg(t, ecg_bruite, ecg_filtre, temps_pics, pos_pics, fc)
    creer_figure_resultats('Theme 3 : ECG', 3);
    
    subplot(2,1,1);
    plot(t, ecg_bruite, 'b');
    xlabel('Temps (s)');
    ylabel('Amplitude');
    title('ECG bruite original');
    xgrid();
    
    subplot(2,1,2);
    plot(t, ecg_filtre, 'g');
    if ~isempty(pos_pics) then
        plot(temps_pics, ecg_filtre(pos_pics), 'ro', 'MarkerSize', 8);
    end
    xlabel('Temps (s)');
    ylabel('Amplitude');
    title(sprintf('ECG filtre avec R-peaks - FC : %.1f BPM', fc));
    xgrid();
endfunction
