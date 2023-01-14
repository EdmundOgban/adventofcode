-module(aoc5).
-export([solve/1]).


move_one(StFrom, StTo, 0) ->
    {StFrom, StTo};

move_one(StFrom, StTo, Times) ->
    move_one(lists:droplast(StFrom), StTo ++ [lists:last(StFrom)], Times - 1).


solve_p1(Sts, []) ->
    [lists:last(St) || St <- array:to_list(Sts)];

solve_p1(Sts, [[Times, From, To] | T]) ->
    {NewStF, NewStT} = move_one(array:get(From - 1, Sts), array:get(To - 1, Sts), Times),
    solve_p1(array:set(From - 1, NewStF, array:set(To - 1, NewStT, Sts)), T).


solve_p2(Sts, []) ->
    [lists:last(St) || St <- array:to_list(Sts)];

solve_p2(Sts, [[Qty, From, To] | T]) ->
    StFrom = array:get(From - 1, Sts),
    StTo = array:get(To - 1, Sts),
    {NewStF, Moved} = lists:split(length(StFrom) - Qty, StFrom),
    solve_p2(array:set(To - 1, StTo ++ Moved, array:set(From - 1, NewStF, Sts)), T).


parse_stacks(S) ->
    Sts = [[lists:nth(N, St) || N <- lists:seq(2, length(St), 4)] || St <- lists:reverse(lists:droplast(S))],
    array:from_list([[lists:nth(N, St) || St <- Sts, lists:nth(N, St) /= 32] || N <- lists:seq(1, 9)]).


parse_movements([]) ->
    [];

parse_movements([H | T]) ->
    case re:run(H, "\\d+", [global, {capture, all, list}]) of
        {match, M} ->
            [lists:flatten([lists:map(fun list_to_integer/1, X) || X <- M]) | parse_movements(T)];
        nomatch ->
            []
    end.


solve(Data) ->
    [S, M] = string:split(Data, "\n\n"),
    Sts = parse_stacks(string:split(S, "\n", all)),
    Movs = parse_movements(string:split(M, "\n", all)),
    {solve_p1(Sts, Movs), solve_p2(Sts, Movs)}.
