-- Procédure principale Kick Or Flip
with entrees_sorties; use entrees_sorties;

with structures; use structures;
with affichage; use affichage;
with utilitaires; use utilitaires;
with entrees_jeu; use entrees_jeu;
with gestion_jeu; use gestion_jeu;
with joueur_ia; use joueur_ia;
with maths; use maths;

procedure kickorflip is

-- rôle : récupère les mouvements d'un joueur donné, qu'il soit humain ou ordi
-- note : cette sous-procédure ne peut qu'être dans ce fichier pour causes
--        de références cycliques entre les fichiers ( entre ia & gestion jeu )
procedure recupererMouvements(j : in Joueur; jeu : in out Damier; c : out Coup) is
begin
    case j.mtype is
        when HUMAIN => saisirMouvements(c);    
        when ORDINATEUR => calculerCoup(j,jeu,c);
    end case;
end recupererMouvements;

-- déclarations nécessaires à l'exécution du jeu
mgrille : Damier;
j1,j2,jCourant : Joueur;
tourJeu : Integer := 0;
j1Gagne,j2Gagne : Boolean := false;
c : Coup;
coupValide : Boolean;
begin
    -- Initialisation du jeu
    initialiserDamier(mgrille);
    j2.mtype := saisirModeJeu;    
    saisirJoueurs(j1,j2);
    jCourant := j1;
    afficherDamier(mgrille);
      
    -- Boucle de jeu principale
    while (not j1Gagne) and (not j2Gagne) loop
        afficherTourJeu(jCourant);
        recupererMouvements(jCourant,mgrille,c);
        afficherMouvements(c);
        verifierCoup(mgrille,jCourant,c,coupValide);
        while (not coupValide) loop
            recupererMouvements(jCourant,mgrille,c);
            verifierCoup(mgrille,jCourant,c,coupValide);
        end loop;
        executerCoup(mgrille,jCourant,c);
        afficherDamier(mgrille);
        partieTermine(mgrille,j1Gagne,j2Gagne);
        
        tourJeu := tourJeu + 1;
        if(tourJeu mod 2 = 0) then
            jCourant := j1;
        else
            jCourant := j2;
        end if;
    end loop;
    
    -- Sortie du jeu
    afficherResultat(mgrille,j1,j2,j1Gagne,j2Gagne);
    
end kickorflip;