// =========================================================================
//  Fonctions d'affichage dans le conteneur
// =========================================================================

function preparer_zone_graphique()
    // Nettoie la zone graphique et prepare pour nouveaux graphiques
    global app_state;
    
    // Fermer toutes les figures sauf l'interface principale
    figs = winsid();
    for i = 1:length(figs)
        if figs(i) ~= app_state.figure_interface then
            close(figure(figs(i)));
        end
    end
endfunction

function creer_subplot_dans_interface(num_rows, num_cols, idx, titre)
    // Cree un subplot dans une nouvelle fenetre externe
    global app_state;
    
    // Chercher ou creer la figure de resultats
    if ~isfield(app_state, 'figure_resultats') | app_state.figure_resultats == [] then
        // Creer nouvelle fenetre pour graphiques
        fig = scf();
        fig.figure_name = 'Resultats - ' + titre;
        fig.background = -2;
        app_state.figure_resultats = fig.figure_id;
    else
        // Utiliser fenetre existante
        scf(app_state.figure_resultats);
    end
    
    // Creer le subplot
    subplot(num_rows, num_cols, idx);
endfunction

function afficher_graphiques_audio(t, x, X, x_filtre, X_filtre, f, N)
    // Affiche les 4 graphiques pour le theme audio
    preparer_zone_graphique();
    
    // Creer nouvelle fenetre
    fig = scf();
    fig.figure_name = 'Theme 1 : Nettoyage Audio Podcast';
    fig.figure_size = [1000, 700];
    fig.background = -2;
    
    // Signal bruite - temporel
    subplot(2,2,1);
    plot(t, x, 'b');
    xlabel('Temps (s)', 'fontsize', 3);
    ylabel('Amplitude', 'fontsize', 3);
    title('Signal audio bruite', 'fontsize', 3);
    a = gca();
    a.grid = [1 1];
    a.tight_limits = "on";
    
    // Spectre bruite
    subplot(2,2,2);
    plot(f(1:N/2), abs(X(1:N/2)), 'b');
    xlabel('Frequence (Hz)', 'fontsize', 3);
    ylabel('Amplitude', 'fontsize', 3);
    title('Spectre du signal bruite', 'fontsize', 3);
    a = gca();
    a.grid = [1 1];
    a.tight_limits = "on";
    
    // Signal filtre - temporel
    subplot(2,2,3);
    plot(t, x_filtre, 'g');
    xlabel('Temps (s)', 'fontsize', 3);
    ylabel('Amplitude', 'fontsize', 3);
    title('Signal audio filtre', 'fontsize', 3);
    a = gca();
    a.grid = [1 1];
    a.tight_limits = "on";
    
    // Spectre filtre
    subplot(2,2,4);
    plot(f(1:N/2), abs(X_filtre(1:N/2)), 'g');
    xlabel('Frequence (Hz)', 'fontsize', 3);
    ylabel('Amplitude', 'fontsize', 3);
    title('Spectre du signal filtre', 'fontsize', 3);
    a = gca();
    a.grid = [1 1];
    a.tight_limits = "on";
endfunction

function afficher_graphiques_image(img_orig, img_bruite, img_debruit, img_accent)
    // Affiche les 6 graphiques pour le theme image
    preparer_zone_graphique();
    
    fig = scf();
    fig.figure_name = 'Theme 2 : Amelioration Image Medicale';
    fig.figure_size = [1200, 700];
    fig.background = -2;
    
    // Image originale
    subplot(2,3,1);
    Matplot(img_orig);
    title('Image originale', 'fontsize', 3);
    a = gca();
    a.isoview = "on";
    
    // Image bruitee
    subplot(2,3,2);
    Matplot(img_bruite);
    title('Image floue et bruitee', 'fontsize', 3);
    a = gca();
    a.isoview = "on";
    
    // Histogramme bruitee
    subplot(2,3,3);
    histplot(256, double(img_bruite));
    title('Histogramme - Bruitee', 'fontsize', 3);
    a = gca();
    a.grid = [1 1];
    
    // Image debruitee
    subplot(2,3,4);
    Matplot(img_debruit);
    title('Apres filtre median', 'fontsize', 3);
    a = gca();
    a.isoview = "on";
    
    // Image accentuee
    subplot(2,3,5);
    Matplot(img_accent);
    title('Image finale accentuee', 'fontsize', 3);
    a = gca();
    a.isoview = "on";
    
    // Histogramme traitee
    subplot(2,3,6);
    histplot(256, double(img_accent));
    title('Histogramme - Traitee', 'fontsize', 3);
    a = gca();
    a.grid = [1 1];
endfunction

function afficher_graphiques_ecg(t, ecg_bruite, ecg_filtre, temps_pics, pos_pics, fc)
    // Affiche les 2 graphiques pour le theme ECG
    preparer_zone_graphique();
    
    fig = scf();
    fig.figure_name = 'Theme 3 : Detection R-Peaks ECG';
    fig.figure_size = [1000, 700];
    fig.background = -2;
    
    // ECG bruite
    subplot(2,1,1);
    plot(t, ecg_bruite, 'b');
    xlabel('Temps (s)', 'fontsize', 3);
    ylabel('Amplitude', 'fontsize', 3);
    title('ECG bruite original', 'fontsize', 3);
    a = gca();
    a.grid = [1 1];
    a.tight_limits = "on";
    
    // ECG filtre avec R-peaks
    subplot(2,1,2);
    plot(t, ecg_filtre, 'g', 'LineWidth', 2);
    if ~isempty(pos_pics) then
        plot(temps_pics, ecg_filtre(pos_pics), 'ro', 'MarkerSize', 10, 'LineWidth', 2);
    end
    xlabel('Temps (s)', 'fontsize', 3);
    ylabel('Amplitude', 'fontsize', 3);
    title(sprintf('ECG filtre avec R-peaks - FC : %.1f BPM', fc), 'fontsize', 3);
    a = gca();
    a.grid = [1 1];
    a.tight_limits = "on";
    legend(['ECG filtre'; 'R-peaks detectes']);
endfunction

function afficher_graphiques_radar(t, s, r_bruite, lag, corr, tau_est, dist_est)
    // Affiche les 3 graphiques pour le theme radar
    preparer_zone_graphique();
    
    fig = scf();
    fig.figure_name = 'Theme 4 : Estimation Distance Radar';
    fig.figure_size = [1000, 800];
    fig.background = -2;
    
    // Signal emis
    subplot(3,1,1);
    plot(t, s, 'b', 'LineWidth', 2);
    xlabel('Temps (s)', 'fontsize', 3);
    ylabel('Amplitude', 'fontsize', 3);
    title('Signal emis (Chirp)', 'fontsize', 3);
    a = gca();
    a.grid = [1 1];
    a.tight_limits = "on";
    
    // Signal recu
    subplot(3,1,2);
    plot(t, r_bruite, 'r', 'LineWidth', 1.5);
    xlabel('Temps (s)', 'fontsize', 3);
    ylabel('Amplitude', 'fontsize', 3);
    title('Signal recu bruite', 'fontsize', 3);
    a = gca();
    a.grid = [1 1];
    a.tight_limits = "on";
    
    // Correlation
    subplot(3,1,3);
    plot(lag, corr, 'g', 'LineWidth', 2);
    [val_max, idx_max] = trouver_maximum(corr);
    plot(tau_est, val_max, 'ro', 'MarkerSize', 12, 'LineWidth', 3);
    xlabel('Retard (s)', 'fontsize', 3);
    ylabel('Correlation', 'fontsize', 3);
    title(sprintf('Intercorrelation - Distance estimee : %.0f m', dist_est), 'fontsize', 3);
    a = gca();
    a.grid = [1 1];
    a.tight_limits = "on";
    legend(['Correlation'; 'Maximum']);
endfunction

function afficher_graphiques_radio(bits_em, bits_rec, sig_mod, sig_filt, t_mod, p, BER)
    // Affiche les 4 graphiques pour le theme radio
    preparer_zone_graphique();
    
    fig = scf();
    fig.figure_name = 'Theme 5 : Simulation Liaison Radio';
    fig.figure_size = [1000, 900];
    fig.background = -2;
    
    t_bits = 0:p.nb_bits;
    
    // Message emis
    subplot(4,1,1);
    plot(t_bits, [bits_em, bits_em($)], 'b-o', 'LineWidth', 3, 'MarkerSize', 8);
    xlabel('Index du bit', 'fontsize', 3);
    ylabel('Valeur', 'fontsize', 3);
    title(sprintf('Message emis (%d bits)', p.nb_bits), 'fontsize', 3);
    a = gca();
    a.grid = [1 1];
    a.tight_limits = "on";
    a.data_bounds = [0, -0.2; p.nb_bits, 1.2];
    
    // Signal module
    subplot(4,1,2);
    plot(t_mod, sig_mod, 'g', 'LineWidth', 1.5);
    xlabel('Temps (s)', 'fontsize', 3);
    ylabel('Amplitude', 'fontsize', 3);
    title('Signal module OOK', 'fontsize', 3);
    a = gca();
    a.grid = [1 1];
    a.tight_limits = "on";
    
    // Signal demodule
    subplot(4,1,3);
    plot(t_mod, sig_filt, 'r', 'LineWidth', 1.5);
    xlabel('Temps (s)', 'fontsize', 3);
    ylabel('Amplitude', 'fontsize', 3);
    title('Signal demodule et filtre', 'fontsize', 3);
    a = gca();
    a.grid = [1 1];
    a.tight_limits = "on";
    
    // Message recu
    subplot(4,1,4);
    plot(t_bits, [bits_rec, bits_rec($)], 'r-o', 'LineWidth', 3, 'MarkerSize', 8);
    xlabel('Index du bit', 'fontsize', 3);
    ylabel('Valeur', 'fontsize', 3);
    title(sprintf('Message recu - BER = %.1f%%', BER*100), 'fontsize', 3);
    a = gca();
    a.grid = [1 1];
    a.tight_limits = "on";
    a.data_bounds = [0, -0.2; p.nb_bits, 1.2];
endfunction


