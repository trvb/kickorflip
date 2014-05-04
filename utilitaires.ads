with entrees_sorties; use entrees_sorties;

with structures; use structures;
with maths; use maths;

package utilitaires is

    function casesVoisines(c1,c2 : Cible; jeu : Damier) return Boolean;
    function trajectoireLibre(depart,dest : Cible; jeu : Damier) return Boolean;
    function directionValide(depart,dest : Cible) return Boolean;
    
end utilitaires;