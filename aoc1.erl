-module(aoc1).
-export([solve/1]).


solve_p1(Sums) ->
    lists:max(Sums).

solve_p2(Sums) ->
    [M1, M2, M3 | _] = lists:sort(fun(A, B) -> A > B end, Sums),
    M1 + M2 + M3.

solve(Data) ->
    Invs = [lists:map(fun list_to_integer/1, string:split(X, "\n", all)) || X <- string:split(Data, "\n\n", all)],
    Sums = lists:map(fun lists:sum/1, Invs),
    {solve_p1(Sums), solve_p2(Sums)}.
