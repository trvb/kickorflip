with entrees_sorties; use entrees_sorties;

with structures; use structures;
with affichage; use affichage;
with entrees_jeu; use entrees_jeu;
with gestion_jeu; use gestion_jeu;

procedure kickorflip is

mgrille : Damier;
j1,j2 : Joueur;
c : Coup;
begin
    initialiserDamier(mgrille);
    afficherDamier(mgrille);
    saisirJoueurs(j1,j2);
    saisirMouvements(c);
    afficherMouvements(c);
end kickorflip;