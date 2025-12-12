// =========================================================================
// INTERFACE.SCI - Creation de l'interface utilisateur
// =========================================================================

function module_config = get_module_config(theme_key)
    global app_state;
    
    select theme_key
        case 'audio' then
            module_config = app_state.modules.audio;
        case 'image' then
            module_config = app_state.modules.image;
        case 'ecg' then
            module_config = app_state.modules.ecg;
        case 'radar' then
            module_config = app_state.modules.radar;
        case 'radio' then
            module_config = app_state.modules.radio;
        else
            error('Theme inconnu: ' + theme_key);
    end
endfunction

function create_main_interface() // creer_interface_principale
    global app_state;
    
    close(winsid()); // Ferme toutes les fenêtres Scilab précédentes
    
    // Initialiser ui_elements s'il n'existe pas
    if ~isfield(app_state, 'ui_elements') then
        app_state.ui_elements = struct();
    end
    
    config = app_state.ui_config; // cfg
    
    // Créer la figure
    figure_handle = figure('figure_name', 'Plateforme Traitement Signal v2.0', ...
                 'position', [50, 50, config.width, config.height], ...
                 'background', config.background_color, ...
                 'resizefcn', 'resize_interface()'); // Redimensionnement
    
    app_state.figure_interface = figure_handle;
    
    create_title_bar();
    create_theme_selector();
    create_parameters_panel();
    create_graphics_panel();
    create_generate_button();
    create_interpretation_zone();
    
    // Appeler une première fois le redimensionnement pour placer les éléments
    resize_interface(); 
    
    show_welcome_message(); // Afficher message de bienvenue
    
    // Afficher les paramètres du thème par défaut
    display_theme_parameters_dynamic(app_state.current_theme_key);
endfunction


// --- Fonctions de Création des Éléments Statiques ---

function create_title_bar() // creer_barre_titre
    global app_state;
    
    uicontrol(app_state.figure_interface, 'style', 'text', ...
              'string', 'Plateforme de Traitement de Signal v2.0', ...
              'position', [20, 650, 1160, 40], ...
              'fontsize', 18, ...
              'fontweight', 'bold', ...
              'background', app_state.ui_config.title_color, ...
              'foreground', [1 1 1], ...
              'horizontalalignment', 'center');
endfunction

function create_theme_selector() // creer_selecteur_theme
    global app_state;
    
    uicontrol(app_state.figure_interface, 'style', 'text', ...
              'string', 'Selectionner un theme :', ...
              'position', [20, 610, 150, 25], ...
              'fontsize', 11, ...
              'background', app_state.ui_config.background_color, ...
              'horizontalalignment', 'left');
    
    popup_handle = uicontrol(app_state.figure_interface, 'style', 'popupmenu', ...
                        'string', app_state.theme_display_names, ...
                        'position', [180, 610, 400, 25], ...
                        'fontsize', 10, ...
                        'tag', 'popup_theme_selector', ...
                        'callback', 'event_theme_change()'); // Appel renommé
    
    app_state.ui_elements.popup_theme = popup_handle;
    
    uicontrol(app_state.figure_interface, 'style', 'pushbutton', ...
              'string', 'Aide', ...
              'position', [1080, 610, 100, 25], ...
              'fontsize', 10, ...
              'callback', 'show_help()'); // Appel renommé
endfunction

function create_parameters_panel() // creer_panneau_parametres
    global app_state;
    
    // Frame des paramètres (stocké pour le nettoyage et l'accès)
    h_frame = uicontrol(app_state.figure_interface, 'style', 'frame', ...
              'position', [20, 80, 280, 510], ...
              'background', [1 1 1], ...
              'tag', 'panel_parameters_frame');
              
    app_state.ui_elements.params_panel_frame = h_frame;
    
    // Titre PARAMETRES
    uicontrol(app_state.figure_interface, 'style', 'text', ...
              'string', 'PARAMETRES', ...
              'position', [30, 560, 260, 25], ...
              'fontsize', 13, ...
              'fontweight', 'bold', ...
              'background', [0.3 0.5 0.8], ...
              'foreground', [1 1 1], ...
              'horizontalalignment', 'center');
endfunction

function create_graphics_panel() // creer_panneau_graphiques
    global app_state;

    // Frame des graphiques (Conteneur)
    uicontrol(app_state.figure_interface, 'style', 'frame', ...
              'position', [320, 80, 860, 510], ...
              'background', [1 1 1], ...
              'tag', 'panel_graphics_zone');
    
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

function create_generate_button() // creer_bouton_generation
    global app_state;
    
    button_handle = uicontrol(app_state.figure_interface, 'style', 'pushbutton', ...
                      'string', 'GENERER LES GRAPHIQUES', ...
                      'position', [30, 90, 260, 40], ...
                      'fontsize', 12, ...
                      'fontweight', 'bold', ...
                      'background', app_state.ui_config.button_color, ...
                      'foreground', [1 1 1], ...
                      'tag', 'button_generate', ... // tag renommé
                      'callback', 'event_generate_results()'); // Appel renommé
    
    app_state.ui_elements.button_generate = button_handle;
endfunction

function create_interpretation_zone() // creer_zone_interpretation
    global app_state;
    
    uicontrol(app_state.figure_interface, 'style', 'text', ...
              'string', 'INTERPRETATION DES RESULTATS', ...
              'position', [320, 55, 860, 20], ...
              'fontsize', 11, ...
              'fontweight', 'bold', ...
              'background', app_state.ui_config.background_color, ...
              'horizontalalignment', 'center');
    
    zone_handle = uicontrol(app_state.figure_interface, 'style', 'text', ...
                       'string', 'Selectionnez un theme et cliquez sur GENERER pour voir les resultats...', ...
                       'position', [320, 10, 860, 40], ...
                       'fontsize', 10, ...
                       'background', [1 1 0.9], ...
                       'tag', 'interpretation_zone_text', ... // tag renommé
                       'horizontalalignment', 'left');
    
    app_state.ui_elements.interpretation_zone = zone_handle;
endfunction


// --- Fonctions Dynamiques de Paramètres ---
function display_theme_parameters_dynamic(theme_key)
    global app_state;
    
    clear_parameter_zone();
    
    // CORRECTION: Utiliser la fonction helper
    module_config = get_module_config(theme_key);
    default_params = module_config.default_params;
    
    // ... reste du code identique
    panel_position = get(app_state.ui_elements.params_panel_frame, 'position');
    panel_y_start = panel_position(2);
    panel_height = panel_position(4);
    
    y_pos_start = panel_y_start + panel_height - 35 - 10;
    step = 40; 
    
    param_names = fieldnames(default_params);
    current_y_pos = y_pos_start;
    
    for i = 1:size(param_names, 1)
        param_key = param_names(i);
        
        // Accès direct (default_params est une structure connue)
        execstr("param_value = default_params." + param_key + ";");
        
        label_text = get_param_label(theme_key, param_key);
        create_parameter_field(label_text, param_key, current_y_pos, param_value);
        current_y_pos = current_y_pos - step;
    end
endfunction

function create_parameter_field(label, tag, y_pos, value) // creer_champ
    global app_state;
    
    // Le positionnement est absolu par rapport à la figure principale
    
    // Position X: 40 (label) et 190 (edit) par rapport au bord gauche de la figure
    // Largeur du panneau : 280
    
    // Label (Nom du paramètre)
    uicontrol(app_state.figure_interface, 'style', 'text', ...
              'string', label + ':', ...
              'position', [40, y_pos, 140, 20], ...
              'horizontalalignment', 'left', ...
              'background', [1 1 1], ...
              'tag', 'param_label_' + tag); // Tag unique pour nettoyage
    
    // Champ de saisie
    uicontrol(app_state.figure_interface, 'style', 'edit', ...
              'string', string(value), ...
              'position', [190, y_pos, 70, 25], ...
              'tag', 'param_' + tag); // Tag pour lecture
endfunction

function clear_parameter_zone() // nettoyer_zone_parametres
    global app_state;
    
    h_all = findobj(app_state.figure_interface);
    
    // Limites de la zone de paramètres [30, 140] à [270, 540] (approx)
    min_x = 30;
    max_x = 270;
    min_y = 140; 
    max_y = 540; 
    
    for i = 1:length(h_all)
        try
            // Vérifier si l'objet est un contrôle utilisateur (uicontrol)
            if get(h_all(i), 'type') == 'uicontrol' then
                pos = get(h_all(i), 'position');
                
                // Vérifier si la position est dans la zone à nettoyer
                if pos(1) >= min_x & pos(1) <= max_x & pos(2) >= min_y & pos(2) <= max_y then
                    tag_val = get(h_all(i), 'tag');
                    
                    // Nettoyer uniquement les champs d'édition et les labels associés
                    if strncmp(tag_val, 'param_', 6) | strncmp(tag_val, 'param_label_', 12) then
                        delete(h_all(i));
                    end
                end
            end
        catch
        end
    end
endfunction


// --- Fonction de Redimensionnement ---

function resize_interface() // redimensionner_interface
    global app_state;
    
    if isempty(app_state.figure_interface) then return; end
    
    // 1. Lire les nouvelles dimensions de la figure
    figure_handle = app_state.figure_interface; // fig
    figure_position = get(figure_handle, 'position'); // fig_pos
    figure_width = figure_position(3); // largeur_fig
    figure_height = figure_position(4); // hauteur_fig
    
    // Définir des marges et des hauteurs fixes (en pixels)
    horizontal_margin = 20; // marge_h
    vertical_margin = 15; // marge_v
    title_bar_height = 40; // hauteur_barre_titre
    selector_height = 25; // hauteur_selecteur
    interpretation_height = 40; // hauteur_interpretation
    generate_button_height = 40; // hauteur_bouton_gen
    
    // Calcul de la hauteur disponible pour les panneaux (Paramètres & Graphiques)
    y_start_panels = vertical_margin + interpretation_height + vertical_margin; 
    y_end_panels = figure_height - vertical_margin - title_bar_height - vertical_margin - selector_height - vertical_margin;
    panels_height = y_end_panels - y_start_panels;
    
    // --- Barre de Titre ---
    h_title = findobj(figure_handle, 'string', 'Plateforme de Traitement de Signal v2.0');
    if ~isempty(h_title) then
        set(h_title(1), 'position', [horizontal_margin, figure_height - title_bar_height - vertical_margin, figure_width - 2*horizontal_margin, title_bar_height]);
    end
    
    // --- Sélecteur de Thème & Aide ---
    y_selector = figure_height - title_bar_height - 2*vertical_margin - selector_height; // y_selecteur
    
    // Label : Selectionner un theme
    h_label_theme = findobj(figure_handle, 'string', 'Selectionner un theme :');
    if ~isempty(h_label_theme) then
        set(h_label_theme(1), 'position', [horizontal_margin, y_selector, 150, selector_height]);
    end
    
    // Popup : Liste des thèmes
    if isfield(app_state.ui_elements, 'popup_theme') & ~isempty(app_state.ui_elements.popup_theme) then
        set(app_state.ui_elements.popup_theme, 'position', [horizontal_margin + 160, y_selector, 400, selector_height]);
    end
    
    // Bouton Aide
    h_help = findobj(figure_handle, 'string', 'Aide'); // h_aide
    if ~isempty(h_help) then
        set(h_help(1), 'position', [figure_width - horizontal_margin - 100, y_selector, 100, selector_height]);
    end
    
    // --- Panneau Paramètres 
    parameters_width = 280; // largeur_params
    
    // Frame des paramètres
    h_frame_params = app_state.ui_elements.params_panel_frame; // h_frame_params
    if ~isempty(h_frame_params) then
        set(h_frame_params(1), 'position', [horizontal_margin, y_start_panels, parameters_width, panels_height]);
    end
    
    // Titre PARAMETRES
    h_title_params = findobj(figure_handle, 'string', 'PARAMETRES'); // h_titre_params
    if ~isempty(h_title_params) then
        set(h_title_params(1), 'position', [horizontal_margin + 10, y_start_panels + panels_height - 35, parameters_width - 20, 25]);
    end
    
    // Bouton GENERER 
    h_btn_gen = app_state.ui_elements.button_generate; // h_btn_gen
    if ~isempty(h_btn_gen) then
        set(h_btn_gen(1), 'position', [horizontal_margin + 10, y_start_panels + vertical_margin, parameters_width - 20, generate_button_height]);
    end
    
    // Les champs de paramètres (labels et edits) ont des positions absolues qui ne bougent pas avec le redimensionnement.
    
    // --- Panneau Graphiques ---
    x_start_graph = horizontal_margin + parameters_width + horizontal_margin;
    graphics_width = figure_width - x_start_graph - horizontal_margin; // largeur_graph
    
    // Frame des graphiques
    h_frame_graph = findobj(figure_handle, 'tag', 'panel_graphics_zone'); // h_frame_graph
    if ~isempty(h_frame_graph) then
        set(h_frame_graph(1), 'position', [x_start_graph, y_start_panels, graphics_width, panels_height]);
    end
    
    // Titre ZONE D'AFFICHAGE DES GRAPHIQUES
    h_title_graph = findobj(figure_handle, 'tag', 'graphics_title_text'); // h_titre_graph
    if ~isempty(h_title_graph) then
        set(h_title_graph(1), 'position', [x_start_graph + 10, y_start_panels + panels_height - 35, graphics_width - 20, 25]);
    end
    
    // --- Zone d'Interprétation ---
    y_interpretation = vertical_margin;
    
    // Titre INTERPRETATION DES RESULTATS
    h_title_inter = findobj(figure_handle, 'string', 'INTERPRETATION DES RESULTATS'); // h_titre_inter
    if ~isempty(h_title_inter) then
        set(h_title_inter(1), 'position', [x_start_graph, y_interpretation + interpretation_height, graphics_width, 20]);
    end
    
    // Zone de texte
    h_zone_inter = app_state.ui_elements.interpretation_zone;
    if ~isempty(h_zone_inter) then
        set(h_zone_inter, 'position', [x_start_graph, y_interpretation, graphics_width, interpretation_height]);
    end
    
    // --- Mise à jour des graphiques existants (si dans la même fenêtre) ---
    // (Non nécessaire ici car les graphiques sont affichés dans une fenêtre séparée.)
endfunction


// --- Fonctions d'aide (Ajout de la fonction utilitaire get_param_label) ---

function show_welcome_message() // afficher_message_bienvenue
    msg = ['Bienvenue sur la Plateforme v2.0 !'; ...
           ''; ...
           'Selectionnez un theme pour commencer.'];
    messagebox(msg, 'Bienvenue', 'info');
endfunction

function show_help() // afficher_aide
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

function label_text = get_param_label(theme_key, param_key)
    
    select theme_key
        case 'audio' then
            select param_key
                case 'duration_s' then label_text = 'Duree du signal (s)';
                case 'fan_freq_hz' then label_text = 'Freq. ventilateur (Hz)';
                case 'whistle_freq_hz' then label_text = 'Freq. sifflement (Hz)';
                case 'noise_level_factor' then label_text = 'Niveau bruit (0-1)';
                else label_text = 'ERREUR: ' + param_key;
            end
            
        case 'image' then
            select param_key
                case 'blur_sigma' then label_text = 'Intensite du flou';
                case 'salt_pepper_noise_percent' then label_text = 'Bruit poivre/sel (%)';
                case 'median_filter_size' then label_text = 'Taille filtre median';
                else label_text = 'ERREUR: ' + param_key;
            end
            
        case 'ecg' then
            select param_key
                case 'duration_s' then label_text = 'Duree (s)';
                case 'heart_rate_bpm' then label_text = 'Freq. cardiaque (BPM)';
                case 'noise_level_factor' then label_text = 'Niveau bruit (0-1)';
                case 'detection_threshold' then label_text = 'Seuil detection (0-1)';
                else label_text = 'ERREUR: ' + param_key;
            end
            
        case 'radar' then
            select param_key
                case 'target_distance_m' then label_text = 'Distance cible (m)';
                case 'snr_db' then label_text = 'SNR (dB)';
                case 'chirp_start_freq_hz' then label_text = 'Freq chirp debut (Hz)';
                case 'chirp_end_freq_hz' then label_text = 'Freq chirp fin (Hz)';
                else label_text = 'ERREUR: ' + param_key;
            end
            
        case 'radio' then
            select param_key
                case 'number_of_bits' then label_text = 'Nombre de bits';
                case 'bit_duration_s' then label_text = 'Duree par bit (s)';
                case 'carrier_freq_hz' then label_text = 'Freq porteuse (Hz)';
                case 'snr_db' then label_text = 'SNR (dB)';
                else label_text = 'ERREUR: ' + param_key;
            end
            
        else
            label_text = 'ERREUR: theme inconnu';
    end
endfunction
