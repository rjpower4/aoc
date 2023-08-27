using Revise
using AOC: data_dir

function read_data(path)
    data_packets = Union{Int64, Vector}[]
    for line in eachline(path)
        isempty(line) && continue
        push!(data_packets, eval(Meta.parse(line)))
    end
    return data_packets
end

compare(a::Integer, b::Integer) = sign(b - a)
compare(a::Integer, b::Vector) = compare([a], b)
compare(a::Vector, b::Integer) = compare(a, [b])

function compare(a::Vector, b::Vector)
    na = length(a)
    nb = length(b)

    for k in 1:min(na, nb)
        v = compare(a[k], b[k])
        v == 0 && continue
        return v
    end

    return sign(nb - na)
end

function part1(path)
    s = 0
    data = read_data(path)
    for (pnum, i) in enumerate(1:2:length(data))
        s += compare(data[i], data[i + 1]) == 1 ? pnum : 0
    end
    return s
end

function part2(path)
    sorter(a, b) = compare(a, b) == 1
    dps = read_data(path)
    sort!(dps; lt = sorter)

    i1::Int64 = findfirst(x -> !sorter(x, [[2]]), dps)
    i2::Int64 = findfirst(x -> !sorter(x, [[6]]), view(dps, i1:length(dps))) + i1
    return i1 * i2
end

function main()
    path = data_dir("day-13-02.txt")
    println("Part 1: $(part1(path))")
    println("Part 2: $(part2(path))")
    return nothing
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end