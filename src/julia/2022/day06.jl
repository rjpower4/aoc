using AOC: data_dir

function solve(code, n)
    f(k) = allunique(SubString(code, (k - n + 1), k))
    return findfirst(f, n:length(code)) + (n - 1)
end

function main()
    code = data_dir("day-06-02.txt") |> readline
    println("Part 1: $(solve(code, 4))")
    println("Part 2: $(solve(code, 14))")
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end