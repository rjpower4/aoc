using AOC


function main()
    pint(x) = isnothing(x) ? 0 : parse(Int, x[1])

    path = AOC.data_dir("2023", "day02.txt")

    lines = readlines(path)

    games = Vector{Vector{NTuple{3,Int}}}()
    for line in lines
        subs = split(line, ";")
        push!(games, NTuple{3, Int}[])
        for s in subs
            reds   = match(r"(\d+) red", s)
            greens = match(r"(\d+) green", s)
            blues  = match(r"(\d+) blue", s)
            push!(games[end], (pint(reds), pint(greens), pint(blues)))
        end
    end

    maxes = (12, 13, 14)
    s = 0
    p = 0
    for (i, game) in enumerate(games)
        m_r = maximum(x -> x[1], game)
        m_g = maximum(x -> x[2], game)
        m_b = maximum(x -> x[3], game)
        if all((m_r, m_g, m_b) .< maxes)
            s += i 
        end

        p += m_r * m_g * m_b
    end

    println("Part 1: $(s)")
    println("Part 1: $(p)")
end