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

begin  
    initialiserDamier(mgrille);
    afficherDamier(mgrille);
    saisirJoueurs(j1,j2);
    
    while true loop
        saisirMouvements(c);        
        --afficherMouvements(c);
        verifierCoup(mgrille,j1,c);
    end loop;

end kickorflip;