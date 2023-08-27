using AOC: data_dir

function parse_input(path)
    cpath = String[]
    d = Dict{String, Int64}()
    add_value!(k, v) = (d[k] = get(d, k, 0) + v)
    for line in eachline(path)
        if startswith(line, "\$ cd")
            p = SubString(line, 6, length(line))
            p == ".." ? pop!(cpath) : push!(cpath, p)
        elseif !startswith(line, "\$ ls")&& !startswith(line, "dir")
            v = split(line, " ") |> t -> parse(Int64, t[1])
            foreach(x -> add_value!(x, v), accumulate(joinpath, cpath))
        end
    end
    return d
end

part1(path) = sum(x -> x <= 100000 ? x : 0, values(parse_input(path)))

function part2(path)
    d = parse_input(path)
    req = 30000000 - (70000000 - d["/"])
    return mapreduce(x -> x >= req ? x : typemax(x), min, values(d))
end

function main()
    path = data_dir("day-07-02.txt")
    println("Part 1: $(part1(path))")
    println("Part 2: $(part2(path))")
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end