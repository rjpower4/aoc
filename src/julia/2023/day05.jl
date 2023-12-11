using AOC

function solve(seeds, d)
    map_sequence = [
        "seed-to-soil",
        "soil-to-fertilizer",
        "fertilizer-to-water",
        "water-to-light",
        "light-to-temperature",
        "temperature-to-humidity",
        "humidity-to-location",
    ]

    # Seed to soil
    current = seeds
    for mname in map_sequence
        m = d[mname]
        for i in 1:length(current)
            c = current[i]

            found = false
            for mp in m
                dst = c - mp[2]
                if dst >= 0 && dst <= mp[3]
                    current[i] = mp[1] + dst
                    found = true
                end
            end
        end
    end

    return minimum(current)
end

function solve2(seeds, d)
    map_sequence = [
        "seed-to-soil",
        "soil-to-fertilizer",
        "fertilizer-to-water",
        "water-to-light",
        "light-to-temperature",
        "temperature-to-humidity",
        "humidity-to-location",
    ]

    current = [(first(s), last(s)) for s in seeds]

    for mname in map_sequence
        xfm_segs = similar(current, 0)
        for rule in d[mname]
            dst_start, src_start, len = rule
            n_segs = length(current)
            new_segs = similar(current, 0)

            for i in 1:n_segs
                (f, l) = pop!(current)

                if f > (src_start + len) || l < src_start
                    push!(new_segs, (f, l))
                else
                    os = max(f, src_start)
                    oe = min(l, src_start + len)
                    push!(xfm_segs, (os, oe) .- src_start .+ dst_start)

                    if f < src_start
                        push!(new_segs, (f, src_start - 1))
                    end

                    if l > src_start + len
                        push!(new_segs, (oe + 1, l))
                    end
                end
            end

            for seg in new_segs
                push!(current, seg)
            end
        end

        for seg in xfm_segs
            push!(current, seg)
        end
    end
    
    minimum([x[1] for x in current])
end

function main(test=false)
    path = AOC.data_dir("2023", test ? "day05-test.txt" : "day05.txt")
    lines = readlines(path)

    d = Dict{String,Vector{NTuple{3,Int64}}}()
    seeds = parse.(Int, split(lines[1])[2:end])
    current_key = ""
    for line in lines[2:end]
        !isempty(line) || continue

        if endswith(line, ':')
            current_key = split(line)[1]
            d[current_key] = Vector{NTuple{3,Int64}}[]
        else
            ll = parse.(Int, split(line))
            push!(d[current_key], (ll[1], ll[2], ll[3]))
        end
    end


    println("Part 1: $(solve(seeds, d))")


    ss = parse.(Int, split(lines[1])[2:end])
    s_ranges = UnitRange{Int}[]
    for k in 1:2:length(ss)
        push!(s_ranges, ss[k]:(ss[k]+ss[k+1]))
    end
    println("Part 2: $(solve2(s_ranges, d))")
end