using AOC

function extrapolate_value(values)
    ds = [values, diff(values)]
    while !all(x -> x == 0, ds[end])
        push!(ds, diff(ds[end]))
    end

    for k in (length(ds) - 1):-1:1
        push!(ds[k], ds[k][end] + ds[k+1][end])
    end


    return ds[1][end]
end

function extrapolate_value_back(values)
    vv = reverse(values)
    ds = [vv, diff(vv)]
    while !all(x -> x == 0, ds[end])
        push!(ds, diff(ds[end]))
    end

    for k in (length(ds) - 1):-1:1
        push!(ds[k], ds[k][end] + ds[k+1][end])
    end


    return ds[1][end]
end

function main()
    path = AOC.data_dir("2023", "day09.txt")
    lines = [parse.(Int, x) for x in split.(readlines(path))]

    println(sum(extrapolate_value, (lines)))
    println(sum(extrapolate_value_back, (lines)))
end