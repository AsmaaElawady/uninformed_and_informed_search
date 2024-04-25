search(Open, Closed, Goal):-
getState(Open, [CurrentState,Parent], _), % Step 1
CurrentState = Goal, !, % Step 2
write("Search is complete!"), nl,
printSolution([CurrentState,Parent], Closed).
search(Open, Closed, Goal):-
getState(Open, CurrentNode, TmpOpen),
getAllValidChildren(CurrentNode,TmpOpen,Closed,Children), % Step3
addChildren(Children, TmpOpen, NewOpen), % Step 4
append(Closed, [CurrentNode], NewClosed), % Step 5.1
search(NewOpen, NewClosed, Goal). % Step 5.2

% Implementation of step 3 to get the next states
getAllValidChildren(Node, Open, Closed, Children):-
findall(Next, getNextState(Node, Open, Closed, Next), Children).

getNextState([State,_], Open, Closed, [Next,State]):-
move(State, Next),
not(member([Next,_], Open)),
not(member([Next,_], Closed)).
% Implementation of getState and addChildren determine the search
alg.
% BFS
getState([CurrentNode|Rest], CurrentNode, Rest).
addChildren(Children, Open, NewOpen):-
append(Open, Children, NewOpen).

% Implementation of printSolution to print the actual solution path
printSolution([State, null],_):-
write(State), nl.
printSolution([State, Parent], Closed):-
member([Parent, GrandParent], Closed),
printSolution([Parent, GrandParent], Closed),
write(State), nl.
 


% input 3x3  >> List of List [[R,R,B],[Y,B,B]], 
% Goal >> [A,A,A,A]


move(State, Next):-
left(State, Next); right(State, Next);
up(State, Next); down(State, Next).

left([ROW,COL,C], Next):-
   CurrColor is element_at(ROW, COL, )



% Using nth0/3 (0-based indexing)
element_at(Row, Column, Matrix, Element) :-
    nth0(Row, Matrix, RowList),
    nth0(Column, RowList, Element).

 
 







%Left invalid if(j < 0)
%Right invalid if(j > M)
%Up invalid if(i < 0)
%down invalid if(i > N)

% state representaion will be [x,y,color]
