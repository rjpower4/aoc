using AOC

function has_symbol(map, loc; only_star=false)
    nr, nc = size(map)
    dirs = ((1, 0), (-1, 0), (0, 1), (0, -1), (1, 1), (-1, 1), (-1, -1), (1, -1))
    for dir in dirs
        new_loc = loc .+ dir

        if (0 < new_loc[1] <= nr) && (0 < new_loc[2] <= nc)
            if !isdigit(map[new_loc...]) && map[new_loc...] != '.' && (!only_star || map[new_loc...] == '*')
                return true, new_loc
            end
        end
    end
    return false, (-1, -1)
end

function part1(lines, mat)


    for (i, line) in enumerate(lines)
        locs = findall(r"\d+", line)
        for r in locs
            okay = false

            for k in r
                if has_symbol(mat, (i, k))[1]
                    okay = true
                    break
                end
            end

            if !okay
                for k in r
                    mat[i, k] = '.'
                end
            end
        end
    end

    p1 = 0

    for row in eachrow(mat)
        r = join(row)
        locs = findall(r"\d+", r)
        for loc in locs
            p1 += parse(Int, r[loc])
        end
    end

    return p1
end

function part2(lines, mat)
    d = Dict{Tuple{Int, Int}, Vector{Int}}()
    for (i, line) in enumerate(lines)
        locs = findall(r"\d+", line)
        for r in locs
            okay = false

            for k in r
                hs, sl = has_symbol(mat, (i, k); only_star=true)
                if hs
                    v = get(d, sl, Int[])
                    push!(v, parse(Int, line[r]))
                    okay = true
                    d[sl] = v
                    break
                end
            end

            if !okay
                for k in r
                    mat[i, k] = '.'
                end
            end
        end
    end

    s = 0
    for (k, v) in d 
        if length(v) == 2
            s += v[1] * v[2]
        end
    end

    s
end

function main()
    path = AOC.data_dir("2023", "day03.txt")
    lines = readlines(path)
    mat = fill('.', length(lines), length(lines[1]))
    for (i, line) in enumerate(lines)
        for (j, char) in enumerate(line)
            mat[i, j] = char
        end
    end


    p1 = part1(lines, copy(mat))
    println("Part 1: $p1")

    # Find gears 
    p2 = part2(lines, copy(mat))
    println("Part 2: $p2")
end