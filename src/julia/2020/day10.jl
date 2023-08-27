using Test
using AOC


function chain_metric(values)
    n_one = 0
    n_three = 0
    for i in 2:length(values)
        val = values[i] - values[i-1]
        if val == 1
            n_one += 1
        elseif val == 3
            n_three += 1
        end
    end
    return n_one * n_three
end

function part1(adapters)
    values = copy(adapters)
    append!(values, [0, maximum(values) + 3])
    sort!(values)
    return chain_metric(values)
end

function part2(adapters)
    values = [0, maximum(adapters) + 3]
    append!(values, adapters)
    sort!(values)
    counts = zeros(Int, length(values)) .+ -1

    function helper(values, counts, current, target)
        current != target || return 1
        counts[current] == -1 || return counts[current]

        counts[current] = 0
        for i in eachindex(values) 
            if 1 <= values[i] - values[current] <= 3
                counts[current] += helper(values, counts, i, target)
            end
        end
        return counts[current]

    end

return     helper(values, counts, 1, length(values))
    return values
end

function tests()
    sample_1 = [16, 10, 15, 5, 1, 11, 7, 19, 6, 12, 4]
    sample_2 = [28, 33, 18, 42, 31, 14, 46, 20, 48, 47, 24, 23, 49, 45, 19, 38, 39, 11, 1, 32, 25, 35, 8, 17, 7, 9, 4, 2, 34, 10, 3]

    @test part1(sample_1) == 35
    @test part1(sample_2) == 220
    @test part2(sample_1) == 8
    @test part2(sample_2) == 19208
end

function main()
    tests()
    path = AOC.data_dir("2020", "day10.txt")
    lines = readlines(path)
    values = parse.(Int, lines)
    part1(values) |> println
    part2(values) |> println
end

main()
