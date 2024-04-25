% % [[yellow, yellow, yellow, red], [blue, yellow, blue, yellow], [blue, blue, blue, yellow], [blue, blue, blue, yellow]]

% To be handled: handle the goal in the start loop


% Predicate to set the value of global variable N
set_n(Value) :-
    retractall(n(_)),
    assertz(n(Value)).


% Predicate to get the value of global variable N
get_n(Value) :-
    n(Value).


% Predicate to set the value of global variable M
set_m(Value) :-
    retractall(m(_)),
    assertz(m(Value)).


% Predicate to get the value of global variable M
get_m(Value) :-
    m(Value).


% Predicate to set the value of the list of lists
set_board(Value) :-
    retractall(board(_)),
    assertz(board(Value)).


% Predicate to get the value of the list of lists
get_board(Value) :-
    board(Value).


search(Open, Closed):-
    getState(Open, Node, TmpOpen), % Step 1
    TmpOpen = [],
    % CurrentState = Goal, !, % Step 2 -> need to handle the check for the goal
    write("Search is complete!"), nl.
    %printSolution(Closed). % -> modify the print.


search(Open, Closed):-
    getState(Open, CurrentNode, TmpOpen),
    getAllValidChildren(CurrentNode, TmpOpen, Closed, Children), % Step3
    addChildren(Children, TmpOpen, NewOpen), % Step 4
    append(Closed, CurrentNode, NewClosed), % Step 5.1
    printSolution(NewClosed),
    search(NewOpen, NewClosed). % Step 5.2


% Implementation of step 3 to get the next states
getAllValidChildren(Node, Open, Closed, Children):-
    findall(Next, getNextState(Node, Open, Closed, Next), Children).


getNextState(Node, Open, Closed, Next):-
    move(Node, Next),
    not(member([Next,_], Open)),
    not(member([Next,_], Closed)).


% Implementation of getState and addChildren determine the search alg.
% BFS
getState([CurrentNode|Rest], CurrentNode, Rest).


addChildren(Children, Open, NewOpen):-
    append(Open, Children, NewOpen).


% Implementation of printSolution to print the actual solution path
% printSolution([State, null],_):-
%     write(State), nl.


% printSolution([State, Parent], Closed):-
%     member([Parent, GrandParent], Closed),
%     printSolution([Parent, GrandParent], Closed),
%     write(State), nl.


printSolution([]).

printSolution([H|T]):-
  write(H), nl,
  printSolution(T).


move(Node, Next):-
    left(Node, Next);
    right(Node, Next);
    up(Node, Next); 
    down(Node, Next).


left(Node, Next):-
  get_board(Board),
  get_n(N),
  nth0(Indx, Board, Node),
  Node = [X1, Y1, Color1],
  CheckIndx is Indx mod N,
  CheckIndx \= 0,
  NextIndx is Indx - 1,
  nth0(NextIndx, Board, Next),
  Next = [X2, Y2, Color2],
  Color1 == Color2.
%   write(Next),nl.


right(Node, Next):-
  get_board(Board),
  get_n(N),
  nth0(Indx, Board, Node),
  Node = [X1, Y1, Color1],
  CheckIndx is (Indx+1) mod N,
  CheckIndx \= 0,
  NextIndx is Indx + 1,
  nth0(NextIndx, Board, Next),
  Next = [X2, Y2, Color2],
  Color1 == Color2.


up(Node, Next):-
  get_board(Board),
  get_n(M),
  nth0(Indx, Board, Node),
  Node = [X1, Y1, Color1],
  Indx >= M,
  NextIndx is Indx mod M,
  nth0(NextIndx, Board, Next),
  Next = [X2, Y2, Color2],
  Color1 == Color2.


down(Node, Next):-
  get_board(Board),
  get_n(N),
  get_m(M),
  nth0(Indx, Board, Node),
  Node = [X1, Y1, Color1],
  CheckIndx is (N * M) - M,
  Indx =< CheckIndx,
  NextIndx is Indx + M,
  nth0(NextIndx, Board, Next),
  Next = [X2, Y2, Color2],
  Color1 == Color2.


% predicate which will start the search.
start(Board, N, M):-
  set_n(N),
  set_m(M),
  set_board(Board),
  End is N*M,
  loop(Board, 1, End, 1).


% Base case: When Start > End, we stop.
loop(Board, End, End, _Step) :- !.


% Recursive case: Print Start, then increment Start and continue.
loop([CurrentNode|Rest], Start, End, Step) :-
     write("done"), nl,
    Start =< End,
    search([CurrentNode], []),
    Next is Start + Step,
    loop(Rest, Next, End, Step).


% Node = [X, Y, Color]
% Open and Closed lists = [[X, Y, Color], [X, Y, Color], ....]
% board = [[X, Y, Color], [X, Y, Color], [X, Y, Color], [X, Y, Color], [X, Y, Color], [X, Y, Color], ....]
% goal -> when the open list is empty.

% board = [[0, 0, yellow], [0, 1, yellow], [0, 2, yellow], [0, 3, red], [1, 0, blue], [1, 1, yellow], [1, 2, blue], [1, 3, yellow], [2, 0, blue], [2, 1, blue], [2, 2, blue], [2, 3, yellow], [3, 0, blue], [3, 1, blue], [3, 2, blue], [3, 3, yellow]]
% start([[0, 0, yellow], [0, 1, yellow], [0, 2, yellow], [0, 3, red], [1, 0, blue], [1, 1, yellow], [1, 2, blue], [1, 3, yellow], [2, 0, blue], [2, 1, blue], [2, 2, blue], [2, 3, yellow], [3, 0, blue], [3, 1, blue], [3, 2, blue], [3, 3, yellow]], 4, 4).