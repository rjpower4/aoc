
pint(x) = parse(Int, x)
row_to_nums(r::AbstractString) = pint.(split(r, '\t')) 
row_range(r::AbstractString) = r |> row_to_nums |> extrema |> x -> x[2] - x[1]

function row_div(r)
    ns = row_to_nums(r)
    for i = 1:length(ns)
        for j in (i+1):length(ns)
            if rem(ns[i], ns[j]) == 0
                return div(ns[i], ns[j])
            elseif rem(ns[j], ns[i]) == 0
                return div(ns[j], ns[i])
            end
        end
    end
    return 0
end

function main()
    lines = readlines(ARGS[1])
    p1 = sum(row_range, lines)
    p2 = sum(row_div, lines)

    println("Part 1: $(p1)")
    println("Part 2: $(p2)")
end

main()
