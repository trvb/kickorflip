-- Structures de données utilisées dans le programme
package structures is

type Couleur is (BLANC,NOIR);
type TypeCase is (VIDE,OCCUPE);

type Pion is record    
    camp : Couleur;    
end record;

type CaseJeu is record
    mtype : TypeCase := VIDE;
    mpion : Pion;
end record;

subtype Lignes is Character range 'A'..'I';
subtype Colonnes is Integer range 1..9;
type Damier is array(Lignes,Colonnes) of CaseJeu;

type TypeCoup is (KICK, FLIP, ERREUR_DEHORS, ERREUR_COUP_NUL, ERREUR_CASE_DEPART,
                  ERREUR_AVANT_ELIM, ERREUR_AVANT_SAUT, ERREUR_CASE_SAUTEE,
                  ERREUR_DEST_SAUT, ERREUR_DEJA_SAUTEE) ;

type TypeJoueur is (HUMAIN, ORDINATEUR);

type Joueur is record
	nom : String(1..10);
	mtype : TypeJoueur := HUMAIN;
	longueurNom : Integer;
	camp : Couleur;
	tourJeu : Boolean := false;
end record;

type Cible is record
	lig : Lignes;
	col : Colonnes;
end record;

type ListeCibles is array(Integer range 1..20) of Cible;

type Coup is record
	ciblesMultiples : Boolean := false;
	mtype : TypeCoup;
	mciblePion : Cible; -- le pion qui exécute le coup
	mcibles : ListeCibles; -- les coordonnées des cases visées par le pion
	nombreCibles : Integer := 0;
end record;

end structures;