-- Procédures utilitaires liées à des calculs mathématiques
package body maths is

-- Rôle : retourne un entier généré aléatoirement compris entre 1 et max
function entierAlea(max : Integer) return Integer is
gen : Generator ;
val : Float;
ent : Integer := -1;
begin
    while (ent <= 0) or (ent > max) loop
        reset(gen);
        val := random(gen);
        ent := (Integer(val*Float(max)));
    end loop;
    return ent;
end entierAlea;

-- Rôle : converti proprement ( sans erreur ) un caractère en entier
function convCharInt(c : Character) return Integer is
s : String(1..1);
n : Integer;
begin
    s(1) := c;    
    n := Integer'Value(s);
    return n;
exception
    -- il peut arriver que le caractère ne soit pas un chiffre, dans ce cas on
    -- ne fait pas planter le programme
    when CONSTRAINT_ERROR =>
        n := -1;
        return n;
end convCharInt;

-- Rôle : calcul par le théorème de Bezout
procedure bezout(a,b : in Integer; pgcd,cs,ct : out Integer) is
x,y,s,t,u,v,w,q,r : Integer;
begin
  x := a; y := b;
  s := 1; v:= 1;
  t := 0; u := 0;
  while(y > 0) loop
    q := x / y; r := x mod y; -- division Euclidienne
    x := y; y := r;
    w := u; u := s - q*u; s := w;
    w := v; v := t - q*v; t := w;
  end loop;
  pgcd := x;
  cs := s;
  ct := t;
end bezout;

-- Rôle : calcul d'un pgcd
function pgcd(x,y : Integer) return Integer is
tmp,f,g : Integer;
begin
  bezout(x,y,tmp,f,g);
  return tmp;
end pgcd; 

-- Rôle : calcule un vecteur direction et indique si il est valide dans le jeu
procedure vecteurDirection(depart,dest : in Cible; valide : out Boolean;
                           vl,vc : out Integer) is
p,dl,dc : Integer;
begin
    dc := dest.col - depart.col;
    dl := Lignes'pos(dest.lig) - Lignes'pos(depart.lig);

    if (dc = 0) and (dl = 0) then
        valide := false;
        vl := 0; vc := 0;
    elsif (dc = 0) then
        valide := true;
        vc := 0;
        vl := dl / abs(dl);
    elsif (dl = 0) then
        valide := true;
        vl := 0;
        vc := dc / abs(dc);
    elsif (abs(dl) = 1) and (abs(dc) = 1) then
        valide := true;
        vl := dl; vc := dc;        
    else
        p := pgcd(abs(dc),abs(dl));
        dl := dl / p; dc := dc / p;        
        valide := not((abs(dl) /= 1) or (abs(dc) /= 1) or (p = 1));        
        vl := dl; vc := dc;    
    end if;
end vecteurDirection;

end maths;