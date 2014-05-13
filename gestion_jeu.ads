with entrees_sorties; use entrees_sorties;
with Ada.Exceptions; use Ada.Exceptions;

with structures; use structures;
with utilitaires; use utilitaires;
with affichage; use affichage;

package gestion_jeu is

    procedure initialiserDamier(jeu : out Damier);
    procedure verifierCoup(jeu : in Damier; j : in Joueur; c : in out Coup; v : out Boolean);
    procedure executerCoup(jeu : in out Damier; j : in Joueur; c : in Coup);
    
    COUP_NON_EXECUTABLE : exception;
    
end gestion_jeu;