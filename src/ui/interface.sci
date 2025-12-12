// =========================================================================
// Creation de l'interface utilisateur
// =========================================================================

function creer_panneau_graphiques()
    global app_state;

    
    // Frame des graphiques (Conteneur)
    h_graph_panel = uicontrol(app_state.figure_interface, 'style', 'frame', ...
              'position', [320, 80, 860, 510], ...
              'background', [1 1 1], ...
              'tag', 'panel_graphics_zone');
              
    app_state.ui_elements.panel_graphics = h_graph_panel;
    
    // Titre
    uicontrol(app_state.figure_interface, 'style', 'text', ...
              'string', 'ZONE D''AFFICHAGE DES GRAPHIQUES', ...
              'position', [330, 560, 840, 25], ...
              'fontsize', 13, ...
              'fontweight', 'bold', ...
              'background', [0.3 0.5 0.8], ...
              'foreground', [1 1 1], ...
              'horizontalalignment', 'center', ...
              'tag', 'graphics_title_text');
endfunction

function creer_interface_principale()
    global app_state;
    
    close(winsid());
    
    // Initialiser ui_elements s'il n'existe pas
    if ~isfield(app_state, 'ui_elements') then
        app_state.ui_elements = struct();
    end
    
    cfg = app_state.config_ui;
    
    // Créer la figure avec la fonction de redimensionnement
    fig = figure('figure_name', 'Plateforme Traitement Signal v2.0', ...
                 'position', [50, 50, cfg.largeur, cfg.hauteur], ...
                 'background', cfg.couleur_fond, ...
                 'resizefcn', 'redimensionner_interface()'); 
    
    app_state.figure_interface = fig;
    
    // SUPPRESSION DE L'APPEL A newaxes FAUTIF: 
    // delete(app_state.ui_elements.graphics_axes) 
    
    creer_barre_titre();
    creer_selecteur_theme();
    creer_panneau_parametres();
    creer_panneau_graphiques();
    creer_bouton_generation();
    creer_zone_interpretation();
    
    //Appeler une première fois le redimensionnement pour placer les éléments
    redimensionner_interface(); 
    
    afficher_message_bienvenue();
endfunction

function creer_barre_titre()
    global app_state;
    
    uicontrol(app_state.figure_interface, 'style', 'text', ...
              'string', 'Plateforme de Traitement de Signal v2.0', ...
              'position', [20, 650, 1160, 40], ...
              'fontsize', 18, ...
              'fontweight', 'bold', ...
              'background', app_state.config_ui.couleur_titre, ...
              'foreground', [1 1 1], ...
              'horizontalalignment', 'center');
endfunction

function creer_selecteur_theme()
    global app_state;
    
    uicontrol(app_state.figure_interface, 'style', 'text', ...
              'string', 'Selectionner un theme :', ...
              'position', [20, 610, 150, 25], ...
              'fontsize', 11, ...
              'background', app_state.config_ui.couleur_fond, ...
              'horizontalalignment', 'left');
    
    h_popup = uicontrol(app_state.figure_interface, 'style', 'popupmenu', ...
                        'string', app_state.themes_liste, ...
                        'position', [180, 610, 400, 25], ...
                        'fontsize', 10, ...
                        'tag', 'popup_theme_selector', ...
                        'callback', 'evenement_changement_theme()');
    
    // Stocker le handle
    app_state.ui_elements.popup_theme = h_popup;
    
    uicontrol(app_state.figure_interface, 'style', 'pushbutton', ...
              'string', 'Aide', ...
              'position', [1080, 610, 100, 25], ...
              'fontsize', 10, ...
              'callback', 'afficher_aide()');
endfunction

function creer_panneau_parametres()
    global app_state;
    
    uicontrol(app_state.figure_interface, 'style', 'frame', ...
              'position', [20, 80, 280, 510], ...
              'background', [1 1 1]);
    
    uicontrol(app_state.figure_interface, 'style', 'text', ...
              'string', 'PARAMETRES', ...
              'position', [30, 560, 260, 25], ...
              'fontsize', 13, ...
              'fontweight', 'bold', ...
              'background', [0.3 0.5 0.8], ...
              'foreground', [1 1 1], ...
              'horizontalalignment', 'center');
    
    afficher_parametres_theme(app_state.theme_actuel);
endfunction

function creer_bouton_generation()
    global app_state;
    
    h_btn = uicontrol(app_state.figure_interface, 'style', 'pushbutton', ...
                      'string', 'GENERER LES GRAPHIQUES', ...
                      'position', [30, 90, 260, 40], ...
                      'fontsize', 12, ...
                      'fontweight', 'bold', ...
                      'background', app_state.config_ui.couleur_bouton, ...
                      'foreground', [1 1 1], ...
                      'tag', 'bouton_generer', ...
                      'callback', 'evenement_generer_resultats()');
    
    app_state.ui_elements.bouton_generer = h_btn;
endfunction

function creer_zone_interpretation()
    global app_state;
    
    uicontrol(app_state.figure_interface, 'style', 'text', ...
              'string', 'INTERPRETATION DES RESULTATS', ...
              'position', [320, 55, 860, 20], ...
              'fontsize', 11, ...
              'fontweight', 'bold', ...
              'background', app_state.config_ui.couleur_fond, ...
              'horizontalalignment', 'center');
    
    h_zone = uicontrol(app_state.figure_interface, 'style', 'text', ...
                       'string', 'Selectionnez un theme et cliquez sur GENERER pour voir les resultats...', ...
                       'position', [320, 10, 860, 40], ...
                       'fontsize', 10, ...
                       'background', [1 1 0.9], ...
                       'tag', 'zone_interpretation_text', ...
                       'horizontalalignment', 'left');
    
    app_state.ui_elements.zone_interpretation = h_zone;
endfunction

function afficher_parametres_theme(num_theme)
    global app_state;
    
    nettoyer_zone_parametres();
    
    y_pos = 520; 
    
    select num_theme
    case 1 then
        creer_champ('Duree du signal (s)', 'duree', y_pos, app_state.params.theme1.duree);
        y_pos = y_pos - 40;
        creer_champ('Freq. ventilateur (Hz)', 'f_ventilateur', y_pos, app_state.params.theme1.f_ventilateur);
        y_pos = y_pos - 40;
        creer_champ('Freq. sifflement (Hz)', 'f_sifflement', y_pos, app_state.params.theme1.f_sifflement);
        y_pos = y_pos - 40;
        creer_champ('Niveau bruit (0-1)', 'niveau_bruit', y_pos, app_state.params.theme1.niveau_bruit);
        
    case 2 then
        creer_champ('Intensite du flou', 'sigma_flou', y_pos, app_state.params.theme2.sigma_flou);
        y_pos = y_pos - 40;
        creer_champ('Bruit poivre/sel (%)', 'niveau_bruit_img', y_pos, app_state.params.theme2.niveau_bruit * 100);
        y_pos = y_pos - 40;
        creer_champ('Taille filtre median', 'taille_median', y_pos, app_state.params.theme2.taille_median);
        
    case 3 then
        creer_champ('Duree (s)', 'duree_ecg', y_pos, app_state.params.theme3.duree);
        y_pos = y_pos - 40;
        creer_champ('Freq. cardiaque (BPM)', 'freq_cardiaque', y_pos, app_state.params.theme3.freq_cardiaque);
        y_pos = y_pos - 40;
        creer_champ('Niveau bruit (0-1)', 'niveau_bruit_ecg', y_pos, app_state.params.theme3.niveau_bruit);
        y_pos = y_pos - 40;
        creer_champ('Seuil detection (0-1)', 'seuil_detection', y_pos, app_state.params.theme3.seuil_detection);
        
    case 4 then
        creer_champ('Distance cible (m)', 'distance', y_pos, app_state.params.theme4.distance);
        y_pos = y_pos - 40;
        creer_champ('SNR (dB)', 'snr_db_radar', y_pos, app_state.params.theme4.snr_db);
        y_pos = y_pos - 40;
        creer_champ('Freq chirp debut (Hz)', 'f_chirp_debut', y_pos, app_state.params.theme4.f_chirp_debut);
        y_pos = y_pos - 40;
        creer_champ('Freq chirp fin (Hz)', 'f_chirp_fin', y_pos, app_state.params.theme4.f_chirp_fin);
        
    case 5 then
        creer_champ('Nombre de bits', 'nb_bits', y_pos, app_state.params.theme5.nb_bits);
        y_pos = y_pos - 40;
        creer_champ('Duree par bit (s)', 'duree_bit', y_pos, app_state.params.theme5.duree_bit);
        y_pos = y_pos - 40;
        creer_champ('Freq porteuse (Hz)', 'f_porteuse', y_pos, app_state.params.theme5.f_porteuse);
        y_pos = y_pos - 40;
        creer_champ('SNR (dB)', 'snr_db_radio', y_pos, app_state.params.theme5.snr_db);
    end
endfunction

function creer_champ(label, tag, y_pos, valeur)
    global app_state;
    
    uicontrol(app_state.figure_interface, 'style', 'text', ...
              'string', label + ':', ...
              'position', [40, y_pos, 140, 20], ...
              'horizontalalignment', 'left', ...
              'background', [1 1 1]);
    
    uicontrol(app_state.figure_interface, 'style', 'edit', ...
              'string', string(valeur), ...
              'position', [190, y_pos, 70, 25], ...
              'tag', 'param_' + tag);
endfunction

function nettoyer_zone_parametres()
    global app_state;
    
    h_all = findobj(app_state.figure_interface);
    for i = 1:length(h_all)
        try
            pos = get(h_all(i), 'position');
            if pos(1) >= 30 & pos(1) <= 270 & pos(2) >= 140 & pos(2) <= 540 then
                style = get(h_all(i), 'style');
                if style == 'text' | style == 'edit' then
                    tag_val = get(h_all(i), 'tag');
                    // Ne pas supprimer les elements avec tag specifique
                    if tag_val ~= 'zone_interpretation_text' & tag_val ~= 'bouton_generer' then
                        delete(h_all(i));
                    end
                end
            end
        catch
        end
    end
endfunction

function afficher_message_bienvenue()
    msg = ['Bienvenue sur la Plateforme v2.0 !'; ...
           ''; ...
           'Selectionnez un theme pour commencer.'];
    
    messagebox(msg, 'Bienvenue', 'info');
endfunction

function afficher_aide()
    msg = ['AIDE - Plateforme v2.0'; ...
           ''; ...
           '1. Selectionnez un theme'; ...
           '2. Ajustez les parametres'; ...
           '3. Cliquez sur GENERER'; ...
           ''; ...
           'Themes disponibles :'; ...
           '- Audio : Filtrage de bruits'; ...
           '- Image : Restauration nettete'; ...
           '- ECG : Detection battements'; ...
           '- Radar : Estimation distance'; ...
           '- Radio : Communication numerique'];
    
    messagebox(msg, 'Aide', 'info');
endfunction

function redimensionner_interface()
    global app_state;
    
    if isempty(app_state.figure_interface) then return; end
    
    // 1. Lire les nouvelles dimensions de la figure
    fig = app_state.figure_interface;
    fig_pos = get(fig, 'position');
    largeur_fig = fig_pos(3);
    hauteur_fig = fig_pos(4);
    
    // Définir des marges et des hauteurs fixes (en pixels)
    marge_h = 20;
    marge_v = 15;
    hauteur_barre_titre = 40;
    hauteur_selecteur = 25;
    hauteur_interpretation = 40;
    hauteur_bouton_gen = 40;
    
    // Calcul de la hauteur disponible pour les panneaux (Paramètres & Graphiques)
    y_start_panneaux = marge_v + hauteur_interpretation + marge_v; 
    y_end_panneaux = hauteur_fig - marge_v - hauteur_barre_titre - marge_v - hauteur_selecteur - marge_v;
    hauteur_panneaux = y_end_panneaux - y_start_panneaux;
    
    // --- Barre de Titre (Position fixe en haut) ---
    h_titre = findobj(fig, 'string', 'Plateforme de Traitement de Signal v2.0');
    if ~isempty(h_titre) then
        set(h_titre(1), 'position', [marge_h, hauteur_fig - hauteur_barre_titre - marge_v, largeur_fig - 2*marge_h, hauteur_barre_titre]);
    end
    
    // --- Sélecteur de Thème & Aide ---
    y_selecteur = hauteur_fig - hauteur_barre_titre - 2*marge_v - hauteur_selecteur;
    
    // Label : Selectionner un theme
    h_label_theme = findobj(fig, 'string', 'Selectionner un theme :');
    if ~isempty(h_label_theme) then
        // Position A GAUCHE (marge_h = 20)
        set(h_label_theme(1), 'position', [marge_h, y_selecteur, 150, hauteur_selecteur]);
    end
    
    // Popup : Liste des thèmes
    if isfield(app_state.ui_elements, 'popup_theme') & ~isempty(app_state.ui_elements.popup_theme) then
        // Position après le label (20 + 160)
        set(app_state.ui_elements.popup_theme, 'position', [marge_h + 160, y_selecteur, 400, hauteur_selecteur]);
    end
    
    // Bouton Aide (position alignée à droite de la figure)
    h_aide = findobj(fig, 'string', 'Aide');
    if ~isempty(h_aide) then
        set(h_aide(1), 'position', [largeur_fig - marge_h - 100, y_selecteur, 100, hauteur_selecteur]);
    end
    
    // --- Panneau Paramètres 
    largeur_params = 280;
    
    // Frame des paramètres
    h_frame_params = findobj(fig, 'style', 'frame', 'position', [marge_h, y_start_panneaux, largeur_params, hauteur_panneaux]);
    if ~isempty(h_frame_params) then
        set(h_frame_params(1), 'position', [marge_h, y_start_panneaux, largeur_params, hauteur_panneaux]);
    end
    
    // Titre PARAMETRES
    h_titre_params = findobj(fig, 'string', 'PARAMETRES');
    if ~isempty(h_titre_params) then
        set(h_titre_params(1), 'position', [marge_h + 10, y_start_panneaux + hauteur_panneaux - 35, largeur_params - 20, 25]);
    end
    
    // Bouton GENERER 
    h_btn_gen = findobj(fig, 'tag', 'bouton_generer');
    if ~isempty(h_btn_gen) then
        set(h_btn_gen(1), 'position', [marge_h + 10, y_start_panneaux + marge_v, largeur_params - 20, hauteur_bouton_gen]);
    end
    
    // --- Panneau Graphiques (Largeur et Hauteur dynamiques) ---
    x_start_graph = marge_h + largeur_params + marge_h;
    largeur_graph = largeur_fig - x_start_graph - marge_h;
    
    // Frame des graphiques
    h_frame_graph = findobj(fig, 'tag', 'panel_graphics_zone');
    if ~isempty(h_frame_graph) then
        set(h_frame_graph(1), 'position', [x_start_graph, y_start_panneaux, largeur_graph, hauteur_panneaux]);
    end
    
    // Titre ZONE D'AFFICHAGE DES GRAPHIQUES
    h_titre_graph = findobj(fig, 'tag', 'graphics_title_text');
    if ~isempty(h_titre_graph) then
        set(h_titre_graph(1), 'position', [x_start_graph + 10, y_start_panneaux + hauteur_panneaux - 35, largeur_graph - 20, 25]);
    end
    
    // --- Zone d'Interprétation 
    y_interpretation = marge_v;
    
    // Titre INTERPRETATION DES RESULTATS
    h_titre_inter = findobj(fig, 'string', 'INTERPRETATION DES RESULTATS');
    if ~isempty(h_titre_inter) then
        set(h_titre_inter(1), 'position', [x_start_graph, y_interpretation + hauteur_interpretation, largeur_graph, 20]);
    end
    
    // Zone de texte
    if isfield(app_state.ui_elements, 'zone_interpretation') & ~isempty(app_state.ui_elements.zone_interpretation) then
        set(app_state.ui_elements.zone_interpretation, 'position', [x_start_graph, y_interpretation, largeur_graph, hauteur_interpretation]);
    end
    
    h_axes = findobj(fig, 'type', 'Axes'); // Tous les axes créés par plot/subplot
    
    if ~isempty(h_axes) then

        x_rel_start = x_start_graph / largeur_fig;
        y_rel_start = y_start_panneaux / hauteur_fig;
        w_rel = largeur_graph / largeur_fig;
        h_rel = hauteur_panneaux / hauteur_fig;

    end
endfunction
