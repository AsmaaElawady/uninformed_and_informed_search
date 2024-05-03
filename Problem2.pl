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
    getAllValidChildren(CurrentNode, TmpOpen, Closed, Goal, Children), % Step 3
    addChildren(Children, TmpOpen, NewOpen), % Step 4
    append(Closed, [CurrentNode], NewClosed), % Step 5.1
    search(NewOpen, NewClosed, Goal). % Step


% Implementation of step 3 to get the next states
getAllValidChildren(Node, Open, Closed, Goal, Children):-
    findall(Next, getNextState(Node,Open,Closed,Goal,Next),
    Children).


% get next state and caculate Cummulative and Heuristic and caculate total(Cummulative+Heuristic)
getNextState([State,_,G,_,_],Open,Closed,Goal,[Next,State,NewG,NewH,NewF]):-
    move(State, Next, MoveCost),
    calculateH(Next, Goal, NewH),
    NewG is G + MoveCost,
    NewF is NewG + NewH,
    % check if node is already exist in open and closed in this case 
    %check cost if cost of node greater than the same node swap with least cost 
    ( not(member([Next,_,_,_,_], Open)) ; memberButBetter(Next,Open,NewF)),
    ( not(member([Next,_,_,_,_],Closed)); memberButBetter(Next,Closed,NewF)).


% Implementation of addChildren and getBestState
addChildren(Children, Open, NewOpen):-
    append(Open, Children, NewOpen).


% get node with min cost and remove it from open list
getBestState(Open, BestChild, Rest):-
    findMin(Open, BestChild),
    delete(Open, BestChild, Rest).


% Implementation of findMin in getBestState determines the search alg.
% A* search.
findMin([X], X):- !.

findMin([Head|T], Min):-
    findMin(T, TmpMin),
    Head = [_,_,_,_,HeadF],
    TmpMin = [_,_,_,_,TmpF],
    (TmpF < HeadF -> Min = TmpMin ; Min = Head).

% if node exist in open and anther node have the same child in open check cost to know i nedd swap or no
memberButBetter(Next, List, NewF):-
    findall(F, member([Next,_,_,_,F], List), Numbers),
    min_list(Numbers, MinOldF),
    MinOldF > NewF.


move(Node, Next, 1):-
    right(Node, Next);
    down(Node, Next);
    left(Node, Next);
    up(Node, Next).


% left predicate checks the left node af the current node and if it is valid -> return it.
left(Node, Next):-
    get_board(Board), % get the board.
    get_n(N), % get N (number of raws).
    nth0(Indx, Board, Node), % get the index of the current node in the board.
    Node = [_, _, Color1], % get the Color of the current node.
    CheckIndx is Indx mod N, % calculate Index % N
    CheckIndx \= 0, % check that the result != 0 (not in the left border).
    NextIndx is Indx - 1, % calculate indx of the next node which is currentIndx - 1.
    nth0(NextIndx, Board, Next), % get the index of the next node.
    Next = [_, _, Color2], % get the Color of the nextNode.
    Color1 == Color2. % check that both are the same.

right(Node, Next):-
    get_board(Board), % get the board.
    get_n(N), % get N (number of raws).
    nth0(Indx, Board, Node), % get the index of the current node in the board.
    Node = [_, _, Color1], % get the Color of the current node.
    CheckIndx is (Indx+1) mod N, % calculate (Index+1) % N
    CheckIndx \= 0, % check that the result != 0 (not in the right border).
    NextIndx is Indx + 1, % calculate indx of the next node which is currentIndx + 1.
    nth0(NextIndx, Board, Next), % get the index of the next node.
    Next = [_, _, Color2], % get the Color of the nextNode.
    Color1 == Color2. % check that both are the same.


up(Node, Next):-
    get_board(Board), % get the board.
    get_n(M), % get M (number of columns).
    nth0(Indx, Board, Node), % get the index of the current node in the board.
    Node = [_, _, Color1], % get the Color of the current node.
    Indx >= M, % check that the current nodes index is greater than or equal the number of columns.
    NextIndx is Indx - M, % calculate index of the up node which will be current index - number of columns.
    nth0(NextIndx, Board, Next), % get the index of the next node.
    Next = [_, _, Color2], % get the Color of the nextNode.
    Color1 == Color2. % check that both are the same.



down(Node, Next):-
    get_board(Board), % get the board.
    get_n(N), % get N (number of raws).
    get_m(M), % get M (number of columns).
    nth0(Indx, Board, Node), % get the index of the current node in the board.
    Node = [_, _, Color1], % get the Color of the current node.
    CheckIndx is (N * M) - M, % calculate (number of raws - number of columns) - numer of columns.
    Indx =< CheckIndx, % check that current indx is less than or equal the CheckIndx (not in the last raw).
    NextIndx is Indx + M, % calculate index of the down node which will be current indx + number of columns.
    nth0(NextIndx, Board, Next), % get the index of the next node.
    Next = [_, _, Color2], % get the Color of the nextNode.
    Color1 == Color2. % check that both are the same.


% start program with Borad,No. of rows, No. of colums and take start and goal to start search on path in board
start(Board, N, M, Start, Goal):-
  set_n(N),
  set_m(M),
  set_board(Board),
  search([Start], [], Goal).
  


% calculate Heuristic based on indices of node 
calculateH(State, Goal, H):-
    State  = [X1, Y1, _],
    Goal = [X2, Y2, _],
    H is (X2 - X1) + (Y2 - Y1).



% base case to print state with indices, Color, Heuristic , Cummulative and total(Heuristic+Cummulative)
printSolution([State, null, G, H, F],_):-
    write([State, G, H, F]), nl.


printSolution([State, Parent, G, H, F], Closed):-
% check if node in closed list to print correct path
    member([Parent, GrandParent, PrevG, Ph, Pf], Closed),
    printSolution([Parent, GrandParent, PrevG, Ph, Pf], Closed),
    write([State, G, H, F]), nl.


% no path -> start([[0, 0, red], [0, 1, red], [0, 2, yellow], [0, 3, yellow], [1, 0, red],[1, 1, blue], [1, 2, red], [1, 3, red], [2, 0, red], [2, 1, blue], [2, 2, red],[2, 3, yellow], [3, 0, blue], [3, 1, red], [3, 2, blue], [3, 3, yellow]], 4, 4, [[0, 0, red], null, 0 ,x, 0], [1,3,red]).
% straight path -> start([[0, 0, red], [0, 1, red], [0, 2, yellow], [0, 3, yellow], [1, 0, red],[1, 1, blue], [1, 2, blue], [1, 3, blue], [2, 0, red], [2, 1, red], [2, 2, red],[2, 3, yellow], [3, 0, blue], [3, 1, red], [3, 2, blue], [3, 3, yellow]], 4, 4, [[1, 1, blue], null, 0 ,x, 0], [1,3,blue]).
% two pathes-> start([[0, 0, red], [0, 1, red], [0, 2, yellow], [0, 3, yellow], [1, 0, red],[1, 1, blue], [1, 2, blue], [1, 3, blue], [2, 0, red], [2, 1, blue], [2, 2, blue],[2, 3, blue], [3, 0, blue], [3, 1, red], [3, 2, blue], [3, 3, yellow]], 4, 4, [[1, 1, blue], null, 0 ,x, 0], [2,3,blue]).
% ex in Ass -> start([[0, 0, red], [0, 1, red], [0, 2, yellow], [0, 3, yellow], [1, 0, red],[1, 1, blue], [1, 2, red], [1, 3, red], [2, 0, red], [2, 1, red], [2, 2, red],[2, 3, yellow], [3, 0, blue], [3, 1, red], [3, 2, blue], [3, 3, yellow]], 4, 4, [[0, 0, red], null, 0 ,x, 0], [1,3,red]).
