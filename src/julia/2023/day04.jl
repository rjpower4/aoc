using AOC

function part1(data)
    n_winning = zeros(Int, length(data))

    for (i, (l, r)) in enumerate(data)
        for j in r
            if j in l
                n_winning[i] += 1
            end
        end
    end

    t = 0
    for k in n_winning
        if k > 0
            t += 2^(k - 1)
        end
    end

    return t
end

function part2(data)
    counts = ones(Int, length(data))
    n_winning = zeros(Int, length(data))

    for (i, (l, r)) in enumerate(data)
        for j in r
            if j in l
                n_winning[i] += 1
            end
        end
    end

    for (i, n) in enumerate(n_winning)
        for k in (i+1):(i+n)
            if k <= length(counts)
                counts[k] += 1 * counts[i]
            end
        end
    end

    return sum(counts)
end

function main()
    path = AOC.data_dir("2023", "day04.txt")

    data = Tuple{Vector{Int},Vector{Int}}[]

    for line in eachline(path)
        sl = split(line)

        left = Int[]
        right = Int[]

        state = :left
        for item in sl[3:end]
            if item == "|"
                state = :right
            elseif state == :left
                push!(left, parse(Int, item))
            else
                push!(right, parse(Int, item))
            end
        end

        push!(data, (left, right))
    end


    p1 = part1(data)

    println("Part 1: $p1")

    return part2(data)
end