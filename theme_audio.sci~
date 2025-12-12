// =========================================================================
// Simulation liaison radio (modulation OOK)
// =========================================================================

function traitement_liaison_radio()
    global app_state;
    p = app_state.params.theme5;
    
    disp('Debut traitement radio...');
    
    // Configuration
    fe = 22050;
    Te = 1/fe;
    
    disp('Generation message binaire...');
    bits_emission = round(rand(1, p.nb_bits));
    
    disp('Modulation OOK...');
    [signal_module, t_mod] = moduler_ook_signal(bits_emission, p, fe);
    
    disp('Ajout bruit canal...');
    signal_recu = ajouter_bruit_canal_radio(signal_module, p.snr_db);
    
    disp('Demodulation...');
    [signal_filtre, bits_recus] = demoduler_ook_signal(signal_recu, p, fe, t_mod);
    
    disp('Calcul BER...');
    erreurs = sum(bits_emission ~= bits_recus);
    BER = erreurs / p.nb_bits;
    
    disp('Affichage resultats...');
    afficher_graphiques_radio(bits_emission, bits_recus, signal_module, signal_filtre, t_mod, p, BER);
    
    disp('Calcul interpretation...');
    if BER == 0 then
        texte = sprintf('Transmission parfaite ! Les %d bits a %.0f Hz ont ete recus sans erreur (BER = 0%%). SNR de %.1f dB garantit une communication fiable.', ...
                        p.nb_bits, p.f_porteuse, p.snr_db);
    else
        texte = sprintf('Transmission avec erreurs : %d bit(s) errones sur %d (BER = %.1f%%). Augmentez le SNR (actuellement %.1f dB) pour ameliorer.', ...
                        erreurs, p.nb_bits, BER*100, p.snr_db);
    end
    mettre_a_jour_interpretation(texte);
    
    disp('Traitement radio termine.');
endfunction

function [signal, t_mod] = moduler_ook_signal(bits, p, fe)
    Te = 1/fe;
    t_mod = 0:Te:(p.nb_bits * p.duree_bit - Te);
    signal = zeros(1, length(t_mod));
    
    for i = 1:p.nb_bits
        debut = (i-1) * p.duree_bit;
        fin = i * p.duree_bit;
        indices = find(t_mod >= debut & t_mod < fin);
        
        if bits(i) == 1 then
            signal(indices) = sin(2*%pi*p.f_porteuse*t_mod(indices));
        end
    end
endfunction

function signal_bruite = ajouter_bruit_canal_radio(signal, snr_db)
    puissance_signal = mean(signal.^2);
    if puissance_signal > 0 then
        puissance_bruit = puissance_signal / (10^(snr_db/10));
        bruit = sqrt(puissance_bruit) * rand(1, length(signal), 'normal');
    else
        bruit = 0.01 * rand(1, length(signal), 'normal');
    end
    signal_bruite = signal + bruit;
endfunction

function [signal_filtre, bits] = demoduler_ook_signal(signal_recu, p, fe, t_mod)
    try
        // Demodulation coherente
        signal_demod = signal_recu .* sin(2*%pi*p.f_porteuse*t_mod);
        
        // Filtrage passe-bas
        fc_filtre = 50;
        [num_lp, den_lp] = iir(6, 'lp', 'butt', fc_filtre/fe, 0.1);
        signal_filtre = filter(num_lp, den_lp, signal_demod);
    catch
        disp('Erreur dans demodulation, retour signal brut');
        signal_filtre = signal_recu;
    end
    
    // Decision
    bits = zeros(1, p.nb_bits);
    seuil = 0.1;
    
    for i = 1:p.nb_bits
        debut = (i-1) * p.duree_bit;
        fin = i * p.duree_bit;
        indices = find(t_mod >= debut & t_mod < fin);
        
        if ~isempty(indices) then
            idx_ech = round(mean(indices));
            if idx_ech > 0 & idx_ech <= length(signal_filtre) then
                if signal_filtre(idx_ech) > seuil then
                    bits(i) = 1;
                end
            end
        end
    end
endfunction
