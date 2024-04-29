
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

% Define the length of an empty list as 0
list_length([], 0).

% Recursively compute the length of the list
list_length([_|Xs], L) :-
    list_length(Xs, N),
    L is N + 1.



search([X,Y,C,Path], Closed, [H|T]):-
    getNextState([X,Y,C,Path],Next),
    Next == H,
    write([H|T]).
    %printSolution(Closed). % -> modify the print.
    % print_cycles(Closed).    





search(Open, Closed, Visited):-
    getState(Open, CurrentNode, TmpOpen),
    append(Closed, [CurrentNode], NewClosed), % Step 5.1
    getAllValidChildren(CurrentNode, TmpOpen, NewClosed, Children), % Step3
    list_length(Children ,LstLen),
    LstLen >= 2,
    addChildren(Children, TmpOpen, [H|T]), % Step 4
    write("current node" + CurrentNode), nl,
    write("children" + Children), nl,
    write("Closed" + NewClosed), nl,
    write("Open" + NewOpen), nl,
    search(NewOpen, NewClosed,[Visited|H]).    % Step 5.2    





% Implementation of step 3 to get the next states
getAllValidChildren([X,Y,C,Path], Open, Closed, Children):-
    findall([X2,Y2,C2,[Path|[X,Y,C]]], getNextState([X,Y,C,Path], Open, Closed, [X2,Y2,C2,[Path|[X,Y,C]]]), Children).


getNextState(Node, Open, Closed, Next):-
    move(Node, Next,Next2),
    not(member(Next, Open)),
    not(member(Next, Closed)),
    not(member(Next2, Open)),
    not(member(Next2, Closed)).


% Implementation of getState and addChildren determine the search alg.
% BFS
getState([CurrentNode|Rest], CurrentNode, Rest).


addChildren(Children, Open, NewOpen):-
    append(Open, Children, NewOpen).


printSolution([]).


printSolution([H|T]):-
  write(H), nl,
  printSolution(T).


move(Node, Next1, Next2):-
(up(Node, Next1), left(Node, Next2)).

move(Node, Next1, Next2):-
(up(Node, Next1), right(Node, Next2)).

move(Node, Next1, Next2):-
(down(Node, Next1), right(Node, Next2)).

move(Node, Next, Next2):-
(down(Node, Next1), left(Node, Next2)).

% move(Node, Next):-
%     right(Node, Next);
%      down(Node, Next);
%     left(Node, Next);
%     up(Node, Next).
   


left(Node, Next):-
  get_board(Board),
  get_n(N),
  nth0(Indx, Board, Node),
  Node = [X1, Y1, Color1,Path],
  CheckIndx is Indx mod N,
  CheckIndx \= 0,
  NextIndx is Indx - 1,
  nth0(NextIndx, Board, Next),
  Next = [X2, Y2, Color2,Path2],
  write("left"), nl,
  write(Node), write(" "), write(Next), write(" "), nl,
  Color1 == Color2.
%   write(Next),nl.


right(Node, Next):-
  get_board(Board),
  get_n(N),
  nth0(Indx, Board, Node),
  Node = [X1, Y1, Color1,Path],
  CheckIndx is (Indx+1) mod N,
  CheckIndx \= 0,
  NextIndx is Indx + 1,
  nth0(NextIndx, Board, Next),
  Next = [X2, Y2, Color2,Path2],
  write("right"), nl,
  write(Node), write(" "), write(Next), write(" "), nl,
  Color1 == Color2.
%   write(Next),nl.


up(Node, Next):-
  get_board(Board),
  get_n(M),
  nth0(Indx, Board, Node),
  Node = [X1, Y1, Color1,Path],
  Indx >= M,
  NextIndx is Indx - M,
  nth0(NextIndx, Board, Next),
  Next = [X2, Y2, Color2,Path2],
  write("up"), nl,
  write(Node), write(" "), write(Next), write(" "), nl,
  Color1 == Color2.
%   write(Next),nl.


down(Node, Next):-
  get_board(Board),
  get_n(N),
  get_m(M),
  nth0(Indx, Board, Node),
  Node = [X1, Y1, Color1,Path],
  CheckIndx is (N * M) - M,
  Indx =< CheckIndx,
  NextIndx is Indx + M,
  nth0(NextIndx, Board, Next),
  Next = [X2, Y2, Color2,Path2],
  write("down"), nl,
  write(Node), write(" "), write(Next), write(" "), nl,
  Color1 == Color2.
%   write(Next),nl.


start(Board, N, M):-
  set_n(N),
  set_m(M),
  set_board(Board),
  End is N*M,
  write(End),
  loop(Board, 1, End, 1).



% Base case: When Start > End, we stop.
loop(Board, End, End, _Step) :- !.


% Recursive case: Print Start, then increment Start and continue.
loop([[X,Y,C,null]|Rest], Start, End, Step) :-
    write("done"), nl,
    Start < End,
    search([[X,Y,C,null]], [],[]),
    Next is Start + Step,
    loop(Rest, Next, End, Step).



