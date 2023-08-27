using Test

function part1(data::String)
    loc = (0, 0)
    visited = Set((loc,))

    for c in data
        if c == '^'
            loc = loc .+ (0, 1)
        elseif c == 'v'
            loc = loc .- (0, 1)
        elseif c == '<'
            loc = loc .- (1, 0)
        elseif c == '>'
            loc = loc .+ (1, 0)
        else
            continue
        end
        push!(visited, loc)
    end

    return visited
end

function part2(data)
    s1 = part1(data[1:2:end])
    s2 = part1(data[2:2:end])
    return length(union(s1, s2))
end

function tests()
    @test part1(">") == 2
    @test part1("^>v<") == 4
    @test part1("^v^v^v^v^v") == 2
end

function main()
    if length(ARGS) > 0
        path = ARGS[1]
        data = read(path, String)
        println(part1(data) |> length)
        println(part2(data))
    else
        tests()
    end
end

main()
