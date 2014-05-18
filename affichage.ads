with entrees_sorties; use entrees_sorties;
with Ada.Exceptions; use Ada.Exceptions;

with structures; use structures;

package affichage is

    type PositionGrille is (HAUT,BAS,MILIEU,GAUCHE,DROITE);
    POSITION_INVALIDE : exception;
    
    type MessageErreurMouv is (PION_SELECTIONNE_INVALIDE,
                           CASE_CIBLE_OCCUPE,
                           DIRECTION_INVALIDE,
                           FLIP_NON_UNIQUE,
                           KICK_NON_UNIQUE,
                           CASE_CIBLE_NON_VOISINE,
                           PION_CIBLE_VOISINS,
                           OBSTACLE_TRAJECTOIRE,
                           CAMP_PION_CIBLE_ALLIE);

    procedure afficherMenu;
    procedure afficherDamier(jeu : in Damier);
    procedure afficherTourJeu(j : in Joueur);
    procedure afficherResultat(jeu : in Damier; j1,j2 : in Joueur; j1g,j2g : in Boolean);
            
    procedure afficherMouvements(c : in Coup);
    
    procedure afficherAideSaisieCoups;    
    procedure afficherMessageErreurMouv(msg : in MessageErreurMouv; dep,dest : Cible);

end affichage;