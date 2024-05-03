% Predicate to set the value of global variable N.
set_n(Value) :-
    retractall(n(_)),
    assertz(n(Value)).


% Predicate to get the value of global variable N.
get_n(Value) :-
    n(Value).


% Predicate to set the value of global variable M.
set_m(Value) :-
    retractall(m(_)),
    assertz(m(Value)).


% Predicate to get the value of global variable M.
get_m(Value) :-
    m(Value).


% Predicate to set the value of the board.
set_board(Value) :-
    retractall(board(_)),
    assertz(board(Value)).


% Predicate to get the value of the board.
get_board(Value) :-
    board(Value).


% base case for search -> if current node has no valid children (valid children means that they are adjacents of the current node and has the same color of the current node) -> no cycle.
search(Open, Closed, _):-
    getState(Open, Node, _), % get the current node from the open list.
    getChildren(Node, Children1, Children2), % get the children of the current node -> Children1 and Children2 hence if the node in the cycle it should return at least 2 children.
    checkNextState(Children1, Closed, ValidChildren1), % check that nodes in Children1 not in closed list and uniques -> return ValidChildren1.
    checkNextState(Children2, Closed, ValidChildren2), % check that nodes in Children2 not in closed list and uniques -> return ValidChildren2.
    ValidChildren1 = [], % check if ValidChildren1 is empty.
    ValidChildren2 = []. % check if ValidChildren2 is empty.


% base case for search -> if one of the current node's children is the head of the cycle list -> cycle found.
search(Open, Closed, CycleList):-
    getState(Open, Node, _), % get the current node from the open list.
    append(Closed, [Node], _), % append the current node to the closed list.
    getChildren(Node, Children1, Children2), % get the children of the current node.
    [H|_] = CycleList, % get the head of the cycle list.
    (checkCycle(Children1, H); checkCycle(Children2, H)), % check if any of the children is the head of the cycle list.
    not(member(Node, CycleList)), % check that current node is not in the cycle list.
    append(CycleList, [Node], NewCycleList), % append the current node to the cycle list.
    length(NewCycleList, Length), % get the length of the cycle list.
    Length >= 4, % check that the length is greater than or equal 4. (smallest size of the cycle is 4).
    write("Cycle found"), nl,
    write(NewCycleList), nl.


% recursive search predicate.
search(Open, Closed, CycleList):-
    getState(Open, CurrentNode, TmpOpen), % get the current node from the open list.
    append(Closed, [CurrentNode], NewClosed), % append the current node to the closed list.
    getChildren(CurrentNode, Children1, Children2), % get the children of the current node.
    
    % Check if both Children1 and Children2 are not empty
    Children1 \= [], Children2 \= [] ->
        not(member(CurrentNode, CycleList)), % append the current node to the cycle list.
        append(CycleList, [CurrentNode], NewCycleList), % Add Current Node to cycle List.
        checkNextState(Children1, NewClosed, ValidChildren1), % check that nodes in Children1 not in closed list and uniques -> return ValidChildren1.
        addChildren(ValidChildren1, TmpOpen, NewOpen), % add the valid children to the open list.
        checkNextState(Children2, NewClosed, ValidChildren2), % check that nodes in Children2 not in closed list and uniques -> return ValidChildren2.
        addChildren(ValidChildren2, NewOpen, NewOpen2), % add the valid children to the open list.
        search(NewOpen2, NewClosed, NewCycleList). % continue search with the NewCycleList, NewClosed, and NewOpen.


% base case of checkCycle if we found that there is a node matches tha first node in the cycle list.
checkCycle([H|_], H).

% checkCycle predicate -> check if any node in the list is the first node in the cycle list.
checkCycle([_|T], H2):-
    checkCycle(T, H2).


% get children of the node (adjacent nodes and with the same color) returns two lists because the valid node should has at least 2 children.
getChildren(Node, Next1List, Next2List):-
    findall(Next1, getNextState(Node, Next1, _), Next1List),
    findall(Next2, getNextState(Node, _, Next2), Next2List).

% get the valid next state to the current state.
getNextState(Node, Next1, Next2):-
    move(Node, Next1, Next2).


% checkNextState to remove duplicates from the children list
checkNextState(Children, Closed, ValidChildren) :-
    sort(Children, UniqueChildren), % remove duplicates from Children
    checkUniqueChildren(UniqueChildren, Closed, [], ValidChildren). % Check each unique child node that it is not in closed list.


% Predicate to check each unique child node
checkUniqueChildren([], _, Acc, Acc).

checkUniqueChildren([Child|Rest], Closed, Acc, ValidChildren) :-
    (not(member(Child, Closed))) -> % Check if the child is not in Closed.
        checkUniqueChildren(Rest, Closed, [Child|Acc], ValidChildren); % If not in Closed, add it to the accumulator

    checkUniqueChildren(Rest, Closed, Acc, ValidChildren). % If the child is in Closed, skip it.


% getState predicate returns the first node in the open list (the approach we follow is LIFO (DFS) so we append in the first of the open list and take the last node appended).
getState([CurrentNode|Rest], CurrentNode, Rest).

% addChildren predicate add the Children to the open list.
addChildren(Children, Open, NewOpen):-
    append(Children,Open, NewOpen).


% move predicate check the up and left of the current node and return Next1 and Next2 if the node has an up and left nodes.
move(Node, Next1, Next2):-
    (up(Node, Next1), left(Node, Next2)).

% move predicate check the up and right of the current node and return Next1 and Next2 if the node has an up and right nodes.
move(Node, Next1, Next2):-
    (up(Node, Next1), right(Node, Next2)).

% move predicate check the down and right of the current node and return Next1 and Next2 if the node has an down and right nodes.
move(Node, Next1, Next2):-
    (down(Node, Next1), right(Node, Next2)).

% move predicate check the down and left of the current node and return Next1 and Next2 if the node has an down and left nodes.
move(Node, Next1, Next2):-
    (down(Node, Next1), left(Node, Next2)).


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
    Indx >= M, % check that the current node's index is greater than or equal the number of columns.
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


% predicate which will start the search.
start(Board, N, M):-
  set_n(N), % set the value of N.
  set_m(M),  % set the value of M.
  set_board(Board),  % set the value of Board.
  End is N*M, % calculate the End of the loop.
  loop(Board, 1, End).


% Base case: When Start == End -> we stop.
loop(_, End, End) :- !.


% Recursive loop
loop([CurrentNode|Rest], Start, End) :-
    Start =< End, % check that Start less than or equal end.
    search([CurrentNode], [], []), % send to the search predicate the open list with the current node and empty closed list and empty cycle list.
    Next is Start + 1, % increase the Next by 1.
    loop(Rest, Next, End). % recursive call to the loop with the Rest of the Board. 



% TEST CASES
% start([[0, 0, blue], [0, 1, blue], [0, 2, blue], [0, 3, blue], [1, 0, blue], [1, 1, blue], [1, 2, yellow], [1, 3, yellow], [2, 0, red], [2, 1, red], [2, 2, yellow], [2, 3, yellow], [3, 0,red], [3, 1, red], [3, 2, yellow], [3, 3, yellow]], 4, 4).
% start([[0, 0, yellow], [0, 1, yellow], [0, 2, yellow], [0, 3, red], [1, 0, blue], [1, 1, yellow], [1, 2, blue], [1, 3, yellow], [2, 0, blue], [2, 1, blue], [2, 2, blue], [2, 3, yellow], [3, 0, blue], [3, 1, blue], [3, 2, blue], [3, 3, yellow]], 4, 4).
% start([[0, 0, yellow], [0, 1, yellow], [0, 2, yellow], [0, 3, red], [1, 0, blue], [1, 1, yellow], [1, 2, blue], [1, 3, yellow], [2, 0, blue], [2, 1, red], [2, 2, blue], [2, 3, yellow], [3, 0, blue], [3, 1, red], [3, 2, blue], [3, 3, yellow]], 4, 4).
% start([[0, 0, blue], [0, 1, blue], [0, 2, blue], [0, 3, blue], [1, 0, blue], [1, 1, blue], [1, 2, blue], [1, 3, blue], [2, 0, blue], [2, 1, blue], [2, 2, blue], [2, 3, blue], [3, 0,red], [3, 1, red], [3, 2, red], [3, 3, red]], 4, 4).
% start([[0, 0, blue], [0, 1, blue], [0, 2, yellow], [1, 0, blue], [1, 1, blue], [1, 2, yellow], [2, 0, yellow], [2, 1, yellow], [2, 2, yellow]], 3, 3).
% start([[0, 0, blue], [0, 1, blue], [0, 2, yellow], [1, 0, blue], [1, 1, yellow], [1, 2, yellow], [2, 0, yellow], [2, 1, yellow], [2, 2, yellow]], 3, 3).
% start([[0, 0, blue], [0, 1, blue], [0, 2, yellow], [1, 0, blue], [1, 1, red], [1, 2, yellow], [2, 0, yellow], [2, 1, yellow], [2, 2, yellow]], 3, 3).
