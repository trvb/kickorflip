package body gestion_jeu is

procedure initialiserDamier(jeu : out Damier) is
begin
    for i in Colonnes'Range loop
        if(i <= 3) then -- pions noirs
            for c in Lignes'Range loop
                jeu(c,i).mpion.camp := NOIR;
                jeu(c,i).mtype := OCCUPE;
            end loop;
        elsif(i >= 7) then -- pions blancs
            for c in Lignes'Range loop
                jeu(c,i).mpion.camp := BLANC;
                jeu(c,i).mtype := OCCUPE;
            end loop;
        end if;
    end loop;
end initialiserDamier;

procedure verifierCoup(jeu : in Damier; j : in Joueur; c : in out Coup) is
typeAnalyse : TypeCoup;
begin
    -- le pion de départ est invalide
    if (jeu(c.mciblePion.lig,c.mciblePion.col).mtype = VIDE)
        or (jeu(c.mciblePion.lig,c.mciblePion.col).mpion.camp /= j.camp) then
        c.mtype := ERREUR_CASE_DEPART;
        return;
    end if;
    
    -- on vérifie le type du premier coup effectué
    if (jeu(c.mcibles(1).lig,c.mcibles(1).col).mtype = VIDE) then
        typeAnalyse := FLIP;
    else
        typeAnalyse := KICK;
    end if;
    
    -- vérifications KICK
    if (typeAnalyse = KICK) then
        null;
    end if;
    
    -- vérifications FLIP
    if (typeAnalyse = FLIP) then
        null;
    end if;
        
end verifierCoup;

end gestion_jeu;