%Problem: meeting scheduling (aka conference room booking)

#show schedule/3.
#show precede/2.

#const firstDayAM=1.
#const firstDayPM=2.
#const secondDayAM=3.
#const secondDayPM=4.

room(r1;r2;r3).
session(a;b;c;d;e;f;g;h;i;j;k).
time(firstDayAM;firstDayPM;secondDayAM;secondDayPM).

%choose an answer set such that there is room for all sessions
session_time_room(S, T, R) :- session(S), time(T), room(R).
11{schedule(S, T, R): session_time_room(S, T, R)}11.


%a session can't be booked at different times.
:- schedule(S, T1, R), schedule(S, T2, R), T1 != T2.

%a session can't be booked in different rooms
:- schedule(S, T, R1), schedule(S, T, R2), R1 != R2.

%the same session cannot be booked at a different time AND in a different room
:- schedule(S, T1, R1), schedule(S, T2, R2), T1 != T2, R1 != R2.

%different sessions cannot be booked in the same room at the same time
:- schedule(S1, T, R), schedule(S2, T, R), S1 != S2.

%if precede(S1, S2) is specified, S1 must always precede S2's meeting slot.
:- precede(S1, S2), schedule(S1, T1, R1), schedule(S2, T2, R2), T2 <= T1.

%no contradictory precede statements allowed.
:- precede(S1, S2), precede(S3, S4), S1 = S4, S2 = S3. 

%established what it means for two distinct meetings to be scheduled at the same time
same_time(S1, S2) :- schedule(S1, T1, R1), schedule(S2, T2, R2), T1 = T2, S1 != S2.

