%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TP5 - Système expert médical simplifié 
% Fichier : tp5_expert.pl
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- dynamic memo/2.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Interaction (rappel des prédicats nécessaires)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

poser_question(Sympt, Rep) :-
    format("Avez-vous ~w ? (o/n) : ", [Sympt]),
    read(Brut),
    ( (Brut == o ; Brut == 'o') ->
        Rep = oui
    ; (Brut == n ; Brut == 'n') ->
        Rep = non
    ; writeln("Réponse non reconnue, tapez o. ou n."),
      poser_question(Sympt, Rep)
    ).

a_le_symptome(S) :-
    memo(S, oui), !.
a_le_symptome(S) :-
    memo(S, non), !, fail.
a_le_symptome(S) :-
    poser_question(S, Rep),
    asserta(memo(S, Rep)),
    Rep == oui.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Définition des pathologies et de leurs symptômes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Règles de déclenchement
pathologie(grippe) :-
    a_le_symptome(fievre),
    a_le_symptome(fatigue),
    a_le_symptome(toux).

pathologie(angine) :-
    a_le_symptome(mal_gorge),
    a_le_symptome(fievre).

pathologie(covid) :-
    a_le_symptome(fievre),
    a_le_symptome(toux),
    a_le_symptome(fatigue).

pathologie(allergie) :-
    a_le_symptome(eternuements),
    a_le_symptome(nez_qui_coule),
    \+ a_le_symptome(fievre).

% Profil de symptômes caractéristiques par maladie
profil_maladie(grippe,   [fievre, courbatures, fatigue, toux]).
profil_maladie(angine,   [mal_gorge, fievre]).
profil_maladie(covid,    [fievre, toux, fatigue]).
profil_maladie(allergie, [eternuements, nez_qui_coule]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Explication : pourquoi cette maladie ?
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% justifier(+Maladie)
% Affiche uniquement les symptômes que l'utilisateur a validés.
justifier(M) :-
    profil_maladie(M, ListeRef),
    findall(S,
            ( member(S, ListeRef),
              memo(S, oui)
            ),
            SymptOK),
    format("Vous pourriez souffrir de ~w car les symptômes suivants sont présents : ~w.~n",
           [M, SymptOK]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Diagnostic global + affichage explicatif
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

collecter_pathologies(Liste) :-
    findall(M, pathologie(M), Liste).

presenter_resultats([]) :-
    writeln("Le système n'a trouvé aucune maladie correspondant à vos réponses.").

presenter_resultats(Liste) :-
    writeln("Résultats de l'analyse :"),
    forall(member(M, Liste), justifier(M)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Point d’entrée principal (Parties 2 + 3)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

session_expert :-
    retractall(memo(_, _)),
    collecter_pathologies(Liste),
    presenter_resultats(Liste).
