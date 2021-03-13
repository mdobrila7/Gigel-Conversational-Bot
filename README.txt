Dobrila Madalin 324CA

			Tema3 PP - Prolog


	TO DO1 - match_rule
	Pentru acest TO DO am creat o functie identic, care primeste doua liste
si da true daca cele doua liste au aceleasi elemente, in aceeasi ordine.
	Astfel, functia match_rule verifica daca replica data de utilizator
coincide cu replica din regula data ca parametru.

	TO DO2 - find_matching_rules
	Extrage din regulile date, doar pe cele care se potrivesc cu replica
utilizatorului. Se folosest findall pentru a obtine o lista (MatchingRules)
doar din acele reguli care se potrivesc cu regula data de utilizator, adica
cele care indeplinesc conditia de la TO DO1 (match_rule).

	TO DO3 - select_answer
	Se obtin toate regulile din baza de cunostinte prin pattern matching
(rules(Keywords, Replici) ), apoi se iau doar acele reguli care au cuvintele
cheie in replica utilizatorului, in ordin, folosind functia ord_subset din
Prolog. In continuare, se filtreaza doar acele reguli care se potrivesc cu
replica utilizatorului, folosind functia de la TO DO2 (find_matching_rules).
(! este folosit pentru a nu merge mai departe, nu e necesar, s-a gasit setul
de reguli). Apoi extrage regula si lista de replici posibile din aceasta.
In continuare, trebuie selectat cel mai bun raspuns din lista de raspunsuri
posibile, acesta fiind cel care a fost folosit cel mai putin pana acum (se
retine in BotMemory de cate ori a fost folosita fiecare replica). In acest
scop am realizat functia get_best_answer, care merge prin toata lista de
raspunsuri posibile si selecteaza mereu un raspuns daca numarul de aparitii
este mai mic decat parametrul App, adica cu alte cuvinte ia Answer-ul care
are numarul de aparitii in memorie minim. (Functia a fost apelata cu 999
pentru a se schimba in interior si Answer sa ia o valoarea valida). Functia
se apeleaza recursiv si face mereu operatia pe head, afland numarul de aparitii
cu ajutorul functiei get_answer dat in schelet (in chat.pl).
	Pentru obtinerea Actions s-a creat o functie get_actions care extrage
actions dintr-o regula rule si se adauga direct in Actions (ultimul parametru).