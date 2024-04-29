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



search(Open, Closed, Goal):-
    getBestState(Open, [CurrentState,Parent,C,H,A], _), % Step 1
    CurrentState = Goal, % Step 2
    write("Search is complete!"), nl,
    printSolution([CurrentState,Parent,C,H,A], Closed), !.

search(Open, Closed, Goal):-
    getBestState(Open, CurrentNode, TmpOpen),
    getAllValidChildren(CurrentNode,TmpOpen,Closed,Goal,Children), % Step 3
    addChildren(Children, TmpOpen, NewOpen), % Step 4
    append(Closed, [CurrentNode], NewClosed), % Step 5.1
    search(NewOpen, NewClosed, Goal). % Step


getAllValidChildren(Node, Open, Closed, Goal, Children):-
    findall(Next, getNextState(Node,Open,Closed,Goal,Next),
    Children).

getNextState([State,_,G,_,_],Open,Closed,Goal,[Next,State,NewG,NewH,NewF]):-
    move(State, Next, MoveCost),
    calculateH(Next, Goal, NewH),
    NewG is G + MoveCost,
    NewF is NewG + NewH,
    ( not(member([Next,_,_,_,_], Open)) ; memberButBetter(Next,Open,NewF)),
    ( not(member([Next,_,_,_,_],Closed)); memberButBetter(Next,Closed,NewF)).


% Implementation of addChildren and getBestState
addChildren(Children, Open, NewOpen):-
    append(Open, Children, NewOpen).

getBestState(Open, BestChild, Rest):-
    findMin(Open, BestChild),
    delete(Open, BestChild, Rest).
% Implementation of findMin in getBestState determines the search
%alg.
% Greedy best-first search
findMin([X], X):- !.

findMin([Head|T], Min):-
    findMin(T, TmpMin),
    Head = [_,_,_,HeadH,HeadF],
    TmpMin = [_,_,_,TmpH,TmpF],
    (TmpF < HeadF -> Min = TmpMin ; Min = Head).


memberButBetter(Next, List, NewF):-
    findall(F, member([Next,_,_,_,F], List), Numbers),
    min_list(Numbers, MinOldF),
    MinOldF > NewF.



move(Node, Next):-
    right(Node, Next);
    down(Node, Next);
    left(Node, Next);
    up(Node, Next).



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
  write("left"), nl,
  write(Node), write(" "), write(Next), write(" "), nl,
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
  write("right"), nl,
  write(Node), write(" "), write(Next), write(" "), nl,
  Color1 == Color2.
%   write(Next),nl.


up(Node, Next):-
  get_board(Board),
  get_n(M),
  nth0(Indx, Board, Node),
  Node = [X1, Y1, Color1],
  Indx >= M,
  NextIndx is Indx - M,
  nth0(NextIndx, Board, Next),
  Next = [X2, Y2, Color2],
  write("up"), nl,
  write(Node), write(" "), write(Next), write(" "), nl,
  Color1 == Color2.
%   write(Next),nl.


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
  write("down"), nl,
  write(Node), write(" "), write(Next), write(" "), nl,
  Color1 == Color2.    






start(Board,Start,Goal ,N, M):-
  set_n(N),
  set_m(M),
  set_board(Board),
  search([Start],[],Goal).
  

%calculateH(State,Next,H):-
    
