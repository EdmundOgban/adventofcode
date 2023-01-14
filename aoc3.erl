-module(aoc3).
-export([solve/1]).


priority(X) when 97 =< X, X =< 122 ->
    X - 96;
priority(X) when 65 =< X, X =< 90 ->
    X - 38.

solve_p1(X) when X =:= []; X =:= [[]] ->
    0;
solve_p1([Sack | T]) ->
    {L, R} = lists:split(length(Sack) div 2, Sack),
    Set = sets:intersection(
        sets:from_list(L),
        sets:from_list(R)
    ),
    sets:fold(fun (E, _) -> priority(E) end, 0, Set) + solve_p1(T).

solve_p2(X) when X =:= []; X =:= [[]] ->
    0;
solve_p2([A, B, C | T]) ->
    Set = sets:intersection([
        sets:from_list(A),
        sets:from_list(B),
        sets:from_list(C)
    ]),
    sets:fold(fun (E, _) -> priority(E) end, 0, Set) + solve_p2(T).

solve(Data) ->
    Inp =string:split(Data, "\n", all),
    {solve_p1(Inp), solve_p2(Inp)}.
