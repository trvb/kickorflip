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
end initialiserDamier;

procedure verifierCoup(jeu : in Damier; j : in Joueur; c : in out Coup) is
pion : Cible := c.mciblePion;

begin
    -- le pion de départ est invalide
    if (jeu(pion.lig,pion.col).mtype = VIDE) or (jeu(pion.lig,pion.col).mpion.camp /= j.camp) then
        put(Couleur'Image(jeu(pion.lig,pion.col).mpion.camp)); put(Couleur'Image(j.camp));
        c.mtype := ERREUR_CASE_DEPART;
        --return;
        put("Le pion choisi est invalide"); new_line;
    end if;
    
    -- on vérifie le type du premier coup effectué
    if (jeu(c.mcibles(1).lig,c.mcibles(1).col).mtype = VIDE) then
        c.mtype := FLIP;
    else
        c.mtype := KICK;
    end if;
    
    -- vérifications KICK
    if (c.mtype = KICK) then    
         -- un kick n'est possible que sur une seule cible
         if (c.nombreCibles > 1) then
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
    end if;
    
    -- vérifications FLIP
    if (c.mtype = FLIP) then
        null;
    end if;
        
    put(TypeCoup'Image(c.mtype));
end verifierCoup;

end gestion_jeu;