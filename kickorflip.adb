with entrees_sorties; use entrees_sorties;

with structures; use structures;
with affichage; use affichage;
with utilitaires; use utilitaires;
with entrees_jeu; use entrees_jeu;
with gestion_jeu; use gestion_jeu;
with maths; use maths;

procedure kickorflip is

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
    afficherDamier(mgrille);
    jCourant := j1;
    
    -- Boucle de jeu principale
    while not(j1Gagne) or not(j2Gagne) loop
        afficherTourJeu(jCourant);
        recupererMouvements(jCourant,mgrille,c);
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
    afficherResultat(mgrille,j1,j2);
    
end kickorflip;