with entrees_sorties; use entrees_sorties;

with utilitaires; use utilitaires;
with affichage; use affichage;
with structures; use structures;

package entrees_jeu is

    procedure saisirJoueurs(j1,j2 : out Joueur);
    procedure saisirMouvements(coupRet : out Coup);
    
end entrees_jeu;