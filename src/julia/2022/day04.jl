using AOC: data_dir

parseline(s) = map(x -> parse(Int64, x.match), eachmatch(r"\d+", s))

function part1(path)
    return sum(eachline(path)) do line
        bounds = parseline(line)
        (bounds[1] - bounds[3])*(bounds[4] - bounds[2]) >= 0 ? 1 : 0
    end
end

function part2(path)
    return sum(eachline(path)) do line
        bounds = parseline(line)
        (bounds[2] < bounds[3] || bounds[4] < bounds[1]) ? 0 : 1
    end
end

function main()
    path = data_dir("day-04-02.txt")
    println("Part 1: $(part1(path))")
    println("Part 2: $(part2(path))")
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end