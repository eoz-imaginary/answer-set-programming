%Problem instance for: meeting scheduling

%INSTANCE 1: (very simple case)
%RESULTS: Correct.
%precede(a, b).
%schedule(a, firstDayAM, r1).

%INSTANCE 1.5 (TESTING PRECEDE() EDGE CASE):
%RESULTS: Correct --> Unsatisfiable (as expected).
%precede(a, b).
%precede(b, a). 

%INSTANCE 2: (slightly more complicated)
%RESULTS: Correct.
%precede(a, b).
%precede(i, f).
%schedule(j, firstDayPM, r1).

%INSTANCE 3: (more complicated)
%RESULTS: Correct.
precede(e, j).
precede(f, k).
precede(d, k).
schedule(a, firstDayAM, r2).
schedule(g, firstDayPM, r1).

%INSTANCE 3.5: (testing same-time-meeting constraints)
%RESULTS: Correct --> Unsatisfiable (as expected).
%schedule(a, firstDayAM, r2).
%schedule(j, firstDayAM, r1).