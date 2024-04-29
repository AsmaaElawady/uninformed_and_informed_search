# uninformed_and_informed_search
Prolog problem that uses uninformed search (breadth first) and informed search (A*)

## Question 1
problem uses uninformed search(breadth first).
- You will be given a board that consists of N x M cells.
- Each cell contains a color (Red, Yellow or Blue).
- Your task is to find color cycles for any of the three colors
- For example, as shown in the picture, cells 2,1 -> 2,2 -> 3,2 -> 3,1 form a blue cycle
- Another cycle could be cells 2,0 -> 2,1 -> 3,1 -> 3,0
- Note that yellow and red colors do not form cycles in this example.
- Your code should print at least one of these cycles including its color (if any) or no cycles
exist
- Cycle defined by the following cells c1, c2, ..., ck must have the following:
    - These cells are different (no duplicates)
    - At least 4 cells (or more)
    - All cells have the same color
    - The cells are adjacent to each other
- You are allowed to use the search engine for uninformed search that we given in the lab
- Your main tasks are:
    - Design input
    - Design state representation
    - Design moves
    - Design output
 
 ## Question 2
 problem uses informed search (A*).
 - You will be given a board that consists of N x M cells.
- Each cell contains a color (Red, Yellow or Blue).
- You will be given a start and goal cells of the same color
- Your task is to find if there is a path between the start and the end cells.
- All cells on the path must be from the same color
- For example, as shown in the picture, 0,0 is the start cell and 1,3 is the end cell. The
correct path is 0,0 -> 1,0 -> 2,0 -> 2,1 -> 2,2 -> 1,2 -> 1,3
- Your code should print at least one path (if any) or no paths exist
- Diagonal moves are not allowed. You can move left, right, up and down
- Path must not contain repeated cells
- You are allowed to use the search engine for informed search that we given in the lab but
make sure it uses A*
- Your main tasks are:
    - Design input
    - Design state representation
    - Design moves
    - Design heuristic predicate
    - Design output

 
