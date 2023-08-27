using AOC: data_dir

function arrangement!(io)
    line = readline(io)
    len = length(line)
    n_stacks = Int64((len - 3) / 4 + 1)
    out = [Char[] for _ in 1:n_stacks]

    while !startswith(line, " 1")
        for (i, ind) in enumerate(2:4:len)
            if isletter(line[ind])
                push!(out[i], line[ind])
            end
        end
        line = readline(io)
    end
    reverse!.(out)
    return out
end

function commands!(io)
    parse_int(s) = parse(Int64, s)
    commands = NTuple{3, Int64}[]
    while !eof(io)
        line = readline(io)
        v = match(r"move (\d+) from (\d+) to (\d+)", line).captures .|> parse_int
        push!(commands, (v[1], v[2], v[3]))
    end
    commands
end

function solve(path, mover)
    return open(path, "r") do io
        arr = arrangement!(io)
        readline(io) # Empty line between arrangment and commands
        cmds = commands!(io)
        foreach(c -> mover(arr, c), cmds)
        String(last.(arr))
    end
end

function cm_9000!(arr, c)
    for _ in 1:c[1]
        push!(arr[c[3]], pop!(arr[c[2]]))
    end
    return nothing
end

function cm_9001!(arr, c)
    buf = Vector{Char}(undef, c[1])
    for idx in reverse(eachindex(buf))
        buf[idx] = pop!(arr[c[2]])
    end
    append!(arr[c[3]], buf)
    return nothing
end

function main()
    path = data_dir("day-05-02.txt")

    println("Part 1: $(solve(path, cm_9000!))")
    println("Part 2: $(solve(path, cm_9001!))")
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end