using AOC

function hash(s)
    h = 0
    for c in s
        v = Int(c)
        h += v
        h *= 17
        h = mod(h, 256)
    end
    return h
end

function parse_command(command)
    mm = match(r"([a-z]+)(-|=)(\d*)", command)
    op = mm[2] == "-" ? :dash : :equal
    val = op == :dash ? 0 : parse(Int, mm[3])
    return (hash(mm[1]) + 1, mm[1], op, val)
end

function part2(s)
    commands = split(s, ",") .|> parse_command
    boxes = [Vector{Tuple{String,Int}}() for _ in 1:256]


    for (bn, label, op, val) in commands
        loc = findfirst(x -> x[1] == label, boxes[bn])

        if op == :dash
            isnothing(loc) || deleteat!(boxes[bn], loc)
        else
            if !isnothing(loc)
                boxes[bn][loc] = (label, val)
            else
                push!(boxes[bn], (label, val))
            end
        end
    end

    s = 0
    for i in 1:256
        for (j, b) in enumerate(boxes[i])
            s += (1 + i - 1) * j * b[2]
        end
    end

    s
end

function main(test=false)
    path = AOC.data_dir("2023", test ? "day15-test.txt" : "day15.txt")
    println("Part1: $(mapfoldl(hash, +, split(read(path, String), ",")))")
    part2(read(path, String))
end