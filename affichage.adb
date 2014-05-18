-- Procédures d'affichage de la grille et des messages utilisateur
package body affichage is

    -- Rôle : affichage du menu
    procedure afficherMenu is
    begin
        new_line;
        put(" ╔════════════════════╗"); new_line;
        put(" ║    Kick-Or-Flip    ║"); new_line;
        put(" ╚════════════════════╝"); new_line;
        new_line;
        put(" (1) JOUEUR vs JOUEUR"); new_line;
        put(" (2) JOUEUR vs  ORDI"); new_line;
        new_line;
    end afficherMenu;
    
    -- Rôle : affichage de la grille de jeu
    procedure afficherBordureHorizontale(pos : in PositionGrille) is
    begin
        case pos is
            when HAUT => put("  "); for i in Colonnes'range loop
                                        put("  "); put(i,0); put(" ");
                                    end loop; new_line;
                         put("  ╔"); for i in 1..35 loop
                                        put("═");
                                     end loop; put("╗");
            when BAS => put("  ╚"); for i in 1..35 loop
                                        put("═");
                                    end loop; put("╝");
            when others => raise POSITION_INVALIDE;
        end case; new_line;
    end afficherBordureHorizontale;
 
    -- Rôle : affichage d'une ligne horizontale de la grille de jeu
    procedure afficherLigneHorizontale is
    begin
        put("  ║"); for i in 1..Colonnes'last-1 loop put("───┼"); end loop;
        put("───║"); new_line;  
    end afficherLigneHorizontale;
    
    -- Rôle : retourne le caractère correspondant au pion d'un camp
    function caractereCaseJeu(lig : Lignes; col : Colonnes; jeu : Damier) return
        String is
    mcase : CaseJeu := jeu(lig,col);
    begin
        case mcase.mtype is
            when VIDE => return " ";
            when OCCUPE => if(mcase.mpion.camp = BLANC) then
                               return "☻";
                           else
                               return "☺";
                           end if;
        end case;
    end caractereCaseJeu;
    
    -- Rôle : affiche une ligne de la grille de jeu
    procedure afficherLigneDamier(jeu : in Damier; lig : Lignes) is
    begin
        put(lig); put(" ║");
        for i in Colonnes'range loop
            put(" "); put(caractereCaseJeu(lig,i,jeu)); put(" ");
            if(i /= Colonnes'last) then put("│"); end if;
        end loop;
        put("║"); new_line;
    end afficherLigneDamier;
    
    -- Rôle : affichage complet de la grille de jeu
    procedure afficherDamier(jeu : in Damier) is
    begin
        new_line; new_line;
        afficherBordureHorizontale(HAUT);
        for c in Lignes'range loop
            afficherLigneDamier(jeu,c);
            if(c /= Lignes'last) then afficherLigneHorizontale; end if; 
        end loop;
        afficherBordureHorizontale(BAS);
        new_line; new_line;
    end afficherDamier;
    
    -- Rôle : affichage du tour de jeu d'un joueur donné
    procedure afficherTourJeu(j : in Joueur) is
    begin
        put("Tour de '" & j.nom(1..j.longueurNom)
            & "' ( " & Couleur'Image(j.camp) & " )");
        new_line;
    end afficherTourJeu;
    
    -- Rôle : affiche le résultat final d'une partie
    procedure afficherResultat(jeu : in Damier; j1,j2 : in Joueur; j1g,j2g : in Boolean) is
    jG : Joueur;
    begin
        if(j1g) then
            jG := j1;
        elsif(j2g) then
            jG := j2;
        end if;        
        put("Partie terminée, '" & jG.nom(1..jG.longueurNom)
            & "' ( " & Couleur'Image(jG.camp) & " ) a gagné !");
        new_line;
    end afficherResultat;
    
    -- Rôle : affichage des coordonnées d'une cible
    procedure afficherCible(c : in Cible) is
    begin
        put(c.lig); put(c.col,0); put(' ');
    end afficherCible;
    
    -- Rôle : affichage d'un coup complet ( liste de cibles )
    procedure afficherMouvements(c : in Coup) is
    begin
        put("Coup : ");
        put(c.mciblePion.lig); put(c.mciblePion.col,0); put(' ');
        for i in 1..c.nombreCibles loop
            afficherCible(c.mcibles(i));
        end loop;
    end afficherMouvements;
    
   -- Rôle : affichage de l'aide à la saisie de coups
   procedure afficherAideSaisieCoups is
    begin
        new_line;
        put("Aide de la saisie de coups");
        new_line; new_line;
        put("On saisie les coordonnées sous la forme 'XY' où X designe la ligne"
            & " (lettre), et Y la colonne (nombre) dans le damier.");
        new_line;
        put("La première coordonnée attendue est celle du pion qui exécute le"
            & " coup, et la/les coordonnées suivantes (séparées par un espace)"
            & " sont les cases où celui-ci doit jouer.");
        new_line;
        put("Ex : B4 B5 D5 désigne le mouvement du pion en B4 vers la case B5"
            & " puis D5.");
        new_line;
        put("Pour plus d'informations sur les mouvements se référer aux règles"
            & " du Kick-Or-Flip.");
        new_line; new_line;
    end afficherAideSaisieCoups;
    
    -- Rôle : affichage des messages d'erreur d'entrée de mouvements
    procedure afficherMessageErreurMouv(msg : in MessageErreurMouv; dep,dest : Cible) is
    begin
        case msg is
            when PION_SELECTIONNE_INVALIDE =>
                put("Le pion sélectionné est invalide");
            when CASE_CIBLE_OCCUPE =>
                put("La case cible du déplacement doit être vide");
            when DIRECTION_INVALIDE =>
                put("La direction du mouvement est invalide");
            when FLIP_NON_UNIQUE =>
                put("Le flip ne peut cibler qu'un pion par saut");
            when KICK_NON_UNIQUE =>
                put("Un seul kick uniquement est autorisé par tour");            
            when CASE_CIBLE_NON_VOISINE =>
                put("La case de mouvement doit être voisine du pion ciblé");
            when PION_CIBLE_VOISINS =>
                put("La cible du kick ne peut pas être voisine du pion");
            when OBSTACLE_TRAJECTOIRE =>
                put("Il ne doit pas y avoir d'obstacle au déplacement du pion");
            when CAMP_PION_CIBLE_ALLIE =>
                put("Le pion ciblé doit appartenir au camp adverse");
        end case;
        -- affichage du mouvement concerné par l'erreur
        put(" ( "); afficherCible(dep); put("-> "); afficherCible(dest); put(").");      
        new_line;
    end afficherMessageErreurMouv;
    
end affichage;