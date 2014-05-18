with entrees_sorties; use entrees_sorties;
with Ada.Exceptions; use Ada.Exceptions;

with structures; use structures;
with utilitaires; use utilitaires;
with affichage; use affichage;
with gestion_jeu; use gestion_jeu;
with maths; use maths;

package joueur_ia is
    
    type ListeCoups is array(Integer range 1..1000) of Coup;
    
    procedure calculerCoup(j : in Joueur; jeu : in Damier; c : out Coup);
    
    JEU_BLOQUE : exception;
end joueur_ia;