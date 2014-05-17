with entrees_sorties; use entrees_sorties;
with Ada.Exceptions; use Ada.Exceptions;

with structures; use structures;
with utilitaires; use utilitaires;
with affichage; use affichage;
with entrees_jeu; use entrees_jeu;

package gestion_jeu is

    procedure initialiserDamier(jeu : out Damier);
    procedure verifierCoup(jeu : in Damier; j : in Joueur; c : in out Coup;
                           v : out Boolean);
                           
    procedure executerCoup(jeu : in out Damier; j : in Joueur; c : in Coup);
    procedure partieTermine(jeu : in Damier; j1Gagnant, j2Gagnant : out Boolean);
    
    procedure recupererMouvements(j : in Joueur; jeu : in out Damier; c : out Coup);
    
    COUP_NON_EXECUTABLE : exception;
    
end gestion_jeu;