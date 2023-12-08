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

function main()
    path = AOC.data_dir("2023", "day05.txt")
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
end