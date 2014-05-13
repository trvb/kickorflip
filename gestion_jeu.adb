package body gestion_jeu is

procedure initialiserDamier(jeu : out Damier) is
begin
    for i in Colonnes'Range loop
        if(i <= 3) then -- pions noirs
            for c in Lignes'Range loop
                jeu(c,i).mpion.camp := BLANC;
                jeu(c,i).mtype := OCCUPE;
            end loop;
        elsif(i >= 7) then -- pions blancs
            for c in Lignes'Range loop
                jeu(c,i).mpion.camp := NOIR;
                jeu(c,i).mtype := OCCUPE;
            end loop;
        end if;
    end loop;
    jeu('D',5).mtype := OCCUPE;
    jeu('D',5).mpion.camp := NOIR;
    jeu('F',5).mtype := OCCUPE;
    jeu('F',5).mpion.camp := NOIR;
    jeu('H',5).mtype := OCCUPE;
    jeu('H',5).mpion.camp := BLANC;
end initialiserDamier;

procedure verifierKICK(jeu : in Damier; j : in Joueur; c : in out Coup) is
pion : Cible := c.mciblePion;
dest : Cible := c.mcibles(1);
begin
    -- un kick n'est possible que sur une seule cible
    if (c.nombreCibles > 1) or (c.nombreCibles = 0) then
        c.mtype := ERREUR_AVANT_ELIM;
        afficherMessageErreurMouv(KICK_NON_UNIQUE, pion, dest);
    end if;         
    -- la cible doit être un pion adverse
    if (jeu(dest.lig,dest.col).mpion.camp = j.camp) then
        c.mtype := ERREUR_AVANT_ELIM;
        afficherMessageErreurMouv(CAMP_PION_CIBLE_ALLIE, pion, dest);
    end if;         
    -- la cible ne doit pas être voisine du pion
    if (casesVoisines(pion,dest,jeu)) then
        c.mtype := ERREUR_AVANT_ELIM;
        afficherMessageErreurMouv(PION_CIBLE_VOISINS, pion, dest);
    end if; 
    -- la cible doit être dans une des 8 directions possibles
    if (not directionValide(pion,dest)) then
        c.mtype := ERREUR_AVANT_ELIM;
        afficherMessageErreurMouv(DIRECTION_INVALIDE, pion, dest);
    end if;         
    -- il ne doit pas y avoir d'obstacles entre le pion et la cible
    if (not trajectoireLibre(pion,dest,jeu)) then
        c.mtype := ERREUR_AVANT_ELIM;
        afficherMessageErreurMouv(OBSTACLE_TRAJECTOIRE, pion, dest);
    end if;
end verifierKICK;

procedure verifierFLIPUnique(jeu : in out Damier; j : in Joueur;
                             depart, dest : in Cible; stat : out TypeCoup;
                             pion : out Cible) is
nbPions : Integer;
listePions : ListeCibles;
begin
    stat := FLIP;
    -- case destination vide
    if (jeu(dest.lig,dest.col).mtype = OCCUPE) then        
        stat := ERREUR_DEST_SAUT;
        afficherMessageErreurMouv(CASE_CIBLE_OCCUPE, depart, dest);
        return;
    end if;    
    -- la cible doit être dans une des 8 directions possibles
    if (not directionValide(depart,dest)) then
        stat := ERREUR_DEST_SAUT;
        afficherMessageErreurMouv(DIRECTION_INVALIDE, depart, dest);
        return;
    end if; 
    -- pas d'obstacle mis à part le pion retourné
    trouverObstacles(depart, dest, jeu, nbPions, listePions);
    pion := listePions(1);
    if (nbPions > 1) then
        stat := ERREUR_CASE_SAUTEE;
        afficherMessageErreurMouv(FLIP_NON_UNIQUE, depart, dest);
        return;
    end if;    
    -- cible voisine au pion retourné
    if (not casesVoisines(dest,listePions(1),jeu)) then
        stat := ERREUR_DEST_SAUT;
        afficherMessageErreurMouv(CASE_CIBLE_NON_VOISINE, depart, dest);
        return;
    end if; 
    -- pion retourné de camp opposé
     if (jeu(listePions(1).lig,listePions(1).col).mpion.camp = j.camp) then
        stat := ERREUR_CASE_SAUTEE;
        afficherMessageErreurMouv(CAMP_PION_CIBLE_ALLIE, depart, dest);
        return;
    end if;
end verifierFLIPUnique;

procedure verifierFLIP(jeu : in Damier; j : in Joueur; c : in out Coup) is
copieJeu : Damier := jeu;
pionDep : Cible := c.mciblePion;
pionRet : Cible;
indC : Integer := 1;
fin : Boolean := false;
statutFlip : TypeCoup;
begin
    -- on vérifie chacun des flips
    while (not fin) and (indC <= c.nombreCibles) loop
        -- on vérifie le flip traité
        verifierFLIPUnique(copieJeu, j, pionDep, c.mcibles(indC), statutFlip, pionRet);        
        -- si il est valide on l'applique dans notre copie de la grille de jeu
        -- afin d'empêcher le saut du même pion plusieurs fois
        if (statutFlip = FLIP) then
            copieJeu(pionRet.lig,pionRet.col).mpion.camp := campInv(j.camp);
        -- sinon on arrête la vérification
        else
            fin := true;
            c.mtype := statutFlip;
        end if;
        pionDep := c.mcibles(indC);
        indC := indC + 1;
    end loop;
end verifierFLIP;

procedure verifierCoup(jeu : in Damier; j : in Joueur; c : in out Coup; v : out Boolean) is
pion : Cible := c.mciblePion;
begin
    -- le pion de départ est invalide
    if (jeu(pion.lig,pion.col).mtype = VIDE) or
       (jeu(pion.lig,pion.col).mpion.camp /= j.camp) then       
        c.mtype := ERREUR_CASE_DEPART;
        afficherMessageErreurMouv(PION_SELECTIONNE_INVALIDE, pion, c.mcibles(1));
        v := false;
        return;
    end if;    
    -- on vérifie le type du premier coup effectué
    if (jeu(c.mcibles(1).lig,c.mcibles(1).col).mtype = OCCUPE) then
        c.mtype := KICK;
        verifierKICK(jeu, j, c);
    else
        c.mtype := FLIP;
        verifierFLIP(jeu, j, c);
    end if;
    
    v := (c.mtype = FLIP) or (c.mtype = KICK); -- validité du coup
end verifierCoup;

procedure executerCoup(jeu : in out Damier; j : in Joueur; c : in Coup) is
nbP : Integer;
listeP : ListeCibles;
pionDep,pionDest : Cible;
begin
-- le coup doit avoir été vérifié préalablement, sinon cette procédure peut
-- avoir un comportement inattendu ou arrêter le programme (exception levée)
    case c.mtype is
    when KICK =>        
        jeu(c.mcibles(1).lig,c.mcibles(1).col).mpion.camp := j.camp;
        jeu(c.mciblePion.lig,c.mciblePion.col).mtype := VIDE;
    when FLIP =>
        pionDep := c.mciblePion;
        pionDest := c.mcibles(1);
        put(c.nombreCibles);
        for i in 1..c.nombreCibles loop
            trouverObstacles(pionDep, pionDest, jeu, nbP, listeP);
            -- on change de camp le pion retourné par le flip
            jeu(listeP(1).lig,listeP(1).col).mpion.camp := j.camp;
            -- puis on déplace le pion qui a effectué le flip
            jeu(pionDep.lig,pionDep.col).mtype := VIDE;
            jeu(pionDest.lig,pionDest.col).mtype := OCCUPE;
            jeu(pionDest.lig,pionDest.col).mpion.camp := j.camp;            
            -- on itère dans les cibles du flip
            pionDep := pionDest;
            pionDest := c.mcibles(i+1);
        end loop;
    when others => raise COUP_NON_EXECUTABLE;
    end case;
end executerCoup;

end gestion_jeu;