using Test

function parse_cmd(s)
    re = r"(\d+),(\d+) through (\d+),(\d+)"
    c = if startswith(s, "turn on")
        :on
    elseif startswith(s, "turn off")
        :off
    else
        :toggle
    end

    m = match(re, s)
    lower::Tuple{Int, Int} = parse.(Int, (m[1], m[2]))
    upper::Tuple{Int, Int} = parse.(Int, (m[3], m[4]))
    return (c, lower, upper)
end

function grid_apply!(g, lower, upper, f)
    for i in lower[1]:upper[1]
        for j in lower[2]:upper[2]
            g[i, j] = f(g[i, j])
        end
    end
end
turn_on(x) = true
turn_on(x::Int) = x + 1
turn_off(x) = false
turn_off(x::Int) = max(x - 1, 0)
toggle(x) = !x
toggle(x::Int) = x + 2

function run!(grid, commands)
    for command in commands
        if command[1] == :on
            grid_apply!(grid, command[2], command[3], turn_on)
        elseif command[1] == :off
            grid_apply!(grid, command[2], command[3], turn_off)
        elseif command[1] == :toggle
            grid_apply!(grid, command[2], command[3], toggle)
        end
    end
end

function part1(commands)
    grid = falses(1_000, 1_000)
    run!(grid, commands)
    return count(grid)
end

function part2(commands)
    grid = zeros(Int, 1_000, 1_000)
    run!(grid, commands)
    return sum(grid)
end

function tests()
end

function main()
    if length(ARGS) > 0
        path = ARGS[1]
        cmds = readlines(path) .|> parse_cmd
        part1(cmds) |> println
        part2(cmds) |> println
    else
        tests()
    end
end

main()
