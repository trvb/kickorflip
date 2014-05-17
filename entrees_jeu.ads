with entrees_sorties; use entrees_sorties;

with utilitaires; use utilitaires;
with maths; use maths;
with affichage; use affichage;
with structures; use structures;

package entrees_jeu is

    procedure saisirJoueurs(j1,j2 : out Joueur);
    procedure saisirMouvements(coupRet : out Coup);
    function saisirModeJeu return TypeJoueur;
    
end entrees_jeu;