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

function campInv(camp : Couleur) return Couleur is
begin
    case camp is
        when NOIR => return BLANC;
        when BLANC => return NOIR;
    end case;
end campInv;

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
        -- pour toutes les cases entre le départ et la destination
        c := c + vc; l := Lignes'val(Lignes'pos(l)+vl);
        while not(fin) and ((c /= dest.col) or (l /= dest.lig)) loop
            -- on vérifie que cette case est bien vide, sinon on arrête
            fin := jeu(l,c).mtype = OCCUPE;
            c := c + vc;
            l := Lignes'val(Lignes'pos(l)+vl);
        end loop;
    else
        fin := true;
    end if;
    return (not fin);
end trajectoireLibre;

procedure trouverObstacles(depart, dest : in Cible; jeu : in Damier;
                           nb : out Integer; liste : out ListeCibles) is                          
c : Colonnes := depart.col;
l : Lignes := depart.lig;
cib : Cible;
vl,vc,n : Integer := 0;
v,fin : Boolean := false;
begin
    vecteurDirection(depart,dest,v,vl,vc);
    -- on vérifie que la trajectoire est bien valide et qu'on peut la parcourir
    if(v) then
        -- pour toutes les cases entre le départ et la destination
        c := c + vc; l := Lignes'val(Lignes'pos(l)+vl);
        while ((c /= dest.col) or (l /= dest.lig)) loop
            -- si un obstacle est trouvé on l'ajoute à la liste
            if(jeu(l,c).mtype = OCCUPE) then
                n := n + 1;
                cib.lig := l; cib.col := c;
                liste(n) := cib;
            end if;
            c := c + vc;
            l := Lignes'val(Lignes'pos(l)+vl);
        end loop;
    end if;
    nb := n;    
end trouverObstacles;

end utilitaires;