with entrees_sorties; use entrees_sorties;
with Ada.Exceptions; use Ada.Exceptions;

with structures; use structures;

package gestion_jeu is

    procedure initialiserDamier(jeu : out Damier);
    procedure verifierCoup(jeu : in Damier; j : in Joueur; c : in out Coup);
    
end gestion_jeu;