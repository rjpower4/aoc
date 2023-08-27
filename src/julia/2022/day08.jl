using AOC: data_dir

parse_int(x) = parse(Int64, x)
parse_map(path) = mapreduce(collect, hcat, readlines(path)) .|> parse_int |> transpose

function visible!(flags, arr::AbstractVector)
    m1 = m2 = -1
    n = length(arr)
    for ind in eachindex(arr)
        if arr[ind] > m1
            m1 = arr[ind]
            flags[ind] = true
        end
        if arr[n - ind + 1] > m2
            m2 = arr[n - ind + 1]
            flags[n - ind + 1] = true
        end
    end
end

function viewlength!(scores, arr::AbstractVector)
    scores[1] = scores[end] = 0
    for j in 2:(length(arr) - 1)
        count1 = count2 = 1

        for k in (j-1):-1:2
            arr[k] >= arr[j] && break
            count1 += 1
        end

        for k in (j+1):(length(arr)-1)
            arr[k] >= arr[j] && break
            count2 += 1
        end
        scores[j] *= (count1 * count2)
    end
end

function rowcolapply(f, a, b)
    nr, nc = size(b)
    foreach(i -> f(view(a, i, :), view(b, i, :)), 1:nr)
    foreach(i -> f(view(a, :, i), view(b, :, i)), 1:nc)
    a
end

visible(arr::AbstractMatrix) = rowcolapply(visible!, falses(size(arr)), arr)
viewlength(arr::AbstractMatrix) = rowcolapply(viewlength!, ones(Int64, size(arr)), arr)

part1(path) = parse_map(path) |> visible |> count
part2(path) = parse_map(path) |> viewlength |> maximum

function main()
    path = data_dir("day-08-02.txt")
    println("Part 1: $(part1(path))") # 1560
    println("Part 2: $(part2(path))") # 252000
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end