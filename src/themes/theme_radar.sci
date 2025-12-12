// =========================================================================
// Estimation de distance radar
// =========================================================================

function traitement_radar()
    global app_state;
    p = app_state.params.theme4;
    
    disp('Debut traitement radar...');
    
    // Configuration
    fe = 10000;
    Te = 1/fe;
    duree = 0.01;
    t = 0:Te:(duree - Te);
    N = length(t);
    
    c = 3e8;
    tau_reel = 2 * p.distance / c;
    
    disp('Generation signaux radar...');
    // Generation des signaux
    [s, r_bruite] = generer_signaux_radar(t, N, fe, tau_reel, p);
    
    disp('Calcul correlation...');
    // Correlation
    correlation = xcorr(r_bruite, s);
    lag = (-(N-1):(N-1)) * Te;
    
    disp('Estimation distance...');
    // Estimation
    [val_max_corr, idx_max_corr] = trouver_maximum(correlation);
    tau_estime = lag(idx_max_corr);
    distance_estimee = (c * tau_estime) / 2;
    erreur = abs(distance_estimee - p.distance);
    
    disp('Affichage resultats...');
    // Affichage
    afficher_resultats_radar(t, s, r_bruite, lag, correlation, tau_estime, distance_estimee);
    
    disp('Calcul interpretation...');
    // Interpretation
    precision = (1 - erreur/p.distance) * 100;
    texte = sprintf('Distance estimee : %.0f m (reel : %.0f m). Erreur : %.1f m (%.2f%%). Precision : %.1f%%. Retard : %.2f us.', ...
                    distance_estimee, p.distance, erreur, (erreur/p.distance)*100, precision, tau_estime*1e6);
    mettre_a_jour_interpretation(texte);
    
    disp('Traitement radar termine.');
endfunction

function [s, r_bruite] = generer_signaux_radar(t, N, fe, tau_reel, p)
    Te = 1/fe;
    duree_impulsion = 0.001;
    t_impulsion = 0:Te:(duree_impulsion - Te);
    
    // Generation chirp
    k = (p.f_chirp_fin - p.f_chirp_debut) / duree_impulsion;
    chirp_em = sin(2*%pi*(p.f_chirp_debut*t_impulsion + 0.5*k*t_impulsion.^2));
    
    // Signal emis
    s = zeros(1, N);
    idx_debut = 100;
    if idx_debut + length(chirp_em) - 1 <= N then
        s(idx_debut:idx_debut+length(chirp_em)-1) = chirp_em;
    end
    
    // Signal recu
    A = 0.7;
    idx_retard = idx_debut + round(tau_reel * fe);
    r = zeros(1, N);
    
    // Verifier les limites
    if idx_retard > 0 & idx_retard + length(chirp_em) - 1 <= N then
        r(idx_retard:idx_retard+length(chirp_em)-1) = A * chirp_em;
    end
    
    // Ajout bruit
    puissance_signal = mean(r.^2);
    if puissance_signal > 0 then
        puissance_bruit = puissance_signal / (10^(p.snr_db/10));
        bruit = sqrt(puissance_bruit) * rand(1, N, 'normal');
    else
        bruit = 0.01 * rand(1, N, 'normal');
    end
    r_bruite = r + bruit;
endfunction

function afficher_resultats_radar(t, s, r_bruite, lag, corr, tau_est, dist_est)
    creer_figure_resultats('Theme 4 : Radar', 4);
    
    subplot(3,1,1);
    plot(t, s, 'b');
    xlabel('Temps (s)');
    ylabel('Amplitude');
    title('Signal emis (Chirp)');
    xgrid();
    
    subplot(3,1,2);
    plot(t, r_bruite, 'r');
    xlabel('Temps (s)');
    ylabel('Amplitude');
    title('Signal recu bruite');
    xgrid();
    
    subplot(3,1,3);
    plot(lag, corr, 'g');
    [val_max_plot, idx_max_plot] = trouver_maximum(corr);
    plot(tau_est, val_max_plot, 'ro', 'MarkerSize', 8);
    xlabel('Retard (s)');
    ylabel('Correlation');
    title(sprintf('Intercorrelation - Distance : %.0f m', dist_est));
    xgrid();
endfunction
