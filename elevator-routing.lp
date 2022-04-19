% Problem: elevator routing

% Original code provided by Dr. Jia-Hui You for CMPUT 620 (University of Alberta)

% Modifications made to original: 
% -changed actions to work with two lifts, 
% -added solution constraint s.t. a person can't board two different lifts at once.
% -constrained maximum number of people allowed in an elevator at once to be m. 

state(0..steps).

#show board/4.
#show unboard/4.
#show up/4.
#show down/4.
%#show at/3.
%#show num_people/3.

#show in/3.
%action board(L,P,F,T)

{board(L,P,F,T)}:-
   state(T), person(P), floor(F), lift(L),
   at(P,F,T),
   at(L,F,T),
   not affected(L,T),
   not goal(T).

{unboard(L,P,F,T)}:-
   state(T), person(P), floor(F), lift(L),
   in(L,P,T),
   at(L,F,T),
   not affected(L,T),
   not goal(T).
 

{up(L,From,To,T)}:-
%  state(T), floor(From), floor(To), lift(L),
   above(To,From),
   at(L,From,T),
   not goal(T).

{down(L,From,To,T)}:-
%  state(T), floor(From), floor(To), lift(L),
   above(From,To),
   at(L,From,T),
   not goal(T).

above(From,To):-
   floor(From), floor(To),  % From and To are unsafe if commented out
   From > To.

%affected
change(P,T):- board(L,P,F,T).
change(P,T):- unboard(L,P,F,T).

affected(L,T):-
   state(T), floor(From), floor(To), lift(L),
   down(L,From,To,T).
affected(L,T):-
   state(T), floor(From), floor(To), lift(L),
   up(L,From,To,T).

%effects

at(L,To,T+1):-
    state(T), floor(From), floor(To), lift(L),
    down(L,From,To,T).

at(L,To,T+1):-
    state(T), floor(From), floor(To), lift(L),
    up(L,From,To,T).

in(L,P,T+1):-
%   state(T), floor(F), person(P), lift(L),
    board(L,P,F,T).

at(P,F,T+1):-
    state(T), floor(F), person(P),
    unboard(L,P,F,T).


%frame axioms

at(P,F,T+1):-
   state(T), person(P), floor(F),
   not change(P,T),
   at(P,F,T).

in(L,P,T+1):-
   state(T), person(P), lift(L),
   not change(P,T),
   in(L,P,T).

at(L,F,T+1):-
   state(T), floor(F), lift(L),
   not affected(L,T),
   at(L,F,T).

%constraints things that shouldn't happen

:- up(L1,From,To,T), up(L2,From,To1,T), To != To1, floor(To1), floor(From), lift(L1), lift(L2), L1=L2.
:- up(L1,From,To,T), up(L2,From1,To,T), From != From1, lift(L1), lift(L2), L1=L2,
   floor(From1), floor(From).

:- down(L1,From,To,T), down(L2,From,To1,T), To != To1, lift(L1), lift(L2), L1=L2,
   floor(To1), floor(From).

:- down(L1,From,To,T), down(L2,From1,To,T), From != From1, lift(L1), lift(L2), L1=L2,
   floor(From1), floor(To), floor(From).

:- up(L1,From,To,T), down(L2,From,To1,T), To != To1, lift(L1), lift(L2), L1=L2,
   floor(To1), floor(To), floor(From).
   
%a person can't get into two different lifts at once
:- board(L1, P, F, T), board(L2, P, F, T), lift(L1), lift(L2), L1!=L2.

%different people can't get onto the same elevator at the same time
:- board(L, P1, F, T), board(L, P2, F, T), person(P1), person(P2), P1!=P2.

%at most m people can be in an elevator at once.
num_people(L, N, T) :- #count{P : in(L, P, T)} = N, lift(L), state(T).

:- lift(L), state(T), num_people(L, N, T), N > m. 


goal(T+1):- goal(T), state(T).
goal:- goal(T), state(T).
:- not goal.



