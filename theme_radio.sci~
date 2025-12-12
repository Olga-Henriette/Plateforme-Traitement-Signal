// =========================================================================
// Traitement du theme liaison radio
// =========================================================================

function traitement_liaison_radio()
    global app_state;
    
    disp('Debut traitement liaison radio...');
    
    try
        p = app_state.params.theme5;
        
        fe = 22050;
        Te = 1/fe;
        
        disp('Generation du message binaire...');
        
        // Message binaire
        bits_emission = round(rand(1, p.nb_bits));
        
        disp('Modulation OOK...');
        
        // Modulation OOK
        t_modulation = 0:Te:(p.nb_bits * p.duree_bit - Te);
        signal_module = zeros(1, length(t_modulation));
        
        for i = 1:p.nb_bits
            debut_bit = (i-1) * p.duree_bit;
            fin_bit = i * p.duree_bit;
            indices_bit = find(t_modulation >= debut_bit & t_modulation < fin_bit);
            
            if bits_emission(i) == 1 then
                signal_module(indices_bit) = sin(2*%pi*p.f_porteuse*t_modulation(indices_bit));
            end
        end
        
        disp('Ajout du bruit de canal...');
        
        // Canal bruite
        puissance_signal = mean(signal_module.^2);
        if puissance_signal > 0 then
            puissance_bruit = puissance_signal / (10^(p.snr_db/10));
        else
            puissance_bruit = 0.01;
        end
        bruit_canal = sqrt(puissance_bruit) * rand(1, length(signal_module), 'normal');
        signal_recu = signal_module + bruit_canal;
        
        disp('Demodulation...');
        
        // Demodulation
        signal_demodule = signal_recu .* sin(2*%pi*p.f_porteuse*t_modulation);
        
        fc_filtre = 50;
        hz_lp = iir(6, 'lp', 'butt', fc_filtre/(fe/2), 0.1);
        signal_filtre = flts(signal_demodule, hz_lp);
        
        disp('Decision binaire...');
        
        // Decision
        bits_recus = zeros(1, p.nb_bits);
        seuil_decision = 0.1;
        
        for i = 1:p.nb_bits
            debut_bit = (i-1) * p.duree_bit;
            fin_bit = i * p.duree_bit;
            indices_bit = find(t_modulation >= debut_bit & t_modulation < fin_bit);
            idx_echantillon = round(mean(indices_bit));
            
            if signal_filtre(idx_echantillon) > seuil_decision then
                bits_recus(i) = 1;
            end
        end
        
        // BER
        erreurs = sum(bits_emission ~= bits_recus);
        BER = erreurs / p.nb_bits;
        
        disp('Affichage des graphiques...');
        
        // Affichage
        afficher_graphiques_radio(bits_emission, bits_recus, signal_module, signal_filtre, t_modulation, p, BER);
        
        // Interpretation
        if BER == 0 then
            texte = sprintf('Transmission parfaite ! Les %d bits ont ete recus sans erreur (BER = 0%%). SNR: %.1f dB.', ...
                            p.nb_bits, p.snr_db);
        else
            texte = sprintf('%d erreur(s) sur %d bits (BER = %.1f%%). Augmentez le SNR (%.1f dB) pour ameliorer la fiabilite.', ...
                            erreurs, p.nb_bits, BER*100, p.snr_db);
        end
        
        mettre_a_jour_interpretation(texte);
        
        disp('Traitement liaison radio termine !');
        
    catch
        disp('ERREUR dans traitement_liaison_radio');
        err = lasterror();
        disp('Message : ' + err.message);
        mettre_a_jour_interpretation('Erreur lors du traitement radio. Voir console.');
    end
endfunction
