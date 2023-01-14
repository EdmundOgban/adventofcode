-module(aoc4).
-export([solve/1]).


split_pairs(X) ->
    [lists:map(fun list_to_integer/1, string:split(Pair, "-")) || Pair <- string:split(X, ",")].

solve_p1([]) ->
    0;
solve_p1([H | T]) ->
    [[A1, A2], [B1, B2]] = split_pairs(H),
    if 
        A1 >= B1, A2 =< B2 ; B1 >= A1, B2 =< A2 -> 1;
        true -> 0
    end + solve_p1(T).

solve_p2([]) ->
    0;
solve_p2([H | T]) ->
    [[A1, A2], [B1, B2]] = split_pairs(H),
    if 
        A1 =< B2, A2 >= B1 ; B1 =< A2, B2 >= A1 -> 1;
        true -> 0
    end + solve_p2(T).

solve(Data) ->
    Inp = string:split(Data, "\n", all),
    {solve_p1(Inp), solve_p2(Inp)}.
