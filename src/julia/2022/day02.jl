using AOC

const ROCK = 1
const PAPER = 2
const SCISSORS = 3

abc_to_rps(c) = Int64(c) - Int64('A') + ROCK
xyz_to_rps(c) = Int64(c) - Int64('X') + ROCK

function part1_selector(first, second)
    return (abc_to_rps(first[1]), xyz_to_rps(second[1]))
end

function part2_selector(first, second)
    m = ((SCISSORS, ROCK, PAPER), (ROCK, PAPER, SCISSORS), (PAPER, SCISSORS, ROCK))
    f = abc_to_rps(first[1])
    s = m[xyz_to_rps(second[1])][f]
    return (f, s)
end

function score_line(selector, first, second)
    score = ((3, 6, 0), (0, 3, 6), (6, 0, 3))
    f, s = selector(first, second)
    return s + score[f][s]
end

function solve(selector, path)
    return sum(eachline(path)) do line
        f, s = split(line, " ")
        score_line(selector, f, s)
    end
end

function main()
    path = AOC.data_dir("2022", "day02.txt")
    println("Part 1: $(solve(part1_selector, path))")
    println("Part 2: $(solve(part2_selector, path))")
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
