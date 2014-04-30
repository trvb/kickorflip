with entrees_sorties; use entrees_sorties;
with Ada.Exceptions; use Ada.Exceptions;

with structures; use structures;

package affichage is

    type PositionGrille is (HAUT,BAS,MILIEU,GAUCHE,DROITE);
    POSITION_INVALIDE : exception;

    procedure afficherDamier(jeu : in Damier);
    procedure afficherResultat(jeu : in Damier; j1,j2 : in Joueur);
            
    procedure afficherMouvements(c : in Coup);
    
    procedure afficherAideSaisieCoups;

end affichage;