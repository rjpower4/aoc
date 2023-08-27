using AOC: data_dir

pint(s) = parse(Int64, s)
pline(line) = split(line) |> x -> (Symbol(x[1]), length(x) == 1 ? 0 : pint(x[2]))

function solve(path, pstep)
    s = (0, 1) # clock, register
    v = pstep()

    incr_clock(s, vv) = (s[1] + 1, s[2]), vv
    incr_register(s, vv, d) = (s[1], s[2] + d), vv

    function step_clock(s, vv, n)
        for _ in 1:n
            s, vv = incr_clock(s, vv)
            s, vv = pstep(s, vv)
        end
        return s, vv
    end

    for line in eachline(path)
        com, val = pline(line)
        s, v = step_clock(s, v, com == :addx ? 2 : 1)

        if com == :addx
            s, v = incr_register(s, v, val)
        end
    end

    return v
end

pstep1() = 0
pstep1(s, rsum) = s, rsum + (mod(s[1], 40) == 20 ? prod(s) : 0)

pstep2() = fill('.', (40, 6))
function pstep2(s, screen)
    for k in s[2]:(s[2] + 2)
        if mod(k, 40) == mod(s[1], 40)
            screen[s[1]] = '█'
        end
    end
    return s, screen
end

function main()
    path = data_dir("day-10-02.txt")
    println("Part 1: $(solve(path, pstep1))")
    println("Part 2:")
    solve(path, pstep2) |> permutedims |> eachrow .|> x -> foldl(*, x) .|> println
    return nothing
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end