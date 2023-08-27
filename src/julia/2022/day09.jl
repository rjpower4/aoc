using AOC: data_dir

const LOCATION = Tuple{Int64, Int64}
const STEP_DIRECTIONS = Dict(:R => (1, 0), :L => (-1, 0), :U => (0, 1), :D => (0, -1))

parse_line(line) = split(line) |> x -> (Symbol(x[1]), parse(Int64, x[2]))
parse_input(path) = eachline(path) .|> parse_line
move(loc, c::Symbol) = loc .+ STEP_DIRECTIONS[c]

function move(loc, ploc::LOCATION)
    delta = ploc .- loc
    (abs(delta[1]) <= 1 && abs(delta[2]) <= 1) ? loc : loc .+ sign.(delta)
end

function solve(input, n)
    visited = Set{LOCATION}()

    locs = [(0, 0) for _ in 1:n]
    push!(visited, (0, 0))

    for command in input
        d, c = command
        for _ in 1:c
            locs[1] = move(locs[1], d)
            foreach(k -> (locs[k] = move(locs[k], locs[k - 1])), 2:length(locs))
            push!(visited, locs[end])
        end
    end

    return length(visited)
end

part1(path) = solve(parse_input(path), 2)
part2(path) = solve(parse_input(path), 10)

function main()
    path = data_dir("day-09-02.txt")
    println("Part 1: $(part1(path))")
    println("Part 2: $(part2(path))")
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end