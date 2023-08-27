using AOC: data_dir

priority(c::Char) =  Int64(c) + (islowercase(c) ? 1  - Int64('a') : 27 - Int64('A'))

score_intersection(sets...) = sum(priority, intersect(sets...))

function halve(s)
    h = (length(s) / 2) |> Int64
    return (view(s, 1:h), view(s, (h+1):2h))
end

function part1(path)
    f(line) = score_intersection(halve(line)...)
    return sum(f, eachline(path))
end

function part2(path)
    return open(path, "r") do io
        score = 0
        while !eof(io)
            score += score_intersection(readline(io), readline(io), readline(io))
        end
        score
    end
end

function main()
    path = data_dir("day-03-02.txt")
    println("Part 1: $(part1(path))")
    println("Part 2: $(part2(path))")
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end