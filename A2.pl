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


search(Open, Closed, CycleList):-
    getState(Open, Node, TmpOpen), % Step 1
    TmpOpen = [],
    % getAllValidChildren(Node, TmpOpen, NewClosed, Children1, Children2), % Step3
    % Children1 = [],
    % Children2 = [],
    % length(CycleList, Length),
    % Length >= 4,
    % CurrentState = Goal, !, % Step 2 -> need to handle the check for the goal
    % write("Search is complete!"), nl,
    write(Closed).
    %printSolution(Closed). % -> modify the print.
    % print_cycles(Closed).    

% print_cycles(Closed):-
%     [[X, Y, Color], [X, Y+1, Color], [X+1, Y+1, Color], [X+1, Y, Color]] = Closed.



search(Open, Closed, CycleList):-
    getState(Open, CurrentNode, TmpOpen),
    append(Closed, [CurrentNode], NewClosed), % Step 5.1
    getAllValidChildren(CurrentNode, TmpOpen, NewClosed, Children), % Step3
    addChildren(Children, TmpOpen, NewOpen), % Step 4
    
    write("current node" + CurrentNode), nl,
    write("children" + Children1 + Children2), nl,
    write("Closed" + UpdatedClosed), nl,
    write("Open" + NewOpen2), nl,
    write("Cycle List" + CycleList), nl,
    
    search(NewOpen2, UpdatedClosed, CycleList)).

    % addChildren(Children1, TmpOpen, NewOpen), % Step 4
    % addChildren(Children2, NewOpen, NewOpen2), % Step 4
    % search(NewOpen2, NewClosed). % Step 5.2


% Implementation of step 3 to get the next states
% getAllValidChildren(Node, Open, Closed, Children):-
    % findall([Next1, Next2], getNextState(Node, Open, Closed, Next1, Next2), Children).
    
% getAllValidChildren(Node, Open, Closed, Next1List, Next2List):-
%     findall(Next1, getNextState(Node, Open, Closed, Next1, _), Next1List),
%     findall(Next2, getNextState(Node, Open, Closed, _, Next2), Next2List).

getAllValidChildren(Node, Open, Closed, Next1List, Next2List):-
    findall(Next1-Next2, getNextState(Node, Open, Closed, Next1, Next2), NextPairs),
    pairs_keys_values(NextPairs, Next1List, Next2List).

% getNextState(Node, Open, Closed, Next1, Next2):-
%     move(Node, Next1, Next2),
%     write("Next1" + Next1),
%     write("Next2" + Next2),
%     not(member(Next1, Open)),
%     not(member(Next1, Closed)),
%     not(member(Next2, Open)),
%     not(member(Next2, Closed)).

getNextState(Node, Open, Closed, Next1, Next2):-
    move(Node, Next1, Next2).
    % checkNextState(Next1, Open, Closed),
    % checkNextState(Next2, Open, Closed).

% Predicate to check if a next state is valid
% checkNextState(Next, Open, Closed):-
%     not(member(Next, Open)),
%     not(member(Next, Closed)).


% Modified checkNextState to remove duplicates from the children list
checkNextState(Children, Open, Closed, ValidChildren) :-
    % Remove duplicates from Children
    sort(Children, UniqueChildren),
    % Check each unique child node
    checkUniqueChildren(UniqueChildren, Open, Closed, [], ValidChildren).


% Predicate to check each unique child node
checkUniqueChildren([], _, _, Acc, Acc).
checkUniqueChildren([Child|Rest], Open, Closed, Acc, ValidChildren) :-
    % Check if the child is not in Open or Closed
    (not(member(Child, Open)), not(member(Child, Closed))) ->
        % If not in Open or Closed, add it to the accumulator
        checkUniqueChildren(Rest, Open, Closed, [Child|Acc], ValidChildren);
    % If the child is in Open or Closed, skip it
    checkUniqueChildren(Rest, Open, Closed, Acc, ValidChildren).


% Implementation of getState and addChildren determine the search alg.
% BFS
getState([CurrentNode|Rest], CurrentNode, Rest).


addChildren(Children, Open, NewOpen):-
    append(Open, Children, NewOpen).


printSolution([]).


printSolution([H|T]):-
  write(H), nl,
  printSolution(T).


% move(Node, Next):-
    % (up(Node, Next), left(Node, Next));
    % (up(Node, Next), right(Node, Next));
    % (down(Node, Next), right(Node, Next));
    % (down(Node, Next), left(Node, Next));

move(Node, Next1, Next2):-
    (up(Node, Next1), left(Node, Next2)).

move(Node, Next1, Next2):-
    (up(Node, Next1), right(Node, Next2)).

move(Node, Next1, Next2):-
    (down(Node, Next1), right(Node, Next2)).

move(Node, Next1, Next2):-
    (down(Node, Next1), left(Node, Next2)).


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
%   write(Next),nl.


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
    Start < End,
    search([CurrentNode], [], []),
    Next is Start + Step,
    loop(Rest, Next, End, Step).




% Node = [X, Y, Color]
% Open and Closed lists = [[X, Y, Color], [X, Y, Color], ....]
% board = [[X, Y, Color], [X, Y, Color], [X, Y, Color], [X, Y, Color], [X, Y, Color], [X, Y, Color], ....]
% goal -> when the open list is empty.

% board = [[0, 0, yellow], [0, 1, yellow], [0, 2, yellow], [1, 0, yellow], [1, 1, yellow], [1, 2, yellow], [2, 0, blue], [2, 1, blue], [2, 2, blue], ]
% start([[0, 0, yellow], [0, 1, yellow], [0, 2, yellow], [0, 3, red], [1, 0, blue], [1, 1, yellow], [1, 2, blue], [1, 3, yellow], [2, 0, blue], [2, 1, blue], [2, 2, blue], [2, 3, yellow], [3, 0, blue], [3, 1, blue], [3, 2, blue], [3, 3, yellow]], 4, 4).
% [[3,2,blue],[2,2,blue],[3,1,blue],[1,2,blue],[2,1,blue],[3,0,blue],[2,0,blue]]

% move(Node, Next, Visited):-
%     (up(Node, Next); down(Node, Next); left(Node, Next); right(Node, Next)),
%     \+ member(Next, Visited).

% left(Node, Next, Visited):-
%   get_board(Board),
%   get_n(N),
%   nth0(Indx, Board, Node),
%   Node = [X1, Y1, Color1],
%   CheckIndx is Indx mod N,
%   CheckIndx \= 0,
%   NextIndx is Indx - 1,
%   nth0(NextIndx, Board, Next),
%   Next = [X2, Y2, Color2],
%   Color1 == Color2,
%   \+ member(Next, Visited).

% right(Node, Next, Visited):-
%   get_board(Board),
%   get_n(N),
%   nth0(Indx, Board, Node),
%   Node = [X1, Y1, Color1],
%   CheckIndx is (Indx+1) mod N,
%   CheckIndx \= 0,
%   NextIndx is Indx + 1,
%   nth0(NextIndx, Board, Next),
%   Next = [X2, Y2, Color2],
%   Color1 == Color2,
%   \+ member(Next, Visited).

% up(Node, Next, Visited):-
%   get_board(Board),
%   get_n(M),
%   nth0(Indx, Board, Node),
%   Node = [X1, Y1, Color1],
%   Indx >= M,
%   NextIndx is Indx - M,
%   nth0(NextIndx, Board, Next),
%   Next = [X2, Y2, Color2],
%   Color1 == Color2,
%   \+ member(Next, Visited).

% down(Node, Next, Visited):-
%   get_board(Board),
%   get_n(N),
%   get_m(M),
%   nth0(Indx, Board, Node),
%   Node = [X1, Y1, Color1],
%   CheckIndx is (N * M) - M,
%   Indx =< CheckIndx,
%   NextIndx is Indx + M,
%   nth0(NextIndx, Board, Next),
%   Next = [X2, Y2, Color2],
%   Color1 == Color2,
%   \+ member(Next, Visited).