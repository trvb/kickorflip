package body entrees_jeu is

    procedure saisirJoueurs(j1,j2 : out Joueur) is    
    begin
        -- TODO : Version 4,5 : support du joueur IA
        j1.camp := BLANC; j2.camp := NOIR;
        put("Joueur 1 - BLANC - Nom : "); get_line(j1.nom,j1.longueurNom);
        put("Joueur 2 - NOIR  - Nom : "); get_line(j2.nom,j2.longueurNom);
    end saisirJoueurs;
    
    procedure saisirMouvements(coupRet : out Coup) is
    c : Coup; cib : Cible;
    lenMax : Integer := 100; -- valeur maximale arbitraire de la longueur de cstr
    cstr : String(1..lenMax);
    lenstr : Integer;
    i : Integer := 1;
    err : Boolean := false;
    saisie1 : Boolean := true;
     
    begin
        put("Saisie coup (? : Aide) : ");
        get_line(cstr,lenstr);
        if(cstr(1..1) = "?") then
            afficherAideSaisieCoups;
            saisirMouvements(coupRet);
        else
        -- on commence à parser la ligne
            while (i <= lenstr) and (not err) loop
                if (cstr(i) /= ' ') then -- on saute les espaces éventuels
                    -- on vérifie la validité des coordonnées fournies
                    if (cstr(i) in Lignes) and (convCharInt(cstr(i+1)) in Colonnes) then
                        cib.lig := cstr(i);
                        cib.col := convCharInt(cstr(i+1));
                        -- si il s'agit de la première coordonnée, c'est celle
                        -- du pion de départ
                        if(saisie1) then
                            c.mciblePion := cib;
                            saisie1 := false;
                        -- sinon on l'ajoute dans la liste des cibles
                        else
                            c.nombreCibles := c.nombreCibles + 1;
                            c.mcibles(c.nombreCibles) := cib;
                        end if;
                        i := i + 2;
                    -- si la ligne est invalide, on fait recommencer l'opération
                    -- et on empêche les suivantes de se produire
                    else
                        put("Format de la saisie invalide."); new_line;
                        err := true;
                    end if;
                else
                    i := i + 1;
                end if;
            end loop;
            -- on vérifie qu'il n'y a pas qu'une cible qui a été saisie
            if(not err) and (c.nombreCibles = 0) then
                put("Il faut également saisir les cibles sur la même ligne que"
                    & "le pion choisi."); new_line;
                err := true;
            end if;
            -- si tout est correct on retourne
            if(not err) then
                coupRet := c;
            -- sinon on recommence l'opération
            else            
                saisirMouvements(coupRet);
            end if;
        end if;
    end saisirMouvements;    
    
end entrees_jeu;