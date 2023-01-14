
-module(aoc6).
-export([solve/1]).


solve_p1(_, 4, Pos) ->
    Pos + 3;

solve_p1([H | T], _, Pos) ->
    {O, _} = lists:split(3, T),
    solve_p1(T, sets:size(sets:from_list([H | O])), Pos + 1).


solve_p2(_, 14, Pos) ->
    Pos + 13;

solve_p2([H | T], _, Pos) ->
    {O, _} = lists:split(13, T),
    solve_p2(T, sets:size(sets:from_list([H | O])), Pos + 1).


solve(Data) ->
    [X | _] = string:split(Data, "\n"),
    {solve_p1(X, 0, 0), solve_p2(X, 0, 0)}.
