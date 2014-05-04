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
begin
    -- un kick n'est possible que sur une seule cible
    if (c.nombreCibles > 1) or (c.nombreCibles = 0) then
        c.mtype := ERREUR_AVANT_ELIM;
        put("Le kick n'est possible que sur une seule cible"); new_line;
    end if;         
    -- la cible doit être un pion adverse
    if (jeu(c.mcibles(1).lig,c.mcibles(1).col).mpion.camp = j.camp) then
        c.mtype := ERREUR_AVANT_ELIM;
        put("La cible du kick ne peut pas être du même camp"); new_line;
    end if;         
    -- la cible ne doit pas être voisine du pion
    if (casesVoisines(pion,c.mcibles(1),jeu)) then
        c.mtype := ERREUR_AVANT_ELIM;
        put("La cible du kick ne peut pas être voisine du pion"); new_line;
    end if; 
    -- la cible doit être dans une des 8 directions possibles
    if (not directionValide(pion,c.mcibles(1))) then
        c.mtype := ERREUR_AVANT_ELIM;
        put("La cible doit être dans une des 8 directions possibles"); new_line;
    end if;         
    -- il ne doit pas y avoir d'obstacles entre le pion et la cible
    if (not trajectoireLibre(pion,c.mcibles(1),jeu)) then
        c.mtype := ERREUR_AVANT_ELIM;
        put("Il ne doit pas y avoir d'obstacles sur la trajectoire du pion"); new_line;
    end if;
end verifierKICK;

procedure verifierFLIP(jeu : in Damier; j : in Joueur; c : in out Coup) is

procedure verifierFLIPUnique(jeu : in out Damier; j : in Joueur;
                             depart, dest : in Cible; stat : out TypeCoup;
                             pion : out Cible) is
nbPions : Integer;
listePions : ListeCibles;
begin
    put("veriFlip");
    -- case destination vide
    if (jeu(dest.lig,dest.col).mtype = OCCUPE) then        
        stat := ERREUR_DEST_SAUT;
        put("La case de saut doit être vide"); new_line;
        return;
    end if;    
    -- la cible doit être dans une des 8 directions possibles
    if (not directionValide(depart,dest)) then
        stat := ERREUR_DEST_SAUT;
        put("La cible doit être dans une des 8 directions possibles"); new_line;
    end if; 
    -- pas d'obstacle mis à part le pion retourné
    trouverObstacles(depart, dest, jeu, nbPions, listePions);
    pion := listePions(1);
    if (nbPions > 1) then
        stat := ERREUR_CASE_SAUTEE;
        put("Un seul pion peut être retourné lors d'un flip"); new_line;
    end if;    
    -- cible voisine au pion retourné
    if (not casesVoisines(dest,listePions(1),jeu)) then
        stat := ERREUR_DEST_SAUT;
        put("Le pion retourné doit être voisin de la case de saut"); new_line;
    end if; 
    -- pion retourné de camp opposé
     if (jeu(listePions(1).lig,listePions(1).col).mpion.camp = j.camp) then
        stat := ERREUR_CASE_SAUTEE;
        put("Le pion retourné doit être de couleur adverse"); new_line;
    end if;
end verifierFLIPUnique;

cJeu : Damier := jeu;
pionDep : Cible := c.mciblePion;
pionRet : Cible;
indC : Integer := 1;
fin : Boolean := false;
statutFlip : TypeCoup;
begin
    -- on vérifie chacun des flips
    put("uniFlip -> "); put(c.nombreCibles,0); new_line;
    while (not fin) and (indC <= c.nombreCibles) loop
        put(indC);
        -- on vérifie le flip traité
        verifierFLIPUnique(cJeu, j, pionDep, c.mcibles(indC), statutFlip, pionRet);
        
        -- si il est valide on l'applique dans notre copie de la grille de jeu
        -- afin d'empêcher le saut du même pion plusieurs fois
        if (statutFlip = FLIP) then
            if(j.camp = BLANC) then
                cJeu(pionRet.lig,pionRet.col).mpion.camp := NOIR;
            else
                cJeu(pionRet.lig,pionRet.col).mpion.camp := BLANC;
            end if;
        -- sinon on arrête la vérification
        else
            fin := true;
            c.mtype := statutFlip;
        end if;    
        indC := indC + 1;
        pionDep := c.mcibles(indC);
    end loop;
end verifierFLIP;

procedure verifierCoup(jeu : in Damier; j : in Joueur; c : in out Coup) is
pion : Cible := c.mciblePion;

begin
    -- le pion de départ est invalide
    if (jeu(pion.lig,pion.col).mtype = VIDE) or (jeu(pion.lig,pion.col).mpion.camp /= j.camp) then
        c.mtype := ERREUR_CASE_DEPART;
        --return;
        put("Le pion choisi est invalide"); new_line;
    end if;
    
    -- on vérifie le type du premier coup effectué
    if (jeu(c.mcibles(1).lig,c.mcibles(1).col).mtype = OCCUPE) then
        c.mtype := KICK;
        verifierKICK(jeu, j, c);
    else
        c.mtype := FLIP;
        verifierFLIP(jeu, j, c);
    end if;
        
    put(TypeCoup'Image(c.mtype)); new_line;
end verifierCoup;

end gestion_jeu;