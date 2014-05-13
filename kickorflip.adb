with entrees_sorties; use entrees_sorties;

with structures; use structures;
with affichage; use affichage;
with utilitaires; use utilitaires;
with entrees_jeu; use entrees_jeu;
with gestion_jeu; use gestion_jeu;
with maths; use maths;

procedure kickorflip is

mgrille : Damier;
j1,j2 : Joueur;
c : Coup;
coupValide : Boolean;
mode : ModeJeu;
begin  
    initialiserDamier(mgrille);

    mode := saisirModeJeu;
    
    saisirJoueurs(j1,j2);
    
    afficherDamier(mgrille);
    while true loop
        saisirMouvements(c);        
        verifierCoup(mgrille,j1,c,coupValide);
        while (not coupValide) loop
            saisirMouvements(c);
            verifierCoup(mgrille,j1,c,coupValide);
        end loop;
        executerCoup(mgrille,j1,c);
        afficherDamier(mgrille);
    end loop;

end kickorflip;