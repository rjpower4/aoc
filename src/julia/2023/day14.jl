using AOC

function testme!(v)
    c1 = 1
    c2 = 1
    while c1 <= length(v) && c2 <= length(v)
        @show c1, c2
        if v[c2] == 'O'
            v[c2] = '.'
            v[c1] = 'O'
            c1 += 1
            c2 += 1
        elseif v[c2] == '.'
            c2 += 1
        elseif v[c2] == '#'
            c1 = c2 + 1
            c2 += 1
        end
    end
end

function tilt!(grid, dir)

    while true
        for i in axis(grid, 1)
            0 < i + dir[0] <= length(grid) || continue
        end
    end
end

function tilt_up!(grid)
    nr, nc = size(grid)
    for c in 1:nc
        start = 1
        count = 0
        for i in 1:nr
            if grid[i, c] == '#'
                for j in start:(start+count-1)
                    grid[j, c] = 'O'
                end
                start = i + 1
                count = 0
            elseif grid[i, c] == 'O'
                count += 1
                grid[i, c] = '.'
            end
        end

        for j in start:(start+count-1)
            grid[j, c] = 'O'
        end
    end

    grid
end

function compute_load(grid)
    s = 0
    for i in axes(grid, 1)
        for j in axes(grid, 2)
            if grid[i, j] == 'O'
                s += size(grid, 1) - i + 1
            end
        end
    end
    s
end

function read_grid(path)
    lines = readlines(path)
    n_rows = length(lines)
    n_cols = length(first(lines))
    g = fill('.', n_rows, n_cols)

    for (i, line) in enumerate(lines)
        for (j, char) in enumerate(line)
            g[i, j] = char
        end
    end

    return g
end

function part2(path)
    n = 1_000_000_000
    g = read_grid(path)
    # cache = Dict{String,Int}()

    # for i in 0:n 
    #     for _ in 1:4
    #         tilt_up!(g)
    #         g = rotr90(g)
    #     end
    #     h = join(g)
    #     if !(h in keys(cache))
    #         cache[h] = i
    #     else
    #         d = i - cache[h]
    #         g = 
    # end 


    gg = copy(g)
    found = Dict{Matrix{Char},Int}()

    found[copy(g)] = 0

    i = 1
    dif = 0
    while true
        tilt_up!(g)
        g = rotr90(g)
        tilt_up!(g)
        g = rotr90(g)
        tilt_up!(g)
        g = rotr90(g)
        tilt_up!(g)
        g = rotr90(g)

        if g in keys(found)
            dif = i - found[g]
            break
        else
            found[copy(g)] = i
            i += 1
        end
    end

    @show d, r = divrem(n - i, dif)
    for _ in 1:r
        tilt_up!(g)
        g = rotr90(g)
        tilt_up!(g)
        g = rotr90(g)
        tilt_up!(g)
        g = rotr90(g)
        tilt_up!(g)
        g = rotr90(g)
    end
    return compute_load(g)


    # for (k, v) in found
    #     @show v, compute_load(k)
    # end

    for (k, v) in found
        if v == rem(r, i)
            return compute_load(k)
        end
    end
end

function main(test=false)
    path = AOC.data_dir("2023", test ? "day14-test.txt" : "day14.txt")
    g = read_grid(path)
    tilt_up!(g)
    compute_load(g)

    println("Part 2: $(part2(path))")

    read_grid(path)
end