-module(aoc2).
-export([solve/1]).


solve_p1([Line | T]) ->
    case Line of
        "A X" -> 3 + 1;
        "A Y" -> 6 + 2;
        "A Z" -> 0 + 3;

        "B X" -> 0 + 1;
        "B Y" -> 3 + 2;
        "B Z" -> 6 + 3;

        "C X" -> 6 + 1;
        "C Y" -> 0 + 2;
        "C Z" -> 3 + 3
    end + case T of
        [[]] -> 0;
        _ -> solve_p1(T)
    end.

solve_p2([Line | T]) ->
    case Line of
        "A X" -> 0 + 3;
        "A Y" -> 3 + 1;
        "A Z" -> 6 + 2;

        "B X" -> 0 + 1;
        "B Y" -> 3 + 2;
        "B Z" -> 6 + 3;

        "C X" -> 0 + 2;
        "C Y" -> 3 + 3;
        "C Z" -> 6 + 1
    end + case T of
        [[]] -> 0;
        _ -> solve_p2(T)
    end.

solve(Data) ->
    Inp = string:split(Data, "\n", all),
    {solve_p1(Inp), solve_p2(Inp)}.
