% Problem: monkey-banana pathing

time(0..n).

#show walk/5.
#show pick_up/4.
#show put_down/4.
#show climb/4.
#show grab/5.
#show has_bananas/4.
#show change_rooms/6.
#show open_door/6.
#show close_door/6.

%Define actions

%ACTION: WALK
%the monkey can walk from P1 to P2 in room R if it's at P1 and goal not reached

{walk(monkey, R, P1, P2, T)} :-
	pos(R, P1), pos(R, P2), time(T),
	at(monkey, R, P1, T),
	not goal(T).
	
%WALK POST-CONDITIONS

%after moving from P1 to P2 at T, monkey is at P2 at T+1
at(monkey, R, P2, T+1) :- walk(monkey, R, P1, P2, T).

%after walking while holding chair, chair has moved with monkey
at(chair, R, P2, T+1):- 
	walk(monkey, R, P1, P2, T), chair(on_monkey, T), pos(R, P1), pos(R, P2), time(T).
	
%after walking while holding chair, on_monkey condition stays
chair(on_monkey, T+1) :-
	walk(monkey, R, P1, P2, T), chair(on_monkey, T).
	
%if chair not on monkey, chair stays in place after monkey walks
at(chair, R, P, T+1) :-
	walk(monkey, R1, P1, P2, T), not chair(on_monkey, T), at(chair, R, P, T), pos(R, P), pos(R1, P1), pos(R1, P2), time(T).
	
%chair exists at current location if not on monkey
% NOTE: this is a bug-fix condition. Remove at your own risk
chair(R, P, T) :-
	at(chair, R, P, T), not chair(on_monkey, T).


%ACTION: CHANGE_ROOMS
%if monkey at door location in one room, monkey can move to adjacent room if door open

{change_rooms(monkey, R1, P1, R2, P2, T)} :-
	pos(R1, P1), pos(R2, P2), time(T), 
	at(monkey, R1, P1, T), 
	door(R1, P1, R2, P2, open, T), 
	not goal(T).
	
%CHANGE_ROOMS POSTCONDITION

%after moving through door, monkey now at door position in adjacent room
at(monkey, R2, P2, T+1) :- change_rooms(monkey, R1, P1, R2, P2, T). 

%if chair not on monkey, chair stays in place after changing rooms
at(chair, R, P, T+1) :-
	change_rooms(monkey, R1, P1, R2, P2, T), not chair(on_monkey, T), at(chair, R, P, T), pos(R, P), pos(R1, P1), pos(R2, P2), time(T).
	
%if chair on monkey, chair goes with monkey through room change.
chair(on_monkey, T+1) :-
	change_rooms(monkey, R1, P1, R2, P2, T), chair(on_monkey, T), pos(R1, P1), pos(R2, P2), time(T).


%ACTION: OPEN_DOOR
%if in a door space and door is closed, monkey can open the door (even if carrying chair).

{open_door(monkey, R1, P1, R2, P2, T)} :-
	pos(R1, P1), time(T), 
	at(monkey, R1, P1, T), 
	door(R1, P1, R2, P2, closed, T), 
	not goal(T).
	
%OPEN_DOOR POSTCONDITIONS:

%after opening door, monkey does not move and door is now open.
at(monkey, R1, P1, T+1) :- open_door(monkey, R1, P1, R2, P2, T), time(T). 
door(R1, P1, R2, P2, open, T+1) :- open_door(monkey, R1, P1, R2, P2, T), time(T).

%door opens symmetrically as well
door(R2, P2, R1, P1, open, T+1) :- open_door(monkey, R1, P1, R2, P2, T), time(T).

%if previous action wasn't a door action, door state remains the same.
door(R1, P1, R2, P2, open, T+1) :- door(R1, P1, R2, P2, open, T), not door_action(monkey, T), time(T).
door(R1, P1, R2, P2, closed, T+1) :- door(R1, P1, R2, P2, closed, T), not door_action(monkey, T), time(T).

%if chair on monkey or on floor during door action, chair state remains the same afterwards
chair(on_monkey, T+1) :- door_action(monkey, T), chair(on_monkey, T), time(T).
chair(R, P, T+1) :- door_action(monkey, T), chair(R, P, T), time(T). 
at(chair, R, P, T+1) :- door_action(monkey, T), at(chair, R, P, T), time(T).

%door_action is defined as monkey opening or closing the door
door_action(monkey, T) :- open_door(monkey, R1, P1, R2, P2, T), door(R1, P1, R2, P2, _, T), time(T).
door_action(monkey, T) :- close_door(monkey, R1, P1, R2, P2, T), door(R1, P1, R2, P2, open, T), time(T). 

%ACTION: CLOSE_DOOR
%monkey closes door behind him iff in a door space w/ door open (even if carrying chair).

{close_door(monkey, R1, P1, R2, P2, T)} :-
	pos(R2, P2), pos(R1, P1), time(T), 
	at(monkey, R1, P1, T), 
	door(R1, P1, R2, P2, open, T), 
	not goal(T).
	
%CLOSE_DOOR POSTCONDITIONS
%after closing door, monkey does not move and door is now closed

at(monkey, R1, P1, T+1) :- close_door(monkey, R1, P1, R2, P2, T), time(T).
door(R1, P1, R2, P2, closed, T+1) :- close_door(monkey, R1, P1, R2, P2, T), time(T).

%door closes symmetrically as well
door(R2, P2, R1, P1, closed, T+1) :- close_door(monkey, R1, P1, R2, P2, T), time(T).

%ACTION: PICK_UP
%monkey picks up chair iff monkey + chair at P in R at T AND monkey doesn't already have chair
{pick_up(monkey, R, P, T)} :-
	at(monkey, R, P, T), 
	at(chair, R, P, T), 
	chair(R, P, T),
	%not on_chair(monkey, R, P, T),
	%not chair(on_monkey, T),
	not goal(T).

%PICK_UP POSTCONDITIONS:
%after picking up chair, monkey has the chair, and monkey + chair haven't moved

chair(on_monkey, T+1) :- pick_up(monkey, R, P, T). 
at(monkey, R, P, T+1) :- pick_up(monkey, R, P, T), pos(R, P), time(T).

%ACTION: PUT_DOWN
%monkey puts down chair iff monkey has chair

{put_down(monkey, R, P, T)} :-
	pos(R, P), time(T),
	at(monkey, R, P, T),
	chair(on_monkey, T),
	not goal(T).

%PUT_DOWN POSTCONDITIONS:
%after putting down chair, chair no longer on monkey, and monkey + chair haven't moved

chair(R, P, T+1) :- put_down(monkey, R, P, T).
at(monkey, R, P, T+1) :- put_down(monkey, R, P, T).
at(chair, R, P, T+1) :- put_down(monkey, R, P, T).


%ACTION: CLIMB
%monkey climbs onto the chair iff:
%monkey + chair at same P/R/T AND monkey not holding chair AND chair under bananas

% NOTE: there is no climb-off-of-chair action, so once the monkey is on the chair it is there permanently.

{climb(monkey,R,P,T)} :-
        at(monkey,R,P,T),
        at(chair,R,P,T),
        at(banana,R,P,T),
        not on_chair(monkey, R, P, T),
		not chair(on_monkey, T),
        time(T), pos(R, P). %pos(R,P1), pos(R,P2), pos(R,P3).


on_chair(monkey,R,P,T+1) :- climb(monkey,R,P,T),pos(R,P),time(T).

%CLIMB POSTCONDITIONS:
%after climbing, monkey + chair haven't moved, and monkey is on chair

at(monkey, R, P, T+1) :- climb(monkey, R, P, T), time(T), pos(R, P).
at(chair, R, P, T+1) :- climb(monkey, R, P, T), time(T), pos(R, P).
at(banana, R, P, T+1) :- climb(monkey, R, P, T), time(T), pos(R, P).


%ACTION: GRAB	
%monkey grabs banana iff monkey + banana at same P/R/T AND monkey can reach (is on chair)
{grab(monkey, banana, R, P, T)} :-
	time(T), pos(R, P), 
	at(monkey, R, P, T), 
	at(banana, R, P, T), 
	at(chair, R, P, T),
	on_chair(monkey, R, P, T), 
	not goal(T).
	
%GRAB POSTCONDITIONS:
%after grabbing banana, monkey has bananas 
has_bananas(monkey, R, P, T+1) :- grab(monkey, banana, R, P, T), pos(R, P), time(T).



% --> SOLUTION CONSTRAINTS <--

%bananas cannot move
at(banana, R, P, T+1) :- at(banana, R, P, T), pos(R, P), time(T). 

%monkey can't walk and pick up/put down the chair at the same time
:- walk(monkey, R, P1, P2, T), pick_up(monkey, R, P1, T), pos(R, P1), pos(R, P2), time(T).
:- walk(monkey, R, P1, P2, T), put_down(monkey, R, P1, T), pos(R, P1), pos(R, P2), time(T).

%monkey can't change rooms without closing the door behind him immediately after
:- change_rooms(monkey, R1, P1, R2, P2, T), not door_action(monkey, T+1), door(R1, P1, R2, P2, _, T), time(T).

%monkey can't change rooms and take door action at the same time.
:- change_rooms(monkey, R1, P1, R2, P2, T), door_action(monkey, T), door(R1, P1, R2, P2, _, T), time(T).

%monkey can't walk and open/close a door at the same time.
:- walk(monkey, R1, P1, P2, T), door_action(monkey, T), time(T).

%monkey can't pick up/put down chair and take a door action at the same time
:- pick_up(monkey, R, P, T), door_action(monkey, T), time(T).
:- put_down(monkey, R, P, T), door_action(monkey, T), time(T).

%monkey can't climb & pick up/put down chair or take door action at the same time
:- climb(monkey, R, P, T), pick_up(monkey, R, P, T), pos(R, P), time(T).
:- climb(monkey, R, P, T), put_down(monkey, R, P, T), pos(R, P), time(T).
:- climb(monkey, R, P, T), door_action(monkey, T), time(T).

%monkey can't take two consecutive door actions on the same door (ie close/open or open/close)
% --> this is for solution efficiency <--
:- door_action(monkey, T+1), door_action(monkey, T), door(R1, P1, R2, P2, _, T), time(T).

%Monkey can't walk to same square
:- walk(monkey, R, P1, P2, T), pos(R, P1), pos(R, P2), P1=P2.

%monkey can't make two moves at the same time
:- walk(monkey, R, P1, P2, T), walk(monkey, R, P1, P3, T), 
	pos(R, P1), pos(R, P2), pos(R, P3), P2!=P3.
	
%monkey can't walk/pickup/putdown/open door and change rooms at the same time
:- walk(monkey, R, P1, P2, T), change_rooms(monkey, R1, P3, R2, P4, T).
:- pick_up(monkey, R, P, T), change_rooms(monkey, R1, P1, R2, P2, T).
:- put_down(monkey, R, P, T), change_rooms(monkey, R1, P1, R2, P2, T).
:- open_door(monkey, R1, P1, R2, P2, T), change_rooms(monkey, R1, P1, R2, P2, T), pos(R1, P1), pos(R2, P2), time(T).

%monkey can't climb onto the chair if it is already on the chair
:- climb(monkey, R, P, T), on_chair(monkey, R, P, T).

%monkey can't climb and walk at the same time
:- climb(monkey, R, P, T), walk(monkey, R, P1, P2, T), pos(R, P1), pos(R, P2), time(T).

%monkey can't walk if on chair
:- walk(monkey, R, P1, P2, T), on_chair(monkey, R, P1, T), pos(R, P1), pos(R, P2), time(T).

%monkey can't grab bananas if it already has them.
:- grab(monkey, banana, R, P, T), has_bananas(monkey, R, P, T).

%if goal state reached at previous step, goal remains at next step
goal(T+1) :- goal(T), time(T).

%no soln if goal not reached
goal :- goal(T), time(T).
:- not goal.
