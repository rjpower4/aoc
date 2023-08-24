using AOC
using Test

const PART_1_MOVE_SET = Dict(
    'U' => [1, 2, 3, 1, 2, 3, 4, 5, 6],
    'D' => [4, 5, 6, 7, 8, 9, 7, 8, 9],
    'L' => [1, 1, 2, 4, 4, 5, 7, 7, 8],
    'R' => [2, 3, 3, 5, 6, 6, 8, 9, 9],
)

const PART_2_MOVE_SET = Dict(
    'U' => [1, 2, 1, 4, 5, 2, 3, 4, 9, 6, 7, 8, 11],
    'D' => [3, 6, 7, 8, 5, 10, 11, 12, 9, 10, 13, 12, 13],
    'L' => [1, 2, 2, 3, 5, 5, 6, 7, 8, 10, 10, 11, 13],
    'R' => [1, 3, 4, 4, 6, 7, 8, 9, 9, 11, 12, 12, 13],
)

function run(lines, moveset)
    n = 5
    value = zeros(Int, length(lines))
    for (i, line) in enumerate(lines)
        for c in line
            n = moveset[c][n]
        end
        value[i] = n
    end
    return value
end

function main()
    lines = readlines(AOC.data_dir("2016", "day02.txt"))
    join(run(lines, PART_1_MOVE_SET) .|> string, "") |>  println
    join(run(lines, PART_2_MOVE_SET) .|> x -> string(x, base=16), "") |> uppercase |>  println
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
