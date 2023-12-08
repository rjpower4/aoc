using AOC

function num_ways(t, d)
    count = 0
    for j in 1:t 
        distance = j * (t - j)
        if distance > d 
            count += 1
        end
    end
    return count
end

function main()
    path = AOC.data_dir("2023", "day06.txt")
    text = split(String(read(path)), "\n") .|> strip
    times = split(text[1])[2:end] .|> x -> parse(Int, x)
    dists = split(text[2])[2:end] .|> x -> parse(Int, x)

    counts = [
        num_ways(t, d) for (t, d) in zip(times, dists)
    ]

    println("Part 1: $(prod(counts))")

    t = parse(Int, join(split(text[1])[2:end]))
    d = parse(Int, join(split(text[2])[2:end]))

    println("Part 2: $(num_ways(t, d))")
    
    return nothing
end