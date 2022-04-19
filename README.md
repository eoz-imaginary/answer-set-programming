This repo contains implementations of answer set programming (ASP) problems, namely:

* Meeting scheduling (aka conference room booking)
* Elevator routing
* Monkey-banana pathing

(list is subject to change as I add more)

These problems are implemented in Clingo. To install, follow the instructions at https://potassco.org/clingo/ 

To run, open a command line/terminal window and type `clingo {(filename).lp} {(instance filename).lp}`. The output will either be SATISFIABLE (with a provided answer set) or UNSATISFIABLE (if no solution exists). 