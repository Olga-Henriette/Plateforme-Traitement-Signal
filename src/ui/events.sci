// =========================================================================
// Gestion des evenements utilisateur
// =========================================================================

function evenement_changement_theme()
    global app_state;
    
    try
        if ~isfield(app_state.ui_elements, 'popup_theme') then
            disp('Erreur : popup_theme non trouve');
            return;
        end
        
        h = app_state.ui_elements.popup_theme;
        app_state.theme_actuel = get(h, 'value');
        
        afficher_parametres_theme(app_state.theme_actuel);
        
        mettre_a_jour_interpretation('Theme modifie. Ajustez les parametres puis cliquez sur GENERER.');
    catch
        disp('Erreur dans evenement_changement_theme');
    end
endfunction

function evenement_generer_resultats()
    global app_state;
    
    try
        disp('=== DEBUG : Debut generation ===');
        disp('Theme actuel : ' + string(app_state.theme_actuel));
        
        lire_parametres_interface();
        
        disp('Parametres lus avec succes');
        
        mettre_a_jour_interpretation('Generation en cours...');
        
        select app_state.theme_actuel
        case 1 then
            disp('Lancement traitement audio...');
            traitement_audio_podcast();
        case 2 then
            disp('Lancement traitement image...');
            traitement_image_medicale();
        case 3 then
            disp('Lancement traitement ECG...');
            traitement_ecg();
        case 4 then
            disp('Lancement traitement radar...');
            traitement_radar();
        case 5 then
            disp('Lancement traitement radio...');
            traitement_liaison_radio();
        else
            error('Theme invalide');
        end
        
        disp('=== DEBUG : Fin generation ===');
        
    catch
        msg_erreur = 'Erreur lors de la generation. Verifiez vos parametres.';
        disp('');
        disp('=== ERREUR DETAILLEE ===');
        err = lasterror();
        disp('Message : ' + err.message);
        disp('Stack :');
        for i = 1:size(err.stack, 1)
            disp('  Ligne ' + string(err.stack(i).line) + ' dans ' + err.stack(i).name);
        end
        disp('======================');
        disp('');
        mettre_a_jour_interpretation(msg_erreur);
        messagebox([msg_erreur; ''; 'Voir console pour details'], 'Erreur', 'error');
    end
endfunction

function lire_parametres_interface()
    global app_state;
    
    select app_state.theme_actuel
    case 1 then
        app_state.params.theme1.duree = lire_valeur('duree');
        app_state.params.theme1.f_ventilateur = lire_valeur('f_ventilateur');
        app_state.params.theme1.f_sifflement = lire_valeur('f_sifflement');
        app_state.params.theme1.niveau_bruit = lire_valeur('niveau_bruit');
        
    case 2 then
        app_state.params.theme2.sigma_flou = lire_valeur('sigma_flou');
        app_state.params.theme2.niveau_bruit = lire_valeur('niveau_bruit_img') / 100;
        app_state.params.theme2.taille_median = lire_valeur('taille_median');
        
    case 3 then
        app_state.params.theme3.duree = lire_valeur('duree_ecg');
        app_state.params.theme3.freq_cardiaque = lire_valeur('freq_cardiaque');
        app_state.params.theme3.niveau_bruit = lire_valeur('niveau_bruit_ecg');
        app_state.params.theme3.seuil_detection = lire_valeur('seuil_detection');
        
    case 4 then
        app_state.params.theme4.distance = lire_valeur('distance');
        app_state.params.theme4.snr_db = lire_valeur('snr_db_radar');
        app_state.params.theme4.f_chirp_debut = lire_valeur('f_chirp_debut');
        app_state.params.theme4.f_chirp_fin = lire_valeur('f_chirp_fin');
        
    case 5 then
        app_state.params.theme5.nb_bits = lire_valeur('nb_bits');
        app_state.params.theme5.duree_bit = lire_valeur('duree_bit');
        app_state.params.theme5.f_porteuse = lire_valeur('f_porteuse');
        app_state.params.theme5.snr_db = lire_valeur('snr_db_radio');
    end
endfunction

function valeur = lire_valeur(tag)
    h = findobj('tag', 'param_' + tag);
    if isempty(h) then
        disp('Attention : parametre ' + tag + ' non trouve');
        valeur = 0;
    else
        try
            valeur = strtod(get(h(1), 'string'));
        catch
            disp('Erreur lecture parametre ' + tag);
            valeur = 0;
        end
    end
endfunction

function mettre_a_jour_interpretation(texte)
    global app_state;
    
    try
        if isfield(app_state.ui_elements, 'zone_interpretation') then
            set(app_state.ui_elements.zone_interpretation, 'string', texte);
        else
            disp('Interpretation : ' + texte);
        end
    catch
        disp('Erreur mise a jour interpretation');
        disp('Texte : ' + texte);
    end
endfunction
