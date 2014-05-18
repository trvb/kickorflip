with entrees_sorties; use entrees_sorties;

with structures; use structures;
with maths; use maths;

package utilitaires is

    procedure sousMatriceVoisins(c : in Cible; jeu : in Damier; ld,lf : out Lignes;
                                 cd,cf : out Colonnes);    
    function casesVoisines(c1,c2 : Cible; jeu : Damier) return Boolean;
    function trajectoireLibre(depart,dest : Cible; jeu : Damier) return Boolean;
    function directionValide(depart,dest : Cible) return Boolean;
    procedure trouverObstacles(depart, dest : in Cible; jeu : in Damier;
                               nb : out Integer; liste : out ListeCibles);
    function cibleValide(lig,col : Integer) return Boolean;
    
    function campInv(camp : Couleur) return Couleur;
    
end utilitaires;