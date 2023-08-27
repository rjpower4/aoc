using AOC: data_dir

vecs_to_mat(vecs) = mapreduce(permutedims, vcat, vecs)
start_and_end(altmap) = (n -> findfirst(x -> x == n - 'a', altmap)).(('S', 'E'))
adjacent_inds(ind) = (ind + k for k in CartesianIndex.(((-1, 0), (1, 0), (0, 1), (0, -1))))

function read_data(path)
    data_raw = (readlines(path) .|> collect .|> x -> x .- 'a') |> vecs_to_mat
    b::CartesianIndex, e::CartesianIndex = start_and_end(data_raw)
    data_raw[b] = 0
    data_raw[e] = 26
    return data_raw, b, e
end

function bfs(data, start, move_check, end_check)
    n, m = size(data)
    visited = falses(n, m)
    distances = fill(typemax(Int64), n, m)
    distances[start] = zero(eltype(distances))
    queue = [start] # would be faster with an actual queue, but only using stdlib...
    visited[start] = true
    cinds = CartesianIndices(data)
    val = zero(eltype(distances))
    while !isempty(queue)
        c = popfirst!(queue)
        val = distances[c]
        end_check(data, c) && break

        for nind in adjacent_inds(c)
            if nind in cinds && !visited[nind] && move_check(data, c, nind)
                push!(queue, nind)
                @inbounds distances[nind] = distances[c] + one(eltype(distances))
                @inbounds visited[nind] = true
            end
        end
    end
    return val::Int64
end

function part1(path)
    data, start_ind, end_ind = read_data(path)
    move_check(data, c, nind) = data[nind] - data[c] <= one(eltype(data))
    end_check(_, c) = c == end_ind
    return bfs(data, start_ind, move_check, end_check)
end

function part2(path)
    data, _, end_ind = read_data(path)
    move_check(data, c, nind) = data[c] - data[nind] <= one(eltype(data))
    end_check(data, c) = data[c] == zero(eltype(data))
    return bfs(data, end_ind, move_check, end_check)
end

function main()
    path = data_dir("day-12-02.txt")
    println("Part 1: $(part1(path))")
    println("Part 2: $(part2(path))")
    return nothing
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end