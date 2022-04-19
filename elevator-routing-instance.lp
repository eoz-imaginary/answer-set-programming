%Problem instance for: elevator-routing 

%maximum number of time steps allowed, and maximum number of people in one elevator at once
%both can be overwritten with the -c command at runtime
#const steps=8.
#const m=2.

% establish four passengers 
person(p0).
person(p1).
person(p2).
person(p3).

% establish two lifts
lift(a).
lift(b).

% establish 5 floors
floor(0..5).

% NOTE: having a passenger 'spawn in' at a time != 0 is theorectically possible, but has not been tested

% set starting locations of passengers
% syntax: at ({passenger}, {starting_floor}, {time_step})
at(p0,2,0).
at(p1,2,0).
at(p2,2,0).
at(p3, 5, 0).

% set starting locations of lifts
% syntax: at({lift}, {starting_floor}, {time_step})
at(a,0,0).
at(b,0,0).

% goal state: 
goal(T):- at(p0,5,T), at(p1,3,T), at(p2,4,T), at(p3, 1, T).

%some other sample goals
%goal(T) :- at(p0, 5, T), at(p1, 3, T), at(p2, 5, T).

%goal(T) :- at(p0, 5, T), at(p1, 5, T), at(p2, 5, T), at(p3, 1, T).
