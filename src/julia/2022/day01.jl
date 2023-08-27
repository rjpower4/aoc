using AOC

function solve(path, n)
    values = zeros(Int64, n)

    function insert_value!(values, v)
        for ind in eachindex(values)
            if values[ind] < v
                values[ind+1:end] .= values[ind:(end-1)]
                values[ind] = v
                break
            end
        end
    end

    cur = 0
    for line in eachline(path)
        if isempty(line)
            insert_value!(values, cur)
            cur = 0
        else
            cur += parse(Int64, line)
        end
    end

    if cur != 0
        insert_value!(values, cur)
    end

    return sum(values)
end

function main()
    p1, p2 = let ipath = AOC.data_dir("2022", "day01.txt")
        (solve(ipath, 1), solve(ipath, 3))
    end

    println("Part 1: $p1")
    println("Part 2: $p2")
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
