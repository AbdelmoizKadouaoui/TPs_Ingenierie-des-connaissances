%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PARTIE 1 : Base de connaissances
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Faits : symptomes(Patient, Symptom)

symptomes(a1, fievre).
symptomes(a1, toux).
symptomes(a1, fatigue).

symptomes(a2, mal_gorge).
symptomes(a2, fievre).

symptomes(a3, eternuements).
symptomes(a3, nez_qui_coule).

% Règles de diagnostic statique
% On met des parenthèses pour bien séparer les conjonctions ET / OU.

diagnostic_stat(grippe, P) :-
    symptomes(P, fievre),
    (   symptomes(P, courbatures)
    ;   symptomes(P, fatigue)
    ),
    symptomes(P, toux).

diagnostic_stat(angine, P) :-
    symptomes(P, mal_gorge),
    symptomes(P, fievre).

diagnostic_stat(covid, P) :-
    symptomes(P, fievre),
    symptomes(P, toux),
    symptomes(P, fatigue).

diagnostic_stat(allergie, P) :-
    symptomes(P, eternuements),
    symptomes(P, nez_qui_coule),
    \+ symptomes(P, fievre).   % absence de fièvre
