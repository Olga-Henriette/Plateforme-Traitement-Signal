
// =========================================================================
// Fonctions mathématiques utilitaires
// =========================================================================

function [val_max, idx_max] = trouver_maximum(vecteur)
    // Trouve le maximum et son indice
    // Compatible Scilab (pas de syntaxe MATLAB [~, idx])
    val_max = max(vecteur);
    idx_max = find(vecteur == val_max);
    idx_max = idx_max(1); // Prendre le premier si plusieurs
endfunction

function [val_min, idx_min] = trouver_minimum(vecteur)
    // Trouve le minimum et son indice
    val_min = min(vecteur);
    idx_min = find(vecteur == val_min);
    idx_min = idx_min(1);
endfunction

function resultat = calculer_mse(signal1, signal2)
    // Calcule l'erreur quadratique moyenne
    resultat = mean((double(signal1(:)) - double(signal2(:))).^2);
endfunction

function resultat = calculer_snr(signal, bruit)
    // Calcule le rapport signal sur bruit
    puissance_signal = mean(signal.^2);
    puissance_bruit = mean(bruit.^2);
    resultat = 10 * log10(puissance_signal / puissance_bruit);
endfunction

function normalise = normaliser_signal(signal)
    // Normalise un signal entre -1 et 1
    normalise = signal / max(abs(signal));
endfunction

function resultat = calculer_correlation(signal1, signal2)
    // Calcule la corrélation croisée
    resultat = xcorr(signal1, signal2);
endfunction
