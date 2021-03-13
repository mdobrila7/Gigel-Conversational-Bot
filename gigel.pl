:- ensure_loaded('chat.pl').

% Returneaza true dacă regula dată ca argument se potriveste cu
% replica data de utilizator. Replica utilizatorului este
% reprezentata ca o lista de tokens. Are nevoie de
% memoria replicilor utilizatorului pentru a deduce emoția (tag-ul
% conversației).
match_rule(Tokens, _UserMemory, rule(Replica, _, _, _, _)) :- identic(Tokens, Replica).

identic([],[]).
identic([H1|R1],[H2|R2]) :- H1 = H2, identic(R1,R2).

% Primeste replica utilizatorului (ca lista de tokens) si o lista de
% reguli, iar folosind match_rule le filtrează doar pe cele care se
% potrivesc cu replica dată de utilizator.
find_matching_rules(Tokens, Rules, UserMemory, MatchingRules) :-
	findall(rule(Replica, _, _, _, _), (member(Replica,Rules), match_rule(Tokens,UserMemory,Replica)),MatchingRules).

% Intoarce in Answer replica lui Gigel. Selecteaza un set de reguli
% (folosind predicatul rules) pentru care cuvintele cheie se afla in
% replica utilizatorului, in ordine; pe setul de reguli foloseste
% find_matching_rules pentru a obtine un set de raspunsuri posibile.
% Dintre acestea selecteaza pe cea mai putin folosita in conversatie.
%
% Replica utilizatorului este primita in Tokens ca lista de tokens.
% Replica lui Gigel va fi intoarsa tot ca lista de tokens.
%
% UserMemory este memoria cu replicile utilizatorului, folosita pentru
% detectarea emotiei (tag-ului).
% BotMemory este memoria cu replicile lui Gigel și va si folosită pentru
% numararea numarului de utilizari ale unei replici.
%
% In Actions se vor intoarce actiunile de realizat de catre Gigel in
% urma replicii (e.g. exit).
%
% Hint: min_score, ord_subset, find_matching_rules
select_answer(Tokens, UserMemory, BotMemory, Answer, Actions) :-
	rules(Keywords, Replici),
	ord_subset(Keywords, Tokens),
	find_matching_rules(Tokens, Replici, UserMemory, MatchingRules), !,
	get_rule(MatchingRules, Rule),
	get_replyList(Rule, ReplyList),
	get_actions(Rule, Actions),
	get_best_answer(ReplyList, BotMemory, 999, [Answer|_]).
	
get_rule([rule(X, _, _, _, _)], X).

get_replyList(rule(_, X, _, _, _), X).

get_actions(rule(_, _, X, _, _), X).

get_best_answer([], _, _, []).
get_best_answer([H|ReplyList], BotMemory, App, Answer) :-
	get_answer(H, BotMemory, Val), Val < App, append(Res, [H], Answer),
	get_best_answer(ReplyList, BotMemory, Val, Res).
get_best_answer([H|ReplyList], BotMemory, App, Answer) :-
	get_answer(H, BotMemory, Val), Val >= App,
	get_best_answer(ReplyList, BotMemory, App, Answer).

% Esuează doar daca valoarea exit se afla in lista Actions.
% Altfel, returnează true.
handle_actions(Actions) :- \+ member(exit, Actions).

% Caută frecvența (numărul de apariți) al fiecarui cuvânt din fiecare
% cheie a memoriei.
% e.g
% ?- find_occurrences(memory{'joc tenis': 3, 'ma uit la box': 2, 'ma uit la un film': 4}, Result).
% Result = count{box:2, film:4, joc:3, la:6, ma:6, tenis:3, uit:6, un:4}.
% Observați ca de exemplu cuvântul tenis are 3 apariți deoarce replica
% din care face parte a fost spusă de 3 ori (are valoarea 3 în memorie).
% Recomandăm pentru usurința să folosiți înca un dicționar în care să tineți
% frecvențele cuvintelor, dar puteți modifica oricum structura, această funcție
% nu este testată direct.
find_occurrences(_UserMemory, _Result) :- fail.

% Atribuie un scor pentru fericire (de cate ori au fost folosit cuvinte din predicatul happy(X))
% cu cât scorul e mai mare cu atât e mai probabil ca utilizatorul să fie fericit.
get_happy_score(_UserMemory, _Score) :- fail.

% Atribuie un scor pentru tristețe (de cate ori au fost folosit cuvinte din predicatul sad(X))
% cu cât scorul e mai mare cu atât e mai probabil ca utilizatorul să fie trist.
get_sad_score(_UserMemory, _Score) :- fail.

% Pe baza celor doua scoruri alege emoția utilizatorul: `fericit`/`trist`,
% sau `neutru` daca scorurile sunt egale.
% e.g:
% ?- get_emotion(memory{'sunt trist': 1}, Emotion).
% Emotion = trist.
get_emotion(_UserMemory, _Emotion) :- fail.

% Atribuie un scor pentru un Tag (de cate ori au fost folosit cuvinte din lista tag(Tag, Lista))
% cu cât scorul e mai mare cu atât e mai probabil ca utilizatorul să vorbească despre acel subiect.
get_tag_score(_Tag, _UserMemory, _Score) :- fail.

% Pentru fiecare tag calculeaza scorul și îl alege pe cel cu scorul maxim.
% Dacă toate scorurile sunt 0 tag-ul va fi none.
% e.g:
% ?- get_emotion(memory{'joc fotbal': 2, 'joc box': 3}, Tag).
% Tag = sport.
get_tag(_UserMemory, _Tag) :- fail.
