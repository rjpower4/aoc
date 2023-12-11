using AOC

function solve(locs, expansion_factor=1)
    n_galaxies = size(locs, 1)
    n_rows = maximum(locs[:, 1])
    n_cols = maximum(locs[:, 2])

    # Expand 
    to_add = Int[]
    for k in 1:n_rows
        if !(k in locs[:, 1])
            push!(to_add, k)
        end
    end

    added = 0
    for r in to_add
        locs[locs[:, 1].>(r+added), 1] .+= expansion_factor
        added += expansion_factor
    end
    empty!(to_add)


    for k in 1:n_cols
        if !(k in locs[:, 2])
            push!(to_add, k)
        end
    end
    added = 0
    for c in to_add
        # @show c, added, locs
        locs[locs[:, 2].>(c+added), 2] .+= expansion_factor
        added += expansion_factor
    end

    # Distances 
    s = 0
    for i in 1:n_galaxies
        for j in (i+1):n_galaxies
            d = abs.(locs[i, :] .- locs[j, :])
            # @show (i, j, locs[i, :], locs[j, :], d)
            s += sum(d)
        end
    end
    s
end

function main()
    path = AOC.data_dir("2023", "day11.txt")
    lines = readlines(path)

    n_galaxies = sum(x -> count('#', x), lines)
    locs = zeros(Int, n_galaxies, 2)
    c = 0
    for (i, row) in enumerate(lines)
        for (j, char) in enumerate(row)
            if char == '#'
                c += 1
                locs[c, 1] = i
                locs[c, 2] = j
            end
        end
    end

    solve(copy(locs)) |> println
    solve(locs, 1_000_000 - 1) |> println
end