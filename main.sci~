// =========================================================================
// Point d'entree 
// =========================================================================

clear; clc; close;

disp('=========================================');
disp('  Plateforme Traitement Signal      ');
disp('  Architecture Modulaire                ');
disp('=========================================');
disp('');

// Determiner le chemin du dossier src
chemin_actuel = pwd();

// Verifier si on est dans src
if ~isdir('config') then
    // On n'est pas dans src, essayer d'y aller
    if isdir('src') then
        cd('src');
        disp('Navigation vers src/');
    else
        error('Erreur : Impossible de trouver le dossier src. Lancez depuis le dossier Plateforme_Traitement_Signal ou src/');
    end
end

chemin_src = pwd();
disp('Chemin src : ' + chemin_src);
disp('');

disp('Chargement des modules...');

// 1. Configuration
disp('  -> config.sci');
exec('config\config.sci', -1);

// 2. Utilitaires
disp('  -> math_utils.sci');
exec('utils\math_utils.sci', -1);
disp('  -> signal_utils.sci');
exec('utils\signal_utils.sci', -1);

// 3. Interface utilisateur
disp('  -> interface.sci');
exec('ui\interface.sci', -1);
disp('  -> events.sci');
exec('ui\events.sci', -1);
disp('  -> display.sci');
exec('ui\display.sci', -1);

// 4. Modules de traitement
disp('  -> theme_audio.sci');
exec('themes\theme_audio.sci', -1);
disp('  -> theme_image.sci');
exec('themes\theme_image.sci', -1);
disp('  -> theme_ecg.sci');
exec('themes\theme_ecg.sci', -1);
disp('  -> theme_radar.sci');
exec('themes\theme_radar.sci', -1);
disp('  -> theme_radio.sci');
exec('themes\theme_radio.sci', -1);

disp('');
disp('Tous les modules charges !');
disp('');
disp('Lancement de l''interface...');

creer_interface_principale();

disp('Application prete !');
disp('Selectionnez un theme et cliquez sur GENERER.');
disp('');
