
// =========================================================================
// Amélioration d'image médicale
// =========================================================================

function traitement_image_medicale()
    global app_state;
    p = app_state.params.theme2;
    
    // Génération image synthétique
    [img_orig, img_bruite] = generer_image_test(p);
    
    // Traitement
    img_debruit = appliquer_filtre_median_image(img_bruite, p.taille_median);
    img_accent = appliquer_accentuation_image(img_debruit);
    
    // Métriques
    MSE_bruite = calculer_mse(img_orig, img_bruite);
    MSE_traitee = calculer_mse(img_orig, img_accent);
    amelioration = ((MSE_bruite - MSE_traitee) / MSE_bruite) * 100;
    
    // Affichage
    afficher_resultats_image(img_orig, img_bruite, img_debruit, img_accent);
    
    // Interprétation
    texte = sprintf('Traitement reussi ! Amelioration de %.1f%% (MSE : %.1f -> %.1f). Le filtre median a elimine le bruit et accentuation a restaure les details.', ...
                    amelioration, MSE_bruite, MSE_traitee);
    mettre_a_jour_interpretation(texte);
endfunction

function [img_orig, img_bruite] = generer_image_test(p)
    // Image originale synthétique
    l = 200; 
    c = 200;
    img_orig = zeros(l, c);
    img_orig(50:150, 80:120) = 1;
    
    // Cercle
    [xx, yy] = ndgrid(1:l, 1:c);
    centre = [100, 100];
    rayon = 30;
    masque = ((xx - centre(1)).^2 + (yy - centre(2)).^2) <= rayon^2;
    img_orig(masque) = 1;
    img_orig = uint8(img_orig * 255);
    
    // Flou gaussien
    taille_noyau = 2 * ceil(3 * p.sigma_flou) + 1;
    x_lin = linspace(-(taille_noyau-1)/2, (taille_noyau-1)/2, taille_noyau);
    noyau_gauss = exp(-(x_lin.^2) / (2 * p.sigma_flou^2));
    noyau_gauss = noyau_gauss' * noyau_gauss;
    noyau_gauss = noyau_gauss / sum(noyau_gauss);
    img_floue = conv2(double(img_orig), noyau_gauss, 'same');
    img_floue = uint8(img_floue);
    
    // Bruit poivre et sel
    img_bruite = double(img_floue);
    masque_bruit = rand(size(img_floue)) < p.niveau_bruit;
    img_bruite(masque_bruit) = rand(sum(masque_bruit), 1) * 255;
    img_bruite = uint8(img_bruite);
endfunction

function img_out = appliquer_filtre_median_image(img, taille)
    [l, c] = size(img);
    img_out = img;
    demi = floor(taille/2);
    
    for i = (1+demi):(l-demi)
        for j = (1+demi):(c-demi)
            voisinage = double(img(i-demi:i+demi, j-demi:j+demi));
            img_out(i, j) = median(voisinage(:));
        end
    end
endfunction

function img_out = appliquer_accentuation_image(img)
    masque_sharpen = [0, -1, 0; -1, 5, -1; 0, -1, 0];
    img_out = conv2(double(img), masque_sharpen, 'same');
    img_out = uint8(max(0, min(255, img_out)));
endfunction

function afficher_resultats_image(img1, img2, img3, img4)
    creer_figure_resultats('Theme 2 : Image Medicale', 2);
    
    tracer_image(img1, 'Image originale', 2*100+3*10+1);
    tracer_image(img2, 'Image floue et bruitee', 2*100+3*10+2);
    tracer_histogramme(img2, 'Histogramme - Bruitee', 2*100+3*10+3);
    tracer_image(img3, 'Apres filtre median', 2*100+3*10+4);
    tracer_image(img4, 'Image finale accentuee', 2*100+3*10+5);
    tracer_histogramme(img4, 'Histogramme - Traitee', 2*100+3*10+6);
endfunction
