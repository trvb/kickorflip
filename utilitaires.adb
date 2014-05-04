package body utilitaires is

procedure sousMatriceVoisins(c : in Cible; jeu : in Damier; ld,lf : out Lignes;
    cd,cf : out Colonnes) is
begin
    if(c.lig = Lignes'first) then ld := Lignes'first;
    else ld := Lignes'pred(c.lig); end if;
    if(c.col = Colonnes'first) then cd := Colonnes'first;
    else cd := Colonnes'pred(c.col); end if;    
    if(c.lig = Lignes'last) then lf := Lignes'last; 
    else lf := Lignes'succ(c.lig); end if;
    if(c.col = Colonnes'last) then cf := Colonnes'last;
    else cf := Colonnes'succ(c.col); end if;
end sousMatriceVoisins;

function casesVoisines(c1,c2 : Cible; jeu : Damier) return Boolean is
ligDebut,ligFin : Lignes;
colDebut,colFin : Colonnes;
voisin : Boolean := false;
begin
    -- initialisation de la sous matrice des voisins de c1
    sousMatriceVoisins(c1,jeu,ligDebut,ligFin,colDebut,colFin);    
    -- parcours des voisins
    for l in ligDebut..ligFin loop
        for c in colDebut..colFin loop
            if (c2.lig = l) and (c2.col = c) then
                voisin := true;
            end if;
        end loop;
    end loop;    
    return voisin;
end casesVoisines;

function directionValide(depart,dest : Cible) return Boolean is
v : Boolean; a,b : Integer;
begin
    vecteurDirection(depart,dest,v,a,b);
    return v;
end directionValide;

function trajectoireLibre(depart,dest : Cible; jeu : Damier) return Boolean is
c : Colonnes := depart.col;
l : Lignes := depart.lig;
vl,vc : Integer;
v,fin : Boolean := false;
begin
    vecteurDirection(depart,dest,v,vl,vc);
    -- on vérifie que la trajectoire est bien valide et qu'on peut la parcourir
    if(v) then    
        put("Vect: ("); put(vl,0); put(','); put(vc,0); put(')'); new_line;
        -- pour toutes les cases entre le départ et la destination
        while not(fin) and ((c + vc) /= dest.col) and ((Lignes'pos(l) + vl) /= Lignes'pos(dest.lig)) loop
            put(l); put(c,0); put(' ');
            c := c + vc;
            l := Lignes'val(Lignes'pos(l)+vl);
            fin := jeu(l,c).mtype = OCCUPE;
        end loop;
    else
        fin := true;
    end if;
    return (not fin);
end trajectoireLibre;
    
end utilitaires;