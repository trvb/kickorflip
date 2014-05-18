with Ada.Numerics.Float_Random;
use Ada.Numerics.Float_Random;

with structures; use structures;

package maths is

    function entierAlea(max : Integer) return Integer;
    function convCharInt(c : Character) return Integer;
    function pgcd(x,y : Integer) return Integer;
    procedure vecteurDirection(depart,dest : in Cible; valide : out Boolean;
                               vl,vc : out Integer);
                               
end maths;