% G -> Cummulative
% H -> Heuristic
% F -> Cummulative + Heuristic

% [Node, Parent, Cummulative, Heuristic, C+H].
% Start -> [[X, Y, Color], null, 0 ,x, 0]


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
    % write("CurrentNode" + CurrentNode), nl,
    getAllValidChildren(CurrentNode, TmpOpen, Closed, Goal, Children), % Step 3
    addChildren(Children, TmpOpen, NewOpen), % Step 4
    append(Closed, [CurrentNode], NewClosed), % Step 5.1
    % write("newopen"+ NewOpen),nl,write("NewClosed" + NewClosed),nl,
    % write("CurrentNode" + CurrentNode),nl,write("Children" + Children),
    search(NewOpen, NewClosed, Goal). % Step


getAllValidChildren(Node, Open, Closed, Goal, Children):-
    findall(Next, getNextState(Node,Open,Closed,Goal,Next),
    Children).


getNextState([State,_,G,_,_],Open,Closed,Goal,[Next,State,NewG,NewH,NewF]):-
    move(State, Next, MoveCost),
    % write("Next" + Next), nl,
    calculateH(Next, Goal, NewH),
    % write("NewH" + NewH),nl,
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


% Implementation of findMin in getBestState determines the search alg.
% Greedy best-first search.
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


move(Node, Next, 1):-
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
%   write("left"), nl,
%   write(Node), write(" "), write(Next), write(" "), nl,
  Color1 == Color2.


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
%   write("right"), nl,
%   write(Node), write(" "), write(Next), write(" "), nl,
  Color1 == Color2.


up(Node, Next):-
  get_board(Board),
  get_n(M),
  nth0(Indx, Board, Node),
  Node = [X1, Y1, Color1],
  Indx >= M,
  NextIndx is Indx - M,
  nth0(NextIndx, Board, Next),
  Next = [X2, Y2, Color2],
%   write("up"), nl,
%   write(Node), write(" "), write(Next), write(" "), nl,
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
%   write("down"), nl,
%   write(Node), write(" "), write(Next), write(" "), nl,
  Color1 == Color2.


start(Board, N, M, Start, Goal):-
  set_n(N),
  set_m(M),
  set_board(Board),
  search([Start], [], Goal).
  

calculateH(State, Goal, H):-
    State  = [X1, Y1, Color1],
    Goal = [X2, Y2, Color2],
    H is (X2 - X1) + (Y2 - Y1).


printSolution([State, null, G, H, F],_):-
    write([State, G, H, F]), nl.


printSolution([State, Parent, G, H, F], Closed):-
    member([Parent, GrandParent, PrevG, Ph, Pf], Closed),
    printSolution([Parent, GrandParent, PrevG, Ph, Pf], Closed),
    write([State, G, H, F]), nl.


% no path -> start([[0, 0, red], [0, 1, red], [0, 2, yellow], [0, 3, yellow], [1, 0, red],[1, 1, blue], [1, 2, red], [1, 3, red], [2, 0, red], [2, 1, blue], [2, 2, red],[2, 3, yellow], [3, 0, blue], [3, 1, red], [3, 2, blue], [3, 3, yellow]], 4, 4, [[0, 0, red], null, 0 ,x, 0], [1,3,red]).
% straight path -> start([[0, 0, red], [0, 1, red], [0, 2, yellow], [0, 3, yellow], [1, 0, red],[1, 1, blue], [1, 2, blue], [1, 3, blue], [2, 0, red], [2, 1, red], [2, 2, red],[2, 3, yellow], [3, 0, blue], [3, 1, red], [3, 2, blue], [3, 3, yellow]], 4, 4, [[1, 1, blue], null, 0 ,x, 0], [1,3,blue]).
% two pathes-> start([[0, 0, red], [0, 1, red], [0, 2, yellow], [0, 3, yellow], [1, 0, red],[1, 1, blue], [1, 2, blue], [1, 3, blue], [2, 0, red], [2, 1, blue], [2, 2, blue],[2, 3, blue], [3, 0, blue], [3, 1, red], [3, 2, blue], [3, 3, yellow]], 4, 4, [[1, 1, blue], null, 0 ,x, 0], [2,3,blue]).
