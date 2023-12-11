using AOC

const DIRECTIONS = Dict(
    :right => (0, 1),
    :down => (1, 0),
    :left => (0, -1),
    :up => (-1, 0),
)

const DESTINATIONS = Dict(
    :right => "-7J",
    :down => "|LJ",
    :left => "-FL",
    :up => "|F7",
)

const TRANSFORM = Dict(
    (:right, '-') => :right,
    (:right, '7') => :down,
    (:right, 'J') => :up,
    (:left, '-') => :left,
    (:left, 'F') => :down,
    (:left, 'L') => :up,
    (:down, '|') => :down,
    (:down, 'L') => :right,
    (:down, 'J') => :left,
    (:up, '|') => :up,
    (:up, 'F') => :right,
    (:up, '7') => :left,
)

valid_index(i, j, m) = i > 0 && i <= size(m, 1) && j > 0 && j <= size(m, 2)

function read_map(path)
    lines = readlines(path)
    m = fill('.', length(lines), length(lines[1]))

    for (i, l) in enumerate(lines)
        for (j, c) in enumerate(l)
            m[i, j] = c
        end
    end

    return m
end

function main()
    map = read_map(AOC.data_dir("2023", "day10.txt"))
    path = falses(size(map))

    s_cind = findfirst(x -> x == 'S', map)
    s = s_cind[1], s_cind[2]

    c_d = :none
    c = (0, 0)
    v_dirs = Symbol[]
    for (k, v) in DIRECTIONS
        i, j = s .+ v

        if valid_index(i, j, map) && map[i, j] in DESTINATIONS[k]
            c_d = k
            c = (i, j)
            push!(v_dirs, c_d)
        end
    end

    count = 1
    while c != s
        path[c...] = true
        count += 1
        c_d = TRANSFORM[(c_d, map[c...])]
        c = c .+ DIRECTIONS[c_d]
    end
    p1 = div(count, 2)

    # Count vertical lines crossing
    p2 = 0
    verts = length(intersect([:up, :down], v_dirs)) > 0 ? "|JLS" : "|JL"
    for i in axes(path, 1)
        inside = false
        for j in axes(path, 2)
            if path[i, j] && map[i, j] in verts
                inside = !inside
            else
                p2 += inside ? 1 : 0
            end
        end
    end

    println("Part 1: $(p1)")
    println("Part 2: $(p2)")
end