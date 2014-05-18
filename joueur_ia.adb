-- Procédures de génération de coups (pseudo IA) par l'ordinateur
-- Cette version ne génère que des coups simples ( 1 kick ou 1 flip )
package body joueur_ia is

-- Rôle : calcule tous les coups possibles simples pour un pion donné
procedure calculerMouvementPion(j : in Joueur; jeu : in Damier;
                                ls : out ListeCoups; indCoups : in out Integer;
                                l : in Lignes; c : in Colonnes) is
cib1,cib2,cib3 : Cible;
ltmp,ld,lf : Lignes;
ctmp,cd,cf : Colonnes;
coupTmp : Coup;
b,finAv : Boolean;
vectX,vectY,module : Integer;
begin
cib1.lig := l; cib1.col := c;
sousMatriceVoisins(cib1, jeu, ld, lf, cd, cf);
-- pour chacun des voisins valides du pion analysé
for ligne in ld..lf loop
    for colonne in cd..cf loop
        -- on calcule un vecteur direction
        cib2.lig := ligne; cib2.col := colonne;
        vecteurDirection(cib1,cib2,b,vectX,vectY);
        if b then
            ltmp := l; ctmp := c;
            finAv := false;
            module := 0;
            -- tant qu'on peut avancer dans cette direction
            while cibleValide(Lignes'pos(ltmp)+vectX-64,ctmp+vectY) and not(finAv) loop
                ltmp := Lignes'val(Lignes'pos(ltmp)+vectX);
                ctmp := ctmp + vectY;
                module := module + 1;
                -- si on rencontre un pion en parcourant
                if(jeu(ltmp,ctmp).mtype = OCCUPE) then
                    -- et qu'il est adverse donc une cible
                    if (jeu(ltmp,ctmp).mpion.camp /= j.camp) and (module /= 1) then
                        -- on enregistre le coup kick
                        coupTmp.mciblePion := cib1;
                        cib3.lig := ltmp; cib3.col := ctmp;
                        coupTmp.mcibles(1) := cib3;
                        coupTmp.nombreCibles := 1;
                        indCoups := indCoups + 1;
                        ls(indCoups) := coupTmp;
                        finAv := true;                        
                        -- et si possible aussi le flip
                        if cibleValide(Lignes'pos(ltmp)+vectX-64,ctmp+vectY) then
                            cib3.lig := Lignes'val(Lignes'pos(ltmp)+vectX);
                            cib3.col := ctmp + vectY;                            
                            if(jeu(cib3.lig,cib3.col).mtype = VIDE) then
                                coupTmp.mcibles(1) := cib3;
                                coupTmp.nombreCibles := 1;
                                indCoups := indCoups + 1;
                                ls(indCoups) := coupTmp;
                            end if;
                        end if;
                    -- sinon cette voie est obstruée et est abandonnée
                    else
                        finAv := true;
                    end if;
                end if;
            end loop;
        end if;
    end loop;
end loop;
end calculerMouvementPion;

-- Rôle : retourne un coup valide généré par l'ordinateur et sélectionné aléatoirement
procedure calculerCoup(j : in Joueur; jeu : in Damier; c : out Coup) is
liste : ListeCoups;
ind : Integer;
nCoups : Integer := 0;
valide : Boolean := false;

begin
    for col in Colonnes'range loop
        for lig in Lignes'range loop
            if(jeu(lig,col).mtype = OCCUPE) and
              (jeu(lig,col).mpion.camp = j.camp) then
              -- pour chaque pion du appartenant au camp de l'IA, on calcule une
              -- liste de coups simples possibles
              calculerMouvementPion(j,jeu,liste,nCoups,lig,col); 
            end if;
        end loop;
    end loop;
    
    -- il peut arriver qu'aucun coup ne soit plus possible à cause de la règle
    -- des voisins inattaquables
    if(nCoups = 0) then
        raise JEU_BLOQUE;
    end if;
    
    -- une fois la liste construite
    while not(valide) loop
        -- on en sélectionne un aléatoirement
        ind := entierAlea(nCoups);
        -- on le vérifie
        verifierCoup(jeu, j, liste(ind), valide);
    end loop;
    -- si le coup est correct, on le retourne pour exécution
    c := liste(ind);  
end calculerCoup;

end joueur_ia;