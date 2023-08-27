using AOC: data_dir

pint(s) = parse(Int64, s)

function parse_line(line)
    turning_points = split.(split(line, " -> "), ",") .|> x -> (pint(x[1]), pint(x[2]))
    newpoints = [turning_points[1]]
    cur = 1
    while cur < length(turning_points)
        if newpoints[end] == turning_points[cur + 1]
            cur += 1
        else
            np = newpoints[end] .+ sign.(turning_points[cur + 1] .- newpoints[end])
            push!(newpoints, np)
        end
    end
    return newpoints
end

function read_input(path)
    rocks = Set{CartesianIndex}()
    for line in eachline(path)
        foreach(x -> push!(rocks, CartesianIndex(x)), parse_line(line))
    end
    rocks, extrema(x -> x[1], rocks), (0, maximum(x -> x[2], rocks))
end

floor_height(yb) = yb[2] + 2
exist_check_p1(env, p, xb, yb) = p in env
exist_check_p2(env, p, xb, yb) = p in env || p[2] == floor_height(yb)

bounds_check_p1(env, p, xb, yb) = (xb[1] <= p[1] <= xb[2]) && (0 < p[2] <= yb[2])
bounds_check_p2(env, p, xb, yb) = p[2] > 0

function drop_sand!(env, xb, yb, ec, bc, drop_point = CartesianIndex(500, 0))
    candidates(p) = map(x -> p + x, CartesianIndex.(((0, 1), (-1, 1), (1, 1))))

    function step_sand(p)
        cs = candidates(p)
        a = findfirst(c -> !ec(env, c, xb, yb), cs)
        return isnothing(a) ? (p, false) : (cs[a], true)
    end

    np = drop_point
    while true
        np, ds = step_sand(np)
        bc(env, np, xb, yb) || return false
        ds || break
    end

    push!(env, np)
    return true
end

function count_drops!(env, xb, yb, ec, bc)
    count = 0
    while drop_sand!(env, xb, yb, ec, bc)
        count += 1
    end
    return count
end

function main()
    env, xb, yb = read_input(data_dir("day-14-02.txt"))
    p1 = count_drops!(env, xb, yb, exist_check_p1, bounds_check_p1)
    p2 = p1 + 1 + count_drops!(env, xb, yb, exist_check_p2, bounds_check_p2)
    println("Part 1: $(p1)")
    println("Part 2: $(p2)")
    return nothing
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end