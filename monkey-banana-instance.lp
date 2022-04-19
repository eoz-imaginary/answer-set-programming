%Problem instance for: monkey-banana pathing

%maximum number of actions the monkey is allowed to take
%can be overwritten with the -c command at runtime
#const n=14.

%establish locations
%syntax: pos({room}, {location_in_room})

pos(a, b1).
pos(a, b2).
pos(a, b3).
pos(a, b4).

pos(c, d1).
pos(c, d2). 
pos(c, d3).

%establish starting locations of monkey, chair, & banana
at(monkey, c, d2, 0).
at(chair, a, b3, 0).
at(banana, c, d2, 0).

%other starting locations (simpler)
%at(monkey, a, b1, 0).
%at(chair, a, b4, 0).
%at(banana, a, b2, 0).

%establish locations of doors between rooms
%syntax: door({room1}, {location_in_room1}, {room2}, {location_in_room2}, [open/closed], {time_step})
% NOTE: A door is not necessarily two-way (although it must be for this instance). 
door(c, d3, a, b1, closed, 0).
door(a, b1, c, d3, closed, 0).

%goal state: monkey has the bananas at some time T
goal(T) :- has_bananas(monkey, R, P, T), pos(R,P), time(T).


%if necessary, some helpful goals for debugging
%goal(T) :- on_chair(monkey, R, P, T), time(T).

%goal(T) :- chair(on_monkey, T), time(T).

%goal(T) :- at(monkey, a, b3, T).
