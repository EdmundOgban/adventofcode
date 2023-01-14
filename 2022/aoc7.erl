-module(aoc7).
-export([solve/1]).


solve_p1([H | T]) ->
    case H of
        "$ cd /" ->
            pass;
        "$ cd .." ->
            io:format("CDing back\n");
        "$ cd " ++ Name ->
            io:format("CDing ~s\n", [Name]);
        "dir " ++ Name ->
            io:format("Directory ~s\n", [Name]);
        X ->
            [A, B] = string:split(X, " "),
            try
                IA = list_to_integer(A),
                io:format("File ~s size ~B\n", [B, IA])
            catch
                error:badarg -> pass
            end
    end,
    solve_p1(T),
    0.


solve_p2(_) ->
    0.


solve(Data) ->
    X = string:split(Data, "\n", all),
    {solve_p1(X), solve_p2(X)}.
