with structures; use structures;

package maths is

    function convCharInt(c : Character) return Integer;
    function pgcd(x,y : Integer) return Integer;
    procedure vecteurDirection(depart,dest : in Cible; valide : out Boolean;
                               vl,vc : out Integer);
                               
end maths;