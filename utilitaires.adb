package body utilitaires is

function convCharInt(c : Character) return Integer is
s : String(1..1);
n : Integer;
begin
    s(1) := c;    
    n := Integer'Value(s);
    return n;
exception
    -- il peut arriver que le caractère ne soit pas un chiffre, dans ce cas on ne fait pas planter le programme
    when CONSTRAINT_ERROR =>
        n := -1;
        return n;
end convCharInt;
    
end utilitaires;