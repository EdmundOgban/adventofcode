-module(aocrunner).
-export([main/1]).

-include("./sessionid.hrl").

-define(AOC_TEMPLATE,
"-module(~s).
-export([solve/1]).


solve_p1(_) ->
    0.


solve_p2(_) ->
    0.


solve(Data) ->
    {solve_p1(Data), solve_p2(Data)}.
").


build_filename(Modname, input) ->
    "inputs/" ++ Modname ++ "_input.txt";

build_filename(Modname, source) ->
    Modname ++ ".erl";

build_filename(Modname, beam) ->
    Modname ++ ".beam".


ensure_exists(Modname) ->
    Fname = build_filename(Modname, source),
    case filelib:is_regular(Fname) of
        true -> exists;
        false ->
            io:format("Creating ~s from template ...\n", [Fname]),
            {ok, F} = file:open(Fname, write),
            try io:fwrite(F, ?AOC_TEMPLATE, [Modname])
            after file:close(F)
            end,
            created
    end.


request(get, URL) ->
    Cookies = {"Cookie", "session=" ?SESSION_ID},
    inets:start(),
    ssl:start(),
    httpc:request(get, {URL, [Cookies]}, [{ssl, [httpc:ssl_verify_host_options(true)]}], []).


download_input(Modname, Day) ->
    filelib:ensure_dir("./inputs/"),
    URLDay = "https://adventofcode.com/2022/day/" ++ Day,
    io:format("Downloading input file for ~s ...\n", [Modname]),
    {ok, {{_, 200, _}, _, Content}} = request(get, URLDay ++ "/input"),
    file:write_file(build_filename(Modname, input), Content),
    URLDay.


repeatf(N, Module, Fun, Data) ->
    case N of
        0 -> nothing;
        _ -> repeatf(N - 1, Module, Fun, Data), Module:Fun(Data)
    end.


run_module(Reps, Modname, Module) ->
    Fname = build_filename(Modname, input),
    case file:read_file(Fname) of
        {ok, Data} ->
            io:format(" === Solutions for ~s ===\n", [Modname]),
            {T, {Solp1, Solp2}} = timer:tc(fun repeatf/4, [Reps, Module, solve, binary_to_list(Data)]),
            Spec1 = case is_integer(Solp1) of true -> "~B"; false -> "~s" end,
            Spec2 = case is_integer(Solp2) of true -> "~B"; false -> "~s" end,
            io:format("Part one: " ++ Spec1 ++ "\n", [Solp1]),
            io:format("Part two: " ++ Spec2 ++ "\n", [Solp2]),
            io:format(" === Execution time: ~f seconds ===", [T / Reps / 1_000_000]);
        {error, enoent} ->
            io:format("Input data file (namely `~s`) not found.\n", [Fname])
    end.


load_and_run(Modname, Reps) ->
    case code:load_file(list_to_atom(Modname)) of
        {module, Module} ->
            try run_module(Reps, Modname, Module)
            after file:delete(build_filename(Modname, beam))
            end;
        {error, nofile} ->
            io:format("Compiling .beam file for ~s ...\n", [Modname]),
            case compile:file(Modname) of
                {ok, _} -> load_and_run(Modname, Reps);
                error -> io:format("Compilation failed, cannot proceed.\n")
            end
    end.


main([Modname]) ->
    main([Modname, 1]);

main([Modname, Reps | _]) when is_list(Reps) ->
    main([Modname, list_to_integer(Reps)]);

main([Modname, Reps | _]) ->
    Day = case re:run(Modname, "^aoc(\\d{1,2})$", [{capture, all_but_first, list}]) of
        {match, [M]} ->
            list_to_integer(M);
        nomatch ->
            exit("Invalid aoc name.")
    end,
    if
        Day < 1 ; Day > 25 -> exit("Day is not between 1 and 25.");
        true -> case ensure_exists(Modname) of
            exists ->
                load_and_run(Modname, Reps);
            created ->
                URL = download_input(Modname, integer_to_list(Day)),
                io:format("Done! Consult ~s for details about this puzzle.\n", [URL])
        end
    end.
