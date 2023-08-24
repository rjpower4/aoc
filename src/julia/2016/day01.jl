# Day 1: No Time for a Taxicab

using AOC
using Test

const Right = (1, 0)
const Left = (-1, 0)
const Up = (0, 1)
const Down = (0, -1)

function turn_right(d)
    d == Up && return Right
    d == Right && return Down
    d == Down && return Left
    d == Left && return Up
end
turn_left(dir) = -1 .* turn_right(dir)

function walk_path(path::String)
    loc = (0, 0)
    dir = Up

    steps = [loc]

    iter = Iterators.Stateful(path)
    next = iterate(iter)
    while next != nothing
        (c, _) = next
        if c == 'R'
            n = parse(Int, join(Iterators.takewhile(isdigit, iter), ""))
            dir = turn_right(dir)
            for _ in 1:n
                push!(steps, steps[end] .+ dir)
            end
        elseif c == 'L'
            n = parse(Int, join(Iterators.takewhile(isdigit, iter), ""))
            dir = turn_left(dir)
            for _ in 1:n
                push!(steps, steps[end] .+ dir)
            end
        end
        next = iterate(iter)
    end

    return steps
end

manhattan(loc) = sum(abs, loc)

function first_repeated(lst)
    !isempty(lst) || error("empty list")
    set = Set{eltype(lst)}()
    for item in lst
        !(item in set) || return item
        push!(set, item)
    end
    error("no repeated element")
end

function tests()
    part1(path) = path |> walk_path |> last |> manhattan
    part2(path) = path |> first_repeated |> manhattan

    @test part1("R2, L3") == 5
    @test part1("R2, R2, R2") == 2
    @test part1("R5, L5, R5, R3") == 12
end

function main()
    line = read(AOC.data_dir("2016", "day01.txt"), String) 
    locs = walk_path(line)
    println("Part 1: $(locs |> last |> manhattan)")
    println("Part 2: $(locs |> first_repeated |> manhattan)")
end

if abspath(PROGRAM_FILE) == @__FILE__
    tests()
    main()
end
