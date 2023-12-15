using AOC

function n_possible!(cache, springs, groups, state)
    recur(s) = n_possible!(cache, springs, groups, s)

    if state in keys(cache)
        return cache[state]
    end

    if state[1] > length(springs)
        if state[2] > length(groups) && state[3] == 0
            return 1
        elseif state[2] == length(groups) && groups[state[2]] == state[3]
            return 1
        else
            return 0
        end
    end

    ways = 0
    for x in "#."
        springs[state[1]] in (x, '?') || continue
        if x == '#'
            ways += recur(state .+ (1, 0, 1))
        elseif iszero(state[3])
            ways += recur(state .+ (1, 0, 0))
        elseif get(groups, state[2], -1) == state[3]
            ways += recur(state .+ (1, 1, -state[3]))
        end
    end

    cache[state] = ways
    return ways
end

function n_possible(springs, groups)
    state = (1, 1, 0)
    cache = Dict{typeof(state),Int}()
    return n_possible!(cache, springs, groups, state)
end

function read_record(path)
    records = Tuple{String,Vector{Int}}[]
    for line in eachline(path)
        s = split(line)
        v = split(s[2], ",") .|> x -> parse(Int, x)
        push!(records, (s[1], v))
    end
    records
end

function unfold(r)
    a, b = r
    w = join(fill(a, 5), "?")
    c = repeat(b, 5)
    return (w, c)
end

function main(test=false)
    path = AOC.data_dir("2023", test ? "day12-test.txt" : "day12.txt")
    recs = read_record(path)

    p1 = sum(x -> n_possible(x...), recs)
    println("Part 1: $p1")

    recs_2 = map(unfold, recs)
    p2 = sum(x -> n_possible(x...), recs_2)
    println("Part 2: $p2")
end