// =========================================================================
// Fonctions de traitement de signal
// =========================================================================

function signal_filtre = appliquer_filtre_passe_bas(signal, fc, fe, ordre)
    // Applique un filtre passe-bas
    // fc : frequence de coupure
    // fe : frequence d'echantillonnage
    // ordre : ordre du filtre
    try
        [num_lp, den_lp] = iir(ordre, 'lp', 'butt', fc/fe, 0.1);
        signal_filtre = filter(num_lp, den_lp, signal);
    catch
        disp('Erreur dans filtre passe-bas');
        signal_filtre = signal;
    end
endfunction

function signal_filtre = appliquer_filtre_passe_haut(signal, fc, fe, ordre)
    // Applique un filtre passe-haut
    try
        [num_hp, den_hp] = iir(ordre, 'hp', 'butt', fc/fe, 0.1);
        signal_filtre = filter(num_hp, den_hp, signal);
    catch
        disp('Erreur dans filtre passe-haut');
        signal_filtre = signal;
    end
endfunction

function signal_filtre = appliquer_filtre_passe_bande(signal, fc_bas, fc_haut, fe, ordre)
    // Applique un filtre passe-bande
    try
        [num_bp, den_bp] = iir(ordre, 'bp', 'butt', [fc_bas, fc_haut]/fe, [0.1, 0.1]);
        signal_filtre = filter(num_bp, den_bp, signal);
    catch
        disp('Erreur dans filtre passe-bande');
        signal_filtre = signal;
    end
endfunction

function signal_bruite = ajouter_bruit_blanc(signal, niveau)
    // Ajoute du bruit blanc gaussien
    // niveau : ecart-type du bruit
    N = length(signal);
    bruit = niveau * rand(1, N, 'normal');
    signal_bruite = signal + bruit;
endfunction

function signal_bruite = ajouter_bruit_snr(signal, snr_db)
    // Ajoute du bruit pour atteindre un SNR cible
    puissance_signal = mean(signal.^2);
    if puissance_signal > 0 then
        puissance_bruit = puissance_signal / (10^(snr_db/10));
        N = length(signal);
        bruit = sqrt(puissance_bruit) * rand(1, N, 'normal');
        signal_bruite = signal + bruit;
    else
        signal_bruite = signal;
    end
endfunction

function [spectre, frequences] = calculer_spectre(signal, fe)
    // Calcule le spectre d'amplitude
    N = length(signal);
    spectre = abs(fft(signal));
    frequences = (0:N-1) * fe/N;
endfunction
